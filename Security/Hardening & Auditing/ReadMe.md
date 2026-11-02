# 🛡️ Automated Security Auditing & Hardening Script (Python)

![Python 3](https://img.shields.io/badge/Python-3.8%2B-blue?style=for-the-badge&logo=python&logoColor=white)
![Security Hardening](https://img.shields.io/badge/Security-Fail2ban%20%26%20Audit-red?style=for-the-badge&logo=linux&logoColor=white)
![Automation](https://img.shields.io/badge/Execution-Cron%20Scheduled-4EAA25?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

An automated **Python Security Auditing & Hardening Script** designed for Linux system administrators and DevSecOps engineers. It audits permission misconfigurations on critical system files, inspects authentication logs for SSH brute-force attempts, and deploys automated Fail2ban mitigation rules to block malicious IPs.

---

## 🌟 Key Features

- **Sensitive File Permission Audit:** Scans critical files (`/etc/passwd`, `/etc/shadow`, `/etc/ssh/sshd_config`) and automatically fixes insecure permissions.
- **SSH Brute-Force Log Analysis:** Parses `/var/log/auth.log` or `/var/log/secure` to identify malicious IP addresses attempting brute-force attacks.
- **Automated Fail2ban Remediation:** Automatically installs and configures `Fail2ban` rules to ban IP addresses with more than 5 failed login attempts within 10 minutes.
- **Zero Third-Party Dependencies:** Uses native Python libraries (`os`, `sys`, `subprocess`, `re`) for maximum reliability.

---

## 🚀 Usage & Setup Guide

### 1. Manual Execution

```bash
# Clone the repository
git clone [https://github.com/digimindx/security-audit-script.git](https://github.com/digimindx/security-audit-script.git)
cd security-audit-script

# Make script executable
chmod +x security_audit_hardening.py

# Run audit script with sudo/root privileges
sudo python3 security_audit_hardening.py
````

### 2. Schedule Execution via Cron (Daily Audit)

Schedule a daily security audit run at midnight to maintain system integrity:

```bash
sudo crontab -e
```

Add the following crontab entry:

```bash
0 0 * * * /usr/bin/python3 /path/to/security_audit_hardening.py >> /var/log/security_audit.log 2>&1
```

## 👨‍💻 Author & Connect

**Abdelazeez Mabrouk**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_

---
# 🛡️ سكريبت التدقيق الأمني الآلي وتأمين الأنظمة (DevSecOps)

![Python 3](https://img.shields.io/badge/Python-3.8%2B-blue?style=for-the-badge&logo=python&logoColor=white)
![Security Hardening](https://img.shields.io/badge/Security-Fail2ban%20%26%20Audit-red?style=for-the-badge&logo=linux&logoColor=white)
![Automation](https://img.shields.io/badge/Execution-Cron%20Scheduled-4EAA25?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

سكريبت أتمتة مخصص لمهندسي الـ DevSecOps ومسؤولي الأنظمة لفحص وتأمين خوادم لينكس تلقائياً. يقوم السكريبت بتدقيق صلاحيات الملفات الحساسة للنظام، فحص وتحليل سجلات المحاولات الفاشلة لتسجيل الدخول عبر SSH، وتثبيت وتفعيل قواعد حظر أوتوماتيكية عبر `Fail2ban` لحماية السيرفر من هجمات التخمين والاختراق (Brute-Force).

---

## 🌟 المميزات الأساسية

- **تدقيق صلاحيات الملفات الحساسة:** فحص ملفات النظام الحرجة مثل (`/etc/shadow` و `/etc/passwd` و `/etc/ssh/sshd_config`) وتعديل صلاحيات الخاطئة فوراً إلى أذونات آمنة.
- **تحليل هجمات SSH:** قراءة وتحليل سجلات النظام (`/var/log/auth.log`) واستخراج عناوين الـ IP التي تحاول اختراق الخادم.
- **أتمتة الحظر التلقائي (Fail2ban):** تثبيت وتعيين قواعد `Fail2ban` أوتوماتيكياً لحظر أي عنوان IP يتجاوز 5 محاولات دخول خاطئة خلال 10 دقائق لمدة ساعة كاملة.
- **بدون مكتبات خارجية:** يعمل بالكامل باستخدام مكتبات بايثون القياسية.

---

## 🚀 طريقة التشغيل والجدولة

### 1. التشغيل المباشر

```bash
# إعطاء صلاحية التنفيذ للسكريبت
chmod +x security_audit_hardening.py

# تشغيل سكريبت الفحص الأمني بصلاحية الجذر (Root)
sudo python3 security_audit_hardening.py
````

### 2. الجدولة الآلية (فحص يومي)

لتشغيل التدقيق الأمني تلقائياً كل يوم منتصف الليل:

```bash
sudo crontab -e
```

أضف السطر التالي:

```bash
0 0 * * * /usr/bin/python3 /path/to/security_audit_hardening.py >> /var/log/security_audit.log 2>&1
```

## 👨‍💻 المطور والتواصل

**عبد العزيز مبروك**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_