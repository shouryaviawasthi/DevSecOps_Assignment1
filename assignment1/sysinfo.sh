#!/usr/bin/env bash
set -euo pipefail

# Bonus: save output to a file named with today's date while also printing to stdout
OUTPUT_FILE="sysinfo_$(date +%Y-%m-%d).log"

{
  echo "========================================"
  echo "System Information Report"
  echo "========================================"
  echo "Hostname       : $(hostname)"
  echo "Date & Time    : $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "Logged-in User : $(whoami)"
  echo ""
  echo "--- Disk Usage (/) ---"
  df -h /
  echo ""
  echo "--- Memory Usage ---"
  if command -v free >/dev/null 2>&1; then
    free -h
  else
    head -n 5 /proc/meminfo
  fi
  echo ""
  echo "--- Top 5 Processes by Memory ---"
  if ps -eo pid,user,%mem,%cpu,comm --sort=-%mem >/dev/null 2>&1; then
    ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -n 6
  else
    ps aux | head -n 6
  fi
  echo "========================================"
} | tee "$OUTPUT_FILE"

echo "Report saved to $OUTPUT_FILE"
