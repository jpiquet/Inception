FROM debian:bookworm

# Install wordpress
RUN apt update -y \
	&& apt install wget -y \
	&& apt install tar -y \
	&& wget https://wordpress.org/latest.tar.gz \
	&& tar -xzvf latest.tar.gz \
	&& mkdir -p /var/www/html

# Install php-fpm
RUN apt install -y \
	php8.2-fpm \
	php8.2-mysql

# Install WP-CLI for configurate wordpress with command line.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]