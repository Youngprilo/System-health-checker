#!/bin/bash
set -e

# -----------------------------
# System Health Checker
# Usage:
#   ./health_check.sh [service_name] [output_file]
# Example:
#   ./health_check.sh nginx health_report.txt
# -----------------------------

SERVICE_NAME="${1:-nginx}"
OUTPUT_FILE="${2:-health_report.txt}"

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

write_line() {
  echo "------------------------------------------------------------" >> "$OUTPUT_FILE"
}

write_header() {
  echo "System Health Report - $(timestamp)" > "$OUTPUT_FILE"
  echo "Host: $(hostname)" >> "$OUTPUT_FILE"
  echo "User: $(whoami)" >> "$OUTPUT_FILE"
  echo "Service to check: $SERVICE_NAME" >> "$OUTPUT_FILE"
  write_line
}

check_uptime() {
  echo "UPTIME:" >> "$OUTPUT_FILE"
  uptime >> "$OUTPUT_FILE"
  write_line
}

check_cpu_load() {
  echo "CPU LOAD (1m, 5m, 15m):" >> "$OUTPUT_FILE"
  cat /proc/loadavg >> "$OUTPUT_FILE"
  write_line
}

check_memory() {
  echo "MEMORY:" >> "$OUTPUT_FILE"
  free -h >> "$OUTPUT_FILE"
  write_line
}

check_disk() {
  echo "DISK USAGE:" >> "$OUTPUT_FILE"
  df -h >> "$OUTPUT_FILE"
  write_line
}

top_processes() {
  echo "TOP 5 PROCESSES BY CPU:" >> "$OUTPUT_FILE"
  ps aux --sort=-%cpu | head -n 6 >> "$OUTPUT_FILE"
  write_line

  echo "TOP 5 PROCESSES BY MEMORY:" >> "$OUTPUT_FILE"
  ps aux --sort=-%mem | head -n 6 >> "$OUTPUT_FILE"
  write_line
}

check_service() {
  echo "SERVICE STATUS ($SERVICE_NAME):" >> "$OUTPUT_FILE"

  if command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active --quiet "$SERVICE_NAME"; then
      echo "$(timestamp) - $SERVICE_NAME is running ✅" >> "$OUTPUT_FILE"
    else
      echo "$(timestamp) - $SERVICE_NAME is NOT running ❌" >> "$OUTPUT_FILE"
      echo "Tip: start it with: sudo systemctl start $SERVICE_NAME" >> "$OUTPUT_FILE"
    fi
  else
    echo "systemctl not available on this system." >> "$OUTPUT_FILE"
  fi

  write_line
}

main() {
  write_header
  check_uptime
  check_cpu_load
  check_memory
  check_disk
  top_processes
  check_service

  echo "Report written to: $OUTPUT_FILE"
}

main

