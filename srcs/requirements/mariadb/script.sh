#!/bin/bash

# crée le dossier pour le socket de MariaDB et définit les permissions appropriées
mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld
