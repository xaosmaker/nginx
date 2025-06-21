# 🚀 Nginx Server Setup for Development & Production

This repository contains a clean, scalable Nginx configuration that I use to serve and reverse-proxy my applications both locally and in production. It's designed to streamline web app development and deployment with a focus on performance, flexibility, and maintainability.

***

## 📌 Features

* 🔁 Reverse proxy support for backend services (e.g., Node.js, Python, etc.)
* 🌐 Static file serving (ideal for React, Vue, etc.)
* 🔐 HTTPS-ready for local deployments
* 🧱 Modular and readable config structure
* ⚙️ Easy to switch between development and production environments
* 🔐 HTTPS-ready for production deployments

***

## 📂 Project Structure
* local mod with self signed certs for local deployment
* product mode need conf for ssl certificates

***
## How To use
### Local Development
* #### requirement
    1. python installed to the system
    2. openssl
1. clone this repo
2. run make init-run
```
make init-run
```
##### the script run with root privileges to be able to  create the file structure
it will create a folder in the home nginx_local and there 3 files
* nginx_local
    1. includes what you can include to the server like headers and settings
    2. servers here go the files for the server configuration
    3. static here go all the static files you want to serve you need to define a server to work correct
i create it this way so you can able to live reload the configs without drop time or rebuild of the container

* here is some ex configurations.

server
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

static files
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
copy the servers and settings you want to add to the folders look in the api what you can do
### Prod Development
there are 3 differences with the local
1. the file storage is in home dir under the name of nginx_prod
2. you need to change the name of the domain i use drosinakis.com because is my domain
3. you need first to generate static certs with certbot because the server will throw an error from ssl
4. and then you can run normal the server

### Api

```
make init-run or make init-run-prod
```
start the server and generates the files 
```
make run or make run-prod
```
start the server and build the docker image
```
make build or make build-prod
```
build the docker image

```
make down-v or make down-v-prod
```
stop the container and remove the networks the files we create is still in place 
if you want to delete them manual delete
```
make inspect_nginx
```
login to the container in bash

```
make test-conf
```
this when you update the server or the includes and static you can check if the nginx config is valid or invalid
this is good to test if everything is ok

```
make hot-reload
```
test the config if there is error it stop
if there is not any error it will send a signal to nginx to reload the config
it will create new workers with the new conf and stop the old when they finish their request


