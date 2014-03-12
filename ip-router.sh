#!/bin/bash

internetinterface="eth0"

username=`whoami`

if [ "x$username" != "xroot" ] ; then

    echo    
    echo "You must be root in order to run this script..."
    echo    

    exit    

fi  

if [ "x$1" != "x" ] ; then
    internetinterface="$1"
fi  

if [ "x$1" == "xdel" ] || [ "x$2" == "xdel" ] ; then
    disable="1"
else
    disable="0"
fi  

if [ "$disable" == "0" ] ; then
    echo "Enabling IP forward and setting up masquerade NAT on interface $internetinterface"

    echo 1 > /proc/sys/net/ipv4/ip_forward

    iptables -t nat -A POSTROUTING -o $internetinterface -j MASQUERADE
else
    echo "Disable IP forward and setting down masquerade NAT on interface $internetinterface"

    echo 0 > /proc/sys/net/ipv4/ip_forward

    iptables -t nat -D POSTROUTING -o $internetinterface -j MASQUERADE
fi  
