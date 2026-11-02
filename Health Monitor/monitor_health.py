#!/usr/bin/env python3
"""
Automated Website & API Health Check Monitoring Script with Telegram Notifications.
Author: Abdelazeez Mabrouk
GitHub: https://github.com/digimindx
LinkedIn: https://www.linkedin.com/in/abdelazeez-mabrouk/
"""

import os
import sys
import datetime
import urllib.request
import urllib.error
import json

# ==============================================================================
# Configuration Options
# ==============================================================================

# List of URLs/APIs to monitor
TARGET_SERVICES = [
    {"name": "Main Website", "url": "https://example.com"},
    {"name": "REST API Health", "url": "https://api.example.com/health"},
]

# HTTP Request Timeout in seconds
TIMEOUT = 10

# Expected Success Status Codes
EXPECTED_STATUS_CODES = [200, 201, 202]

# Telegram Bot Alert Configuration
# Tip: Use environment variables or fill in direct values below
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "YOUR_TELEGRAM_BOT_TOKEN_HERE")
TELEGRAM_CHAT_ID = os.getenv("TELEGRAM_CHAT_ID", "YOUR_TELEGRAM_CHAT_ID_HERE")


# ==============================================================================
# Notification Functions
# ==============================================================================

def send_telegram_alert(service_name, target_url, error_message, status_code=None):
    """Sends an automated critical alert message via Telegram Bot Webhook."""
    if TELEGRAM_BOT_TOKEN == "YOUR_TELEGRAM_BOT_TOKEN_HERE" or not TELEGRAM_BOT_TOKEN:
        print("[WARNING] Telegram credentials not configured. Skipping notification.")
        return

    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    code_display = f"`{status_code}`" if status_code else "`N/A (Connection Failed)`"
    
    message_text = (
        f"🚨 *CRITICAL ALERT: Service Down!*\n\n"
        f"📌 *Service Name:* {service_name}\n"
        f"🌐 *URL:* {target_url}\n"
        f"📊 *HTTP Status Code:* {code_display}\n"
        f"⚠️ *Error Details:* `{error_message}`\n"
        f"⏰ *Time:* {timestamp}\n\n"
        f"⚡ _Please investigate immediately._"
    )

    telegram_api_url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": message_text,
        "parse_mode": "Markdown"
    }

    try:
        data = json.dumps(payload).encode('utf-8')
        req = urllib.request.Request(
            telegram_api_url,
            data=data,
            headers={'Content-Type': 'application/json'}
        )
        with urllib.request.urlopen(req, timeout=10) as response:
            if response.status == 200:
                print(f"[SUCCESS] Telegram alert sent for {service_name}.")
    except Exception as e:
        print(f"[ERROR] Failed to send Telegram alert: {e}", file=sys.stderr)


# ==============================================================================
# Core Health Check Routine
# ==============================================================================

def check_service_health(service):
    """Checks service HTTP status code and response time."""
    name = service["name"]
    url = service["url"]
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    req = urllib.request.Request(
        url,
        headers={'User-Agent': 'Python-HealthCheck-Monitor/1.0'}
    )

    try:
        start_time = datetime.datetime.now()
        with urllib.request.urlopen(req, timeout=TIMEOUT) as response:
            status_code = response.getcode()
            elapsed_ms = int((datetime.datetime.now() - start_time).total_seconds() * 1000)

            if status_code in EXPECTED_STATUS_CODES:
                print(f"[{timestamp}] [UP] {name} ({url}) - Status: {status_code} - Response Time: {elapsed_ms}ms")
                return True
            else:
                error_msg = f"Unexpected HTTP status code received: {status_code}"
                print(f"[{timestamp}] [DOWN] {name} ({url}) - {error_msg}")
                send_telegram_alert(name, url, error_msg, status_code)
                return False

    except urllib.error.HTTPError as e:
        error_msg = f"HTTP Error: {e.code} {e.reason}"
        print(f"[{timestamp}] [DOWN] {name} ({url}) - {error_msg}")
        send_telegram_alert(name, url, error_msg, e.code)
        return False

    except urllib.error.URLError as e:
        error_msg = f"URL/Network Error: {e.reason}"
        print(f"[{timestamp}] [DOWN] {name} ({url}) - {error_msg}")
        send_telegram_alert(name, url, error_msg)
        return False

    except Exception as e:
        error_msg = f"Unexpected Error: {str(e)}"
        print(f"[{timestamp}] [DOWN] {name} ({url}) - {error_msg}")
        send_telegram_alert(name, url, error_msg)
        return False


def main():
    print("==========================================================")
    print(f"Starting Health Check Monitor Run: {datetime.datetime.now()}")
    print("==========================================================")
    
    all_healthy = True
    for service in TARGET_SERVICES:
        healthy = check_service_health(service)
        if not healthy:
            all_healthy = False
            
    print("==========================================================")
    if all_healthy:
        print("All monitored services are UP and Healthy.")
    else:
        print("Health Check complete with service failures detected.")
    print("==========================================================")

if __name__ == "__main__":
    main()