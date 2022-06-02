FROM alpine:3.14

RUN apk --update add --no-cache --virtual .builddeps nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/nginx_start.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/nginx_start.sh

EXPOSE 80

# ENTRYPOINT /usr/sbin/nginx -g "daemon off;" -c /etc/nginx/nginx.conf

ENTRYPOINT ["nginx_start.sh"]