#!/bin/bash

# ==============================================================================
# Automated System & Docker Cleanup Script
# Author: Abdelazeez Mabrouk
# GitHub: https://github.com/digimindx
# LinkedIn: https://www.linkedin.com/in/abdelazeez-mabrouk/
# Description: Automatically cleans log files older than 7 days, prunes unused 
#              Docker assets (containers, images, volumes), clears package caches, 
#              and logs liberated disk space.
# ==============================================================================

set -e

# Output Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

log_success() {
    echo -e "${GREEN}[SUCCESS] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}[WARN] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

# Retention period for log files (in days)
LOG_RETENTION_DAYS=7
LOG_DIR="/var/log"

log_info "Starting Automated System Cleanup & Disk Maintenance..."

# Record Initial Disk Usage
INITIAL_FREE_SPACE=$(df -h / | awk 'NR==2 {print $4}')
log_info "Initial Disk Free Space: $INITIAL_FREE_SPACE"

# ------------------------------------------------------------------------------
# 1. Clean Log Files Older Than 7 Days
# ------------------------------------------------------------------------------
log_info "Cleaning log files older than $LOG_RETENTION_DAYS days in $LOG_DIR..."

if [ -d "$LOG_DIR" ]; then
    # Rotate journald logs to release active unneeded system logs
    if command -v journalctl &> /dev/null; then
        log_info "Vacuuming systemd journald logs older than 7 days..."
        journalctl --vacuum-time=7d || true
    fi

    # Find and remove compressed log files (.gz, .1, .log) older than RETENTION_DAYS
    find "$LOG_DIR" -type f \( -name "*.gz" -o -name "*.1" -o -name "*.old" \) -mtime +$LOG_RETENTION_DAYS -exec rm -f {} \;
    
    # Truncate large active .log files older than RETENTION_DAYS instead of deleting them to avoid breaking active handles
    find "$LOG_DIR" -type f -name "*.log" -mtime +$LOG_RETENTION_DAYS -exec truncate -s 0 {} \;
    
    log_success "Log cleanup completed."
else
    log_warn "Directory $LOG_DIR does not exist. Skipping log cleanup."
fi

# ------------------------------------------------------------------------------
# 2. Prune Unused Docker Containers, Images, Networks, & Volumes
# ------------------------------------------------------------------------------
if command -v docker &> /dev/null; then
    log_info "Docker detected. Starting Docker resources cleanup..."

    # Remove stopped containers, dangling images, unused networks, and build cache
    docker system prune -af --volumes

    log_success "Docker system prune completed successfully."
else
    log_info "Docker is not installed on this system. Skipping Docker cleanup."
fi

# ------------------------------------------------------------------------------
# 3. Clear Package Manager Cache & Temporary Files
# ------------------------------------------------------------------------------
log_info "Clearing APT package manager cache and temporary files..."

if command -v apt-get &> /dev/null; then
    apt-get clean -y
    apt-get autoremove --purge -y
fi

# Clean /tmp directory files older than 7 days
find /tmp -type f -atime +7 -delete 2>/dev/null || true

log_success "Package manager cache and temporary files cleared."

# ------------------------------------------------------------------------------
# 4. Summary & Freed Disk Space Report
# ------------------------------------------------------------------------------
FINAL_FREE_SPACE=$(df -h / | awk 'NR==2 {print $4}')

log_success "================================================================="
log_success " System Cleanup Completed Successfully!"
log_success " Initial Free Disk Space: $INITIAL_FREE_SPACE"
log_success " Current Free Disk Space : $FINAL_FREE_SPACE"
log_success "================================================================="