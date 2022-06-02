FROM alpine:3.14

RUN apk --update add --no-cache --virtual .builddeps \
    nginx \
    openssl \
    && openssl req -x509 \
                    -nodes \
                    -subj "/C=JP/ST=Tokyo/O=42/CN=iyamada.42.fr" \
                    -days 365 \
                    -newkey rsa:2048 \
                    -keyout /etc/ssl/private/nginx-selfsigned.key \
                    -out /etc/ssl/certs/nginx-selfsigned.crt

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/wp.conf /etc/nginx/conf.d/wp.conf
COPY tools/nginx_start.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/nginx_start.sh

EXPOSE 80

ENTRYPOINT ["nginx_start.sh"]
