#!/usr/bin/env bash
#
# Lab 03: Website Down Due to Apache/Nginx Failure
# cleanup.sh - Restores web server to clean state
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BACKUP_DIR="/root/.webserver-lab-backup"
NGINX_CONFIG="/etc/nginx/sites-enabled/default"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 03..."
echo "========================================"

# Restore backup if exists
if [[ -f "$BACKUP_DIR/default.backup" ]]; then
    print_status "Restoring original Nginx configuration..."
    cp "$BACKUP_DIR/default.backup" "$NGINX_CONFIG"
else
    print_status "No backup found, creating default configuration..."
    cat > "$NGINX_CONFIG" << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.html index.htm;
    server_name _;
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF
fi

# Restart nginx
print_status "Restarting Nginx..."
systemctl restart nginx 2>/dev/null || true

# Remove backup directory
rm -rf "$BACKUP_DIR"

echo ""
print_cleanup "Environment restored to clean state."
echo ""
