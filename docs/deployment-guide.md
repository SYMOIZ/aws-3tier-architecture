# Deployment Guide (SOP)

## Phase 0 — Read (no AWS charges)

1. [../README.md](../README.md)
2. [../01-understand/](../01-understand/)
3. [cost.md](cost.md) — set a billing alarm

## Phase 1 — IAM (console)

[../02-infrastructure/01-iam/README.md](../02-infrastructure/01-iam/README.md)

## Phases 2–8 — Scripts

```bash
cd scripts
bash 01-network.sh && bash 02-security-groups.sh && bash 03-keypair-ami.sh \
  && bash 04-squid.sh && bash 05-openvpn.sh && bash 06-app-servers.sh && bash 07-alb.sh
```

If a script fails midway, fix the cause and rerun **only that script**; IDs already created are kept in `ids.sh`.

## Phase 9 — VPN client

```bash
source ./vars.sh
ssh -i 3tier-key.pem ubuntu@$VPN_EIP
sudo make-client my-pc "$VPN_EIP"
exit
scp -i 3tier-key.pem ubuntu@$VPN_EIP:~/my-pc.ovpn .
```

Import `my-pc.ovpn` into OpenVPN Connect / GUI, then:

```bash
ssh -i 3tier-key.pem ubuntu@10.0.11.10
ssh -i 3tier-key.pem ubuntu@10.0.11.20
```

## Values you supply

| Variable | Source |
|----------|--------|
| Region | `vars.sh` (`ap-south-1` default) |
| MY_IP | Auto via `checkip.amazonaws.com` |
| Access keys | IAM user `3tier-deployer` |

Never commit `.pem` or `.ovpn` files.
