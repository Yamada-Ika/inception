FROM alpine:3.14

RUN apk --update add --no-cache --virtual .builddeps \
    mariadb-client \
    sudo \
    curl \
    php \
    php-fpm \
    php-mysqli \
    php-phar \
    php7-common \
    php7-session \
    php7-iconv \
    php7-json \
    php7-gd \
    php7-curl \
    php7-xml \
    php7-mysqli \
    php7-imap \
    php7-cgi \
    fcgi \
    php7-pdo \
    php7-pdo_mysql \
    php7-soap \
    php7-xmlrpc \
    php7-posix \
    php7-mcrypt \
    php7-gettext \
    php7-ldap \
    php7-ctype \
    php7-dom \
    php7-simplexml \
    && mkdir -p /var/www/html \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && adduser -D -g nginx nginx \
    && chown -R nginx:nginx var/www/html/

WORKDIR /var/www/html
EXPOSE  9000
COPY    tools/wp_start.sh /usr/local/bin/
COPY    conf/www.conf /etc/php7/php-fpm.d/www.conf

ENTRYPOINT ["wp_start.sh"]
CMD ["php-fpm7", "-F"]
