#!/bin/bash
# userdata/squid.sh — runs once at first boot as root
set -eux
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y squid
cp /etc/squid/squid.conf /etc/squid/squid.conf.orig
cat > /etc/squid/squid.conf <<'CONF'
http_port 8888
acl localnet src 10.0.0.0/16
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 443
acl CONNECT method CONNECT
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost
http_access allow localnet
http_access deny all
cache deny all
forwarded_for delete
via off
access_log /var/log/squid/access.log
CONF
squid -k parse
systemctl enable squid
systemctl restart squid
