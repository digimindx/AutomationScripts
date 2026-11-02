
# 📡 Automated Health Check & Monitoring Script (Python)

![Python 3](https://img.shields.io/badge/Python-3.8%2B-blue?style=for-the-badge&logo=python&logoColor=white)
![Telegram Integration](https://img.shields.io/badge/Alerts-Telegram%20Bot-26A5E4?style=for-the-badge&logo=telegram&logoColor=white)
![Automation](https://img.shields.io/badge/Execution-Cron%20Scheduled-4EAA25?style=for-the-badge)

A lightweight, zero-dependency Python script designed for DevOps engineers and system administrators to monitor the health and uptime of Web Applications, APIs, and microservices. When a monitored endpoint returns an unexpected HTTP status code or fails to respond, it triggers an instant alert notification via a Telegram Bot.

---

## 🌟 Key Features

- **Zero External Dependencies:** Built using Python standard libraries (`urllib`, `json`), requiring no `pip install` packages.
- **Multi-Target Monitoring:** Easily monitor multiple endpoints and APIs simultaneously.
- **Instant Telegram Alerts:** Sends Markdown-formatted alerting messages to your incident channel or personal Telegram chat.
- **Custom Timeout & Error Handling:** Gracefully handles DNS failures, HTTP error codes (404, 500, 502, etc.), and timeouts.
- **Cron Ready:** Formatted output designed for seamless integration with Linux `cron` logging.

---

## 🛠️ Configuration Options

You can configure your target URLs and Telegram bot credentials directly inside `monitor_health.py` or pass credentials via Environment Variables.

### 1. Target Services Setup
Edit `TARGET_SERVICES` inside the script:

```python
TARGET_SERVICES = [
    {"name": "Production Website", "url": "[https://yourdomain.com](https://yourdomain.com)"},
    {"name": "Authentication API", "url": "[https://api.yourdomain.com/v1/health](https://api.yourdomain.com/v1/health)"},
]
````

### 2. Telegram Bot Setup

1. Create a Telegram bot via [@BotFather](https://t.me/BotFather) and get your `TELEGRAM_BOT_TOKEN`.   
2. Get your personal/group `TELEGRAM_CHAT_ID` using [@userinfobot](https://t.me/userinfobot).
3. Set environment variables or update the fallback strings in `monitor_health.py`:
    
```bash
export TELEGRAM_BOT_TOKEN="your_bot_token_here"
export TELEGRAM_CHAT_ID="your_chat_id_here"
```

## 🚀 Usage & Cron Scheduling

### Manual Execution



```bash
# Make script executable
chmod +x monitor_health.py

# Run monitor check
python3 monitor_health.py
```

### Automate Execution via Cron (Every 5 Minutes)

Edit system crontab:

```Bash
crontab -e
```

Add the following entry to execute health checks every 5 minutes and log output:

```Bash
*/5 * * * * /usr/bin/python3 /path/to/monitor_health.py >> /var/log/health_monitor.log 2>&1
```

## 👨‍💻 Author & Connect

**Abdelazeez Mabrouk**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_

  ---


# 📡 سكريبت الفحص الآلي للمواقع والخدمات والتنبيه التلقائي (Python)

![Python 3](https://img.shields.io/badge/Python-3.8%2B-blue?style=for-the-badge&logo=python&logoColor=white)
![Telegram Integration](https://img.shields.io/badge/Alerts-Telegram%20Bot-26A5E4?style=for-the-badge&logo=telegram&logoColor=white)
![Automation](https://img.shields.io/badge/Execution-Cron%20Scheduled-4EAA25?style=for-the-badge)

سكريبت خفيف وعالي الكفاءة مكتوب بلغة **Python** بدون الحاجة لمكتبات خارجية، مخصص لمهندسي الـ DevOps ومسؤولي الأنظمة لمراقبة استقرار وتوفر المواقع الإلكترونية والـ APIs (Health Check). يقوم السكريبت بفحص استجابة المواقع باستمرار، وفي حال حدوث عطل أو توقف في الخدمة، يرسل إشعارات وتنبيهات فورية ومباشرة عبر بوت تليجرام (Telegram Bot).

---

## 🌟 مميزات السكريبت

- **بدون مكتبات خارجية (Zero Dependencies):** يعتمد بالكامل على مكتبات بايبر القياسية المدمجة (`urllib` و `json`) بدون الحاجة لتثبيت أي `pip packages`.
- **مراقبة خوادم متعددة:** دعم فحص أكثر من موقع أو API في وقت واحد بسهولة.
- **إشعارات تليجرام فورية:** إرسال رسالة تنبيهية مصممة بلغة Markdown تُحدد اسم الخدمة المتوقفة، الرابط، كود الخطأ HTTP، ووقت حدوث العطل بالتفصيل.
- **معالجة الاستثناءات والأخطاء:** التعامل الذكي مع مهل الاتصال (Timeouts)، أخطاء الاتصال بالشبكة (DNS/Connection Errors)، وأكواد الخطأ من السيرفر (404, 500, 502, 503).
- **جاهز للجدولة الآلية:** مصمم ليعمل في الخلفية بسلاسة عبر أداة `Cron` في بيئات لينكس.

---

## 🛠️ إعدادات وتجهيز السكريبت

تستطيع ضبط عناوين الخدمات المراد مراقبتها وبيانات بوت تليجرام داخل ملف `monitor_health.py` مباشرة أو عبر المتغيرات البيئية (Environment Variables).

### 1. إضافة الخدمات للمراقبة
قم بتعديل مصفوفة `TARGET_SERVICES` داخل السكريبت:

```python
TARGET_SERVICES = [
    {"name": "الموقع الرئيسي", "url": "[https://yourdomain.com](https://yourdomain.com)"},
    {"name": "واجهة البرمجة API", "url": "[https://api.yourdomain.com/health](https://api.yourdomain.com/health)"},
]
````

### 2. إعداد بوت تليجرام للإشعارات

1. أنشئ بوت تليجرام جديد عبر [@BotFather](https://t.me/BotFather) واحصل على `TELEGRAM_BOT_TOKEN`.
2. احصل على معرف الحساب/المجموعة `TELEGRAM_CHAT_ID` عبر [@userinfobot](https://t.me/userinfobot).
3. قم بتمرير البيانات عبر المتغيرات البيئية في لينكس.


```Bash
export TELEGRAM_BOT_TOKEN="your_bot_token_here"
export TELEGRAM_CHAT_ID="your_chat_id_here"
```

## 🚀 التشغيل والجدولة الآلية

### التشغيل اليدوي

```Bash
# إعطاء صلاحية التنفيذ للسكريبت
chmod +x monitor_health.py

# تشغيل السكريبت
python3 monitor_health.py
```

### الجدولة الآلية عبر Cron (كل 5 دقائق)

افتتح محرر الجدولة الخاصة بالنظام:

```Bash
crontab -e
```

أضف السطر التالي لتشغيل عملية الفحص كل 5 دقائق وحفظ السجلات تلقائياً:


```Bash
*/5 * * * * /usr/bin/python3 /path/to/monitor_health.py >> /var/log/health_monitor.log 2>&1
```

## 👨‍💻 المطور والتواصل

**عبد العزيز مبروك**
_Senior DevOps & Cloud Infrastructure Engineer | Tech Lead_
