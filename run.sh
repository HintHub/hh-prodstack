#!/bin/bash
# Written by (vorlage) Karim S 09/2021 | SAAD-IT
# reused by Karim S & HintHub Gruppe 01/2022

if [ -z "$1" ]; then
	echo "Error $0 <appName>";
	exit;
fi

serviceName="$1"
sudo docker-compose -p "$serviceName" up -d --build


