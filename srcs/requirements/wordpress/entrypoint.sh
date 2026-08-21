#!/bin/bash

set -eu

# Copy the WordPress files to /var/www/html only if an index.php file does not already exist
if [ ! -f "/var/www/html/index.php" ]; then
	cp -a /wordpress/. /var/www/html/
fi

# Create the wp-config.php configuration file with the database information
# only if it does not already exist
if [ ! -f "/var/www/html/wp-config.php" ]; then
	wp config create --allow-root \
		--dbname=${DB_NAME} \
		--dbuser=${DB_USER} \
		--dbpass=$(cat /run/secrets/db_password) \
		--dbhost=mariadb:3306 \
		--path=/var/www/html
fi

echo "Configuration file wp-config.php was created successfully"

# Install WordPress using the information provided in the .env file
if ! wp core is-installed --allow-root --path=/var/www/html >/dev/null 2>&1; then
	wp core install --allow-root \
		--url=jpiquet.42.fr \
		--title=Inception \
		--admin_user=${ADMIN_NAME} \
		--admin_password=$(cat /run/secrets/admin_password) \
		--admin_email=${ADMIN_EMAIL} \
		--path=/var/www/html

	wp user create --allow-root \
		${USER_NAME} \
		${USER_EMAIL} \
		--user_pass=$(cat /run/secrets/user_password) \
		--path=/var/www/html
fi

echo "WordPress installed successfully"

# Run PHP-FPM in the foreground using -F (foreground mode)
exec php-fpm8.2 -F
