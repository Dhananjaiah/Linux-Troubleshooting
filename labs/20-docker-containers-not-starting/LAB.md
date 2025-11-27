# Lab 20: Docker Containers Not Starting

## 📖 Scenario / Story

The deployment pipeline just pushed new containers, but they're **not starting**. The `docker ps` shows nothing running. The application is completely down.

**Your mission**: Debug Docker container startup issues and get the application running.

---

## 🎯 What You Will Learn

- Debug Docker container failures
- Use `docker logs` for troubleshooting
- Check Docker daemon status
- Understand common container startup issues
- Work with Docker networking and volumes

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- Docker installed (`sudo apt install docker.io`)
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/20-docker-containers-not-starting
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ docker ps
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
# Empty! Nothing running

$ docker ps -a
CONTAINER ID   IMAGE        STATUS                    NAMES
abc123         myapp        Exited (1) 5 minutes ago  myapp-container
```

---

## ✅ Tasks for You

1. **Check Docker service status**
2. **List all containers** including stopped ones
3. **Check container logs** for errors
4. **Identify why** the container exited
5. **Fix the issue** and start the container
6. **Verify** the container is running

---

## 💡 Hints

<details>
<summary><b>Hint 1: Docker Logs</b></summary>

```bash
# View container logs
docker logs <container_name>

# Follow logs
docker logs -f <container_name>

# View Docker daemon logs
journalctl -u docker
```
</details>

<details>
<summary><b>Hint 2: Container Details</b></summary>

```bash
# Inspect container
docker inspect <container_name>

# Check exit code
docker inspect --format='{{.State.ExitCode}}' <container_name>
```
</details>

---

## ✔️ Verification

```bash
./scripts/verify.sh
```

---

## 🧹 Cleanup

```bash
sudo ./scripts/cleanup.sh
```

---

**Previous Lab**: [19 - Emergency Mode Boot](../19-emergency-mode-boot/)  
**Next Lab**: [21 - Not Responding to Ping](../21-not-responding-to-ping/)
