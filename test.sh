#!/bin/bash

echo -n "Wordpress admin username (can't contains \"admin\") : "
read ADMIN

# admin = ${ADMIN}

until ./search_string ${ADMIN}
do
	echo -n "Wordpress admin username (can't contains \"admin\") : "
	read ADMIN
done