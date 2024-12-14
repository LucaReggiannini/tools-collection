#!/bin/bash

# Help function
usage() {
  echo "Usage: $0 [-f <folder> ...] [-w <width>] [-h]"
  echo
  echo "This script analyzes disk usage for specified folders."
  echo "It also provides an overview of physical disks and their usage."
  echo
  echo "Available options:"
  echo "  -f, --folders   Specify a folder to analyze. Can be repeated multiple times."
  echo "                  If no folder is specified, '/' and '\$HOME' are scanned by default."
  echo "  -w, --width     Set the maximum column width (default: 30)."
  echo "  -h, --help      Show this help message and exit."
  exit 0
}

# Initial variables
folders=()
column_width=30

# Argument parsing
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -f|--folders)
      if [[ -z "$2" ]]; then usage; fi
      folders+=("$2")
      shift
      ;;
    -w|--width)
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then usage; fi
      column_width="$2"
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Error: Unknown option '$1'"
      usage
      ;;
  esac
  shift
done

# If no folder is specified, use / and $HOME as default
if [[ ${#folders[@]} -eq 0 ]]; then
  folders=("/" "$HOME")
fi

# Function to truncate folder names
truncate_name() {
  local name="$1"
  local max_length="$2"
  if [[ ${#name} -gt $max_length ]]; then
    echo "${name:0:$((max_length-3))}..."
  else
    echo "$name"
  fi
}

# Array to store scan results
outputs=()
valid_folders=()

# Run the find command for each folder
for folder in "${folders[@]}"; do
  if [[ ! -d "$folder" ]]; then
    echo "Error: $folder is not a directory or does not exist." >&2
    continue
  fi

  output=$(find "$folder" -maxdepth 1 -type d -exec du -hs {} 2>/dev/null \; | sort -h)
  if [[ $? -ne 0 ]]; then
    echo "Error while processing folder: $folder" >&2
    continue
  fi

  # Add output only if valid
  outputs+=("$output")
  valid_folders+=("$folder")
done

# Find the maximum number of rows across scans
max_lines=0
for output in "${outputs[@]}"; do
  lines=$(echo "$output" | wc -l)
  if (( lines > max_lines )); then
    max_lines=$lines
  fi
done

# Print disks stats
echo
lsblk -Ali -I 8 -o NAME,FSUSED,SIZE,MODEL,MOUNTPOINT
echo
printf "%0.s-" $(seq 1 50); echo
echo

# Print rows dynamically, aligning columns
for ((i=0; i<max_lines; i++)); do
  row=""
  for output in "${outputs[@]}"; do
    line=$(echo "$output" | sed -n "$((i+1))p")  # Get the current row
    size=$(echo "$line" | awk '{print $1}')
    path=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ *//g')
    truncated_path=$(truncate_name "$path" "$column_width")
    row+="$(printf "%-7s %-*s " "${size:-}" "$column_width" "${truncated_path:-}")"
  done
  echo "$row"
done
