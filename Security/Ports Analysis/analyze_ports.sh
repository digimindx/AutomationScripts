#!/usr/bin/env bash
set -euo pipefail

INTERVAL="${1:-5}"   # ثواني القياس، مثال: ./port-traffic.sh 10

declare -A SERVICE_BY_PID PREV_SENT PREV_RECV CUR_SENT CUR_RECV PORT_PID PORT_PROTO

# ربط PID بخدمة systemd إن وُجدت
while read -r unit; do
  pid="$(systemctl show "$unit" --property=MainPID --value 2>/dev/null || true)"
  [[ "$pid" =~ ^[1-9][0-9]*$ ]] && SERVICE_BY_PID["$pid"]="$unit"
done < <(systemctl list-units --type=service --all --no-legend --no-pager | awk '{print $1}')

service_name() {
  local pid="$1"
  if [[ -n "${SERVICE_BY_PID[$pid]:-}" ]]; then
    printf '%s' "${SERVICE_BY_PID[$pid]}"
  else
    ps -p "$pid" -o comm= 2>/dev/null | xargs || printf 'غير معروف'
  fi
}

read_listeners() {
  PORT_PID=()
  PORT_PROTO=()

  while IFS='|' read -r proto port pid; do
    [[ -z "$port" ]] && continue
    PORT_PID["$port"]="$pid"
    PORT_PROTO["$port"]="$proto"
  done < <(
    ss -H -ltnup 2>/dev/null | awk '
      {
        proto=$1
        local=$4
        sub(/^.*:/, "", local)
        pid=""
        if (match($0, /pid=[0-9]+/)) {
          pid=substr($0, RSTART+4, RLENGTH-4)
        }
        print proto "|" local "|" pid
      }'
  )
}

read_tcp_counters() {
  CUR_SENT=()
  CUR_RECV=()

  while IFS='|' read -r port pid sent recv; do
    [[ -z "$port" || -z "$sent" || -z "$recv" ]] && continue
    CUR_SENT["$port"]=$(( ${CUR_SENT[$port]:-0} + sent ))
    CUR_RECV["$port"]=$(( ${CUR_RECV[$port]:-0} + recv ))

    # استخدام PID الخاص بالاتصال إن لم يكن المنفذ مستمعاً
    [[ -z "${PORT_PID[$port]:-}" && -n "$pid" ]] && PORT_PID["$port"]="$pid"
    [[ -z "${PORT_PROTO[$port]:-}" ]] && PORT_PROTO["$port"]="tcp"
  done < <(
    ss -H -tinp state established 2>/dev/null | awk '
      /^[A-Z]+/ {
        local=$4
        sub(/^.*:/, "", local)

        pid=""
        if (match($0, /pid=[0-9]+/))
          pid=substr($0, RSTART+4, RLENGTH-4)

        if (getline > 0) {
          sent=recv=0
          if (match($0, /bytes_sent:[0-9]+/))
            sent=substr($0, RSTART+11, RLENGTH-11)
          if (match($0, /bytes_received:[0-9]+/))
            recv=substr($0, RSTART+15, RLENGTH-15)

          print local "|" pid "|" sent "|" recv
        }
      }'
  )
}

read_listeners
read_tcp_counters

for p in "${!CUR_SENT[@]}"; do
  PREV_SENT["$p"]="${CUR_SENT[$p]}"
  PREV_RECV["$p"]="${CUR_RECV[$p]}"
done

sleep "$INTERVAL"

read_listeners
read_tcp_counters

printf "%-7s %-8s %-8s %-24s %14s %14s\n" \
  "PROTO" "PORT" "PID" "SERVICE/PROCESS" "SEND B/s" "RECV B/s"
printf "%0.s-" {1..92}; echo

for port in "${!PORT_PROTO[@]}"; do
  pid="${PORT_PID[$port]:-}"
  proto="${PORT_PROTO[$port]}"
  name="غير معروف"
  [[ -n "$pid" ]] && name="$(service_name "$pid")"

  sent_now="${CUR_SENT[$port]:-0}"
  recv_now="${CUR_RECV[$port]:-0}"
  sent_old="${PREV_SENT[$port]:-0}"
  recv_old="${PREV_RECV[$port]:-0}"

  send_rate=$(( (sent_now - sent_old) / INTERVAL ))
  recv_rate=$(( (recv_now - recv_old) / INTERVAL ))

  printf "%-7s %-8s %-8s %-24.24s %14d %14d\n" \
    "$proto" "$port" "${pid:--}" "$name" "$send_rate" "$recv_rate"
done | sort -k2n