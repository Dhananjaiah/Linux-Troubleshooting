# Lab 03: Website Down Due to Apache/Nginx Failure

## 📖 Scenario / Story

Your company's marketing team just launched a new campaign, and traffic to the website is expected to increase by 300%. But within minutes of the campaign going live, the customer support team reports that **the website is completely down**.

Customers are seeing "This site can't be reached" or "Connection refused" errors. The CEO is calling for an immediate fix, and the marketing team is panicking because they can't pause the campaign.

**Your mission**: Get the website back online as fast as possible.

---

## 🎯 What You Will Learn

By completing this lab, you will learn how to:

- Check web server status with `systemctl`
- Analyze web server error logs
- Validate web server configuration files
- Identify common configuration mistakes
- Restart and reload web servers safely
- Test web server responses with `curl`

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server (VM recommended)
- Non-root user with sudo access
- Apache2 or Nginx installed (`sudo apt install apache2 nginx`)
- Basic understanding of web servers

---

## 🛠️ Lab Setup

### Step 1: Navigate to the Lab Directory

```bash
cd /path/to/Linux-Troubleshooting/labs/03-webserver-down-apache-nginx
```

### Step 2: Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### Step 3: Run the Break Script

```bash
sudo ./scripts/break.sh
```

### Step 4: Confirm the Problem Exists

```bash
# Test if website responds
curl -I http://localhost

# Check web server status
sudo systemctl status nginx
sudo systemctl status apache2
```

---

## 🔴 Problem Symptoms (What You See)

### Connection Refused
```bash
$ curl -I http://localhost
curl: (7) Failed to connect to localhost port 80: Connection refused
```

### Service Not Running
```bash
$ sudo systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled)
     Active: failed (Result: exit-code) since Mon 2024-01-15 10:00:00 UTC
    Process: 12345 ExecStart=/usr/sbin/nginx (code=exited, status=1/FAILURE)
```

### Configuration Errors in Logs
```bash
$ sudo tail /var/log/nginx/error.log
2024/01/15 10:00:00 [emerg] 12345#0: unknown directive "server_name_typo" in /etc/nginx/sites-enabled/default:10
```

---

## ✅ Tasks for You

1. **Check if the web server service is running**
2. **Attempt to start the service and observe errors**
3. **Check web server configuration syntax**
4. **Review error logs for clues**
5. **Identify and fix configuration errors**
6. **Restart the web server**
7. **Verify the website is accessible**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Test Configuration Syntax</b></summary>

```bash
# Nginx
sudo nginx -t

# Apache
sudo apache2ctl configtest
# or
sudo apachectl -t
```
</details>

<details>
<summary><b>Hint 2: Check Log Files</b></summary>

```bash
# Nginx logs
sudo tail -50 /var/log/nginx/error.log

# Apache logs
sudo tail -50 /var/log/apache2/error.log

# Systemd journal
sudo journalctl -xe -u nginx
```
</details>

<details>
<summary><b>Hint 3: Common Configuration Issues</b></summary>

- Missing semicolon at end of directive
- Typo in directive name
- Duplicate listen directives
- Wrong file permissions
- Missing SSL certificates
</details>

---

## ✔️ Verification

```bash
./scripts/verify.sh
```

**Expected output:**
```
[✓] Web server service is running
[✓] Port 80 is listening
[✓] Website returns HTTP 200
[SUCCESS] Lab completed successfully!
```

---

## 🧹 Cleanup

```bash
sudo ./scripts/cleanup.sh
```

---

## 🤔 Reflection Questions

1. How would you set up monitoring to detect web server failures immediately?
2. What's the difference between `systemctl restart` and `systemctl reload` for web servers?
3. How would you handle a situation where the config is valid but the server still won't start?
4. What are the security implications of running a web server as root?

---

**Previous Lab**: [02 - SSH Login Failure](../02-ssh-login-failure/)  
**Next Lab**: [04 - High CPU Usage](../04-high-cpu-usage/)
