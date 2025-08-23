server {
    server_name git.mielota.com;

    listen 80;
    listen [::]:80;

    root /usr/share/cgit;
    try_files $uri @cgit ;

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

    location ~ /.+/(info/refs|git-upload-pack) {
        include             fastcgi_params;
        fastcgi_param       SCRIPT_FILENAME /usr/lib/git-core/git-http-backend;
        fastcgi_param       PATH_INFO           $uri;
        fastcgi_param       GIT_HTTP_EXPORT_ALL 1;
        fastcgi_param       GIT_PROJECT_ROOT    /var/git;
        fastcgi_param       HOME                /var/git;
        fastcgi_pass        unix:/run/fcgiwrap.socket;
    }

    location @cgit {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /usr/lib/cgit/cgit.cgi;
        fastcgi_param PATH_INFO $uri;
        fastcgi_param QUERY_STRING $args;
        fastcgi_param HTTP_HOST $server_name;
        fastcgi_pass unix:/run/fcgiwrap.socket;
    }

}
