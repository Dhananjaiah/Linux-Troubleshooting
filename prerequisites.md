# Prerequisites for Linux Troubleshooting Labs

Before starting the Break & Fix Labs, ensure you have the following requirements met.

## 🖥️ System Requirements

### Operating System
- **Ubuntu 22.04 LTS** (server edition, minimal installation)
- No GUI required (headless server is fine)
- Both virtual machines (VMs) and bare metal work

### Recommended VM Specifications
| Resource | Minimum | Recommended |
|----------|---------|-------------|
| vCPU | 1 core | 2 cores |
| RAM | 2 GB | 4 GB |
| Disk | 20 GB | 40 GB |
| Network | NAT or Bridged | Bridged (for network labs) |

### Virtualization Platforms (Recommended)
- VirtualBox (free, cross-platform)
- VMware Workstation/Player
- Hyper-V (Windows)
- KVM/QEMU (Linux)
- Cloud instances (AWS EC2, GCP, Azure, DigitalOcean)

## 👤 User Access Requirements

You need a **non-root user with sudo privileges**.

### Check Your Sudo Access
```bash
# Run this command - it should NOT ask for a password repeatedly
sudo whoami
# Expected output: root
```

### Create a User with Sudo (if needed)
```bash
# As root, create a new user
sudo adduser labuser

# Add user to sudo group
sudo usermod -aG sudo labuser

# Switch to the new user
su - labuser
```

## 🛠️ Required Packages

Most labs require standard system utilities. Install them with:

```bash
# Update package lists
sudo apt update

# Install essential troubleshooting tools
sudo apt install -y \
    curl \
    wget \
    net-tools \
    iputils-ping \
    dnsutils \
    vim \
    nano \
    htop \
    iotop \
    sysstat \
    lsof \
    strace \
    tcpdump \
    traceroute \
    mtr \
    tree \
    git

# Install specific lab dependencies
sudo apt install -y \
    apache2 \
    nginx \
    mysql-server \
    nfs-common \
    docker.io \
    chrony
```

> **Note**: Not all packages are needed for every lab. Install only what you need, or install all for convenience.

## 📚 Required Knowledge & Skills

### Basic Skills (Required)
Before starting, you should be comfortable with:

- [ ] Navigating the Linux filesystem (`cd`, `ls`, `pwd`)
- [ ] Viewing file contents (`cat`, `less`, `head`, `tail`)
- [ ] Editing files with a text editor (`vim`, `nano`)
- [ ] Basic file permissions (`chmod`, `chown`)
- [ ] Using `sudo` for administrative tasks
- [ ] Understanding basic piping and redirection (`|`, `>`, `>>`)

### Intermediate Skills (Helpful)
These skills will make the labs easier:

- [ ] Process management (`ps`, `top`, `kill`)
- [ ] Service management (`systemctl`, `service`)
- [ ] Viewing logs (`journalctl`, `/var/log/`)
- [ ] Basic networking (`ip`, `ping`, `ss`)
- [ ] Disk management (`df`, `du`, `mount`)

### Quick Self-Assessment

Run these commands and verify you understand the output:

```bash
# Can you explain what each of these shows?
df -h
free -m
ps aux | head
ip addr show
systemctl status ssh
journalctl -n 10
```

If any of these are unfamiliar, review basic Linux tutorials before starting.

## 🔧 Environment Preparation

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/Linux-Troubleshooting.git
cd Linux-Troubleshooting
```

### 2. Make Scripts Executable
```bash
# Make all scripts in the labs directory executable
find labs/ -name "*.sh" -exec chmod +x {} \;
```

### 3. Create a Snapshot (Recommended)
If using a VM, create a snapshot now. This gives you a clean restore point.

**VirtualBox:**
```bash
VBoxManage snapshot "VM_NAME" take "clean-state"
```

**VMware:**
```
Virtual Machine → Snapshot → Take Snapshot
```

### 4. Verify Your Setup
```bash
# Check OS version
lsb_release -a

# Check user permissions
id
sudo -l

# Check available disk space
df -h /

# Check available memory
free -h
```

## ⚠️ Important Notes

### Do NOT Use Production Systems
- **These labs intentionally break things**
- Always use a dedicated test environment
- Data loss is possible if cleanup fails

### Network Considerations
- Some labs require internet access for package installation
- Some labs simulate network issues (temporarily disable connections)
- If using cloud instances, be aware of egress costs

### Time Expectations
| Lab Difficulty | Estimated Time |
|----------------|----------------|
| Beginner (01-10) | 15-30 minutes each |
| Intermediate (11-20) | 30-45 minutes each |
| Advanced (21-31) | 45-90 minutes each |

## ✅ Prerequisite Checklist

Before starting Lab 01, verify:

- [ ] Ubuntu 22.04 LTS installed
- [ ] Non-root user with sudo access configured
- [ ] Repository cloned to your system
- [ ] Scripts made executable
- [ ] VM snapshot created (recommended)
- [ ] Comfortable with basic Linux commands
- [ ] Text editor configured (vim/nano)

---

Ready to start? Head to [how-to-use-labs.md](how-to-use-labs.md) for detailed instructions, then begin with [Lab 01: Disk Full - Application Failure](labs/01-disk-full-app-failure/).
