build: clean
	# mkdir -p /home/iyamada/data/mariadb
	# mkdir -p /home/iyamada/data/wordpress
	mkdir -p /tmp/iyamada/data/mariadb
	mkdir -p /tmp/iyamada/data/wordpress
	docker-compose -f srcs/docker-compose.yml build

ncbuild: clean
	# mkdir -p /home/iyamada/data/mariadb
	# mkdir -p /home/iyamada/data/wordpress
	mkdir -p /tmp/iyamada/data/mariadb
	mkdir -p /tmp/iyamada/data/wordpress
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
	-docker rmi -f $$(docker image ls -q)

re: fclean run
