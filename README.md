# 🚀 Nginx Server Setup for Development & Production

This repository contains a clean, scalable Nginx configuration that I use to serve and reverse-proxy my applications both locally and in production. It's designed to streamline web app development and deployment with a focus on performance, flexibility, and maintainability.

***

## 📌 Features

* 🔁 Reverse proxy support for backend services (e.g., Node.js, Python, etc.)
* 🌐 Static file serving (ideal for React, Vue, etc.)
* 🔐 HTTPS-ready for local deployments
* 🧱 Modular and readable config structure
* ⚙️ Easy to switch between development and production environments
* 🔐 HTTPS-ready for production deployments (comming Soon)

***

## 📂 Project Structure
* local files for local deployment

***
## How To use
### Local Development
1. clone this repo
2. create folder at home dir
```
mkdir -p ~/.nginx-certs
```
3. go to the .nginx-certs dir
```
cd ~/.nginx-certs
```
4. generate the certs
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt
```
5. add the servers you want
the server live in the dirrectory
```
local/files/servers
```

* here is a basic configuration for a live server.
```

upstream react {
        server homepage:5173;
    }
server{
    listen 443 ssl;
    server_name localhost;
    include /etc/nginx/conf.d/includes/ssl_conf.conf;

    location / {
        proxy_pass http://react;
        include /etc/nginx/conf.d/includes/location.conf;
    
    }

}

```

 * configuration for static files serving

```
server {
    listen       443 ssl;
    server_name  localhost;
    include /etc/nginx/conf.d/includes/ssl_conf.conf;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        include /etc/nginx/conf.d/includes/location.conf;
    }

}


```

6. now you are ready to go one last command
```
make run
```
and the server is ready to go

