#!/bin/bash
# userdata/frontend.sh — __SQUID_IP__ and __PROXY_PORT__ filled by 06-app-servers.sh
set -eux
PROXY="http://__SQUID_IP__:__PROXY_PORT__"

# ---- Use Squid for all outbound traffic ----
cat >> /etc/environment <<EOF
http_proxy=$PROXY
https_proxy=$PROXY
HTTP_PROXY=$PROXY
HTTPS_PROXY=$PROXY
no_proxy=localhost,127.0.0.1,169.254.169.254,10.0.0.0/16
NO_PROXY=localhost,127.0.0.1,169.254.169.254,10.0.0.0/16
EOF
cat > /etc/apt/apt.conf.d/95proxy <<EOF
Acquire::http::Proxy "$PROXY";
Acquire::https::Proxy "$PROXY";
EOF
export http_proxy=$PROXY https_proxy=$PROXY

# ---- Nginx + sample page ----
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx
cat > /var/www/html/index.html <<'HTML'
<!doctype html>
<html><head><meta charset="utf-8"><title>3-Tier Frontend</title></head>
<body style="font-family:sans-serif;max-width:640px;margin:40px auto">
  <h1>Frontend is up</h1>
  <p>Served by Nginx in the private subnet, behind the ALB.</p>
  <p>Backend says: <code id="api">loading...</code></p>
  <script>
    fetch('/api/info').then(r => r.json())
      .then(d => document.getElementById('api').textContent = JSON.stringify(d))
      .catch(e => document.getElementById('api').textContent = 'error: ' + e);
  </script>
</body></html>
HTML
systemctl enable --now nginx
