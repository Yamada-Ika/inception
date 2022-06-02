#!/bin/sh

# MARIADB_USER_PASS=${WORDPRESS_DB_PASSWORD}

WORDPRESS_DB_HOST=${MYSQL_HOST}
WORDPRESS_DB_USER=${MYSQL_USER}
WORDPRESS_DB_PASSWORD=${MYSQL_PASSWORD}
WORDPRESS_DB_NAME=${MYSQL_DATABASE}
WORDPRESS_ADMIN_USER=${WORDPRESS_ADMIN_USER}
WORDPRESS_ADMIN_USER_PASS=${WORDPRESS_ADMIN_USER_PASS}
WORDPRESS_ADMIN_EMAIL=${WORDPRESS_ADMIN_EMAIL}

echo "[log info] : waiting for finishing setting up database container ..."
until mysql -h mariadb -u ${WORDPRESS_DB_USER} \
		--password=${WORDPRESS_DB_PASSWORD} ${WORDPRESS_DB_NAME} &> /dev/null; do
		sleep 3
done

if ! wp core is-installed --path=/var/www/html --allow-root &> /dev/null; then
	echo "[log info] : \${WORDPRESS_DB_HOST}     : ${WORDPRESS_DB_HOST}"
	echo "[log info] : \${WORDPRESS_DB_NAME}     : ${WORDPRESS_DB_NAME}"
	echo "[log info] : \${WORDPRESS_DB_USER}     : ${WORDPRESS_DB_USER}"
	echo "[log info] : \${WORDPRESS_DB_PASSWORD} : ${WORDPRESS_DB_PASSWORD}"

	echo "[log info] : downloading wordpress ..."
	wp core download \
		--locale=ja \
		--path=/var/www/html \
		--allow-root

	echo "[log info] : creating wp-config.php ..."
	wp config create \
		--dbname=${WORDPRESS_DB_NAME} \
		--dbuser=${WORDPRESS_DB_USER} \
		--dbpass=${WORDPRESS_DB_PASSWORD} \
		--dbhost=${WORDPRESS_DB_HOST} \
		--allow-root \
		--path=/var/www/html

	echo "[log info] : installing wp-config.php ..."
	wp core install \
		--url=http://localhost:8080 \
		--title=localhost:8080 \
		--admin_user=${WORDPRESS_ADMIN_USER} \
		--admin_password=${WORDPRESS_ADMIN_USER_PASS} \
		--admin_email=${WORDPRESS_ADMIN_EMAIL} \
		--allow-root \
		--skip-email \
		--path=/var/www/html

	# wp user create \
	# 	$WORDPRESS_AUTHOR_USER \
	# 	$WORDPRESS_AUTHOR_EMAIL \
	# 	--role=author \
	# 	--user_pass=$WORDPRESS_AUTHOR_USER_PASS \
	# 	--allow-root \
	# 	--path=/var/www/html
else
	echo "[log info] : wordpress has already downloaded"
fi

echo "[log info] : now, wordpress container is running"

exec "$@"
