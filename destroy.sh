#!/bin/bash
# Written by (vorlage) Karim S 09/2021 | SAAD-IT
# reused by Karim S & HintHub Gruppe 01/2022

# check if docker-compose.yml
if [ ! -f "docker-compose.yml" ]; then
        echo "abort, no docker-compose.yaml";
        exit;
fi

# check first Param (appName)
if [ -z "$1" ]; then
	echo "Error $0 <appName>";
	exit;
fi

serviceName="$1"

sudo docker network disconnect "$1_default" "nginx"

sudo docker-compose -p "$serviceName" down

sudo rm docker-compose.yml
sudo rm docker-compose.yaml
sudo rm -rf nginx/www/
mkdir nginx/www/
