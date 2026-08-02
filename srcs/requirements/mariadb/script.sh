#!/bin/bash

#crée le dossier pour le socket de MariaDB
mkdir -p /var/run/mysqld
#on définit le propriétaire du dossier sur l'utilisateur mysql pour que MariaDB puisse y accéder
chown mysql:mysql /var/run/mysqld

# on démarre le serveur MariaDB en arrière-plan et on récupère son PID
mariadbd --user=mysql &
PID=$!

#on attend que le serveur MariaDB soit prêt à accepter les connexions
until mariadb -u root -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 1
done

#on crée la base de données wordpress si elle n'existe pas déjà
#on crée l'utilisateur 'jocelyn' avec le mot de passe 'jocelyn' s'il n'existe pas déjà
#on accorde tous les privilèges sur la base de données 'wordpress' à l'utilisateur 'jocelyn'
#on applique les changements de privilèges
mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

#on arrête le serveur MariaDB
kill "$PID"

#on attend que le serveur MariaDB se termine avant de continuer
wait "$PID"

#on redémarre le serveur MariaDB en mode premier plan pour que le conteneur continue de fonctionner
exec mariadbd --user=mysql