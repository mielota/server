server {
    listen 80;
    listen [::]:80;

    server_name searx.mielota.com ;

    access_log /dev/null;
    error_log  /dev/null;

    add_header X-Frame-Options "DENY";

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";

    add_header Content-Security-Policy "default-src 'self';";

    location / {
        uwsgi_pass unix:///usr/local/searxng/run/socket;

        include uwsgi_params;

        uwsgi_param    HTTP_HOST             $host;
        uwsgi_param    HTTP_CONNECTION       $http_connection;

        uwsgi_param    HTTP_X_SCHEME         $scheme;
        uwsgi_param    HTTP_X_SCRIPT_NAME    /searxng;

        uwsgi_param    HTTP_X_REAL_IP        $remote_addr;
        uwsgi_param    HTTP_X_FORWARDED_FOR  $proxy_add_x_forwarded_for;
    }
}
