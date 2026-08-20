COMPOSE = docker compose -f srcs/docker-compose.yml
USER = jpiquet

all: db-volume wp-volume
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

clean:
	$(COMPOSE) down
	docker image prune -af

fclean:
	$(COMPOSE) down
	docker system prune -af

re: fclean all