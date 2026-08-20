#!/bin/bash

echo "Creating .env file.."
touch .env
mkdir secrets

echo "URL_NAME=jpiquet.42.fr" > .env

# DATABASE ENV + SECRETS
echo -n "Database name: "
read DBNAME
echo "DB_NAME=${DBNAME}" >> .env

echo -n "Database user name: "
read DBUSER
echo "DB_USER=${DBUSER}" >> .env

echo -n "Database user password: "
read DBPASS
echo -n "DBPASS" > /secrets/db_passord.txt

echo -n "Database root password: "
read ROOTPASS
echo -n "DBPASS" > /secrets/db_root_passord.txt

# WORDPRESS ENV + SECRETS

echo -n "Wordpress admin username (can't contains \"admin\"): "
read ADMIN

# admin = ${ADMIN}
until ./search_string ${ADMIN}
do
	echo -n "Wordpress admin username (can't contains \"admin\"): "
	read ADMIN
done

echo -n "Wordpress admin password: "
read ADMINPASS

echo "Choose your "