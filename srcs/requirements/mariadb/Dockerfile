FROM alpine:3.14

RUN apk --update add --no-cache --virtual .builddeps \
    mariadb \
    mariadb-client \
    mariadb-server-utils \
    openrc \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel

EXPOSE 3306
COPY   tools/db_start.sh /usr/local/bin/

RUN    chmod 755 /usr/local/bin/db_start.sh

ENTRYPOINT ["db_start.sh"]
