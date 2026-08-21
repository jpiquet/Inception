# Developer Documentation

## Prerequisites

The development environment requires:

- Docker;
- Docker Compose;
- `make`;
- Git.

The current project uses Debian as the base distribution.

## Configuration

### `.env` & secrets

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

Before committing the project, verify:

```bash
git status
```

and make sure no secret files or confidential credentials are staged.

## Building and starting the project

Builds/starts the project and launches the initialization procedure.

```bash
make
```

Performs the cleanup procedure and rebuilds the project.

```bash
make re
```

The Makefile is responsible for launching the project's Docker Compose configuration and building the required images.

The Compose file is located at:

```text
srcs/docker-compose.yml
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

Display logs:

```bash
make logs
```

Display the status of the Compose services:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Open a shell in a running container:

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

Stop the Compose project without removing the containers:

```bash
make stop
```

Start previously stopped containers:

```bash
make start
```

Stop and remove the Compose containers and network:

```bash
make down
```

Before changing these targets, verify exactly which Docker resources they remove. In particular, deleting named volumes deletes persistent project data.

## Images

The project builds one image for each mandatory service:

```text
nginx
wordpress
mariadb
```

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

Inspect available networks:

```bash
docker network ls
```

Inspect the project network:

```bash
docker network inspect <network_name>
```

## Persistent volumes

The project requires two Docker named volumes: MariaDB database files and WordPress website files.
The subject requires both named volumes to store their data under:

```text
/home/<login>/data/
```

List volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

The persistence mechanism is important because containers are replaceable. The database and website files must survive container recreation.

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
