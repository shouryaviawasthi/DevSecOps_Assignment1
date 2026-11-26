# DevSecOps Assignment

Solutions for **Assignment 1 (Linux shell scripting & Git)** and **Assignment 2 (Dockerizing a Flask app & GitHub Actions CI)** from `Assignment-SecAndDevOps-2026-devops.pdf`.

## Repository Structure
- `assignment1/`:
  - `sysinfo.sh` — System information report script (saves dated `.log` file)
  - `log_report.sh` — Web access log analyzer script (with usage check)
  - `sample.log` — Sample access log for testing
  - `README.md` — Instructions, cron setup, and sample output
- `assignment2/`:
  - `app.py` — Flask application (`/` and `/health`)
  - `requirements.txt` — Python dependencies
  - `Dockerfile` & `.dockerignore` — Container build definition
  - `README.md` — Build/run commands, `curl` output, and Task 4 notes
- `.github/workflows/build.yml` — GitHub Actions workflow that builds the Assignment 2 Docker image on every push