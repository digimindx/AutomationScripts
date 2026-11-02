# 🚀 Automated Server Provisioning & Security Hardening Script

![Bash Shell](https://img.shields.io/badge/Shell_Script-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux Support](https://img.shields.io/badge/Supported_OS-Ubuntu%2FDebian-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Docker Ready](https://img.shields.io/badge/Includes-Docker%20%26%20Nginx-2496ED?style=for-the-badge&logo=docker&logoColor=white)


An enterprise-ready **Bash Automation Script** designed for Linux system administrators and DevOps engineers. It automates the initial setup, software provisioning, user creation, and security hardening of fresh **Ubuntu / Debian** servers with a single execution.

---

## 🌐 Language Options / خيارات اللغة

- [English](#-english-documentation)
- [اللغة العربية](##-التوثيق-باللغة-العربية)

---

## English Documentation

### 🌟 Key Features

1. **System Maintenance:** Automated package list updating and upgrade execution.
2. **Security Hardening:**
   - **UFW (Uncomplicated Firewall):** Configures firewall rules (allows SSH/22, HTTP/80, HTTPS/443; blocks all other incoming traffic).
   - **Fail2ban:** Deploys automated brute-force protection against SSH attacks.
3. **User Management & SSH Setup:**
   - Creates a new sudo-privileged administrative user (`devops`).
   - Automated SSH public key insertion for secure passwordless login.
4. **DevOps & Web Stack Installation:**
   - **Docker Engine & Docker Compose:** Official repository installation and user permissions configuration.
   - **Nginx Web Server:** High-performance web server setup and service activation.
5. **Production Ready Logging:** Colored terminal status logs (`INFO`, `SUCCESS`, `ERROR`).

---

### 📋 Prerequisites

- A fresh installation of **Ubuntu (20.04/22.04/24.04)** or **Debian (11/12)**.
- Root or `sudo` access.

---

### 🚀 Fast Execution Guide

#### Option A: Clone Repository & Run

```bash
# 1. Clone the repository
git clone [https://github.com/digimindx/server-provisioning-script.git](https://github.com/digimindx/server-provisioning-script.git)
cd server-provisioning-script

# 2. Grant execution permissions
chmod +x setup_server.sh

# 3. Run script with sudo
sudo ./setup_server.sh
````

#### Option B: One-Liner Direct Execution

Bash

```
curl -sSL [https://raw.githubusercontent.com/digimindx/server-provisioning-script/main/setup_server.sh](https://raw.githubusercontent.com/digimindx/server-provisioning-script/main/setup_server.sh) | sudo bash
```

### ⚙️ Configuration Variables

You can customize the script parameters inside `setup_server.sh` before running:

  

Bash

```
NEW_USER="devops"                        # Administrative user name
SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1..." # Paste your public SSH key string here
```

## التوثيق باللغة العربية

### 🌟 المميزات الأساسية

1. **تحديث النظام:** تحديث تلقائي للحزم والبرامج المسبقة التثبيت.
    
      
    
2. **الحماية والتعزيز الأمني (Hardening):**
    
      
    - **جدار الحماية (UFW):** غلق الترددات غير المصرح بها والسماح فقط بـ (SSH/22, HTTP/80, HTTPS/443).
        
          
        
    - **حماية من هجمات الاختراق (Fail2ban):** تفعيل حظر تلقائي لمحاولات تسجيل الدخول العشوائية عبر SSH.
        
          
        
3. **إدارة المستخدمين ومفاتيح SSH:**
    
      
    - إنشاء مستخدم جديد وتزويده بصلاحيات `sudo`.
        
          
        
    - إعداد وإضافة مفاتيح الدخول المشفرة (SSH Keys) أوتوماتيكياً.
        
          
        
4. **تثبيت بيئة التطوير والتشغيل:**
    
      
    - **Docker & Docker Compose:** التثبيت المباشر من المستودع الرسمي وضبط صلاحيات المستخدم.
        
          
        
    - **Nginx:** تثبيت وتفعيل خادم الويب للعرض الفوري.
        
          
        
5. **سجلات تنفيذ واضحة:** مخرجات ملونة في التيرمينال لتسهيل المتابعة وتشخيص أي خطأ.
    
      
    

### 🚀 طريقة التشغيل المباشرة



```Bash
# 1. استنساخ المستودع
git clone [https://github.com/digimindx/server-provisioning-script.git](https://github.com/digimindx/server-provisioning-script.git)
cd server-provisioning-script

# 2. منح صلاحية التنفيذ
chmod +x setup_server.sh

# 3. تشغيل السكريبت بصلاحية الجذر
sudo ./setup_server.sh
```

## 👨‍💻 Author & Connect

**Abdelazeez Mabrouk**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_

