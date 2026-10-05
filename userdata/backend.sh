#!/bin/bash
# userdata/backend.sh — sample API on port 8000
set -eux
PROXY="http://__SQUID_IP__:__PROXY_PORT__"

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

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip python3-venv
mkdir -p /opt/backend
cat > /opt/backend/app.py <<'PY'
import json, socket
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/api/health"):
            body = {"status": "ok"}
        elif self.path.startswith("/api"):
            body = {"service": "backend", "host": socket.gethostname(), "path": self.path}
        else:
            self.send_response(404)
            self.end_headers()
            return
        data = json.dumps(body).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

ThreadingHTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
PY

cat > /etc/systemd/system/backend.service <<'UNIT'
[Unit]
Description=3-tier sample backend API
After=network-online.target
[Service]
ExecStart=/usr/bin/python3 /opt/backend/app.py
DynamicUser=yes
Restart=always
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now backend
