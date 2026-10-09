# 🚀 Nginx Server Setup for Development & Production

A clean, scalable Nginx configuration for serving static files and reverse-proxying web applications, both locally and in production. Everything runs in Docker, and a small `Makefile` wraps the common tasks.

***

## 💡 Why

I created this project to host my own server on an old laptop.
I really enjoy working on it because I had no prior experience with Nginx, and learning how to set up and configure the server has been a fun challenge.

I'm still missing bandwidth limiting and request rate limiting, but once I finish my other projects, I plan to come back and fine-tune those settings.

Nginx is one of the most widely used web servers in the industry, and I'm proud that I've been able to configure it to this extent.

***

## 📌 Features

* 🔁 Reverse proxy support for backend services (e.g., Node.js, Python, Portainer, etc.)
* 🌐 Static file serving (ideal for React, Vue, etc.)
* 🔐 HTTPS for local (self-signed) and production (real certs) deployments
* 🧱 Modular config: shared `includes/` plus one file per `server` block
* ⚙️ Separate local and production setups driven by Docker Compose
* 🔥 Hot reload without downtime
* 🛡️ Security headers and a reusable Content-Security-Policy snippet
* ⚡ gzip, HTTP/1.1 keepalive, and WebSocket upgrade support out of the box

***

## 📂 Project Structure

```
.
├── configs/
│   └── nginx.conf              # Main Nginx config baked into the image
├── devops/
│   ├── Dockerfile              # nginx:alpine + configs/nginx.conf
│   ├── local.yaml              # Docker Compose for local (self-signed certs)
│   ├── prod.yaml               # Docker Compose for production
│   └── certbot/                # ACME webroot for Let's Encrypt challenges
├── directories/
│   ├── local/                  # Template copied to ~/nginx_local by setup
│   │   ├── includes/
│   │   ├── servers/
│   │   └── static/
│   └── prod/                   # Template copied to ~/nginx_prod by setup
│       ├── includes/
│       ├── servers/
│       └── static/
├── scripts/
│   ├── local_setup.sh          # Creates ~/nginx_local + self-signed cert
│   └── prod_setup.sh           # Creates ~/nginx_prod
├── example.env                 # Sample environment file (copy to .env)
├── Makefile                    # Dev/prod shortcuts
└── README.md
```

The setup scripts copy `directories/<env>/` into your home directory (`~/nginx_local` or `~/nginx_prod`) and Docker Compose mounts those folders into the container. This keeps generated certs and your edits out of the repo.

Each environment folder contains:

* `includes/` – reusable snippets (TLS, headers, proxy timeouts, CSP)
* `servers/` – one file per Nginx `server` block
* `static/` – files served by Nginx

***

## ✅ Requirements

* Docker + Docker Compose
* GNU Make
* OpenSSL (local self-signed certs)
* Certbot (production certs)

***

## 🛠️ How to Use

### ⚙️ Local Development

First run (builds the image, creates `~/nginx_local` with a self-signed certificate, and starts the container):

```
make dev-init-run
```

Subsequent runs:

```
make dev-run
```

After setup, the container mounts these host paths:

| Host                                    | Container                          |
| --------------------------------------- | ---------------------------------- |
| `~/nginx_local/letsencrypt/live/domain.com` | `/certs/live/domain.com` (read-only) |
| `~/nginx_local/servers/`                | `/etc/nginx/conf.d/servers`        |
| `~/nginx_local/includes/`               | `/etc/nginx/conf.d/includes`       |
| `~/nginx_local/static/`                 | `/usr/share/nginx/html`            |

The default local page is served at `https://localhost` (accept the self-signed certificate warning).

> ⚠️ The setup script copies `directories/local/` to `~/nginx_local` **once**. Edit the files under `~/nginx_local/` for day-to-day changes, or re-run `make dev-init-run` to refresh from the templates.

### 🚀 Production Deployment

1. Create your environment file and set `CERT_DIR` to the directory containing your Let's Encrypt `fullchain.pem` and `privkey.pem`:

   ```
   cp example.env .env
   # edit .env -> CERT_DIR="/etc/letsencrypt/live/your-domain.com"
   ```

2. Generate real certificates with **Certbot**. The `.well-known/acme-challenge/` location is served from `/var/www/certbot`, which is mounted from `devops/certbot/`.

3. Build, create `~/nginx_prod`, and start:

   ```
   make prod-init-run
   ```

   Subsequent runs:

   ```
   make prod-run
   ```

4. Replace the placeholder domains in your server configs (e.g., `localhost`) with your own domain names.

In production, `CERT_DIR` is mounted to `/certs/live/domain.com`, and the container joins an internal `nginx-net` network so backends can be reached by service name.

***

## 🧩 How Configuration Works

The image ships a single main config, `configs/nginx.conf`. It:

* Defines global settings: gzip, `client_max_body_size 20M`, keepalive, and proxy headers.
* Provides a `map` for WebSocket `Upgrade`/`Connection` handling.
* Listens on port `80`, serves the ACME challenge, and redirects everything else to HTTPS.
* Includes every file from `/etc/nginx/conf.d/servers/*.conf`.
* Falls back to `404` on the default HTTPS server when no `server_name` matches.

Each `server` block in `servers/` is intentionally small. Reusable pieces live in `includes/`:

* `headers_conf.conf` – TLS protocols/ciphers and security headers (HSTS, `X-Frame-Options`, etc.)
* `proxy_conf.conf` – proxy read/connect/send timeouts
* `csp_header.conf` / `csp.conf` – an optional `Content-Security-Policy` header

### Example: static file server

```nginx
server {
    listen 443 ssl;
    server_name localhost;
    include /etc/nginx/conf.d/includes/headers_conf.conf;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        include /etc/nginx/conf.d/includes/proxy_conf.conf;
    }
}
```

### Example: reverse proxy

```nginx
upstream react {
    server homepage:5173;
}

server {
    listen 443 ssl;
    server_name app.localhost;
    include /etc/nginx/conf.d/includes/headers_conf.conf;

    location / {
        proxy_pass http://react;
        include /etc/nginx/conf.d/includes/proxy_conf.conf;
    }
}
```

Just drop a new `*.conf` file into `~/nginx_local/servers/` (or `~/nginx_prod/servers/`) and reload.

***

## 🧪 Makefile API

**Local:**

```
make dev-init-run     # Build, create ~/nginx_local + self-signed cert, start
make dev-run          # Start the local container
make dev-build        # Rebuild the local image (no cache)
make dev-down-v       # Stop and remove containers, networks, and volumes
```

**Production:**

```
make prod-init-run    # Build, create ~/nginx_prod, start with .env
make prod-run         # Start the production container
make prod-build       # Rebuild the production image (no cache)
make prod-down-v      # Stop and remove containers, networks, and volumes
```

**Operations:**

```
make inspect_nginx    # Open a shell inside the running container
make logs             # Follow the Nginx container logs
make test-conf        # Validate the Nginx configuration (nginx -t)
make hot-reload       # Validate, then gracefully reload Nginx
```

`make hot-reload` runs `test-conf` first, so Nginx only reloads when the configuration is valid.

***

## 🔑 Environment Variables

| Variable   | Used by        | Description                                                        |
| ---------- | -------------- | ------------------------------------------------------------------ |
| `CERT_DIR` | `devops/prod.yaml` | Host path to Let's Encrypt certs, mounted at `/certs/live/domain.com`. |

Copy `example.env` to `.env` and adjust as needed. `.env` is git-ignored; `example.env` is committed.

***

## 📝 Notes

* Editing files under `directories/` only affects **new** setups. To apply changes to an existing deployment, edit the copy in `~/nginx_local` or `~/nginx_prod`, then run `make hot-reload`.
* The local setup uses a self-signed certificate for `CN=localhost`; browsers will warn until you trust it.
* `make dev-down-v` / `make prod-down-v` remove containers and networks but keep the config folders in your home directory. Delete them manually if you want a clean slate.
