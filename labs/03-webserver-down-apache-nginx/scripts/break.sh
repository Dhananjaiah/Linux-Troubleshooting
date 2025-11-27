#!/usr/bin/env bash
#
# Lab 03: Website Down Due to Apache/Nginx Failure
# break.sh - Introduces web server configuration errors
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BACKUP_DIR="/root/.webserver-lab-backup"
NGINX_CONFIG="/etc/nginx/sites-enabled/default"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

# Check if nginx is installed
if ! command -v nginx &>/dev/null; then
    echo "Nginx is not installed. Installing..."
    apt-get update && apt-get install -y nginx
fi

echo ""
print_break "Starting web server failure simulation for Lab 03..."
echo "========================================"

# Backup configuration
mkdir -p "$BACKUP_DIR"
if [[ -f "$NGINX_CONFIG" ]]; then
    cp "$NGINX_CONFIG" "$BACKUP_DIR/default.backup"
fi

print_status "Introducing configuration error..."

# Create broken configuration with typo
cat > "$NGINX_CONFIG" << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm;

    # TYPO: should be "server_name" not "server_name_typo"
    server_name_typo _;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

print_status "Stopping Nginx service..."
systemctl stop nginx 2>/dev/null || true

# Create marker file
touch "$BACKUP_DIR/.lab03_active"

echo ""
print_break "Web server is now broken!"
echo ""
echo "========================================"
echo "YOUR TASK: Get the website back online!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  sudo systemctl status nginx"
echo "  sudo nginx -t"
echo "  curl -I http://localhost"
echo ""
