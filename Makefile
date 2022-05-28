build:
	# mkdir -p /home/iyamada/data/mariadb
	# mkdir -p /home/iyamada/data/wordpress
	mkdir -p /tmp/iyamada/data/mariadb
	mkdir -p /tmp/iyamada/data/wordpress
	docker-compose -f srcs/docker-compose.yml build

up:
	docker-compose -f srcs/docker-compose.yml up

run: build up

clean: SHELL:=/bin/bash
clean:
	docker rm -f $$(docker ps -aq)
