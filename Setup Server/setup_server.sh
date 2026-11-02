#!/bin/bash

# ==============================================================================
# Automated Server Provisioning & Setup Script
# Author: Abdelazeez Mabrouk
# GitHub: https://github.com/digimindx
# LinkedIn: https://www.linkedin.com/in/abdelazeez-mabrouk/
# Description: Automated OS updates, security hardening (UFW & Fail2ban),
#              sudo user configuration with SSH key, and installation of Docker,
#              Docker Compose, and Nginx on Ubuntu/Debian servers.
# ==============================================================================

set -e # Exit immediately if a command exits with a non-zero status

# Colors for Output Logging
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

log_success() {
    echo -e "${GREEN}[SUCCESS] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

log_error() {
    echo -e "${RED}[ERROR] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  log_error "Please run this script as root or using sudo."
  exit 1
fi

# Variables (Customize these before execution)
NEW_USER="devops"
PUB_KEY_URL="" # Optional: URL to public SSH key (e.g., https://github.com/username.keys)
SSH_PUBLIC_KEY="" # Optional: Paste your public SSH key string here if not using URL

log_info "Starting Automated Server Provisioning..."

# ------------------------------------------------------------------------------
# 1. Update & Upgrade System Packages
# ------------------------------------------------------------------------------
log_info "Updating system package repositories and upgrading packages..."
apt-get update -y && apt-get upgrade -y
apt-get install -y curl wget git unzip software-properties-common apt-transport-https ca-certificates lsb-release ufw fail2ban

# ------------------------------------------------------------------------------
# 2. Configure Security & Firewall (UFW & Fail2ban)
# ------------------------------------------------------------------------------
log_info "Configuring Security Hardening (UFW Firewall & Fail2ban)..."

# Configure Firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
echo "y" | ufw enable

# Configure Fail2ban for SSH Protection
systemctl enable fail2ban
systemctl start fail2ban

log_success "Firewall (UFW) and Fail2ban configured successfully."

# ------------------------------------------------------------------------------
# 3. Create Administrative User & Configure SSH Keys
# ------------------------------------------------------------------------------
if id "$NEW_USER" &>/dev/null; then
    log_info "User '$NEW_USER' already exists. Skipping user creation."
else
    log_info "Creating user '$NEW_USER' with sudo privileges..."
    useradd -m -s /bin/bash "$NEW_USER"
    usermod -aG sudo "$NEW_USER"
    # Allow passwordless sudo for automation ease (Optional)
    echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$NEW_USER
    log_success "User '$NEW_USER' created successfully."
fi

# Setup SSH Directory for the new user
USER_SSH_DIR="/home/$NEW_USER/.ssh"
mkdir -p "$USER_SSH_DIR"
chmod 700 "$USER_SSH_DIR"

if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" > "$USER_SSH_DIR/authorized_keys"
    log_info "Added SSH key from string variable."
elif [ -n "$PUB_KEY_URL" ]; then
    curl -s "$PUB_KEY_URL" > "$USER_SSH_DIR/authorized_keys"
    log_info "Downloaded SSH key from $PUB_KEY_URL."
fi

if [ -f "$USER_SSH_DIR/authorized_keys" ]; then
    chmod 600 "$USER_SSH_DIR/authorized_keys"
    chown -R "$NEW_USER:$NEW_USER" "$USER_SSH_DIR"
    log_success "SSH Authorized Keys set up successfully for '$NEW_USER'."
fi

# ------------------------------------------------------------------------------
# 4. Install Docker & Docker Compose
# ------------------------------------------------------------------------------
log_info "Installing Docker Engine and Docker Compose..."
if ! command -v docker &> /dev/null; then
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add user to docker group
    usermod -aG docker "$NEW_USER"
    systemctl enable docker
    systemctl start docker
    log_success "Docker installed and service enabled successfully."
else
    log_info "Docker is already installed."
fi

# ------------------------------------------------------------------------------
# 5. Install & Configure Nginx
# ------------------------------------------------------------------------------
log_info "Installing Nginx Web Server..."
if ! command -v nginx &> /dev/null; then
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    log_success "Nginx installed and service started successfully."
else
    log_info "Nginx is already installed."
fi

# ------------------------------------------------------------------------------
# 6. Final Clean-up
# ------------------------------------------------------------------------------
log_info "Cleaning up unneeded packages..."
apt-get autoremove -y && apt-get clean -y

log_success "================================================================="
log_success " Server Provisioning completed successfully!"
log_success " Created User: $NEW_USER"
log_success " Installed Services: Docker, Docker Compose, Nginx, UFW, Fail2ban"
log_success "================================================================="