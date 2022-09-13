#!/use/bin/python

import hashlib # Used to calculate file hashes          
import os # Used for file size and determining file size
import sys # Used to parse command line arguments
import re  # Used for Regular Expressions
from pathlib import Path

def compareChunkHash(argData, argChunkSize, argHash):
    with open(argData, 'rb') as f:
        offset=0
        while True:
            print("Testing offset {} with chunk size {}                        ".format(offset, argChunkSize), end='\r')
            f.seek(offset)
            chunk = f.read(argChunkSize)
            if not chunk:
                break
            
            # Initialize hashlib
            md5 = hashlib.md5()
            sha1 = hashlib.sha1()
            sha256 = hashlib.sha256()

            sha1.update(chunk)
            sha256.update(chunk)
            md5.update(chunk)

            if md5.hexdigest() == argHash or \
            sha1.hexdigest() == argHash or \
            sha256.hexdigest() == argHash:
                print("Hash found at offset {} using chunk size {}!\nChunk: {}\nMD5: {}\nSHA1: {}\nSHA256: {} ".format(offset, argChunkSize, chunk, md5.hexdigest(), sha1.hexdigest(), sha256.hexdigest()))
                return True

            #print("Chunk size: {}\n Chunk: {}\n MD5: {}\nSHA1: {}\nSHA256: {} ".format(argChunkSize, chunk, md5.hexdigest(), sha1.hexdigest(), sha256.hexdigest()))
            offset+=1
    return False

def help():
    print("""
findhash

SYNOPSIS
    python3 findhash.py [HASH] [FILE]

DESCRIPTION
    Small utility to find hashes of file pieces.
    Read a file in small chunks and calculate the hash for each of them.
    Chunk size will increment until specified hash is found or the chunk size is equal the file size.

    Given hash must be a valid md5, sha1 or sha256.

EXAMPLE
    ls -alh /bin/bash
        -rwxr-xr-x 1 root root 927K Jan  8  2022 /bin/bash
    
    cat /bin/bash | grep -a gnu | grep -a http
        bash home page: <http://www.gnu.org/software/bash>
        General help using GNU software: <http://www.gnu.org/gethelp/>
        Copyright (C) 2020 Free Software Foundation, Inc.License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    
    echo -n 'http://www.gnu.org' | md5sum
        022637434e50bdd2b2fc591c17a81f2f  -
    
    time python findHash.py 022637434e50bdd2b2fc591c17a81f2f "/bin/bash" 
        Hash found at offset 734105 using chunk size 18!                
        Chunk: b'http://www.gnu.org'
        MD5: 022637434e50bdd2b2fc591c17a81f2f
        SHA1: afef535a7dc44c4981ea01993303b2cd8777dcd9
        SHA256: 5ab476a93b77180d108527568116d93e073b247e8ac64a2ea1a1b79d747a7273 
        Done
        
        real	1m31.503s
        user	0m59.805s
        sys	0m12.610s
""")
    sys.exit()

if __name__ == "__main__":

    if not len(sys.argv):
       print("No argument given")
       help()

    if not len(sys.argv) == 3:
        print("Invalid number of arguments")
        help()
    
    if sys.argv[1] in "-h":
       help()

    hashToSearch = sys.argv[1]
    filePath = sys.argv[2]

     # Check if file parameter is populated
    try:
        filePath = Path(filePath)
    except:
        help()

    # Check if file exists
    if not Path(filePath).is_file():
        print("Invalid file given")
        help()

    if (re.search('/^([a-f\d]{32}|[A-F\d]{32})$/', hashToSearch) == 0) and \
    (re.search('/\b([a-f0-9]{40})\b/', hashToSearch)==0) and \
    (re.search('^[A-Fa-f0-9]{64}$', hashToSearch)==0):
        print("Invalid hash given (must be md5, sha1 or sha256)")
        help()

    fileSize =  (os.stat(filePath)).st_size
    chunkSize = 8
    while chunkSize <= fileSize:
        result = compareChunkHash(filePath, chunkSize, hashToSearch.lower())
        if result:
            print("Done")
            sys.exit()
        chunkSize+=1

    print("Done: no results found")
