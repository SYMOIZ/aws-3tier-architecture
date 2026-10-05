# Troubleshooting (SOP)

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| OpenVPN TLS handshake failed / timeout | Your public IP changed, or UDP 1194 blocked | `bash scripts/update-my-ip.sh`; try another network |
| VPN connects but SSH to 10.0.11.x times out | NAT/forwarding off, or Connect-SG wrong | On VPN: `systemctl status vpn-nat`, `sysctl net.ipv4.ip_forward` (=1), `sudo iptables -t nat -S`; Connect-SG source = VPN-SG |
| apt-get hangs on Frontend/Backend | Squid down, or Proxy-SG missing that SG | `systemctl status squid`; Proxy-SG must allow Web-SG **and** Backend-SG |
| Squid returns 403 | Client outside 10.0.0.0/16 or port not 80/443 | Check `acl localnet` / `Safe_ports`; `sudo tail /var/log/squid/access.log` |
| Target group unhealthy | Service down, wrong port, SG blocks ALB | `systemctl status nginx` / `backend`; Web-SG:80 and Backend-SG:8000 from APP-SG |
| ALB 502/503 on `/api/*` | Backend target unhealthy | Same as above for Backend |
| User-data unexpected | Script error | `sudo cat /var/log/cloud-init-output.log` |

## Update MyIP

```bash
cd scripts
bash update-my-ip.sh
```
