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
echo -n ${DBPASS} > /secrets/db_passord.txt

echo -n "Database root password: "
read ROOTPASS
echo -n ${ROOTPASS} > /secrets/db_root_passord.txt

# WORDPRESS ENV + SECRETS

echo -n "Wordpress admin username (can't contains \"admin\"): "
read ADMIN

# admin = ${ADMIN}
until ./search_string ${ADMIN}
do
	echo -n "Wordpress admin username (can't contains \"admin\"): "
	read ADMIN
done
echo "ADMIN_NAME=${ADMIN}" >> .env

echo -n "Wordpress admin password: "
read ADMINPASS
echo -n ${ADMINPASS} > /secrets/admin_password.txt

echo -n "Wordpress user username: "
read USER
echo -n ${USER} >> .env

echo -n "Wordpress guest password: "
read USERPASS
echo -n ${USERPASS} > /secrets/user_password.txt

if [ ! -f "/secrets/inception.crt" ]; then
	openssl req -x509 \
	-nodes \
	-days 365 \
	-newkey rsa:2048 \
	-out /etc/ssl/certs/inception.crt \
	-keyout /etc/ssl/private/inception.key \
	-subj /C=FR/ST=RH/L=Lyon/O=42/OU=42/CN=jpiquet.42.fr
fi

#rm -f start_script