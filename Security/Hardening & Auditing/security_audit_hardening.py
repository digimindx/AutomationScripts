#!/usr/bin/env python3
"""
Automated Security Auditing & Hardening Script (SSH & File Permissions Check).
Author: Abdelazeez Mabrouk
GitHub: https://github.com/digimindx
LinkedIn: https://www.linkedin.com/in/abdelazeez-mabrouk/
Description: Audits Linux sensitive file permissions, checks for failed SSH brute-force 
             login attempts, and automates Fail2ban & UFW firewall setup for threat mitigation.
"""

import os
import sys
import subprocess
import datetime
import re

# ==============================================================================
# Terminal Color Codes & Formatting
# ==============================================================================
GREEN = "\033[0;32m"
BLUE = "\033[0;34m"
YELLOW = "\033[1;33m"
RED = "\033[0;31m"
RESET = "\033[0m"

def log_info(msg):
    print(f"{BLUE}[INFO] {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {msg}{RESET}")

def log_success(msg):
    print(f"{GREEN}[SUCCESS] {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {msg}{RESET}")

def log_warn(msg):
    print(f"{YELLOW}[WARN] {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {msg}{RESET}")

def log_error(msg):
    print(f"{RED}[ERROR] {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {msg}{RESET}")

# Ensure Script is Run as Root
if os.geteuid() != 0:
    log_error("This security audit script must be executed with root/sudo privileges.")
    sys.exit(1)

# ==============================================================================
# 1. Audit Sensitive System File Permissions
# ==============================================================================
CRITICAL_FILES = {
    "/etc/passwd": "644",
    "/etc/shadow": "600",
    "/etc/group": "644",
    "/etc/gshadow": "600",
    "/etc/ssh/sshd_config": "600"
}

def audit_file_permissions():
    log_info("Starting System File Permissions Audit...")
    permission_issues = 0

    for filepath, expected_octal in CRITICAL_FILES.items():
        if not os.path.exists(filepath):
            log_warn(f"File {filepath} does not exist on this system.")
            continue

        stat_info = os.stat(filepath)
        current_octal = oct(stat_info.st_mode)[-3:]

        if current_octal != expected_octal:
            log_warn(f"Insecure permissions on {filepath}: Found {current_octal}, Expected {expected_octal}.")
            log_info(f"Remediating permissions on {filepath} -> chmod {expected_octal}...")
            os.chmod(filepath, int(expected_octal, 8))
            permission_issues += 1
        else:
            log_success(f"Permissions verified for {filepath} ({current_octal} OK).")

    if permission_issues == 0:
        log_success("All sensitive system file permissions are fully secure.")

# ==============================================================================
# 2. Audit SSH Brute-Force Attempts
# ==============================================================================
def audit_ssh_brute_force():
    log_info("Analyzing authentication logs for SSH Brute-Force attempts...")
    
    auth_logs = ["/var/log/auth.log", "/var/log/secure"]
    failed_ips = {}

    log_file_path = None
    for path in auth_logs:
        if os.path.exists(path):
            log_file_path = path
            break

    if not log_file_path:
        log_warn("No system authentication log file found (/var/log/auth.log or /var/log/secure).")
        return

    # Regular Expression to catch failed SSH attempts & IP addresses
    ip_pattern = re.compile(r"Failed password for .* from (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})")

    try:
        with open(log_file_path, "r", errors="ignore") as f:
            for line in f:
                match = ip_pattern.search(line)
                if match:
                    ip = match.group(1)
                    failed_ips[ip] = failed_ips.get(ip, 0) + 1

        if failed_ips:
            log_warn(f"Detected failed SSH login attempts from {len(failed_ips)} unique IP addresses:")
            for ip, count in sorted(failed_ips.items(), key=lambda item: item[1], reverse=True)[:10]:
                print(f"   --> IP: {ip:<15} Failed Attempts: {count}")
        else:
            log_success("No failed SSH brute-force login attempts detected in recent logs.")

    except Exception as e:
        log_error(f"Error reading authentication log file: {str(e)}")

# ==============================================================================
# 3. Setup Automated Mitigation (Fail2ban & UFW Hardening)
# ==============================================================================
def enforce_fail2ban_hardening():
    log_info("Enforcing automated brute-force prevention (Fail2ban)...")

    # Check if fail2ban is installed
    check_fail2ban = subprocess.run(["which", "fail2ban-client"], capture_output=True, text=True)
    
    if check_fail2ban.returncode != 0:
        log_info("Fail2ban not detected. Installing Fail2ban package...")
        subprocess.run(["apt-get", "update", "-y"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(["apt-get", "install", "-y", "fail2ban"], check=True)
        log_success("Fail2ban installed successfully.")

    # Create optimized jail configuration for SSH protection
    jail_local_content = """[DEFAULT]
bantime  = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
"""
    
    jail_path = "/etc/fail2ban/jail.local"
    with open(jail_path, "w") as f:
        f.write(jail_local_content)

    # Enable and restart Fail2ban service
    subprocess.run(["systemctl", "enable", "fail2ban"], check=True)
    subprocess.run(["systemctl", "restart", "fail2ban"], check=True)
    log_success("Fail2ban jail rules active: IPs with >5 failed logins will be banned for 1 hour.")

# ==============================================================================
# Main Execution Flow
# ==============================================================================
def main():
    print("=================================================================")
    print("      LINUX SYSTEM SECURITY AUDIT & AUTOMATED HARDENING           ")
    print("=================================================================")
    
    audit_file_permissions()
    audit_ssh_brute_force()
    enforce_fail2ban_hardening()

    print("=================================================================")
    log_success("Security Audit & Automated Remediation Completed Successfully.")
    print("=================================================================")

if __name__ == "__main__":
    main()