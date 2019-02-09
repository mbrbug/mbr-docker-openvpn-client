#!/bin/sh
service rsyslog stop && service rsyslog start
sysctl -w net.ipv6.conf.all.disable_ipv6=0
sysctl -w net.ipv6.conf.default.disable_ipv6=0
sysctl -w net.ipv6.conf.lo.disable_ipv6=0 
sysctl -p
iptables -F OUTPUT
iptables -P OUTPUT DROP
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -o tun0 -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp -m udp -d 80.211.1xx.xx --dport 4194 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -I OUTPUT -d 172.17.0.0/16 -m state --state NEW,ESTABLISHED -j ACCEPT
ip6tables -F OUTPUT
ip6tables -P OUTPUT DROP
ip6tables -A OUTPUT -o tun0 -m state --state NEW,ESTABLISHED -j ACCEPT
openvpn $1 $2
