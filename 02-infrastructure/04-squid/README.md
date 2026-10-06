# Phase 4–5 — Key pair and Squid (Console)

> **What is Squid?** A forward proxy: private Frontend/Backend use `http://10.0.1.10:8888` to download packages. Without Squid (and without NAT), they have no internet.  
> **Where does `userdata/squid.sh` run?** On the Squid EC2 instance at **first boot** after you paste it into User data — not in Git Bash on your PC.  
> Full flow: [root README](../../README.md).

## Objective

Create an SSH key, then launch Squid in the public subnet **before** Frontend/Backend (they install packages through Squid).

## 4.1 Key pair

1. **EC2** → Key Pairs → **Create key pair**.
2. Name: `3tier-key`
3. Type: **ED25519**
4. Format: `.pem`
5. Create → save `3tier-key.pem` safely (you need it for SSH).

Windows (if SSH says key is too open), PowerShell:

```powershell
icacls .\3tier-key.pem /inheritance:r /grant:r "$($env:USERNAME):(R)"
```

## 4.2 User data for Squid

Copy the full contents of [../../userdata/squid.sh](../../userdata/squid.sh) into the User data box when launching.

## 4.3 Launch Squid

**EC2** → Instances → **Launch instance**:

| Setting | Value |
|---------|--------|
| Name | `squid-proxy` |
| AMI | Ubuntu Server 24.04 LTS |
| Instance type | `t3.micro` |
| Key pair | `3tier-key` |
| VPC | `3tier-vpc` |
| Subnet | `3tier-public-a` |
| Auto-assign public IP | **Enable** |
| Security groups | `Remote-SG` **and** `Proxy-SG` |
| Advanced network → Primary IP | `10.0.1.10` |
| Advanced details → User data | paste `userdata/squid.sh` |
| Tags | `Name=squid-proxy`, `Project=3tier` |

Launch → wait until **2/2 checks passed**.

## Validation (from your PC)

```bash
ssh -i 3tier-key.pem ubuntu@<SQUID_PUBLIC_IP>
sudo systemctl status squid --no-pager
sudo ss -lntp | grep 8888
curl -sI -x http://127.0.0.1:8888 https://ubuntu.com | head -1
```

Expect Squid active and `HTTP/1.1 200 Connection established`.

## Cost

`t3.micro` may be Free Tier eligible. Public IPv4 can still incur charges — see [../../docs/cost.md](../../docs/cost.md).

## What comes next?

[../05-openvpn/](../05-openvpn/)
