# 🚀 Nginx Server Setup for Development & Production

This repository contains a clean, scalable Nginx configuration I use to serve and reverse*proxy my applications both locally and in production. It's designed to streamline web app development and deployment with a focus on performance, flexibility, and maintainability.

***

## 💡 WHY

I created this project to host my own server on an old laptop.  
I really enjoy working on it because I had no prior experience with Nginx, and learning how to set up and configure the server has been a fun challenge.

I'm still missing bandwidth limiting and request rate limiting, but once I finish my other projects, I plan to come back and fine-tune those settings.

Nginx is one of the most widely used web servers in the industry, and I’m proud that I’ve been able to configure it to this extent.

***

## 📌 Features

* 🔁 Reverse proxy support for backend services (e.g., Node.js, Python, etc.)
* 🌐 Static file serving (ideal for React, Vue, etc.)
* 🔐 HTTPS-ready for local and production deployments
* 🧱 Modular and readable config structure
* ⚙️ Easy switching between development and production environments

***

## 📂 Project Structure

* `nginx_local/` – for local deployment using self-signed certificates  
* `nginx_prod/` – for production mode (requires real SSL certs)

Each environment includes:

* `includes/` – reusable snippets (headers, settings, etc.)
* `servers/` – individual server blocks
* `static/` – static assets to serve (if needed)

This modular setup allows live-reloading of config files without downtime or container rebuilds.

***

## 🛠️ How to Use

### ⚙️ Local Development

#### Requirements

1. Python  
2. OpenSSL

#### Steps

1. Clone this repo  
2. Run:

```
make init-run
```

⚠️ This script runs with root privileges to set up the required file structure.

**It will create the following in your home directory: `~/nginx_local/`**

* `includes/` – shared settings (headers, SSL, etc.)
* `servers/` – Nginx server configuration files
* `static/` – static files to serve

#### Example Configurations

**Reverse Proxy (e.g., React Dev Server):**

```
upstream react {
    server homepage:5173;
}

server {
    listen 443 ssl;
    server_name localhost;
    include /etc/nginx/conf.d/includes/ssl_conf.conf;

    location / {
        proxy_pass http://react;
        include /etc/nginx/conf.d/includes/location.conf;
    }
}
```

**Static File Server:**

```
server {
    listen 443 ssl;
    server_name localhost;
    include /etc/nginx/conf.d/includes/ssl_conf.conf;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        include /etc/nginx/conf.d/includes/location.conf;
    }
}
```

Just copy your desired `server` configs into the `servers/` folder and you're good to go.

***

### 🚀 Production Deployment

Differences from local setup:

1. Uses `~/nginx_prod/` for configuration and data.  
2. Replace domain name (e.g., `drosinakis.com`) with your own.  
3. Generate real SSL certificates using **Certbot** before starting the server.  
4. Then, start the server as usual.

***

## 🧪 Makefile API

**Initialize and Start (creates folders and runs container):**

```
make init-run           # Local
make init-run-prod      # Production
```

**Run Server (build and start container):**

```
make run                # Local
make run-prod           # Production
```

**Build Docker Image:**

```
make build              # Local
make build-prod         # Production
```

**Stop & Clean Up:**

```
make down-v             # Local
make down-v-prod        # Production
```

This removes containers and networks, but keeps config files.  
Delete manually if needed.

**Inspect Container:**

```
make inspect_nginx
```

**Test Nginx Config:**

```
make test-conf
```

Useful after making changes to servers, includes, or static files.

**Hot Reload (no downtime):**

```
make hot-reload
```

Validates config, then gracefully reloads Nginx if all checks pass.

***
