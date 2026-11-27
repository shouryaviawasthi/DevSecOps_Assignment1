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

| # | Problem | Why It Fails | Fix |
|---|---------|--------------|-----|
| 1 | `FORM python:3.12-slim` | `FORM` is a typo and not a valid Dockerfile instruction; Docker build fails with an unknown instruction error. | Change `FORM` to `FROM`: `FROM python:3.12-slim` |
| 2 | `RUN pip install -r requirement.txt` | Typo in filename (`requirement.txt` instead of `requirements.txt`). `pip` fails with `Could not open requirements file: [Errno 2] No such file or directory`. | Change to `RUN pip install --no-cache-dir -r requirements.txt` |
| 3 | `docker run -p 5000:8080 myapp` | `app.py` listens on port `5000` (`app.run(host="0.0.0.0", port=5000)`), not `8080`. Forwarding host port `5000` to container port `8080` means requests to `localhost:5000` never reach Flask. | Map host port `5000` to container port `5000`: `docker run -p 5000:5000 myapp` (and add `EXPOSE 5000` in the `Dockerfile` for documentation). |
