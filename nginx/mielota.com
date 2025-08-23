server {
    listen 80;
    listen [::]:80;

    server_name mielota.com;

    root /var/www/mielota.com;
    index index.html;

    location ~* \.(?:jpg|jpeg|gif|png|ico|svg|webp)$ {
        expires 1M;
        access_log off;
        # max-age must be in seconds
        add_header Cache-Control "max-age=2629746, public";
    }

    location ~* \.(?:css|js)$ {
        expires 1y;
        access_log off;
        add_header Cache-Control "max-age=31556952, public";
    }

    gzip on;
    gzip_min_length 1100;
    gzip_buffers 4 32k;
    gzip_types text/plain application/x-javascript text/xml text/css;
    gzip_vary on;

    location / {
        try_files $uri $uri/ =404;
    }
}
