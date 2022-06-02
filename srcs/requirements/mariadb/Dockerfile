FROM alpine:3.14

RUN apk --update add --no-cache --virtual .builddeps \
	mariadb \
	mariadb-client \
	mariadb-server-utils \
	openrc \
	&& mkdir -p /run/openrc \
	&& touch /run/openrc/softlevel
	# && /etc/init.d/mariadb setup

EXPOSE 3306
COPY tools/mariadb_start.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/mariadb_start.sh

ENTRYPOINT ["mariadb_start.sh"]
# CMD ["/usr/bin/mysqld", "--console", "--user=mysql"]
# CMD ["/usr/bin/mysqld_safe", "--datadir=/var/lib/mysql"]
