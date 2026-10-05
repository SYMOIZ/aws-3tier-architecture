# Testing Checklists (SOP)

## Go-live

- [ ] `http://<ALB_DNS>` shows Frontend page with Backend JSON
- [ ] `http://<ALB_DNS>/api/health` returns `{"status":"ok"}`
- [ ] Both target groups healthy
- [ ] Frontend and Backend have **no** public IP
- [ ] From private server: `curl` via Squid works; `curl --noproxy '*'` times out
- [ ] OpenVPN connects only from MyIP; SSH to `10.0.11.10` / `10.0.11.20` only while connected
- [ ] SSH to Squid and OpenVPN only from MyIP
- [ ] Resource Group `3tier-rg` lists VPC, subnets, SGs, 4 instances, EIP, ALB, target groups

## VPN tunnel (after connect)

```powershell
Get-NetIPAddress | Where-Object IPAddress -like '10.8.0.*'
route print | findstr 10.0.0.0
```

## Proxy proof (on Frontend or Backend)

```bash
curl -sI https://ubuntu.com | head -1
curl -sI --noproxy '*' --max-time 5 https://ubuntu.com   # should time out
sudo apt-get update
```

Mark items **UNVERIFIED** until you run them in your account.
