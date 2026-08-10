# Basic Dockerfile for running the repository's fuse-water command
FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl ca-certificates git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY code/ /app/code/
ENTRYPOINT ["python", "code/s1s2_pond_production.py"]
CMD ["--help"]
