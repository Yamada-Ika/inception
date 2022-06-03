#!/bin/bash

set -u

function assert() {
    arg_1=${1}
    arg_2=${2}

    if [ ${arg_1} = ${arg_2} ]; then
        echo "OK"
    else
        echo "FAIL : expected ${arg_2}, but got ${arg_1}"
        exit 1
    fi
}

function print() {
    echo -e "\033[36m[info]\033[0m $1"
}

function step() {
    print "Press Enter to go to next"
    read
}

# There musn't be 'network: host' in compose yaml
assert "$(cat $(find . -name "docker-compose.yml") | grep 'network: host')" ""
# There musn't be 'links:' in compose yaml
assert "$(cat $(find . -name "docker-compose.yml") | grep 'links:')" ""
# There must be 'network(s)' in compose yaml
assert "$(cat $(find . -name "docker-compose.yml") | grep 'networks:' &> /dev/null; echo $?)" "0"
# There musn't be '--link' in compose yaml and Makefile
assert "$(cat $(find . -name "Makefile" -o -name "*.sh" | grep -v 'check.sh') | grep '\--link')" ""
# There musn't be any command like 'tail -f', 'bash' and 'sh' in Dockerfile
assert "$(cat $(find . -name "Dockerfile") | grep 'ENTRYPOINT' | grep '\"tail -f\"')" ""
assert "$(cat $(find . -name "Dockerfile") | grep 'ENTRYPOINT' | grep '\"bash\"')" ""
assert "$(cat $(find . -name "Dockerfile") | grep 'ENTRYPOINT' | grep '\"sh\"')" ""
# Scripts musn't run program in background
assert "$(cat $(find . -name "*.sh" | grep -v 'check.sh') | grep 'nginx & bash')" ""
# Scripts musn't run prohibited commands
assert "$(cat $(find . -name "*.sh" | grep -v 'check.sh') | grep 'sleep')" ""
assert "$(cat $(find . -name "*.sh" | grep -v 'check.sh') | grep 'tail -f /dev/null')" ""
assert "$(cat $(find . -name "*.sh" | grep -v 'check.sh') | grep 'tail -f /dev/random')" ""

step

# check directory structure
print "Check directory structure"
ls -lR | grep -v 'check.sh'

step

# NGINX can be accessed by port 443 (https) only
print "Access with port 443, but may show self signed certificate warning"
curl https://iyamada.42.fr
print "Accessing with port 80 should be failed"
curl http://iyamada.42.fr

step

# SSL/TLS certificate is used
print "Check SSL/TLS certificate is used"
echo "" | openssl s_client -connect iyamada.42.fr:443

step

# Dockerfile must be in each service directory
print "Dockerfile must be in each service directory, and not empty"
find . -name "Dockerfile" -type f -not -empty

step

# Build docker images with own Dockerfile
print "Build docker images with own Dockerfile"
cat $(find . -name "*.yml") | grep 'build'

step

# Use alpine or debian buster as base image
print "Use alpine or debian buster as base image"
cat $(find . -name "Dockerfile" -type f -not -empty) | grep 'FROM'

step

# Check docker image name
print "Check docker image name"
docker images

step

# Services must build with docker-compose
print "Services must build with docker-compose"
cat Makefile

step

# Docker-network is used in docker-compose
print "Docker-network is used in docker-compose"
cat $(find . -name "*.yml")
docker network ls

step

# Check container status
print "Check container status"
docker-compose -f srcs/docker-compose.yml ps

step

# Check certificate version
print "Check certificate version"
echo "" | openssl s_client -connect iyamada.42.fr:443 -tls1_2
echo "" | openssl s_client -connect iyamada.42.fr:443 -tls1_3

step

# Check nginx is not used in wordpress container
print "Check certificate version"
cat srcs/requirements/wordpress/Dockerfile

step

# Check nginx is not used in wordpress container
print "Check certificate version"
docker volume inspect $(docker volume ls -q)

step

# Check nginx is not used in mariadb container
print "Check certificate version"
cat srcs/requirements/mariadb/Dockerfile

step

# Login database as root without password
print "Login database as root without password"
docker exec -it mariadb mariadb -h localhost -u root

step

# Login database as user without password
print "Login database as iyamada without password"
print "If settings are correctly, user can operation wp_db"
docker exec -it mariadb mariadb -h localhost -u user

print "Finally, reboot your machine and configure services all correct !"
