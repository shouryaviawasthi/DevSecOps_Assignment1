#!/usr/bin/env bash
set -euo pipefail

# Bonus: print usage message if no file is given
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <log_file>"
  echo "Example: $0 sample.log"
  exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
  echo "Error: File '$LOG_FILE' not found." >&2
  exit 1
fi

TOTAL_REQUESTS=$(wc -l < "$LOG_FILE" | tr -d ' ')
ERRORS_404=$(awk '$9 == 404 { count++ } END { print count + 0 }' "$LOG_FILE")
TOP_IPS=$(awk '{ print $1 }' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 3)

echo "========================================"
echo "Log Report: $LOG_FILE"
echo "========================================"
echo "Total Requests : $TOTAL_REQUESTS"
echo "404 Errors     : $ERRORS_404"
echo ""
echo "Top 3 IP Addresses:"
echo "$TOP_IPS" | awk '{ printf "  %-16s (%s requests)\n", $2, $1 }'
echo "========================================"
