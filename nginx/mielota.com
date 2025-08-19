server {
    listen 80 ;
    listen [::]:80 ;

    server_name mielota.com;

    return 301 http://www.mielota.com$request_uri;
}
