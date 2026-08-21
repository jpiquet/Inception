#!/bin/bash

set -eu

# Create the directory for the MariaDB socket
mkdir -p /run/mysqld

# Set the directory owner to the mysql user so that MariaDB can access it
chown mysql:mysql /run/mysqld

# Initialize the directory that will store the database files (on the mounted volume)
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start the MariaDB server in the background and store its PID
mariadbd --user=mysql &
PID=$!

# Wait until the MariaDB server is ready to accept connections
until mariadb -u root --password=$(cat /run/secrets/db_root_password) -e "SELECT 1;" >/dev/null 2>&1; do
	sleep 1
done

# Create the WordPress database if it does not already exist
# Create the 'db_user' user with the 'db_password' password if it does not already exist
# Grant all privileges on the 'wordpress' database to the user ''
# Apply the privilege changes

mariadb -u root --password=$(cat /run/secrets/db_root_password) <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';
CREATE USER IF NOT EXISTS 'healthcheck'@'localhost';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Stop the MariaDB server
kill "$PID"

# Wait for the MariaDB server to terminate before continuing
wait "$PID"

echo "Mariadb is ready !"

# Restart the MariaDB server in the foreground so that the container keeps running
exec mariadbd --user=mysql