# 🚀 Automated Application Deployment Script (Zero Downtime)

![Bash Shell](https://img.shields.io/badge/Shell_Script-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![CI/CD](https://img.shields.io/badge/Deployment-Zero%20Downtime-007ACC?style=for-the-badge&logo=git&logoColor=white)
![Automation](https://img.shields.io/badge/Stack-PHP%2FNode.js-777BB4?style=for-the-badge&logo=php&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

A streamlined, robust **Bash Deployment Script** designed for lightweight CI/CD pipelines. It automates the code synchronization process (`git pull`), installs application dependencies (`Composer` & `npm`), executes framework caching/migrations, and gracefully reloads web services to guarantee **Zero Downtime** updates.

---

## 🌟 Key Features

- **Atomic Code Synchronization:** Safely resets and pulls the latest production-ready branch from remote Git repositories.
- **Dependency Management:** Automatically detects and installs updates for PHP (`Composer`) and Node.js (`npm`) applications.
- **Framework Optimization:** Built-in hooks for popular frameworks (e.g., Laravel artisan cache clearing and database migrations).
- **Zero Downtime Reloads:** Utilizes graceful service reloading (`systemctl reload`) instead of hard restarts to prevent dropped user requests.

---

## 🚀 Fast Execution & Setup Guide

### 1. Manual Execution

```bash
# Make script executable
chmod +x deploy.sh

# Run deployment script with appropriate privileges
sudo ./deploy.sh
````

### 2. Setting up as a Post-Receive Git Webhook (Automatic Deployment)

To trigger this script automatically whenever a developer pushes code to the server repository:

  

1. Create a bare git repository on your server (`/var/repo/my-app.git`).
2. Add a `post-receive` hook inside the repository hooks directory:
    
```bash
    nano /var/repo/my-app.git/hooks/post-receive
```
    
3. Paste the following hook logic:
```bash
    #!/bin/bash
    TARGET="/var/www/html/my-app"
    GIT_DIR="/var/repo/my-app.git"
    BRANCH="main"
    
    while read oldrev newrev ref
    do
        if [ "$ref" = "refs/heads/$BRANCH" ]; then
            echo "Deploying changes to production..."
            sudo /path/to/deploy.sh
        fi
    done
```
    
4. Give execution permission to the hook:
```bash
    chmod +x /var/repo/my-app.git/hooks/post-receive
```

## 👨‍💻 Author & Connect

**Abdelazeez Mabrouk**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_

---

# 🚀 سكريبت أتمتة نشر وتحديث التطبيقات بدون انقطاع (Zero Downtime Deployment)

![Bash Shell](https://img.shields.io/badge/Shell_Script-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![CI/CD](https://img.shields.io/badge/Deployment-Zero%20Downtime-007ACC?style=for-the-badge&logo=git&logoColor=white)
![Automation](https://img.shields.io/badge/Stack-PHP%2FNode.js-777BB4?style=for-the-badge&logo=php&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

سكريبت أتمتة متطور ومبسط مكتوب بلغة **Bash** لأغراض الـ CI/CD الخفيفة، مصمم لمهندسي الـ DevOps ومطوري الباك إند. يقوم السكريبت بسحب أحدث الأكواد البرمجية مباشرة من مستودع Git، تثبيت التحديثات البرمجية (`Composer` و `npm`)، تحديث قواعد البيانات وترميز الكاش، وإعادة تحميل خادم الويب بمرونة تامة دون أي توقف للخدمة (**Zero Downtime**).

---

## 🌟 مميزات السكريبت

- **تزامن الأكواد البرمجية بآمان:** سحب التحديثات وتحديث الفرع البرمجي على السيرفر بدقة متناهية.
- **إدارة الحزم التلقائية:** الكشف التلقائي عن ملفات `composer.json` و `package.json` وتحديث الحزم بناءً عليها.
- **دعم الأطر البرمجية المشهورة:** تنفيذ عمليات الترحيل (Migrations) وتحديث الـ Caching للأطر مثل Laravel مباشرة.
- **إعادة تحميل بلا انقطاع:** استخدام أمر إعادة التحميل المرن (`systemctl reload`) بدلاً من إيقاف الخدمة كلياً لضمان عدم تأثر المستخدمين الحاليين بالموقع.

---

## 🚀 طريقة التشغيل وإعداد الـ Git Hook

### 1. التشغيل اليدوي

```bash
# إعطاء صلاحية التنفيذ للسكريبت
chmod +x deploy.sh

# تشغيل السكريبت
sudo ./deploy.sh
````

### 2. الربط التلقائي عبر Git Post-Receive Hook

لتشغيل التحديث تلقائياً بمجرد عمل `git push` على السيرفر:

  

1. أنشئ خطاف الـ `post-receive` داخل مسار المستودع على السيرفر:
```bash
    nano /var/repo/my-app.git/hooks/post-receive
```
    
2. أضف الكود البرمجي الذي يستدعي سكريبت النشر تلقائياً عند الدفع لفرع `main`:
```bash
    #!/bin/bash
    while read oldrev newrev ref
    do
        if [ "$ref" = "refs/heads/main" ]; then
            sudo /path/to/deploy.sh
        fi
    done
```
    
3. منح صلاحية التنفيذ للخطاف:
```
    chmod +x /var/repo/my-app.git/hooks/post-receive
```
    

## 👨‍💻 المطور والتواصل

**عبد العزيز مبروك**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_
