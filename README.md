# 📘 Docker Reference Guide for Different Application Types

This document summarizes common **Dockerfile patterns**, **best practices**, and **troubleshooting tips** for various applications and stacks.

---

## 🐍 Python – Django App

```docker
# Get Python image
FROM python:3.10

# Set workdir
WORKDIR /app

# Copy dependencies first (for caching)
COPY requirements.txt .

# Upgrade pip and install dependencies from requirements.txt
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . .

# Expose Django default port
EXPOSE 8000

# Run Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

🔑 Notes:

- If `requirements.txt` not present → create one with required packages.
- Always pin versions inside `requirements.txt` for reproducibility.
- Expose correct port (`8000` is default for Django).

---

## 🟣 ASP.NET / .NET Core

```docker
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
RUN dotnet build aspnetapp.csproj -c Release \
 && dotnet publish aspnetapp.csproj -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .
ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000
CMD ["dotnet", "aspnetapp.dll"]
```

🔑 Notes:

- **Build & publish** in SDK image → copy to runtime image → results in smaller final image.
- `ASPNETCORE_URLS` env ensures app binds to container port.

---

## 🚀 FastAPI (with Uvicorn)

```docker
FROM python:3.10

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## 🌱 Flask App

Two common setups:

### 1. **Default Flask run**

Requires ENV variables because Flask defaults to `127.0.0.1`:

```docker
FROM python:3.10
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

ENV FLASK_APP=hello.py
ENV FLASK_ENV=development
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8000

EXPOSE 8000
CMD ["flask", "run"]
```

### 2. **Explicit host/port in app.run()**

```python
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9090, debug=True)
```

```docker
CMD ["python3", "server.py"]
```

---

## 🌐 Node.js App

```docker
FROM node:18

WORKDIR /app
COPY package*.json ./

# Clean install for reproducible builds
RUN npm ci

COPY . .

EXPOSE 3000
CMD ["npm", "start"] # for development

RUN npm run build # for production
```

🔑 Notes:

- `npm ci` is preferred over `npm install` for clean, reproducible builds.
- `npm start` looks up the `"start"` script in `package.json`.

---

## 🐳 Alpine Images

- Use `apk` instead of `apt-get`.

```docker
RUN apk update && apk add --no-cache git
```

- Great for **small images**, but some tools (like `git`) may not work out-of-the-box → use Debian slim if needed.

---

## 🟢 Java (Spring Boot, Maven-based)

```docker
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/myapp.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```

🔑 Notes:

- Check `pom.xml` for dependencies.
- Database settings (username, password, db name) usually live in `application.properties`.

⚠️ MySQL error:

`Access denied for user 'root'@'172.18.0.3' (using password: YES)`

→ Means wrong credentials or MySQL container not configured with matching root password.

---

## 🗄️ Mongo + Flask Integration

If Flask connects using:

```python
client = MongoClient("mongo:27017")
```

→ Ensure your `docker-compose.yml` sets:

```yaml
services:
  mongo:
    image: mongo:5
    container_name: mongo
  flask-app:
    build: .
    depends_on:
      - mongo
```

Container name **must** match (`mongo`).

---

## 🌐 Nginx – Backend vs Frontend

### 1. Proxying Backend Apps (Flask, ASP.NET, Node.js)

```
server {
    listen 8000;
    server_name localhost;

    location / {
        proxy_pass http://backend-app:9090;
    }
}
```

✅ Works normally since backend apps serve HTTP responses.

### 2. Frontend (React, Angular, Vue)

- **Dev server (`npm start`)** → ❌ Not good for production (serves from memory, hot reload, WebSockets).
- **Production build (`npm run build`)** → ✅ Generates static `build/` folder.

```
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri /index.html;
    }
}
```

---

## 📝 Extra Best Practices

- Always use **multi-stage builds** (smaller runtime images).
- Pin dependency versions (`requirements.txt`, `package.json` lockfiles).
- Use `.dockerignore` to avoid copying unnecessary files.
- Always define **WORKDIR** instead of `cd`.
- Prefer `CMD` for the final process; use `ENTRYPOINT` only when app binary must always run.
- Expose the correct app port.
