# Traffic Flow

## 1. Employee opens the website

```text
Browser → Internet → ALB:80 → Frontend:80
Browser → ALB:80 /api/* → Backend:8000
```

The frontend page calls `/api/info`; the ALB path rule sends `/api/*` to the Backend target group.

## 2. Administrator SSH

```text
Admin laptop → OpenVPN:1194 → tunnel → Frontend|Backend:22 (Connect-SG ← VPN-SG)
```

## 3. Private instance downloads packages

```text
Frontend|Backend → Squid:8888 → Internet
```

`http_proxy` / apt proxy point at `http://10.0.1.10:8888`. Direct internet (`--noproxy '*'`) times out because the private route table has no IGW/NAT route.

## 4. What must never happen

- Internet → Backend:8000 without ALB
- `0.0.0.0/0` on SSH for private instances
- Backend package installs without Proxy-SG allowing Backend-SG
