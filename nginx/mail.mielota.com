server {

    server_name mail.mielota.com;

    listen 80;
    listen [::]:80;

    root /var/www/mielota.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
