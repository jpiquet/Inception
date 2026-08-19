*This project has been created as a part og the 42 curriculum by jpiquet*

# Inception

## Description

This project consists of set up a small infrastructure composed of different services:
- Nginx : a web server
- Wordpress
- Mariadb
By using **docker container** & **docker compose** for a network creation.

### Virtual Machine vs Docker

A virtual machine can virtualize a computer, it has it's own OS. Therefore this it can be deploye on every computer with different OS, unlike docker container.
A docker share is OS with the host. This sharing with the host machine allows it to be lighter and run really fast.
Docker allows also to deploye an application and every dependencies in one container and run hundreds of application without surcharging the systeme.
It helps to guarantee that every codes of the application work on every computer.

### Secrets vs Environment Variables

Secrets are files that will be copied directly to the container in /etc/secrets and used only when the container is run.
Environement variable are going to be add to the variable environement of the container and used when the image is mount. That's why, for security reason we aren't going to add informations like password or certification key to the env cause its could be visible in the image that we will potentialy push to docker hub.

### Docker Network vs Host Network

Docker Network and Host Network are two different networking modes in Docker. Docker Network allows containers to communicate with each other and with external networks using a virtual network created by Docker. 
This provides isolation and security for containers. On the other hand, Host Network allows containers to use the host machine's network stack directly, bypassing Docker's network isolation. 
This can provide better performance but may also pose security risks as containers have direct access to the host network. Overall, Docker Network is more commonly used for its security and isolation benefits, while Host Network may be preferred for performance-critical applications.

### Docker Volumes vs Bind Mounts

