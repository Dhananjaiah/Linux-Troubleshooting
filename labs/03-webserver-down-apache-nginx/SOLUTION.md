# Lab 03: Website Down Due to Apache/Nginx Failure

## SOLUTION GUIDE

---

## 📋 Recap

The website is down because the web server (Nginx) has stopped running due to a configuration syntax error introduced in the virtual host file.

---

## 🔍 Root Cause

A typo in the Nginx configuration file (`server_name_typo` instead of `server_name`) causes Nginx to fail to start.

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check Service Status

```bash
sudo systemctl status nginx
```

Shows: `Active: failed (Result: exit-code)`

### Step 2: Test Configuration Syntax

```bash
sudo nginx -t
```

**Output:**
```
nginx: [emerg] unknown directive "server_name_typo" in /etc/nginx/sites-enabled/default:10
nginx: configuration file /etc/nginx/nginx.conf test failed
```

### Step 3: Fix the Configuration

```bash
sudo nano /etc/nginx/sites-enabled/default
```

Change:
```
server_name_typo _;
```

To:
```
server_name _;
```

### Step 4: Verify and Restart

```bash
sudo nginx -t
sudo systemctl restart nginx
```

### Step 5: Test the Website

```bash
curl -I http://localhost
```

Should return `HTTP/1.1 200 OK`

---

## 🛡️ Prevention

1. **Always test configuration before restarting**: `nginx -t`
2. **Use version control** for configuration files
3. **Set up configuration validation** in CI/CD pipelines
4. **Monitor web server status** with tools like Prometheus/Grafana

---

## 🔄 Extra Variations

1. **Missing SSL certificate**: Configure HTTPS but remove the certificate file
2. **Port conflict**: Another process using port 80
3. **Permission issues**: Wrong ownership on web root directory
4. **Syntax error in included file**: Error in a separate config file
