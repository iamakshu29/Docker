# 📘 Docker Reference Guide for Different Application Types

This document summarizes common **Dockerfile patterns**, **best practices**, and **troubleshooting tips** for various applications and stacks.

---

## 🐍 Python – Django App

```dockerfile
# Get Python image
FROM python:3.10

# Set working directory
WORKDIR /app

# Copy dependencies first (for caching)
COPY requirements.txt .

# Upgrade pip and install dependencies
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . .

# Expose Django default port
EXPOSE 8000

# Run Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

