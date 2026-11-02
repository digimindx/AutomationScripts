# Automated MySQL Backup & AWS S3 Archival Script

A production-ready **Bash shell script** designed for automated, zero-downtime backups of MySQL/MariaDB databases. It creates a compressed archive (`.tar.gz`), securely uploads it to an **Amazon S3** bucket, cleans up local backup files older than a configurable retention period, and logs all operations with timestamps.

This repository demonstrates practical **DevOps automation**, system cleanup logic, error handling, and cloud integration.

---

## Key Features

* **Automated Database Dumps:** Performs full logical backups using `mysqldump`.
* **Archive Compression:** Reduces storage overhead by compressing SQL dumps into `.tar.gz` archives.
* **AWS S3 Cloud Integration:** Securely syncs and uploads backups to Amazon Web Services (S3) using the AWS CLI.
* **Retention Policy & Cleanup:** Automatically purges local backup files older than $N$ days (default: 30 days) to prevent disk space exhaustion.
* **Robust Error Handling & Logging:** Captures stdout/stderr outputs with execution timestamps and exit status validation.
* **Cron-Ready Execution:** Designed for unattended, scheduled cron jobs.

---

## Prerequisites

Before deploying this script, ensure the target Linux server satisfies the following requirements:

1. **MySQL / MariaDB Client:** `mysqldump` utility installed.
2. **AWS CLI (v2):** Installed and pre-configured with appropriate credentials (`aws configure`).
3. **AWS IAM Permissions:** The IAM user/role must have `s3:PutObject` permissions on the destination S3 bucket.
4. **Bash Shell:** Standard Linux Bash environment.

---

## Repository Structure

```text
.
├── backup.sh          # Primary automated backup script
├── README.md          # Comprehensive documentation
└── LICENSE            # MIT License (optional)
```

---

## Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/mysql-s3-backup-automation.git
cd mysql-s3-backup-automation
```

### 2. Make the Script Executable
```bash
chmod +x backup.sh
```

### 3. Configure Environment Variables
Open `backup.sh` in your preferred text editor and update the configuration variables matching your system specs:

```bash
# Database Configuration
DB_NAME="your_database_name"
DB_USER="your_database_user"
DB_PASSWORD="your_database_password"

# Path & Cloud Settings
BACKUP_DIR="/var/backups/mysql"
S3_BUCKET="s3://your-aws-s3-bucket-name/mysql-backups"
RETENTION_DAYS=30
```

> **Security Best Practice:** For production environments, avoid storing credentials directly inside shell scripts. Use environment variables or a restricted MySQL option file (`~/.my.cnf`) with `600` permissions.

---

## Usage & Execution

### Manual Execution
Test the script manually to ensure database connections and S3 uploading work as expected:

```bash
./backup.sh
```

### Automated Execution via Crontab
To schedule the backup to run automatically **every night at midnight (00:00)**:

1. Open crontab for editing:
   ```bash
   crontab -e
   ```

2. Add the following entry:
   ```bash
   0 0 * * * /bin/bash /path/to/mysql-s3-backup-automation/backup.sh >> /var/log/mysql_backup.log 2>&1
   ```

---

## Log Output Example

Upon successful execution, the script appends output formatted as follows:

```text
[Mon Nov  2 00:00:01 UTC 2026] Starting database backup for: production_db
[Mon Nov  2 00:00:05 UTC 2026] Database dump successfully created.
[Mon Nov  2 00:00:08 UTC 2026] Compressed archive created: db_backup_production_db_20261102_000001.tar.gz
[Mon Nov  2 00:00:12 UTC 2026] Backup successfully uploaded to AWS S3.
[Mon Nov  2 00:00:12 UTC 2026] Purged local backups older than 30 days.
[Mon Nov  2 00:00:12 UTC 2026] Backup process completed successfully.
```

---
# سكريبت الأتمتة والنسخ الاحتياطي لقواعد بيانات MySQL والرفع السحابي على AWS S3

سكربت تنفيذي مصمم لبيئات الإنتاج (Production-ready **Bash shell script**) لأتمتة النسخ الاحتياطي لقواعد بيانات MySQL/MariaDB بدون أي توقف للخدمات. يقوم السكريبت بإنشاء أرشيف مضغوط بصيغة (`.tar.gz`)، ورفعه بأمان إلى حاوية تخزين **Amazon S3**، ثم حذف النسخ المحلية القديمة بناءً على فترة احتفاظ محددة، مع تسجيل جميع العمليات بخصائص التوقيت الزمني (Timestamps).

يعكس هذا المستودع تطبيقا عملياً لـ **أتمتة العمليات (DevOps Automation)**، المنطق البرمجي لتنظيف الأنظمة، إدارة الأخطاء، والتكامل مع الخدمات السحابية.

## المميزات الرئيسية

- **أتمتة نسخ قواعد البيانات:** تنفيذ النسخ الاحتياطي الشامل باستخدام أداة `mysqldump`.
    
- **ضغط الأرشيف:** تقليل المساحة المستهلكة عبر ضغط ملفات الـ SQL إلى أرشيف مضغوط بصيغة `.tar.gz`.
    
- **التكامل السحابي مع AWS S3:** مزامنة ورفع النسخ الاحتياطية بأمان إلى خدمات Amazon السحابية باستخدام AWS CLI.
    
- **سياسة الحذف الذكي للنسخ القديمة:** حذف النسخ الاحتياطية المحلية التي تجاوزت $N$ من الأيام (افتراضياً: 30 يوماً) لمنع امتلاء القرص الصلب.
    
- **إدارة الأخطاء والسجلات (Logging):** تسجيل كل الخطوات والأخطاء مع توقيت حدوثها وحالة الانتهاء من التنفيذ.
    
- **جاهز للجدولة التلقائية:** مصمم ليعمل كـ Cron Job دون الحاجة لأي تدخل بشري.
    

## المتطلبات الأساسية

قبل تشغيل السكريبت على خادم لينكس، تأكد من توفر المتطلبات التالية:

1. **عميل MySQL / MariaDB:** تثبيت أداة `mysqldump`.
    
2. **واجهة أومامر AWS CLI (v2):** تثبيت الأداة وإعداد المفاتيح مسبقاً (`aws configure`).
    
3. **صلاحيات AWS IAM:** يجب أن يمتلك المستخدم أو الدور (Role) صلاحية `s3:PutObject` على حاوية S3 المستهدفة.
    
4. **بيئة Bash:** بيئة عمل قياسية لـ Linux Bash.
    

## هيكل المستودع

```
.
├── backup.sh          # السكريبت التنفيذي للنسخ الاحتياطي والأتمتة
├── README.md          # التوثيق باللغة الإنجليزية
├── README_AR.md       # التوثيق باللغة العربية
└── LICENSE            # رخصة الاستخدام (اختياري)
```

## الإعداد والتثبيت

### 1. استنساخ المستودع (Clone)

```
git clone https://github.com/your-username/mysql-s3-backup-automation.git
cd mysql-s3-backup-automation
```

### 2. منح صلاحية التنفيذ للسكريبت

```
chmod +x backup.sh
```

### 3. تعديل المتغيرات الخاصة بالبيئة

افتح ملف `backup.sh` في أي محرر نصوص وقم بتحديث المتغيرات لتناسب بيانات خادمك:

```
# إعدادات قاعدة البيانات
DB_NAME="your_database_name"
DB_USER="your_database_user"
DB_PASSWORD="your_database_password"

# إعدادات المسارات والحساب السحابي
BACKUP_DIR="/var/backups/mysql"
S3_BUCKET="s3://your-aws-s3-bucket-name/mysql-backups"
RETENTION_DAYS=30
```

> **تنبيه أمني:** في بيئات الإنتاج الفعلية، يُفضل عدم كتابة كلمة المرور مباشرة داخل السكريبت. استخدم متغيرات البيئة (Environment Variables) أو ملف الإعدادات المخصص لـ MySQL (`~/.my.cnf`) مع إعطائه صلاحيات قراءة مقيدة `600`.

## طريقة الاستخدام والتنفيذ

### التشغيل اليدوي للتجربة

يمكنك تجربة السكريبت يدوياً للتأكد من الاتصال بقاعدة البيانات ونجاح الرفع السحابي:

```
./backup.sh
```

### التجدولة التلقائية عبر Cron Job

لتشغيل السكريبت تلقائياً **كل يوم منتصف الليل (الساعة 00:00)**:

1. افتح جدول المهام للتعديل:
    
    ```
    crontab -e
    ```
    
2. أضف السطر التالي في نهاية الملف:
    
    ```
    0 0 * * * /bin/bash /path/to/mysql-s3-backup-automation/backup.sh >> /var/log/mysql_backup.log 2>&1
    ```
    

## مثال لمخرجات ملف السجل (Log Example)

عند التنفيذ بنجاح، يُخرج السكريبت سجلاً بالصيغة التالية:

```
[Mon Nov  2 00:00:01 UTC 2026] Starting database backup for: production_db
[Mon Nov  2 00:00:05 UTC 2026] Database dump successfully created.
[Mon Nov  2 00:00:08 UTC 2026] Compressed archive created: db_backup_production_db_20261102_000001.tar.gz
[Mon Nov  2 00:00:12 UTC 2026] Backup successfully uploaded to AWS S3.
[Mon Nov  2 00:00:12 UTC 2026] Purged local backups older than 30 days.
[Mon Nov  2 00:00:12 UTC 2026] Backup process completed successfully.
```

---
## Author

**Abdelazeez Mabrouk**  
*Senior DevOps & Systems Infrastructure Engineer*  
[LinkedIn Profile]([https://linkedin.com](https://www.linkedin.com/in/abdelazeez-mabrouk/)) | [GitHub Profile]([https://github.com](https://github.com/digimindx))