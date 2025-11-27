# Linux Commands Cheatsheet

A quick reference guide for common troubleshooting commands organized by category.

---

## 📁 File & Disk Commands

### Disk Usage & Space

| Command | Description | Example |
|---------|-------------|---------|
| `df -h` | Show disk space usage (human-readable) | `df -h /` |
| `df -i` | Show inode usage | `df -i /dev/sda1` |
| `du -sh <dir>` | Show directory size | `du -sh /var/log` |
| `du -sh * \| sort -h` | List sizes sorted | `cd /var/log && du -sh * \| sort -h` |
| `ncdu` | Interactive disk usage analyzer | `ncdu /var` |

### Finding Files

| Command | Description | Example |
|---------|-------------|---------|
| `find / -size +100M` | Find files larger than 100MB | `find /var -size +100M` |
| `find / -name "*.log"` | Find files by name pattern | `find /var/log -name "*.log"` |
| `find / -mtime -1` | Files modified in last 24 hours | `find /etc -mtime -1` |
| `find / -type f -empty` | Find empty files | `find /tmp -type f -empty` |
| `locate <filename>` | Quick file search (uses database) | `locate nginx.conf` |

### File Operations

| Command | Description | Example |
|---------|-------------|---------|
| `ls -la` | List all files with details | `ls -la /etc` |
| `ls -lah` | List with human-readable sizes | `ls -lah /var/log` |
| `cat <file>` | Display file contents | `cat /etc/passwd` |
| `less <file>` | View file with pagination | `less /var/log/syslog` |
| `head -n 20 <file>` | Show first 20 lines | `head -n 20 /var/log/syslog` |
| `tail -n 50 <file>` | Show last 50 lines | `tail -n 50 /var/log/syslog` |
| `tail -f <file>` | Follow file changes in real-time | `tail -f /var/log/syslog` |
| `stat <file>` | Detailed file information | `stat /etc/passwd` |

### Open Files & File Descriptors

| Command | Description | Example |
|---------|-------------|---------|
| `lsof` | List open files | `lsof \| head` |
| `lsof -u <user>` | Open files by user | `lsof -u www-data` |
| `lsof -p <pid>` | Open files by process | `lsof -p 1234` |
| `lsof +D /var/log` | Open files in directory | `lsof +D /var/log` |
| `lsof -i :80` | Files/processes using port 80 | `lsof -i :80` |
| `lsof \| grep deleted` | Find deleted but open files | `lsof \| grep deleted` |

---

## 🔧 CPU & Process Commands

### Process Monitoring

| Command | Description | Example |
|---------|-------------|---------|
| `top` | Interactive process viewer | `top` |
| `htop` | Enhanced process viewer | `htop` |
| `ps aux` | List all processes | `ps aux` |
| `ps aux --sort=-%cpu` | Sort by CPU usage | `ps aux --sort=-%cpu \| head` |
| `ps aux --sort=-%mem` | Sort by memory usage | `ps aux --sort=-%mem \| head` |
| `pstree` | Show process tree | `pstree -p` |
| `pidof <name>` | Get PID of process by name | `pidof nginx` |
| `pgrep <pattern>` | Find PIDs matching pattern | `pgrep -l apache` |

### Process Management

| Command | Description | Example |
|---------|-------------|---------|
| `kill <pid>` | Send SIGTERM to process | `kill 1234` |
| `kill -9 <pid>` | Force kill (SIGKILL) | `kill -9 1234` |
| `killall <name>` | Kill all processes by name | `killall nginx` |
| `pkill <pattern>` | Kill processes matching pattern | `pkill -f "python script.py"` |
| `nohup <cmd> &` | Run command immune to hangups | `nohup ./script.sh &` |
| `nice -n 10 <cmd>` | Run with lower priority | `nice -n 10 tar -czf backup.tar.gz /data` |
| `renice -n 10 -p <pid>` | Change priority of running process | `renice -n 10 -p 1234` |

### CPU Information

| Command | Description | Example |
|---------|-------------|---------|
| `uptime` | System uptime and load average | `uptime` |
| `w` | Who is logged in and what they're doing | `w` |
| `mpstat` | CPU statistics | `mpstat 1 5` |
| `vmstat` | Virtual memory statistics | `vmstat 1 5` |
| `sar -u 1 5` | CPU usage history | `sar -u 1 5` |
| `cat /proc/cpuinfo` | CPU details | `cat /proc/cpuinfo` |
| `nproc` | Number of CPU cores | `nproc` |

---

## 💾 Memory Commands

| Command | Description | Example |
|---------|-------------|---------|
| `free -h` | Memory usage (human-readable) | `free -h` |
| `free -m` | Memory in megabytes | `free -m` |
| `cat /proc/meminfo` | Detailed memory info | `cat /proc/meminfo` |
| `vmstat 1 5` | Memory/swap statistics | `vmstat 1 5` |
| `slabtop` | Kernel slab cache info | `slabtop` |
| `smem` | Memory usage by process | `smem -t -k` |

### Swap Management

| Command | Description | Example |
|---------|-------------|---------|
| `swapon -s` | Show swap usage | `swapon -s` |
| `swapon --show` | Display swap areas | `swapon --show` |
| `cat /proc/swaps` | Swap file information | `cat /proc/swaps` |
| `swapoff -a` | Disable all swap | `sudo swapoff -a` |
| `swapon -a` | Enable swap from fstab | `sudo swapon -a` |

---

## 🌐 Network Commands

### Network Configuration

| Command | Description | Example |
|---------|-------------|---------|
| `ip addr` | Show IP addresses | `ip addr show` |
| `ip link` | Show network interfaces | `ip link show` |
| `ip route` | Show routing table | `ip route show` |
| `ifconfig` | Legacy interface config | `ifconfig -a` |
| `hostname` | Show/set hostname | `hostname` |
| `hostnamectl` | Detailed host info | `hostnamectl status` |

### Network Connections

| Command | Description | Example |
|---------|-------------|---------|
| `ss -tulpn` | Show listening ports | `ss -tulpn` |
| `ss -antp` | All TCP connections | `ss -antp` |
| `netstat -tulpn` | Listening ports (legacy) | `netstat -tulpn` |
| `netstat -an` | All connections | `netstat -an` |
| `lsof -i` | Network connections by process | `lsof -i` |
| `lsof -i :22` | Who is using port 22 | `lsof -i :22` |

### Network Testing

| Command | Description | Example |
|---------|-------------|---------|
| `ping <host>` | Test connectivity | `ping -c 4 google.com` |
| `ping6 <host>` | IPv6 ping | `ping6 -c 4 google.com` |
| `traceroute <host>` | Trace network path | `traceroute google.com` |
| `mtr <host>` | Combined ping/traceroute | `mtr google.com` |
| `curl -I <url>` | HTTP headers | `curl -I https://google.com` |
| `wget -q -O- <url>` | Fetch URL content | `wget -q -O- http://localhost` |
| `nc -zv <host> <port>` | Test port connectivity | `nc -zv google.com 443` |
| `telnet <host> <port>` | Test port (interactive) | `telnet localhost 80` |

### DNS Commands

| Command | Description | Example |
|---------|-------------|---------|
| `dig <domain>` | DNS lookup | `dig google.com` |
| `dig +short <domain>` | Quick DNS lookup | `dig +short google.com` |
| `nslookup <domain>` | DNS query tool | `nslookup google.com` |
| `host <domain>` | Simple DNS lookup | `host google.com` |
| `cat /etc/resolv.conf` | DNS resolver config | `cat /etc/resolv.conf` |
| `resolvectl status` | SystemD DNS status | `resolvectl status` |

### Network Troubleshooting

| Command | Description | Example |
|---------|-------------|---------|
| `tcpdump -i eth0` | Capture packets | `sudo tcpdump -i eth0 port 80` |
| `nmap <host>` | Port scanner | `nmap -sV localhost` |
| `iptables -L -n` | List firewall rules | `sudo iptables -L -n` |
| `ufw status` | Ubuntu firewall status | `sudo ufw status verbose` |
| `nmcli` | NetworkManager CLI | `nmcli device status` |

---

## ⚙️ Service & Systemd Commands

### Service Management

| Command | Description | Example |
|---------|-------------|---------|
| `systemctl status <svc>` | Service status | `systemctl status nginx` |
| `systemctl start <svc>` | Start service | `sudo systemctl start nginx` |
| `systemctl stop <svc>` | Stop service | `sudo systemctl stop nginx` |
| `systemctl restart <svc>` | Restart service | `sudo systemctl restart nginx` |
| `systemctl reload <svc>` | Reload config | `sudo systemctl reload nginx` |
| `systemctl enable <svc>` | Enable at boot | `sudo systemctl enable nginx` |
| `systemctl disable <svc>` | Disable at boot | `sudo systemctl disable nginx` |
| `systemctl is-active <svc>` | Check if running | `systemctl is-active nginx` |
| `systemctl is-enabled <svc>` | Check if enabled | `systemctl is-enabled nginx` |

### System Information

| Command | Description | Example |
|---------|-------------|---------|
| `systemctl list-units` | List all units | `systemctl list-units --type=service` |
| `systemctl list-unit-files` | List unit files | `systemctl list-unit-files --state=enabled` |
| `systemctl --failed` | Show failed services | `systemctl --failed` |
| `systemctl daemon-reload` | Reload systemd config | `sudo systemctl daemon-reload` |

---

## 📜 Log Commands

### Journalctl (SystemD Logs)

| Command | Description | Example |
|---------|-------------|---------|
| `journalctl` | All logs | `journalctl` |
| `journalctl -xe` | Recent errors with context | `journalctl -xe` |
| `journalctl -u <svc>` | Logs for specific service | `journalctl -u nginx` |
| `journalctl -f` | Follow logs real-time | `journalctl -f` |
| `journalctl -b` | Logs since last boot | `journalctl -b` |
| `journalctl -b -1` | Logs from previous boot | `journalctl -b -1` |
| `journalctl --since "1 hour ago"` | Time-filtered logs | `journalctl --since "1 hour ago"` |
| `journalctl -p err` | Only error messages | `journalctl -p err` |
| `journalctl -k` | Kernel messages | `journalctl -k` |
| `journalctl --disk-usage` | Journal disk usage | `journalctl --disk-usage` |

### Traditional Log Files

| Log File | Description |
|----------|-------------|
| `/var/log/syslog` | System messages |
| `/var/log/auth.log` | Authentication logs |
| `/var/log/kern.log` | Kernel logs |
| `/var/log/dmesg` | Boot messages |
| `/var/log/apache2/` | Apache logs |
| `/var/log/nginx/` | Nginx logs |
| `/var/log/mysql/` | MySQL logs |

### Log Analysis Commands

| Command | Description | Example |
|---------|-------------|---------|
| `tail -f /var/log/syslog` | Follow log file | `tail -f /var/log/syslog` |
| `grep ERROR /var/log/syslog` | Search for errors | `grep -i error /var/log/syslog` |
| `zgrep <pattern> <file.gz>` | Search compressed logs | `zgrep error /var/log/syslog.*.gz` |
| `dmesg` | Kernel ring buffer | `dmesg \| tail -50` |
| `dmesg -T` | Kernel messages with timestamps | `dmesg -T \| tail` |
| `last` | Login history | `last -10` |
| `lastb` | Failed login attempts | `sudo lastb -10` |
| `lastlog` | Recent login for all users | `lastlog` |

---

## 👤 User & Permission Commands

### User Management

| Command | Description | Example |
|---------|-------------|---------|
| `whoami` | Current user | `whoami` |
| `id` | User ID and groups | `id` |
| `id <user>` | Info about specific user | `id www-data` |
| `groups` | Current user's groups | `groups` |
| `users` | Logged in users | `users` |
| `who` | Who is logged in | `who` |
| `w` | Logged in users and activity | `w` |
| `finger <user>` | User information | `finger root` |

### Permission Commands

| Command | Description | Example |
|---------|-------------|---------|
| `chmod 755 <file>` | Change permissions | `chmod 755 script.sh` |
| `chmod +x <file>` | Add execute permission | `chmod +x script.sh` |
| `chown user:group <file>` | Change ownership | `chown www-data:www-data file.txt` |
| `chown -R user:group <dir>` | Recursive ownership change | `chown -R www-data:www-data /var/www` |
| `chattr +i <file>` | Make file immutable | `sudo chattr +i /etc/passwd` |
| `chattr -i <file>` | Remove immutable flag | `sudo chattr -i /etc/passwd` |
| `lsattr <file>` | List file attributes | `lsattr /etc/passwd` |
| `getfacl <file>` | Get ACL permissions | `getfacl /var/log/syslog` |
| `setfacl -m u:user:rw <file>` | Set ACL permissions | `setfacl -m u:john:rw file.txt` |

### sudo Commands

| Command | Description | Example |
|---------|-------------|---------|
| `sudo <cmd>` | Run as root | `sudo apt update` |
| `sudo -u <user> <cmd>` | Run as specific user | `sudo -u www-data touch file.txt` |
| `sudo -i` | Interactive root shell | `sudo -i` |
| `sudo -l` | List allowed sudo commands | `sudo -l` |
| `visudo` | Edit sudoers safely | `sudo visudo` |

---

## 🕐 Time & Scheduling Commands

### Time Commands

| Command | Description | Example |
|---------|-------------|---------|
| `date` | Current date/time | `date` |
| `date +"%Y-%m-%d %H:%M:%S"` | Formatted date | `date +"%Y-%m-%d %H:%M:%S"` |
| `timedatectl` | Time/timezone info | `timedatectl status` |
| `timedatectl set-timezone <tz>` | Set timezone | `sudo timedatectl set-timezone UTC` |
| `hwclock` | Hardware clock | `sudo hwclock --show` |
| `ntpq -p` | NTP peers status | `ntpq -p` |
| `chronyc sources` | Chrony time sources | `chronyc sources` |
| `chronyc tracking` | Chrony tracking info | `chronyc tracking` |

### Cron Commands

| Command | Description | Example |
|---------|-------------|---------|
| `crontab -l` | List cron jobs | `crontab -l` |
| `crontab -e` | Edit cron jobs | `crontab -e` |
| `crontab -u <user> -l` | List user's cron jobs | `sudo crontab -u www-data -l` |
| `cat /etc/crontab` | System crontab | `cat /etc/crontab` |
| `ls /etc/cron.d/` | Additional cron files | `ls -la /etc/cron.d/` |
| `systemctl status cron` | Cron service status | `systemctl status cron` |

---

## 🔍 Quick Troubleshooting Combos

### Disk Issues
```bash
df -h && df -i                        # Space and inodes
du -sh /var/log/* | sort -h           # Find large directories
lsof | grep deleted                   # Deleted but open files
```

### Memory Issues
```bash
free -h && vmstat 1 3                 # Memory overview
ps aux --sort=-%mem | head            # Top memory consumers
dmesg | grep -i oom                   # OOM killer events
```

### CPU Issues
```bash
uptime && top -bn1 | head -20         # Load and top processes
ps aux --sort=-%cpu | head            # Top CPU consumers
mpstat 1 5                            # Per-CPU statistics
```

### Network Issues
```bash
ip addr && ip route                   # IP and routing
ss -tulpn                             # Listening ports
ping -c 4 8.8.8.8 && ping -c 4 google.com  # Connectivity
```

### Service Issues
```bash
systemctl status <service>            # Service status
journalctl -xe -u <service>           # Service logs
systemctl --failed                    # All failed services
```

---

## 📌 Keyboard Shortcuts

### Terminal Shortcuts
| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Cancel current command |
| `Ctrl+Z` | Suspend current command |
| `Ctrl+D` | Exit shell / EOF |
| `Ctrl+L` | Clear screen |
| `Ctrl+R` | Search command history |
| `Ctrl+A` | Move to start of line |
| `Ctrl+E` | Move to end of line |
| `Tab` | Auto-complete |
| `Tab Tab` | Show all completions |

### In `top` / `htop`
| Key | Action |
|-----|--------|
| `q` | Quit |
| `k` | Kill process |
| `M` | Sort by memory |
| `P` | Sort by CPU |
| `h` | Help |

### In `less`
| Key | Action |
|-----|--------|
| `q` | Quit |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `g` | Go to top |
| `G` | Go to bottom |

---

This cheatsheet covers the most commonly used commands for Linux troubleshooting. For more details on any command, use `man <command>` or `<command> --help`.
