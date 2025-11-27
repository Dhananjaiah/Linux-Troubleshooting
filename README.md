# Linux Troubleshooting – Break & Fix Labs

Welcome to the **Linux Troubleshooting – Break & Fix Labs** course! This repository contains **31 hands-on labs** designed to teach you real-world Linux troubleshooting skills through practical, scenario-based exercises.

## 🎯 Course Overview

This course simulates real production issues that Linux System Administrators and Site Reliability Engineers (SREs) encounter daily. Each lab follows a **Break → Investigate → Fix** methodology:

1. **Break**: Run a script that introduces a realistic problem
2. **Investigate**: Use your troubleshooting skills to identify the root cause
3. **Fix**: Apply the correct solution to restore normal operation
4. **Verify**: Confirm the fix worked correctly

## 🖥️ Target Environment

- **Operating System**: Ubuntu 22.04 LTS (minimal server, no GUI)
- **User Access**: Non-root user with sudo privileges
- **Shell**: /bin/bash

## 📚 How to Use This Repository

### Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/Linux-Troubleshooting.git
cd Linux-Troubleshooting

# 2. Navigate to a lab (e.g., Lab 01)
cd labs/01-disk-full-app-failure

# 3. Read the lab instructions
cat LAB.md

# 4. Run the break script to create the problem
sudo ./scripts/break.sh

# 5. Troubleshoot and fix the issue using the hints in LAB.md

# 6. Verify your fix
./scripts/verify.sh

# 7. (Optional) Check the solution
cat SOLUTION.md

# 8. Clean up before moving to the next lab
sudo ./scripts/cleanup.sh
```

### Detailed Instructions

See [how-to-use-labs.md](how-to-use-labs.md) for a complete walkthrough with examples.

## 📋 Prerequisites

Before starting, ensure you have:
- Basic Linux command-line skills
- A test Ubuntu 22.04 LTS server (VM recommended)
- sudo access on the test server

See [prerequisites.md](prerequisites.md) for detailed requirements.

## 🔧 Command Reference

Need a quick refresher on common commands? Check out [common-commands-cheatsheet.md](common-commands-cheatsheet.md).

## 🗂️ Lab Index

### Beginner Labs (Start Here)
| # | Lab Name | Topic |
|---|----------|-------|
| 01 | [Disk Full - Application Failure](labs/01-disk-full-app-failure/) | Disk Management |
| 02 | [SSH Login Failure](labs/02-ssh-login-failure/) | SSH & Authentication |
| 03 | [Webserver Down (Apache/Nginx)](labs/03-webserver-down-apache-nginx/) | Web Services |
| 04 | [High CPU Usage](labs/04-high-cpu-usage/) | Performance |
| 05 | [Low Memory / OOM](labs/05-low-memory-oom/) | Memory Management |
| 06 | [Database Too Many Connections](labs/06-db-too-many-connections/) | Database |
| 07 | [Network Interface Down](labs/07-network-interface-down/) | Networking |
| 08 | [Permission Denied Even as Root](labs/08-permission-denied-even-root/) | Permissions |
| 09 | [Wrong System Time](labs/09-wrong-system-time/) | Time & NTP |
| 10 | [Disk I/O Slowness](labs/10-disk-io-slowness/) | Performance |

### Intermediate Labs
| # | Lab Name | Topic |
|---|----------|-------|
| 11 | [Kernel Panic on Boot](labs/11-kernel-panic-on-boot/) | Boot Issues |
| 12 | [Password Change Not Working](labs/12-password-change-not-working/) | Authentication |
| 13 | [DNS Resolution Failing](labs/13-dns-resolution-failing/) | DNS |
| 14 | [Out of Inodes](labs/14-out-of-inodes/) | Filesystem |
| 15 | [SSH Key Auth Not Working](labs/15-ssh-key-auth-not-working/) | SSH |
| 16 | [NFS Mount Failure](labs/16-nfs-mount-failure/) | Storage |
| 17 | [High Load Low CPU](labs/17-high-load-low-cpu/) | Performance |
| 18 | [Crontab Not Running](labs/18-crontab-not-running/) | Scheduling |
| 19 | [Emergency Mode Boot](labs/19-emergency-mode-boot/) | Boot Issues |
| 20 | [Docker Containers Not Starting](labs/20-docker-containers-not-starting/) | Containers |

### Advanced Labs
| # | Lab Name | Topic |
|---|----------|-------|
| 21 | [Not Responding to Ping](labs/21-not-responding-to-ping/) | Networking |
| 22 | [Too Many Open Files (FD Limit)](labs/22-too-many-open-files-fd-limit/) | System Limits |
| 23 | [New Disk Not Detected](labs/23-new-disk-not-detected/) | Storage |
| 24 | [Filesystem Read-Only](labs/24-filesystem-read-only/) | Filesystem |
| 25 | [Kernel Logs Flooding Disk](labs/25-kernel-logs-flooding-disk/) | Logging |
| 26 | [Server Suddenly Unresponsive](labs/26-server-suddenly-unresponsive/) | Performance |
| 27 | [Time Drifting](labs/27-time-drifting/) | Time & NTP |
| 28 | [GRUB Missing or Corrupt](labs/28-grub-missing-corrupt/) | Boot Issues |
| 29 | [Out of Swap](labs/29-out-of-swap/) | Memory |
| 30 | [Too Many Open TCP Connections](labs/30-too-many-open-tcp-connections/) | Networking |
| 31 | [Hidden/Orphaned Files Filling Disk](labs/31-hidden-or-orphaned-files-filling-disk/) | Disk Management |

## 📊 Suggested Learning Path

### Week 1: Foundations
- Labs 01-05 (Disk, SSH, Web, CPU, Memory)

### Week 2: Services & Network
- Labs 06-10 (Database, Network, Permissions, Time, I/O)

### Week 3: Boot & Authentication
- Labs 11-15 (Kernel, Password, DNS, Inodes, SSH Keys)

### Week 4: Advanced Topics
- Labs 16-20 (NFS, Load, Cron, Boot, Docker)

### Week 5: Expert Scenarios
- Labs 21-25 (Network, FD Limits, Storage, Filesystem, Logging)

### Week 6: Production Readiness
- Labs 26-31 (Complex scenarios combining multiple issues)

## ⚠️ Important Safety Notes

1. **Always use a test environment** - Never run these labs on production servers
2. **Snapshots recommended** - Take a VM snapshot before each lab
3. **Read before running** - Always review scripts before executing them
4. **Cleanup after each lab** - Run cleanup.sh before starting a new lab

## 🤝 Contributing

Found a bug or want to add a new lab? Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Contact

For questions, feedback, or support, please open an issue in this repository.

---

**Happy Troubleshooting! 🐧**
