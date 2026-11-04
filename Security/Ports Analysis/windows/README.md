# Port Traffic Monitor

`analyze_ports.sh` is a Bash script for Linux that lists open/listening ports, identifies the owning process or systemd service, and estimates TCP traffic per local port over a selected sampling interval.

## Requirements

- Linux with Bash 4 or later
- `ss` from the `iproute2` package
- `ps`, `awk`, and `systemctl`
- `sudo` or root access, recommended so process ownership is visible

## Installation

Save the script as `analyze_ports.sh`, then make it executable:

```bash
chmod +x analyze_ports.sh
```

## Usage

Run with the default five-second measurement interval:

```bash
sudo ./analyze_ports.sh
```

Or provide the interval in seconds:

```bash
sudo ./analyze_ports.sh 10
```

## Output

The report includes these fields:

| Field | Description |
|---|---|
| `PROTO` | Protocol, normally TCP or UDP. |
| `PORT` | Local port number. |
| `PID` | Process identifier that owns the port or connection. |
| `SERVICE/PROCESS` | Matching systemd service when available; otherwise, the process name. |
| `SEND B/s` | Estimated outbound TCP bytes per second during the sampling interval. |
| `RECV B/s` | Estimated inbound TCP bytes per second during the sampling interval. |

## How traffic is calculated

The script reads TCP kernel counters through `ss`, takes one snapshot, waits for the requested interval, takes a second snapshot, and calculates the difference. Traffic is grouped by the local port of each established TCP connection.

## Limitations

- Accurate per-port byte-rate counters are collected for established **TCP** connections only.
- UDP listeners are shown with their owner, but standard `ss` output does not provide equally reliable per-port UDP byte counters.
- Short-lived TCP connections that start and finish entirely between the two snapshots may not appear.
- A port used by multiple concurrent TCP connections shows the aggregate traffic of those connections.
- Without `sudo`, some PIDs, process names, and service names may be unavailable.

---

# مراقب حركة المنافذ

`analyze_ports.sh` هو سكربت Bash يعمل على لينكس لعرض المنافذ المفتوحة أو المستمعة، وتحديد العملية أو خدمة systemd المالكة لها، وتقدير حركة بيانات TCP لكل منفذ محلي خلال فترة قياس تختارها.

## المتطلبات

- لينكس مع Bash بالإصدار 4 أو أحدث
- أداة `ss` ضمن حزمة `iproute2`
- الأدوات `ps` و`awk` و`systemctl`
- يُنصح باستخدام `sudo` أو صلاحيات root لإظهار مالكي جميع العمليات

## التثبيت

احفظ السكربت باسم `analyze_ports.sh` ثم امنحه صلاحية التنفيذ:

```bash
chmod +x analyze_ports.sh
```

## التشغيل

التشغيل بفترة قياس افتراضية مقدارها خمس ثوانٍ:

```bash
sudo ./analyze_ports.sh
```

أو تحديد فترة القياس بالثواني:

```bash
sudo ./analyze_ports.sh 10
```

## المخرجات

يعرض التقرير الحقول التالية:

| الحقل | الوصف |
|---|---|
| `PROTO` | البروتوكول، وعادةً TCP أو UDP. |
| `PORT` | رقم المنفذ المحلي. |
| `PID` | معرّف العملية المالكة للمنفذ أو الاتصال. |
| `SERVICE/PROCESS` | خدمة systemd المطابقة عند توفرها، أو اسم العملية. |
| `SEND B/s` | معدل البايتات المرسلة عبر TCP في الثانية خلال فترة القياس. |
| `RECV B/s` | معدل البايتات المستلمة عبر TCP في الثانية خلال فترة القياس. |

## آلية حساب الحركة

يقرأ السكربت عدّادات TCP من النواة عبر `ss`، ثم يأخذ لقطة أولى وينتظر الفترة المحددة ويأخذ لقطة ثانية. يحسب الفرق بين اللقطتين ويجمع الحركة حسب المنفذ المحلي لكل اتصال TCP قائم.

## القيود

- تُجمع عدّادات معدل البايتات الدقيقة لكل منفذ لاتصالات **TCP** القائمة فقط.
- تظهر منافذ UDP المستمعة مع مالكها، لكن مخرجات `ss` القياسية لا توفر عدّادات بايتات موثوقة لكل منفذ UDP بالطريقة نفسها.
- قد لا تظهر اتصالات TCP القصيرة جداً التي تبدأ وتنتهي بالكامل بين اللقطتين.
- إذا استخدم المنفذ عدة اتصالات TCP متزامنة، يعرض السكربت مجموع حركة تلك الاتصالات.
- بدون `sudo` قد لا تظهر بعض معرّفات العمليات أو أسماء العمليات والخدمات.
