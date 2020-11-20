#!/bin/bash

# Run this script within a virtme configured for qemu
# user networking and it will bring up a static network
# interface and allow you to ssh into the virtme.

# addrs fixed by qemu host network
mac="52:54:00:12:34:56"
ip="10.0.2.15"
subnet="$ip/24"
gateway="10.0.2.2"

# grep the right link and pull out its name
dev=$(ip link | grep -B1 $mac | grep state | cut -d: -f2)

ip addr add $subnet dev $dev
ip link set $dev up
ip route add default via $gateway
/usr/sbin/sshd -D
