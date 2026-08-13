#!/bin/bash

# on copie les fichiers de wordpress dans le dossier /var/www/html uniquement si il n'existe pas déjá un fichier index.php
if [ ! -f "/var/www/html/index.php" ]; then
    cp -a /wordpress/. /var/www/html/
fi

# on crée le fichier de configuration wp-config.php avec les informations de la base de données
# uniquement si il n'existe pas déjá
if [ ! -f "/var/www/html/wp-config.php" ]; then
	wp config create --allow-root \
		--dbname=${DB_NAME} \
		--dbuser=${DB_USER} \
		--dbpass=$(cat /run/secrets/db_password) \
		--dbhost=mariadb \
		--path=/var/www/html
fi

echo "Configuration file wp-config.php was created successfully"

# on installe WordPress avec les informations fournies dans le fichier .env
if ! wp core is-installed --allow-root --path=/var/www/html >/dev/null 2>&1; then
	wp core install --allow-root \
		--url=${URL_NAME} \
		--title=${TITLE_NAME} \
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

rm -rf /run/secrets

# on execute php-fpm au premier plan grace a -F (forground)
exec php-fpm8.2 -F