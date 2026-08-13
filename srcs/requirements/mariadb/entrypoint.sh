#!/bin/bash

set -eu

# crée le dossier pour le socket de MariaDB
mkdir -p /run/mysqld

# on définit le propriétaire du dossier sur l'utilisateur mysql pour que MariaDB puisse y accéder
chown mysql:mysql /run/mysqld

# on initialise le dsossier qui stockera les fichiers de la base de donné (sur le volume monté)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# on change les permissions du dossier pour etre sur que le user mysql puisse apporter des modifications
#chown mysql:mysql /var/lib/mysql

# on démarre le serveur MariaDB en arrière-plan et on récupère son PID
mariadbd --user=mysql &
PID=$!

#on attend que le serveur MariaDB soit prêt à accepter les connexions
echo coucou
until mariadb -u root --password=$(cat /run/secrets/db_root_password) -e "SELECT 1;" >/dev/null 2>&1; do
	echo "in loop"
    sleep 1
done
echo caca

# on crée la base de données wordpress si elle n'existe pas déjà
# on crée l'utilisateur 'db_user' avec le mot de passe 'db_password' s'il n'existe pas déjà
# on accorde tous les privilèges sur la base de données 'wordpress' à l'utilisateur ''
# on applique les changements de privilèges
mariadb -u root --password=$(cat /run/secrets/db_root_password)" <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';
CREATE USER IF NOT EXISTS 'healthcheck'@'localhost';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

#on arrête le serveur MariaDB
kill "$PID"

#on attend que le serveur MariaDB se termine avant de continuer
wait "$PID"

echo "Mariadb is ready !"

#on redémarre le serveur MariaDB en mode premier plan pour que le conteneur continue de fonctionner
exec mariadbd --user=mysql