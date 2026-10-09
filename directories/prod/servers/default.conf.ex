server {
    listen       443 ssl;
    server_name  localhost;
    include /etc/nginx/conf.d/includes/headers_conf.conf;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        include /etc/nginx/conf.d/includes/proxy_conf.conf;
    }


    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}

