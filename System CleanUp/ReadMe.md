# 🧹 Automated System & Docker Cleanup Script

![Bash Shell](https://img.shields.io/badge/Shell_Script-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Docker Ready](https://img.shields.io/badge/Includes-Docker%20Prune-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Automation](https://img.shields.io/badge/Execution-Cron%20Scheduled-4EAA25?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

An automated **Bash Cleanup Script** engineered for Linux servers to prevent disk space exhaustion. It automatically purges system log files older than 7 days, removes unused Docker containers, dangling images, and unreferenced volumes, clears package manager caches, and reports liberated storage space.

---

## 🌟 Key Features

- **Automated Log Rotation & Truncation:** Cleans compressed `/var/log` archives older than 7 days and vacuums systemd `journald` logs.
- **Docker Deep Clean:** Executes a safe `docker system prune` to eliminate stopped containers, unused volumes, dangling images, and build caches.
- **Package Manager Maintenance:** Clears `apt` caches and purges orphaned dependencies (`autoremove`).
- **Disk Space Metrics Report:** Compares available storage before and after execution for immediate verification.
- **Cron Scheduled:** Optimized for non-interactive execution via Linux `cron`.

---

## 🚀 Fast Execution Guide

### 1. Direct Execution

```bash
# Make script executable
chmod +x cleanup_system.sh

# Run script as root or with sudo
sudo ./cleanup_system.sh
````

### 2. Schedule Execution via Cron (Weekly Run)

Automate execution every Sunday at 02:00 AM to keep your server clean:
```Bash
sudo crontab -e
```

Add the following crontab entry:

```Bash
0 2 * * 0 /bin/bash /path/to/cleanup_system.sh >> /var/log/system_cleanup.log 2>&1
```

## ⚙️ Customizing Retention Settings

Edit the `LOG_RETENTION_DAYS` variable inside `cleanup_system.sh` to adjust log retention thresholds:

```Bash
LOG_RETENTION_DAYS=7  # Change retention period (e.g., 14 or 30 days)
```

## 👨‍💻 Author & Connect

**Abdelazeez Mabrouk**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_

---
  
# 🧹 سكريبت تنظيف النظام وأتمتة مساحة التخزين (Bash & Docker)

![Bash Shell](https://img.shields.io/badge/Shell_Script-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Docker Ready](https://img.shields.io/badge/Includes-Docker%20Prune-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Automation](https://img.shields.io/badge/Execution-Cron%20Scheduled-4EAA25?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

سكريبت أتمتة مخصص لمهندسي الـ DevOps ومسؤولي الأنظمة لمنع امتلاء مساحة التخزين (Disk Space) على خوادم لينكس. يقوم السكريبت بتنظيف وتفريغ ملفات السجلات (Logs) القديمة التي يتجاوز عمرها 7 أيام، حذف حاويات وصور دوكر (Docker Containers & Images) غير المستخدمة، تفريغ ذاكرة التخزين المؤقت للحزم، وحساب المساحة المحررة بدقة.

---

## 🌟 المميزات الأساسية

- **تنظيف السجلات والـ Logs:** تفريغ وحذف الملفات المضغوطة القديمة في المجلد `/var/log` وتخفيض حجم سجلات `journald`.
- **تنظيف شامـل لـ Docker:** تطبيق أوتوماتيكي لأمر `docker system prune` لإزالة Containers المتوقفة، Images غير المستخدمة، والـ Volumes المعلقة لتفريغ الجيجابايتات الضائعة.
- **تفريغ كاش الحزم (APT Cache):** إزالة الملفات المؤقتة والاعتماديات الزائدة عبر `apt-get autoremove`.
- **تقرير مساحة القرص:** حساب وعرض المساحة الخالية قبل وبعد عملية التنظيف لمتابعة النتائج فوراً.
- **جاهز للجدولة الآلية:** مصمم ليعمل بامتياز وبدون تدخل بشري عبر أداة `Cron`.

---

## 🚀 طريقة التشغيل والجدولة

### 1. التشغيل المباشر

```bash
# إعطاء صلاحية التنفيذ للسكريبت
chmod +x cleanup_system.sh

# تشغيل السكريبت بصلاحية الجذر (Root)
sudo ./cleanup_system.sh
````

### 2. الجدولة الآلية (أسبوعياً)

لتشغيل السكريبت تلقائياً كل يوم أحد الساعة 2:00 صباحاً:

```Bash
sudo crontab -e
```

أضف السطر التالي

```Bash
0 2 * * 0 /bin/bash /path/to/cleanup_system.sh >> /var/log/system_cleanup.log 2>&1
```

## 👨‍💻 المطور والتواصل

**عبد العزيز مبروك**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_
