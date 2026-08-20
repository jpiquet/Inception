COMPOSE = docker compose -f srcs/docker-compose.yml
USER = jpiquet

all: db-volume wp-volume
	tools/start_script.sh
	$(COMPOSE) up -d --build

db-volume: 
	mkdir -p /home/$(USER)/data/mariadb

wp-volume:
	mkdir -p /home/$(USER)/data/wordpress

build: db-volume wp-volume
	$(COMPOSE) build

up: db-volume wp-volume
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs

clean: down
	docker image prune -af

fclean: clean
	docker system prune -af
	sudo rm -rf /home/$(USER)/data/mariadb /home/$(USER)/data/wordpress

re: fclean all