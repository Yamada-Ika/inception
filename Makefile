build: clean
	# mkdir -p /home/iyamada/data/mariadb
	# mkdir -p /home/iyamada/data/wordpress
	mkdir -p /Users/yamadaiori/data/mariadb
	mkdir -p /Users/yamadaiori/data/wordpress
	docker-compose -f srcs/docker-compose.yml build

ncbuild: clean
	# mkdir -p /home/iyamada/data/mariadb
	# mkdir -p /home/iyamada/data/wordpress
	mkdir -p /Users/yamadaiori/data/mariadb
	mkdir -p /Users/yamadaiori/data/wordpress
	docker-compose -f srcs/docker-compose.yml build --no-cache

up:
	docker-compose -f srcs/docker-compose.yml up

run: build up

rund: build
	docker-compose -f srcs/docker-compose.yml up -d

ps:
	docker ps -a

clean: SHELL:=/bin/bash
clean:
	-docker rm -f $$(docker ps -aq)

fclean: SHELL:=/bin/bash
fclean: clean
	-docker volume rm $(docker volume ls -qf dangling=true)
	-docker rmi -f $$(docker image ls -q)

re: fclean run
