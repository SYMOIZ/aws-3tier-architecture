# Phase 6 — OpenVPN (Console)

## Objective

Launch OpenVPN in `3tier-public-a` at `10.0.1.20`, attach an Elastic IP, disable source/dest check, create your `.ovpn` client file.

## User data

Paste [../../userdata/openvpn.sh](../../userdata/openvpn.sh) into User data.

## Launch instance

| Setting | Value |
|---------|--------|
| Name | `openvpn-server` |
| AMI | Ubuntu Server 24.04 LTS |
| Type | `t3.micro` |
| Key | `3tier-key` |
| VPC / Subnet | `3tier-vpc` / `3tier-public-a` |
| Auto-assign public IP | Enable (temporary until EIP) |
| Security groups | `VPN-SG` **and** `Remote-SG` |
| Primary IP | `10.0.1.20` |
| User data | `userdata/openvpn.sh` |
| Tags | `Name=openvpn-server`, `Project=3tier` |

### After launch

1. Select instance → Actions → Networking → **Change source/destination check** → **Stop**.
2. **Elastic IPs** → Allocate Elastic IP address → Allocate.
3. Actions → **Associate** → choose `openvpn-server`.
4. Tag EIP: `Name=openvpn-eip`, `Project=3tier`.
5. Wait until instance status checks pass (user-data installs OpenVPN; can take a few minutes).

## Create client profile

```bash
ssh -i 3tier-key.pem ubuntu@<VPN_ELASTIC_IP>
sudo systemctl status openvpn-server@server --no-pager
sudo make-client my-pc <VPN_ELASTIC_IP>
exit
scp -i 3tier-key.pem ubuntu@<VPN_ELASTIC_IP>:~/my-pc.ovpn .
```

Treat `my-pc.ovpn` like a password. Do not commit it to git.

## Validation

- OpenVPN service active.
- UDP 1194 allowed only from **My IP** on VPN-SG.
- SSH to VPN only from My IP (Remote-SG).

## What comes next?

[../06-app-servers/](../06-app-servers/)
