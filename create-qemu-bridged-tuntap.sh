#!/bin/bash

bridgename=br0
tapinterface=tap0
outinterface=eth0

if [ "x$1" != "x" ] ; then
    outinterface="$1"
fi  

ifaces=`awk -F: '{print $1}' /proc/net/dev | tail -n +3`
iffound="0"

for i in $ifaces
do  
    if [ "$outinterface" == "$i" ] ; then
            iffound="1"
    fi  
done

if [ "$iffound" == "0" ] ; then
    echo
    echo "Can't find the output interface."
    echo
    exit 1
fi  

outifaceip=`ifconfig | grep -A1 $outinterface | tail -1 | awk -F: '{print $2}' | awk '{print $1}'`
outifaceiptokens=`echo $outifaceip | awk -F \. '{print NF}'`

if [ "$outifaceiptokens" != "4" ] ;  then
    echo
    echo "The selected output interface $outinterface doesn't seem to have a valid IP address."
    echo
    exit 1
fi  

hostaddress="172.16.58.85"
guestaddress="172.16.58.162"

sudo tunctl -t $tapinterface

sudo brctl addbr $bridgename
sudo brctl addif $bridgename $tapinterface

sudo ip link set $bridgename up
sudo ip addr add $hostaddress/24 dev $bridgename

sudo route add -host $guestaddress dev $bridgename
sudo parprouted eth0 $bridgename

sudo ~/ip-router.sh $outinterface
