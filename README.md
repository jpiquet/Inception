*This project has been created as a part og the 42 curriculum by jpiquet*

# Inception

## Description

This project consists of set up a small infrastructure composed of different services:
- Nginx: a web server who get request from the navigateur, if it receive php it will send it to php-fpm thanks to fastgi.
- Wordpress: Is the application who contain the php code that will be executed by php-fpm.
- Mariadb: the data base where everything that wordpress needs to work
Each service will have it's own **Docker container** and they're will be linked with **Docker compose**.

### Virtual Machine vs Docker

A virtual machine can virtualize a computer, it has it's own OS. Therefore this it can be deploye on every computer with different OS, unlike docker container.
A docker share it's OS with the host. This sharing with the host machine allows it to be lighter and run really fast.
Docker allows also to deploye an application and every dependencies in one container and run hundreds of application without surcharging the systeme.
It helps to guarantee that every codes of the application work on every computer.

### Secrets vs Environment Variables

Secrets are files that will be copied directly to the container in /etc/secrets and used only when the container is run.
Environement variable are going to be add to the variable environement of the container and used when the image is mount.
That's why, for security reason we aren't going to add informations like password or certification key to the env cause its could be visible in the image that we will potentialy push to docker hub.

### Docker Network vs Host Network

Docker Network and Host Network are two different networking modes in Docker. Docker Network allows containers to communicate with each other and with external networks using a virtual network created by Docker. 
This provides isolation and security for containers. On the other hand, Host Network allows containers to use the host machine's network stack directly, bypassing Docker's network isolation. 
This can provide better performance but may also pose security risks as containers have direct access to the host network. 
Overall, Docker Network is more commonly used for its security and isolation benefits, while Host Network may be preferred for performance-critical applications.

### Docker Volumes vs Bind Mounts

A volume is used to store data that your application created since when a container is stopped every thing that is store in it will be deleted. It's a file that is share with the container and the host machine.
There is differents type of volume. Docker volume and bind mount. With bind mounts volume you can define a specific path where you'll store the volume on your computer. 
For the docker volume (named volume), you just name your volume and the storing is managed by Docker.

## Instruction

My network need to be launch with make.
It will create directory file for mariadb and wordpress volumes at this path: /home/*login*/data/.
It will create ssl certificat & certificat key for the tsl and put it in the secrets/ directory.
All secrets has to be filled with the good informations depend on the commentary in it.

Some commands that are useful to monitor image & container that are launch.

docker ps : show all container that are run. Add -a to see all even ones that are stopped.
docker image ls: show informations about images built.
docker logs <id_container> : Show logs about a specific container.
docker inspect <id_container>

