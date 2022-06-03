NAME=inception
VOLUME_PATH=/Users/yamadaiori/data

$(NAME):all

all: up

clean: down

fclean: SHELL:=/bin/bash
fclean: clean
	sudo rm -rf $(VOLUME_PATH)/mariadb/* $(VOLUME_PATH)/wordpress/*
	-docker volume rm $(docker volume ls -qf dangling=true)
	-docker rmi -f $$(docker image ls -q)

re: fclean all

.PHONY: $(NAME) all clean fclean re

up:
	docker-compose -f srcs/docker-compose.yml up

down:
	docker-compose -f srcs/docker-compose.yml down

build:
	docker-compose -f srcs/docker-compose.yml build

ncbuild:
	docker-compose -f srcs/docker-compose.yml build --no-cache

run: down ncbuild up

check: SHELL:=/bin/bash
check:
	./check.sh

review: clean-docker init-review

init-review:
	sudo echo '127.0.0.1' iyamada.42.fr >> /etc/hosts
	sudo mkdir -p $(VOLUME_PATH)/mariadb
	sudo mkdir -p $(VOLUME_PATH)/wordpress

clean-docker:
	-docker stop $$(docker ps -qa)
	-docker rm $$(docker ps -aq)
	-docker rmi -f $$(docker images -qa)
	-docker volume rm $$(docker volume ls -q)
	-docker network rm $$(docker network ls -q) 2> /dev/null

help:
	@echo "Usage: make [target]"

h: help
