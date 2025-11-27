# Lab 20: Docker Containers Not Starting

## SOLUTION GUIDE

---

## 🔍 Root Cause

Common reasons containers don't start:
1. Docker daemon not running
2. Application error inside container
3. Missing environment variables
4. Volume mount failures
5. Port conflicts

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check Docker Daemon

```bash
sudo systemctl status docker
```

If not running: `sudo systemctl start docker`

### Step 2: Check Container Status

```bash
docker ps -a
```

### Step 3: View Container Logs

```bash
docker logs <container_name>
```

Look for error messages, missing dependencies, etc.

### Step 4: Inspect Container

```bash
docker inspect <container_name>
```

Check mounts, environment variables, exit code.

### Step 5: Fix and Restart

Based on the error, fix the issue:
```bash
# Start stopped container
docker start <container_name>

# Or recreate with fixed config
docker run -d --name myapp ...
```

---

## 🛡️ Prevention

1. **Use health checks** in Docker Compose
2. **Test containers** before deployment
3. **Set up container monitoring** (Prometheus + cAdvisor)
4. **Use restart policies** (`--restart=unless-stopped`)
