# Developer Documentation

## Project architecture

The project is built with Docker Compose and contains three mandatory services:

```text
                        HTTPS :443
                            |
                            v
                    +---------------+
                    |     NGINX     |
                    +-------+-------+
                            |
                       FastCGI :9000
                            |
                            v
                    +---------------+
                    | WordPress +   |
                    |   PHP-FPM     |
                    +-------+-------+
                            |
                       MariaDB
                            |
                            v
                    +---------------+
                    |    MariaDB    |
                    +---------------+
```

Each service runs in its own dedicated container.

The containers communicate through a dedicated Docker network. NGINX is the only public entry point of the mandatory infrastructure.

The project uses Docker named volumes for persistent data:

- a volume for the MariaDB database;
- a volume for the WordPress website files.

The volume data is stored under `/home/<login>/data/` on the host, as required by the subject.

## Prerequisites

The project must be run inside a virtual machine.

The development environment requires:

- Docker;
- Docker Compose;
- `make`;
- Git.

The project uses custom Dockerfiles for the mandatory services. The subject requires the images to be built from either Alpine or Debian and prohibits pulling ready-made service images.

The current project uses Debian as the base distribution.

## Repository structure

The project follows the structure required by the subject:

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/
        └── tools/
```

The exact files inside each directory depend on the implementation.

## Configuration

### `.env`

The `.env` file is located in:

```text
srcs/.env
```

It is used for environment variables required by the Compose configuration.

Examples of non-secret configuration include:

```text
DOMAIN_NAME=jpiquet.42.fr
MYSQL_DATABASE=...
MYSQL_USER=...
```

Passwords and other confidential information must not be written directly in the Dockerfiles.

The `.env` file and secret files containing confidential information must be ignored by Git.

### Docker secrets

Sensitive values are stored in the `secrets/` directory.

The project uses secret files for passwords instead of embedding them directly in Dockerfiles.

The subject explicitly requires credentials, passwords and API keys not to be publicly stored in the Git repository.

Before committing the project, verify:

```bash
git status
```

and make sure no secret files or confidential credentials are staged.

## Domain configuration

The mandatory domain follows the format:

```text
<login>.42.fr
```

For this project:

```text
jpiquet.42.fr
```

The domain must resolve to the local IP address of the machine running the infrastructure.

For local development, the host's `/etc/hosts` file can be configured accordingly.

## Building and starting the project

The recommended entry point is the Makefile:

```bash
make
```

The Makefile is responsible for launching the project's Docker Compose configuration and building the required images.

The Compose file is located at:

```text
srcs/docker-compose.yml
```

To build the services manually:

```bash
docker compose -f srcs/docker-compose.yml build
```

To start the infrastructure:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

To rebuild the images:

```bash
docker compose -f srcs/docker-compose.yml build --no-cache
```

## Container management

List running containers:

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

Display the status of the Compose services:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Display logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Display the logs of one service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

Follow logs:

```bash
docker compose -f srcs/docker-compose.yml logs -f wordpress
```

Open a shell in a running container:

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

Stop the Compose project without removing the containers:

```bash
docker compose -f srcs/docker-compose.yml stop
```

Start previously stopped containers:

```bash
docker compose -f srcs/docker-compose.yml start
```

Stop and remove the Compose containers and network:

```bash
docker compose -f srcs/docker-compose.yml down
```

## Images

The project builds one image for each mandatory service:

```text
nginx
wordpress
mariadb
```

The subject requires each image to have the same name as its corresponding service.

The images are built from project-specific Dockerfiles rather than pulled from DockerHub.

To list images:

```bash
docker image ls
```

To remove an image:

```bash
docker image rm <image>
```

Be careful when removing images that are still required by containers.

## Docker network

The services communicate through the Docker network declared in `docker-compose.yml`.

This network allows containers to reach each other by their Docker service names.

For example, WordPress can use the MariaDB service name as the database host rather than relying on a hard-coded container IP address.

The project must not use:

- `network: host`;
- Docker `--link`;
- the legacy `links:` Compose option.

Inspect available networks:

```bash
docker network ls
```

Inspect the project network:

```bash
docker network inspect <network_name>
```

## Persistent volumes

The project requires two Docker named volumes.

### MariaDB volume

This volume contains the MariaDB database files.

### WordPress volume

This volume contains the WordPress website files.

The subject requires both named volumes to store their data under:

```text
/home/<login>/data/
```

Bind mounts are not used for these two persistent storages.

List volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

The persistence mechanism is important because containers are replaceable. The database and website files must survive container recreation.

## NGINX and TLS

NGINX is the only public entry point.

It listens on:

```text
443
```

and uses TLS 1.2 and/or TLS 1.3.

NGINX receives HTTP requests, serves static files when appropriate, and forwards PHP requests to the WordPress container through PHP-FPM using FastCGI.

PHP is therefore not executed by NGINX itself.

The TLS certificate and private key are generated during the project setup and stored as secrets.

## WordPress and PHP-FPM

The WordPress container contains:

- WordPress;
- PHP;
- PHP-FPM;
- the PHP extensions required by WordPress.

PHP-FPM listens for FastCGI requests from NGINX.

NGINX communicates with the WordPress container through the Docker network rather than exposing PHP-FPM directly to the host.

## MariaDB

MariaDB runs in its own dedicated container.

It stores the WordPress database in the MariaDB named volume.

The database credentials are supplied through the project's configuration and secret mechanism.

MariaDB must not contain NGINX or WordPress application files; its role is limited to database storage and service.

## Makefile targets

The project currently provides the following documented targets:

```bash
make
```

Builds/starts the project and launches the initialization procedure.

```bash
make fclean
```

Performs the project's full cleanup procedure, including persistent resources according to the Makefile configuration.

```bash
make re
```

Performs the cleanup procedure and rebuilds the project.

Before changing these targets, verify exactly which Docker resources they remove. In particular, deleting named volumes deletes persistent project data.

## Development workflow

A typical development cycle is:

1. Modify the relevant Dockerfile, configuration file or initialization script.
2. Rebuild the affected image.
3. Restart the relevant service.
4. Check the container status.
5. Check the service logs.
6. Test the website through HTTPS.
7. Verify that persistent data is still available.

For example:

```bash
docker compose -f srcs/docker-compose.yml build wordpress
docker compose -f srcs/docker-compose.yml up -d wordpress
docker compose -f srcs/docker-compose.yml logs -f wordpress
```

## Troubleshooting

### Check whether the containers are running

```bash
docker ps -a
```

### Check the Compose status

```bash
docker compose -f srcs/docker-compose.yml ps
```

### Check NGINX

```bash
docker logs nginx
```

Verify that port `443` is listening and that the TLS configuration is valid.

### Check PHP-FPM / WordPress

```bash
docker logs wordpress
```

If NGINX returns a `502 Bad Gateway`, verify that PHP-FPM is running and that NGINX can reach the WordPress container on the configured FastCGI port.

### Check MariaDB

```bash
docker logs mariadb
```

If WordPress cannot connect to the database, verify:

- MariaDB is running;
- the database credentials are correct;
- the database exists;
- WordPress uses the MariaDB service name as its database host;
- both containers are connected to the same Docker network.

## Security requirements

The following rules from the project subject must be preserved:

- No passwords in Dockerfiles.
- No public credentials in the Git repository.
- Use environment variables where required.
- Use a `.env` file for environment configuration.
- Use Docker secrets for confidential information.
- NGINX is the only public entry point of the mandatory infrastructure.
- Only port `443` is exposed for the mandatory part.
- Only TLS 1.2 and TLS 1.3 are allowed.
- Do not use host networking.
- Do not use `--link` or `links:`.
- Do not use infinite-loop commands such as `tail -f`, `sleep infinity` or `while true` to keep containers alive.
- Each service must run in its own dedicated container.

## Persistence and cleanup

Containers are intended to be replaceable, while persistent data must remain available through Docker named volumes.

Before running:

```bash
make fclean
```

or any command that removes volumes, verify that the data does not need to be preserved.

To inspect the host-side persistent directories:

```bash
ls -la /home/<login>/data/
```

The directory should contain the persistent data associated with the project's two named volumes.
