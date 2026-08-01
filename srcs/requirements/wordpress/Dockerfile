FROM debian:bookworm

#INSTALL WORDPRESS
RUN apt update -y 
RUN apt install wget -y
RUN apt install tar -y
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN apt install php-fpm -y

#INTALL PHP-FPM
RUN apt install php8.1-fpm -y
RUN systemctl enable php8.1-fpm
RUN systemctl start php8.1-fpm
RUN systemctl status php8.1-fpm

