#!/bin/bash

echo "Début du script"

# on copie les fichiers de wordpress dans le dossier /var/www/html uniquement si il n'existe pas déjá un fichier index.php
if [ ! -f "/var/www/html/index.php" ]; then
    cp -a /wordpress/. /var/www/html/
fi

# on crée le fichier de configuration wp-config.php avec les informations de la base de données
# uniquement si il n'existe pas déjá
if [ ! -f "/var/www/html/wp-config.php" ]; then
	wp config create --allow-root \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=mariadb \
		--path=/var/www/html
fi

echo "Fichier de configuration wp-config.php créé"

# on installe WordPress avec les informations fournies dans le fichier .env
if ! wp core is-installed --allow-root --path=/var/www/html >/dev/null 2>&1; then
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
fi

echo "WordPress installé avec succès"

# on execute php-fpm au premier plan grace a -F (forground)
exec php-fpm8.2 -F

# Changer le --allow-root car peu etre dangereux, mais pour le moment on le laisse pour que ça fonctionne.