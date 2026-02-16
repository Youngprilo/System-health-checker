# System Health Checker (Bash)

A beginner-friendly Bash script that generates a system health report and optionally checks a service (default: nginx).

## Features
- Writes a timestamped health report to a file
- Captures:
  - uptime
  - CPU load
  - memory usage
  - disk usage
  - top processes by CPU and memory
- Checks a service status using systemctl (default: nginx)

## Requirements
- Linux environment
- bash
- common utilities: df, free, ps, uptime
- systemctl (optional, for service checks)

## Usage

Run with defaults:
```bash
./health_check.sh

