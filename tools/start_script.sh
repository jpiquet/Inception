#!/bin/bash
INC="/home/${USER}/Inception"

if [ ! -f "${INC}/srcs/.env" ]; then
	echo "Creating .env file & secrets.."
	touch ${INC}/srcs/.env
	mkdir ${INC}/secrets

	echo "URL_NAME=jpiquet.42.fr" > ${INC}/srcs/.env

	# DATABASE ENV + SECRETS
	echo -n "Database name: "
	read DBNAME
	echo "DB_NAME=${DBNAME}" >> ${INC}/srcs/.env

	echo -n "Database user name: "
	read DBUSER
	echo "DB_USER=${DBUSER}" >> ${INC}/srcs/.env

	echo -n "Database user password: "
	read DBPASS
	echo -n ${DBPASS} > ${INC}/secrets/db_password.txt

	echo -n "Database root password: "
	read ROOTPASS
	echo -n ${ROOTPASS} > ${INC}/secrets/db_root_password.txt

	# WORDPRESS ENV + SECRETS
	echo -n "Wordpress admin username (can't contains \"admin\"): "
	read ADMIN

	# admin = ${ADMIN}
	until ${INC}/tools/search_str ${ADMIN}
	do
		echo -n "Wordpress admin username (can't contains \"admin\"): "
		read ADMIN
	done
	echo "ADMIN_NAME=${ADMIN}" >> ${INC}/srcs/.env
	echo "ADMIN_EMAIL=${ADMIN}@42.fr" >> ${INC}/srcs/.env

	echo -n "Wordpress admin password: "
	read ADMINPASS
	echo -n ${ADMINPASS} > ${INC}/secrets/admin_password.txt

	echo -n "Wordpress user username: "
	read USER
	echo "USER_NAME=${USER}" >> ${INC}/srcs/.env
	echo "USER_EMAIL=${USER}@42.fr" >> ${INC}/srcs/.env

	echo -n "Wordpress user password: "
	read USERPASS
	echo -n ${USERPASS} > ${INC}/secrets/user_password.txt
fi

if [ ! -f "${INC}/secrets/inception.crt" ]; then
	openssl req -x509 \
	-nodes \
	-days 365 \
	-newkey rsa:2048 \
	-out ${INC}/secrets/inception.crt \
	-keyout ${INC}/secrets/inception.key \
	-subj /C=FR/ST=RH/L=Lyon/O=42/OU=42/CN=jpiquet.42.fr
fi

#rm -f start_script