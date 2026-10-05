#!/bin/bash
# userdata/openvpn.sh — runs once at first boot as root
set -eux
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y openvpn easy-rsa iptables

# ---- PKI (certificate authority + server cert) ----
make-cadir /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa
export EASYRSA_BATCH=1 EASYRSA_REQ_CN="3tier-vpn-ca"
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa build-server-full server nopass
openvpn --genkey secret /etc/openvpn/server/ta.key
cp pki/ca.crt pki/issued/server.crt pki/private/server.key /etc/openvpn/server/

# ---- Server config ----
cat > /etc/openvpn/server/server.conf <<'CONF'
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh none
tls-crypt ta.key
topology subnet
server 10.8.0.0 255.255.255.0
push "route 10.0.0.0 255.255.0.0"
keepalive 10 120
cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/status.log
verb 3
explicit-exit-notify 1
CONF
mkdir -p /var/log/openvpn

# ---- IP forwarding ----
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/99-openvpn.conf
sysctl --system

# ---- NAT VPN clients to this server's private IP (persistent via systemd) ----
cat > /usr/local/sbin/vpn-nat.sh <<'NAT'
#!/bin/bash
IFACE=$(ip route show default | awk '{print $5; exit}')
iptables -t nat -C POSTROUTING -s 10.8.0.0/24 -o "$IFACE" -j MASQUERADE 2>/dev/null || \
  iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$IFACE" -j MASQUERADE
NAT
chmod +x /usr/local/sbin/vpn-nat.sh

cat > /etc/systemd/system/vpn-nat.service <<'UNIT'
[Unit]
Description=NAT for OpenVPN clients
After=network-online.target
Wants=network-online.target
[Service]
Type=oneshot
ExecStart=/usr/local/sbin/vpn-nat.sh
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
UNIT

# ---- Client profile generator: make-client <name> <public-ip> ----
cat > /usr/local/bin/make-client <<'MKCLIENT'
#!/bin/bash
set -e
NAME=${1:?usage: make-client <name> <public-ip>}
REMOTE=${2:?usage: make-client <name> <public-ip>}
cd /etc/openvpn/easy-rsa
EASYRSA_BATCH=1 ./easyrsa build-client-full "$NAME" nopass
OUT=/home/ubuntu/$NAME.ovpn
cat > "$OUT" <<EOF
client
dev tun
proto udp
remote $REMOTE 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM
verb 3
<ca>
$(cat pki/ca.crt)
</ca>
<cert>
$(openssl x509 -in pki/issued/$NAME.crt)
</cert>
<key>
$(cat pki/private/$NAME.key)
</key>
<tls-crypt>
$(cat /etc/openvpn/server/ta.key)
</tls-crypt>
EOF
chown ubuntu:ubuntu "$OUT"; chmod 600 "$OUT"
echo "Created $OUT"
MKCLIENT
chmod +x /usr/local/bin/make-client

systemctl daemon-reload
systemctl enable --now vpn-nat.service
systemctl enable --now openvpn-server@server
