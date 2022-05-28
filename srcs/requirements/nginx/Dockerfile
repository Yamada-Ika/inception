FROM alpine:3.16

RUN apk --update add --no-cache --virtual .builddeps nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT /usr/sbin/nginx -g "daemon off;" -c /etc/nginx/nginx.conf
