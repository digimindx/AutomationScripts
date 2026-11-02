#!/bin/bash

# ==========================================
# إعدادات قاعدة البيانات والنسخ الاحتياطي
# ==========================================
DB_NAME="your_database_name"
DB_USER="your_database_user"
DB_PASSWORD="your_database_password"
BACKUP_DIR="/var/backups/mysql"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="db_backup_${DB_NAME}_${DATE}.sql"
ARCHIVE_NAME="${BACKUP_NAME}.tar.gz"
S3_BUCKET="s3://your-aws-s3-bucket-name/mysql-backups"
RETENTION_DAYS=30

# إنشاء مجلد النسخ الاحتياطي إذا لم يكن موجوداً
mkdir -p "$BACKUP_DIR"

echo "[$(date)] بدء عملية النسخ الاحتياطي لقاعدة البيانات: $DB_NAME"

# 1. أخذ نسخة احتياطية (Dump) من MySQL
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_DIR/$BACKUP_NAME"

if [ $? -eq 0 ]; then
    echo "[$(date)] تم إنشاء النسخة الاحتياطية بنجاح."
    
    # 2. ضغط ملف النسخة الاحتياطية بصيغة tar.gz
    tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$BACKUP_DIR" "$BACKUP_NAME"
    rm "$BACKUP_DIR/$BACKUP_NAME" # حذف ملف الـ SQL الأصلي والابقاء على الملف المضغوط
    echo "[$(date)] تم ضغط الملف إلى: $ARCHIVE_NAME"

    # 3. رفع الملف المضغوط إلى AWS S3
    aws s3 cp "$BACKUP_DIR/$ARCHIVE_NAME" "$S3_BUCKET/"
    
    if [ $? -eq 0 ]; then
        echo "[$(date)] تم رفع النسخة بنجاح إلى AWS S3."
    else
        echo "[$(date)] خطأ: فشل رفع الملف إلى S3!" >&2
    fi

    # 4. حذف النسخ المحلية القديمة التي مر عليها أكثر من 30 يوماً
    find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
    echo "[$(date)] تم تنظيف الحذف المحلي للنسخ التي أقدم من $RETENTION_DAYS يوماً."

else
    echo "[$(date)] خطأ: فشل أخذ النسخة الاحتياطية من قاعدة البيانات!" >&2
    exit 1
fi

echo "[$(date)] اكتملت عملية النسخ الاحتياطي بنجاح تام."