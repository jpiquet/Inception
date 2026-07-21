FROM debian:bookworm

RUN apt update -y 
RUN apt install wget -y
RUN apt install tar -y
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN apt install php-fpm -y
