FROM debian:bookworm

#INSTALL WORDPRESS
RUN apt update -y \
	&& apt install wget -y \
	&& apt install tar -y \
	&& wget https://wordpress.org/latest.tar.gz \
	&& tar -xzvf latest.tar.gz \
	&& mkdir -p /var/www/html \
	&& mv wordpress/* /var/www/html

#INTALL PHP-FPM
RUN apt install php-fpm8.4 -y \
	php-mysql -y \
	php-curl -y \
	php-gd -y \
	php-mbstring -y \
	php-xml -y \
	php-zip -y

# on installe WP-CLI pour gérer WordPress en ligne de commande
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.
COPY script.sh /script.sh

RUN chmod +x /script.sh

CMD ["./script.sh"]