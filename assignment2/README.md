# Assignment 2: Dockerize a Small App with a Basic CI Check

## Files
- `app.py`: Flask application exposing `/` and `/health` on `0.0.0.0:5000`.
- `requirements.txt`: Python dependencies (`flask`).
- `Dockerfile`: Containerizes the Flask app using `python:3.12-slim`.
- `.dockerignore`: Excludes local caches and VCS files from the Docker build context.
- `../.github/workflows/build.yml`: GitHub Actions workflow that builds the Docker image on every push.

## Build and Run Locally

Build the Docker image (from `assignment2/`):
```bash
docker build -t devops-flask-app:local .
```
*(Or from the repository root: `docker build -t devops-flask-app:local ./assignment2`)*

Run the container:
```bash
docker run -d --name devops-app -p 5000:5000 devops-flask-app:local
```

Verify endpoints with `curl`:
```bash
curl http://localhost:5000/
# Hello from DevOps!

curl http://localhost:5000/health
# {"status":"ok"}
```

Stop and remove the container:
```bash
docker rm -f devops-app
```

## GitHub Actions CI
The workflow at `.github/workflows/build.yml` triggers on every `push` (and on pull requests to `main`/`master`) and runs:
```bash
docker build -t devops-flask-app:ci ./assignment2
```

## Task 4: Find and Fix the Bugs
> **Note:** In `Assignment-SecAndDevOps-2026-devops.pdf` (2 pages), the teammate's buggy code/Dockerfile snippet referenced in Task 4 was omitted from the PDF.

If you have the teammate's snippet, paste it and we can diagnose the exact lines. Below are the standard root causes when a containerized Flask app cannot be reached, along with their fixes:

1. **Flask bound to `127.0.0.1` instead of `0.0.0.0`**
   - *Problem:* `app.run()` defaults to `host="127.0.0.1"`, which only listens on the container's loopback interface, making it unreachable from the host.
   - *Fix:* Use `app.run(host="0.0.0.0", port=5000)`.
2. **Missing host-to-container port mapping (`-p`)**
   - *Problem:* Running `docker run <image>` without `-p 5000:5000` does not publish port `5000` to the host.
   - *Fix:* Run with `docker run -p 5000:5000 <image>` and document `EXPOSE 5000` in the `Dockerfile`.
3. **Port mismatch between Flask, `EXPOSE`, and `-p`**
   - *Problem:* Flask listens on `5000` while `docker run -p 8080:80` or `EXPOSE` expects a different port.
   - *Fix:* Align the app port (`5000`), `EXPOSE 5000`, and container port in `-p <host_port>:5000`.
4. **Missing dependencies or wrong `CMD` / `WORKDIR`**
   - *Problem:* Container exits immediately because `flask` isn't installed (`requirements.txt` not copied/installed) or `CMD` points to the wrong file.
   - *Fix:* Ensure `WORKDIR /app`, `COPY requirements.txt .`, `RUN pip install --no-cache-dir -r requirements.txt`, `COPY app.py .`, and `CMD ["python", "app.py"]`.
