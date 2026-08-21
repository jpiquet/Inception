# User Documentation

## Overview

This project provides a small web infrastructure composed of three Docker services:

- **NGINX**: the web server and the only public entry point. It receives HTTPS requests on port `443` and forwards PHP requests to PHP-FPM.
- **WordPress + PHP-FPM**: runs the WordPress application and executes its PHP code.
- **MariaDB**: stores the WordPress database.

The services run in separate containers and communicate through a dedicated Docker network.

## Starting the project

The project is started from the root of the repository with:

```bash
make
```

The Makefile starts the project and launches the configuration script located in the project tools.

During the initial setup, the script asks for the information required to configure:

- the MariaDB database;
- the database user;
- the database password;
- the WordPress administrator;
- the WordPress regular user;
- the corresponding passwords.

The project also generates the TLS certificate and private key required by NGINX.

## Stopping and cleaning the project

The project provides Makefile targets for cleanup.

To remove the project's containers and persistent resources according to the Makefile configuration:

```bash
make fclean
```

To clean the project and rebuild it:

```bash
make re
```

**Warning:** cleanup commands can remove persistent project data. Do not use them if you need to preserve the WordPress database or website files.

If only a temporary stop is required:

```bash
make stop
```

The containers can then be started again with:

```bash
make start
```

## Accessing the website

The website is available through HTTPS:

```text
https://jpiquet.42.fr
```

The domain must point to the local IP address of the machine running the project.

## Accessing WordPress administration

The WordPress administration panel is available at:

```text
https://jpiquet.42.fr/wp-admin/
```

## Credentials and secrets

Passwords and other sensitive credentials are stored locally in the `secrets/` directory and must not be committed to Git.
The project uses secrets for sensitive values such as database passwords and other credentials required by the services.
The `.env` file is used for environment variables and non-secret configuration.
Do not publish the contents of the `secrets/` directory or expose passwords in Dockerfiles, Compose files, Git history, or public repositories.

## Persistent data

The project uses two persistent Docker named volumes:
- one for the MariaDB database;
- one for the WordPress website files.

The data is stored on the host under:
```text
/home/<login>/data/
```

## Checking the services

To check which containers are running:

```bash
docker ps
```

The expected services are:

```text
nginx
wordpress
mariadb
```

To inspect the logs of a service:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```