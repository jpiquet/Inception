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

make will launch the start_script.sh in tools.
You'll have to enter every information to create .env & secrets files.

Database user is the user who will interact with the database, modifies and add data on it.
Admin user is the admin of your wordpress.
User is just a basic user with limited right on wordpress.

Each of password you enter are going to be on differents file stored in the secrets directory.
It will create ssl certificat & certificat key for the tsl and put it in the secrets/ directory.

It will create directory file for mariadb and wordpress volumes at this path: /home/*login*/data/

Do make fclean : If you want to delete everything included volumes.

Do make re : If you want to delete everything included volumes and rebuilt each container.

## Ressources

https://www.youtube.com/watch?v=dH3DdLy574M&list=PLIhvC56v63IJlnU4k60d0oFIrsbXEivQo
https://www.youtube.com/watch?v=pg19Z8LL06w
https://www.youtube.com/watch?v=DM65_JyGxCo&list=PLIhvC56v63IJlnU4k60d0oFIrsbXEivQo&index=6
https://www.youtube.com/watch?v=mspEJzb8LC4
https://www.youtube.com/watch?v=SXB6KJ4u5vg
https://www.youtube.com/watch?v=ES4BcZcsBdU
https://courses.mooc.fi/org/uh-cs/courses/devops-with-docker/chapter-2/in-depth-dive-into-images
https://www.delftstack.com/fr/howto/docker/difference-between-cmd-and-entrypoint/
https://tuto.grademe.fr/inception/
https://www.youtube.com/watch?v=y1QUtn_x12I
https://www.museeinformatique.fr/wordpress-docker-mariadb-nginx/
https://www.youtube.com/watch?v=lh4RnczaATI
https://wpshell.com/lesson/install-php-fpm/
https://make.wordpress.org/cli/handbook/how-to/how-to-install/
https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/volumes/
https://www.baeldung.com/ops/docker-compose-expose-vs-ports
https://thisvsthat.io/docker-network-vs-host-network

I've used AI for information like how to write a script the good way and for correction of my readme's.