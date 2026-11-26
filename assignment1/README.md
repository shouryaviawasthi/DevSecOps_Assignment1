# Assignment 1: Linux Shell Scripting and Git

## Overview
This directory contains two executable Bash scripts:
- `sysinfo.sh`: Prints hostname, current date and time, logged-in user, disk usage of `/`, memory usage, and the top 5 processes by memory. Also saves the output to a dated file (`sysinfo_YYYY-MM-DD.log`).
- `log_report.sh`: Takes a web access log file as an argument and prints the total number of requests, the number of `404` errors, and the top 3 IP addresses. Prints a usage message if no file is provided.
- `sample.log`: Sample Nginx/Apache-style access log used to test `log_report.sh` (provided since the assignment PDF did not include the sample log text).

## Prerequisites & Permissions
Make both scripts executable on Linux/macOS:
```bash
chmod +x sysinfo.sh log_report.sh
```

## How to Run

### 1. `sysinfo.sh`
```bash
./sysinfo.sh
```

#### Sample Output
```text
========================================
System Information Report
========================================
Hostname       : 87834c714a12
Date & Time    : 2026-11-26 22:10:25 UTC
Logged-in User : root

--- Disk Usage (/) ---
Filesystem      Size  Used Avail Use% Mounted on
overlay        1007G   13G  943G   2% /

--- Memory Usage ---
               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       1.6Gi       789Mi        46Mi       5.5Gi       6.0Gi
Swap:          2.0Gi       292Ki       2.0Gi

--- Top 5 Processes by Memory ---
    PID USER     %MEM %CPU COMMAND
    118 root      0.0  0.0 ps
      1 root      0.0  0.8 bash
    108 root      0.0  0.0 bash
    110 root      0.0  0.0 bash
    111 root      0.0  0.0 tee
========================================
Report saved to sysinfo_2026-11-26.log
```

### 2. `log_report.sh`
```bash
./log_report.sh sample.log
```

#### Sample Output
```text
========================================
Log Report: sample.log
========================================
Total Requests : 12
404 Errors     : 4

Top 3 IP Addresses:
  192.168.1.10     (5 requests)
  10.0.0.5         (3 requests)
  172.16.0.22      (2 requests)
========================================
```

#### Usage Message (when no argument is passed)
```bash
./log_report.sh
```
```text
Usage: ./log_report.sh <log_file>
Example: ./log_report.sh sample.log
```

## Bonus: Hourly Cron Job
To run `sysinfo.sh` every hour automatically, add the following line to your crontab (`crontab -e`):
```cron
0 * * * * cd /path/to/assignment1 && ./sysinfo.sh >/dev/null 2>&1
```
