COMPOSE = docker compose -f srcs/docker-compose.yml
USER = jpiquet

db-volume: 
	mkdir -p /home/$(USER)/data/mariadb;

wp-volume:
	mkdir -p /home/$(USER)/data/wordpress;

all: db-volume wp-volume
	$(COMPOSE) up -d --build

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

fclean:
	$(COMPOSE) down --volumes
	docker system prune -af

re: fclean all