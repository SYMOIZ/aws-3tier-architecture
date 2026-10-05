# Phase 9 — Connect OpenVPN and reach private servers

## Objective

Import `my-pc.ovpn`, connect, then SSH to `10.0.11.10` and `10.0.11.20`.

Your home/office LAN must **not** already use `10.0.x.x` or `10.8.0.x` (route clash).

## Install client

| OS | Client |
|----|--------|
| Windows | [OpenVPN Connect](https://openvpn.net/client/) or OpenVPN GUI |
| Ubuntu | `sudo apt install openvpn` then `sudo openvpn --config my-pc.ovpn` |
| macOS | OpenVPN Connect or Tunnelblick |

Import `my-pc.ovpn` → Connect.

## Confirm tunnel (Windows PowerShell)

```powershell
Get-NetIPAddress | Where-Object IPAddress -like '10.8.0.*'
route print | findstr 10.0.0.0
```

## SSH to private servers

```bash
ssh -i 3tier-key.pem ubuntu@10.0.11.10
ssh -i 3tier-key.pem ubuntu@10.0.11.20
```

Optional `~/.ssh/config`:

```text
Host frontend
  HostName 10.0.11.10
  User ubuntu
  IdentityFile ~/path/to/3tier-key.pem

Host backend
  HostName 10.0.11.20
  User ubuntu
  IdentityFile ~/path/to/3tier-key.pem
```

## Prove Squid path (on Frontend or Backend)

```bash
sudo tail -n 20 /var/log/cloud-init-output.log
curl -sI https://ubuntu.com | head -1
curl -sI --noproxy '*' --max-time 5 https://ubuntu.com   # should time out
sudo apt-get update
```

On Squid: `sudo tail -f /var/log/squid/access.log`

## If IP changed

Update Remote-SG and VPN-SG to your new My IP (Console → Security Groups → Edit inbound rules), or run optional `scripts/update-my-ip.sh`.
