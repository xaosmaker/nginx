upstream portainer {
        server portainer:9443;
    }
server{
    listen 443 ssl;
    server_name portainer;
    include /etc/nginx/conf.d/includes/headers_conf.conf;

    location / {
        proxy_pass https://portainer;
        include /etc/nginx/conf.d/includes/proxy_conf.conf;
    
    }

}

