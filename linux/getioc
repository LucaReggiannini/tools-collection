#!/bin/bash

filterIP='ip.dst!=0.0.0.0/8 && ip.dst!=10.0.0.0/8 && ip.dst!=100.64.0.0/10 && ip.dst!=127.0.0.0/8 && ip.dst!=169.254.0.0/16 && ip.dst!=172.16.0.0/12 && ip.dst!=192.0.0.0/24 && ip.dst!=192.0.2.0/24 && ip.dst!=192.88.99.0/24 && ip.dst!=192.168.0.0/16 && ip.dst!=198.18.0.0/15 && ip.dst!=198.51.100.0/24 && ip.dst!=203.0.113.0/24 && ip.dst!=224.0.0.0/4 && ip.dst!=233.252.0.0/24 && ip.dst!=240.0.0.0/4 && ip.dst!=255.255.255.255/32'
filterDNS="*.in-addr.arpa|*.ip6.arpa"
filterDomains="*.windows.com|*.windowsupdate.com|*.microsoft.com|*.oracle.com|*.live.com|*.digicert.com|*.verisign.com|*.google.com|*.gstatic.com"
filterEmptyLines="^\s*$"
function help() {
    echo '
getioc

SYNOPSIS: 
    getioc [FILE]

DESCRIPTION:
    Get IPv4 and DNS traffic from pcap/pcapng file.
    Private IP Networks, trusted Domains and reverse DNS query are hidden.
    Tshark is required for this operation.
'
}

if [ -z "$1" ]
then  
    echo "Error: no argument given"
    help
    exit 1
fi

ips=$(tshark -nr "$1" -T fields -e ip.dst -Y "$filterIP" | sort | uniq)
dns=$(tshark -nr "$1" -T fields -e dns.qry.name | sort | uniq | grep -Evi "$filterDNS|$filterDomains|$filterEmptyLines")

echo
echo "Found $(echo "$ips" | wc -l) addressess and $(echo "$dns" | wc -l) domains"
echo
echo "$ips"
echo
echo "$dns"
echo

exit 0