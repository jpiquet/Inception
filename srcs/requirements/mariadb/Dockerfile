FROM debian:bookworm

RUN apt update -y && apt install mariadb-server -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY script.sh /script.sh

#RUN chmod +x /script.sh
#RUN /script.sh