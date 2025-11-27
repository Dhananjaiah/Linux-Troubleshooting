# How to Use the Labs

This guide walks you through the complete process of running a lab from start to finish.

## 🎯 Lab Workflow Overview

Each lab follows this workflow:

```
┌─────────────────┐
│   1. PREPARE    │  Read LAB.md, understand the scenario
└────────┬────────┘
         ▼
┌─────────────────┐
│   2. BREAK      │  Run break.sh to create the problem
└────────┬────────┘
         ▼
┌─────────────────┐
│   3. DIAGNOSE   │  Investigate and identify root cause
└────────┬────────┘
         ▼
┌─────────────────┐
│   4. FIX        │  Apply your solution
└────────┬────────┘
         ▼
┌─────────────────┐
│   5. VERIFY     │  Run verify.sh to confirm the fix
└────────┬────────┘
         ▼
┌─────────────────┐
│   6. REVIEW     │  Check SOLUTION.md to compare approaches
└────────┬────────┘
         ▼
┌─────────────────┐
│   7. CLEANUP    │  Run cleanup.sh before next lab
└─────────────────┘
```

## 📁 Understanding the Lab Structure

Each lab folder contains:

```
labs/01-disk-full-app-failure/
├── LAB.md           # Student instructions (READ FIRST)
├── SOLUTION.md      # Complete solution (READ AFTER ATTEMPTING)
└── scripts/
    ├── break.sh     # Creates the problem
    ├── verify.sh    # Checks if problem is fixed
    └── cleanup.sh   # Resets the environment
```

## 🚀 Complete Example: Running Lab 01

Let's walk through Lab 01 (Disk Full - Application Failure) step by step.

### Step 1: Navigate to the Lab

```bash
# Change to the lab directory
cd /path/to/Linux-Troubleshooting/labs/01-disk-full-app-failure
```

**Output:**
```
user@ubuntu:~/Linux-Troubleshooting/labs/01-disk-full-app-failure$
```

### Step 2: Read the Lab Instructions

```bash
# Read the student-facing instructions
cat LAB.md
# Or use a pager for long files
less LAB.md
```

Take your time to understand:
- The scenario and story
- What symptoms you'll observe
- The tasks you need to complete
- Available hints

### Step 3: Run the Break Script

```bash
# Make the script executable (first time only)
chmod +x scripts/break.sh

# Run the break script with sudo
sudo ./scripts/break.sh
```

**Example Output:**
```
[BREAK] Starting disk full simulation...
[INFO] Creating large files in /var/log/app-simulation...
[INFO] Creating file 1 of 10 (100MB)...
[INFO] Creating file 2 of 10 (100MB)...
...
[BREAK] Disk full condition created!
[INFO] The application 'simulated-app' is now failing.
[BREAK] Your task: Identify why and fix it!
```

### Step 4: Observe the Symptoms

Before fixing, confirm the problem exists:

```bash
# Check disk usage
df -h

# Try to write a file (should fail)
touch /var/log/test-file

# Check the application status
sudo systemctl status simulated-app
```

**Example Output (showing the problem):**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G   19G  100M  99% /

touch: cannot touch '/var/log/test-file': No space left on device

● simulated-app.service - Simulated Application
   Active: failed (Result: exit-code)
```

### Step 5: Troubleshoot and Diagnose

Use your Linux knowledge to investigate:

```bash
# Find what's using disk space
sudo du -sh /var/log/*

# Look for large files
sudo find /var/log -type f -size +50M

# Check for deleted but open files
sudo lsof | grep deleted
```

### Step 6: Apply Your Fix

Based on your diagnosis, fix the issue. For example:

```bash
# Remove the large files causing the issue
sudo rm -f /var/log/app-simulation/large-file-*.dat

# Restart the affected service
sudo systemctl restart simulated-app
```

### Step 7: Verify the Fix

```bash
# Run the verify script
./scripts/verify.sh
```

**Example Output (success):**
```
[VERIFY] Checking system status...
[✓] Disk usage is below 90%
[✓] simulated-app service is running
[✓] Application is responding to requests
[VERIFY] All checks passed! Lab completed successfully.
```

**Example Output (failure):**
```
[VERIFY] Checking system status...
[✗] Disk usage is still above 90% (Current: 95%)
[VERIFY] Some checks failed. Keep troubleshooting!
```

### Step 8: Compare with the Solution

After completing (or if stuck), review the official solution:

```bash
cat SOLUTION.md
```

Compare your approach with the recommended troubleshooting steps.

### Step 9: Clean Up

Before starting another lab:

```bash
# Run the cleanup script
sudo ./scripts/cleanup.sh
```

**Example Output:**
```
[CLEANUP] Removing simulation files...
[CLEANUP] Stopping simulated-app service...
[CLEANUP] Restoring default configuration...
[CLEANUP] Environment restored to clean state.
```

## 💡 Tips for Success

### Do's
- ✅ Read the entire LAB.md before running break.sh
- ✅ Take notes as you troubleshoot
- ✅ Try multiple approaches before checking SOLUTION.md
- ✅ Understand WHY the fix works, not just WHAT to type
- ✅ Run cleanup.sh between labs

### Don'ts
- ❌ Don't run break.sh on production systems
- ❌ Don't skip to SOLUTION.md immediately
- ❌ Don't skip the verification step
- ❌ Don't ignore error messages - they are clues!

## 🎓 Learning Strategies

### For Beginners
1. Follow the hints in LAB.md
2. Use the cheatsheet for command references
3. Check SOLUTION.md if stuck for more than 30 minutes
4. Re-run the lab after reading the solution

### For Intermediate Users
1. Try to solve without looking at hints
2. Time yourself to build speed
3. Document your troubleshooting process
4. Research unfamiliar commands/concepts

### For Advanced Users
1. Set a time limit (e.g., 15 minutes)
2. Try alternative solutions
3. Think about how to automate the detection
4. Consider how to prevent the issue in production

## 🔄 Repeating Labs

Want to practice a lab again?

```bash
# 1. Clean up any previous state
sudo ./scripts/cleanup.sh

# 2. Re-run the break script
sudo ./scripts/break.sh

# 3. Try a different approach this time
```

## 🚨 Troubleshooting Common Issues

### "Permission denied" when running scripts
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Or run with bash explicitly
sudo bash scripts/break.sh
```

### "Command not found" errors
```bash
# Install missing tools
sudo apt update
sudo apt install <package-name>
```

### Lab environment seems corrupted
```bash
# Run cleanup to reset
sudo ./scripts/cleanup.sh

# If cleanup fails, restore from VM snapshot
```

### Verify script still shows failure after fix
- Double-check your fix was applied correctly
- Some services need a restart
- Some changes need time to take effect
- Read the error messages from verify.sh carefully

## 📊 Tracking Your Progress

Create a simple tracking file:

```bash
# Create a progress tracker
cat > ~/lab-progress.md << 'EOF'
# Lab Progress

## Completed Labs
- [ ] Lab 01 - Disk Full
- [ ] Lab 02 - SSH Login Failure
- [ ] Lab 03 - Webserver Down
...

## Notes
### Lab 01
- Date completed: 
- Time taken: 
- Difficulty: 
- Key learnings: 

EOF
```

## 🔗 Quick Reference Links

- [Prerequisites](prerequisites.md) - System requirements
- [Command Cheatsheet](common-commands-cheatsheet.md) - Common commands
- [Lab 01](labs/01-disk-full-app-failure/) - Start here!

---

Ready to begin? Start with **[Lab 01: Disk Full - Application Failure](labs/01-disk-full-app-failure/)**!
