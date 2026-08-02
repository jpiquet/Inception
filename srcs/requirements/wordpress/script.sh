#!/bin/bash

# on installe WP-CLI pour gérer WordPress en ligne de commande
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
chmod +x /usr/local/bin/wp

# on crée le fichier de configuration wp-config.php avec les informations de la base de données
wp config create --allow-root \
	--dbname=${DB_NAME} \
	--dbuser=${DB_USER} \
	--dbpass=${DB_PASSWORD} \
	--dbhost=mariadb \
	--path=/var/www/html

# on installe WordPress avec les informations fournies dans le fichier .env
wp core install --allow-root \
	--url=${URL_NAME} \
	--title=${TITLE_NAME} \
	--admin_user=${ADMIN_USER} \
	--admin_password=${ADMIN_PASSWORD} \
	--admin_email=${ADMIN_EMAIL} \
	--path=/var/www/html

wp user create --allow-root \
	${WP_USER} \
	${WP_EMAIL} \
	--user_pass=${WP_PASSWORD} \
	--path=/var/www/html



# Changer le --allow-root car peu etre dangereux, mais pour le moment on le laisse pour que ça fonctionne.