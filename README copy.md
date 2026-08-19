*This project has been created as a part og the 42 curriculum by jpiquet*

# Inception

## Description

This project consists of set up a small infrastructure composed of different services:
- Nginx : a web server
- Wordpress
- Mariadb
By using **docker container** & **docker compose** for a network creation.

### Virtual Machine vs Docker

Un machine virtuel est une machine qui va permettre de virtualiser un ordinateur complet.
La machine virtuel a son propre systeme d'exploitation ce qui la rend plus lourde.
Une machine virtual va pouvoir etre cependant lancé sur n'importe quel machine/systeme d'exploitation contrairement au docker.

Les dockers partages le meme systeme d'exploitation que l'hote.
Le partage de du systeme d'exploitation des containers les rends tres leger et leur permet de démarrer très rapidement.
Docker permet aussi de deployer une application et toutes ses dependance en un seul conteneur.
lancer des centaines d'application sur le meme hote sans surcharger le systeme
Garantir donc que le codes fonctionnes de la meme maniere sur chaque machine.

A virtual machine can virtualize a computer, it has it's own OS. Therefore this it can be deploye on every computer with different OS, unlike docker container.
A docker share is OS with the host. This sharing with the host machine allows it to be lighter and run really fast.
Docker allows also to deploye an application and every dependencies in one container and run hundreds of application without surcharging the systeme.
It helps to guarantee that every codes of the application work on every computer.

### Secrets vs Environment Variables

Secrets are files that will be copied directly to the container in /etc/secrets and used only when the container is run.
Environement variable are going to be add to the variable environement of the container and used when the image is mount. That's why, for security reason we aren't going to add informations like password or certification key to the env cause its could be visible in the image that we will potentialy push to docker hub.

### Docker Network vs Host Network



### Docker Volumes vs Bind Mounts

