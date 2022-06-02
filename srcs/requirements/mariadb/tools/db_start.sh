#!/bin/sh

# set -x

if [ -d "/run/mysqld" ]; then
    echo "[log info] : mysqld exists"
    chown -R mysql:mysql /run/mysqld
else
    echo "[log info] : mysqld not found ..."
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

WORDPRESS_DB_NAME=${MYSQL_DATABASE}
WORDPRESS_DB_USER=${MYSQL_USER}
WORDPRESS_DB_PASSWORD=${MYSQL_PASSWORD}
MARIADB_USER=${MYSQL_USER}
MARIADB_USER_PASS=${MYSQL_PASSWORD}

if [ -d "/var/lib/mysql/mysql" ]; then
    echo "[log info] : mysql directory exists"
    chown -R mysql:mysql /var/lib/mysql/mysql
else
    echo "[log info] : mysql direcotry not found ..."
    echo "[log info] : mysql installing ..."
    echo "[log info] : \${MYSQL_ROOT_PASSWORD}   : ${MYSQL_ROOT_PASSWORD}"
    echo "[log info] : \${WORDPRESS_DB_USER}     : ${WORDPRESS_DB_USER}"
    echo "[log info] : \${WORDPRESS_DB_PASSWORD} : ${WORDPRESS_DB_PASSWORD}"
    echo "[log info] : \${WORDPRESS_DB_NAME}     : ${WORDPRESS_DB_NAME}"
    echo "[log info] : \${MARIADB_USER}          : ${MARIADB_USER}"
    echo "[log info] : \${MARIADB_USER_PASS}     : ${MARIADB_USER_PASS}"
    mkdir -p /var/lib/mysql/mysql
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi
    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;

CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_USER_PASS}';
GRANT ALL ON ${WORDPRESS_DB_NAME}.* to '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
    rm -f $tfile
fi

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@
