server {
    listen 80;
    listen [::]:80;

    server_name mielota.com;

    root /var/www/mielota.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
