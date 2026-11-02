#!/bin/bash

# ==============================================================================
# Automated Application Zero-Downtime Deployment Script (Git-based)
# Author: Abdelazeez Mabrouk
# GitHub: https://github.com/digimindx
# LinkedIn: https://www.linkedin.com/in/abdelazeez-mabrouk/
# Description: Automates pulling latest code, updating dependencies (Composer/NPM),
#              database migrations, and reloading services with zero downtime.
# ==============================================================================

set -e

# Output Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

log_success() {
    echo -e "${GREEN}[SUCCESS] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

log_error() {
    echo -e "${RED}[ERROR] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}"
}

# Configuration Paths
PROJECT_DIR="/var/www/html/my-app"
BRANCH_NAME="main"
WEB_SERVICE="nginx" # or php-fpm, apache2, etc.

log_info "Starting Automated Application Deployment..."

# Navigate to project directory
if [ ! -d "$PROJECT_DIR" ]; then
    log_error "Project directory $PROJECT_DIR does not exist!"
    exit 1
fi

cd "$PROJECT_DIR"
log_info "Working directory set to: $PROJECT_DIR"

# ------------------------------------------------------------------------------
# 1. Pull Latest Code from Git Repository
# ------------------------------------------------------------------------------
log_info "Fetching latest changes from origin/$BRANCH_NAME..."
git fetch origin "$BRANCH_NAME"
git reset --hard "origin/$BRANCH_NAME"
log_success "Codebase updated successfully."

# ------------------------------------------------------------------------------
# 2. Install / Update PHP (Composer) & Node.js (NPM) Dependencies
# ------------------------------------------------------------------------------
if [ -f "composer.json" ]; then
    log_info "Composer dependencies detected. Installing/Updating..."
    composer install --no-dev --optimize-autoloader --no-interaction
    log_success "Composer packages updated."
fi

if [ -f "package.json" ]; then
    log_info "Node.js dependencies detected. Building frontend assets..."
    npm install
    if npm run | grep -q "build"; then
        npm run build
    fi
    log_success "Frontend assets built successfully."
fi

# ------------------------------------------------------------------------------
# 3. Run Database Migrations (If applicable)
# ------------------------------------------------------------------------------
if [ -f "artisan" ]; then
    log_info "Laravel framework detected. Running database migrations..."
    php artisan migrate --force
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    log_success "Laravel cache optimized and migrations executed."
fi

# ------------------------------------------------------------------------------
# 4. Graceful Service Reload (Zero Downtime)
# ------------------------------------------------------------------------------
log_info "Reloading web server services gracefully for Zero Downtime..."

if systemctl is-active --quiet php8.2-fpm; then
    systemctl reload php8.2-fpm
elif systemctl is-active --quiet php8.1-fpm; then
    systemctl reload php8.1-fpm
fi

if systemctl is-active --quiet "$WEB_SERVICE"; then
    systemctl reload "$WEB_SERVICE"
    log_success "Service $WEB_SERVICE reloaded gracefully."
else
    log_error "Warning: Web service $WEB_SERVICE is not active."
fi

log_success "================================================================="
log_success " Application Deployment Completed Successfully (Zero Downtime)!"
log_success "================================================================="