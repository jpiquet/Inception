*This project has been created as part of the 42 curriculum by jpiquet.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. Its goal is to build a small web infrastructure using Docker Compose and several independent services.

The infrastructure is composed of three containers:

- **NGINX**: the only public entry point. It handles HTTPS requests using TLS and forwards PHP requests to PHP-FPM.
- **WordPress + PHP-FPM**: runs the WordPress application and executes its PHP code through PHP-FPM.
- **MariaDB**: stores the data required by WordPress.

Each service runs in its own dedicated Docker container. The containers communicate through a dedicated Docker network.

### Virtual Machines vs Docker

A **virtual machine (VM)** virtualizes an entire computer, including its operating system. Each VM therefore contains its own OS and requires more resources.
A **Docker container** virtualizes the application environment while sharing the host's kernel. Containers are generally lighter and start faster than virtual machines.
For this project, the VM is the environment required by the 42 subject, while Docker is used inside that VM to isolate and run the different services.

### Secrets vs Environment Variables

**Environment variables** are values made available to a process through its environment. They are useful for configuration such as database names, usernames, and domain names.
**Docker secrets** are intended for sensitive information such as passwords and credentials. A secret is made available to a container as a file, rather than being stored directly in the Dockerfile.
For this project, passwords and other confidential credentials should not be written in Dockerfiles or committed to the Git repository. Non-sensitive configuration can be stored in `.env`.

### Docker Network vs Host Network

A **Docker network** creates an isolated network through which containers can communicate using their service or container names. It provides network isolation between the containers and the host.
With **host networking**, a container uses the host's network stack directly and does not get the same network isolation provided by a normal Docker network.
This project uses a dedicated Docker network because the services need to communicate with each other while keeping the infrastructure isolated from the host network.

### Docker Volumes vs Bind Mounts

Both mechanisms allow data to persist outside the writable layer of a container.
A **bind mount** directly maps a specific path from the host filesystem into a container. The host path is explicitly controlled by the user.
A **Docker named volume** is managed by Docker and has its own name. Docker handles the volume's lifecycle and mounting.
This project requires two **named volumes**:
- one for the MariaDB database;
- one for the WordPress website files.

## Instructions

### Installation and configuration

The project is initialized using the Makefile.

```bash
make
```

The startup script creates the required configuration and secret files and asks for the information needed to configure the infrastructure.

The configuration includes:

- the database name;
- the database user;
- the database password;
- the WordPress administrator;
- the WordPress regular user;
- the corresponding passwords.

Sensitive passwords are stored in the `secrets/` directory rather than directly in Dockerfiles.

The project also generates the TLS certificate and private key required by NGINX.

The persistent data directories are located under:

```text
/home/<login>/data/
```

with separate storage for MariaDB and WordPress.

### Starting the project

Run:

```bash
make
```

This builds the Docker images and starts the infrastructure using Docker Compose.

Once the services are running, the website is available through:

```text
https://jpiquet.42.fr
```

Only NGINX is exposed to the host on port `443`.

### Stopping the project

The exact Docker Compose commands can be used to stop or remove the containers. The Makefile also provides cleanup targets.

To remove the containers, images, networks and persistent volumes according to the project's cleanup configuration:

```bash
make fclean
```

To perform a full cleanup and rebuild the project:

```bash
make re
```

> **Warning:** `make fclean` removes persistent project data. Make sure you understand which volumes and data are being deleted before using it.

### Useful Docker commands

Check the running containers:

```bash
docker ps
```

Display the logs of a service:

```bash
docker logs <container>
```

Open a shell inside a running container:

```bash
docker exec -it <container> bash
```

List Docker volumes:

```bash
docker volume ls
```

Inspect the Docker network:

```bash
docker network ls
```

## Resources

### Docker

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- Docker volumes: https://docs.docker.com/engine/storage/volumes/
- Docker networking: https://docs.docker.com/engine/network/
- Docker `CMD` vs `ENTRYPOINT`: https://www.delftstack.com/fr/howto/docker/difference-between-cmd-and-entrypoint/

### NGINX, PHP-FPM and WordPress

- PHP-FPM introduction: https://wpshell.com/lesson/install-php-fpm/
- WP-CLI installation documentation: https://make.wordpress.org/cli/handbook/how-to/how-to-install/
- WordPress Docker / MariaDB / NGINX overview: https://www.museeinformatique.fr/wordpress-docker-mariadb-nginx/

### Additional tutorials and explanations

- Docker tutorial: https://www.youtube.com/watch?v=dH3DdLy574M
- Docker Compose tutorial: https://www.youtube.com/watch?v=pg19Z8LL06w
- Docker networking tutorial: https://www.youtube.com/watch?v=DM65_JyGxCo
- Docker volumes: https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/volumes/
- Docker `EXPOSE` vs published ports: https://www.baeldung.com/ops/docker-compose-expose-vs-ports
- Docker network vs host network: https://thisvsthat.io/docker-network-vs-host-network
- Inception tutorial: https://tuto.grademe.fr/inception/

### AI usage

AI was used for:

- correcting and improving the English and structure of this README;
- discussing approaches for writing and organizing shell scripts and Makefile rules.
