#!/bin/bash
# Install Script 01/2021 | Hinthub | Karim S
startPath=$(pwd);
branch="develop"
repo="ssh://git@repo2.github.com/HintHub/HintHub.git"

function check_stack_name()
{
	if [ -z "$1" ]; then
		echo "No stackName set";
		echo "ERROR: $0 <stackName> <appName> <dbUser> <dbPass> <domain>";
		exit;
	fi
}

function check_set_appName ()
{
	if [ -z "$1" ]; then
		echo "No AppName set";
		echo "ERROR: $0 <stackName> <appName> <dbUser> <dbPass> <domain>";
		exit;
	fi
}

function check_set_dbUser ()
{
        if [ -z "$1" ]; then
		echo "No dbUser set";
                echo "ERROR: $0 <stackName> <appName> <dbUser> <dbPass> <domain>";
                exit;
        fi
}

function check_set_dbPass ()
{
        if [ -z "$1" ]; then
		echo "No dbPass set";
                echo "ERROR: $0 <stackName> <appName> <dbUser> <dbPass> <domain>";
                exit;
        fi
}

function check_set_domain ()
{
        if [ -z "$1" ]; then
                echo "No domain set";
                echo "ERROR: $0 <stackName> <appName> <dbUser> <dbPass> <domain>";
                exit;
        fi
}


function clear_nginx_folder ()
{
	find "nginx/www/." ! -name '.' ! -name '..' -delete
}

function download_HintHub ()
{
	echo "[+] Downloading HintHub";
	cd "nginx/www/"
	#git clone -b "$1" "$2" .
	git init
	git remote add origin "$2"
	git fetch --prune
	git checkout "$1"
	git pull
	git reset --hard HEAD
	git pull
	cd ../../
	echo "[=] Done";
}

function configureGit ()
{
	# store git creds
	git config credential.helper 'store'
	cp copy/gitconfig .git/config
}


function copy_and_replace_docker_compose_vars ()
{
	if [ -z "$1" ]; then
		echo "cardcv 1";
		exit;
	fi

	if [ -z "$2" ]; then
		echo "cardcv 2";
		exit;
	fi

	if [ -z "$3" ]; then
		echo "cardcv 3";
		exit;
	fi
	
	fname="docker-compose.yaml"
	# replaces the vars inside of the docker-compose 
	cp "copy/docker-compose.yml" "$fname"
	
	sed -i "s/{dbUser}/$1/g" "$fname" 
	sed -i "s/{dbPass}/$2/g" "$fname"
	sed -i "s/{dbDBName}/$3/g" "$fname"
	
}

function copy_rpl_nginx () 
{
	domain="$1";
	fname="nginx/sites/${domain}.conf"
	cp "copy/nginx_standard.conf" "$fname"
	sed -i "s/{domain}/$domain/g" "$fname"
}

function copy_and_replace_local_env () 
{
	fname="nginx/www/.env.local"
	stackName="$1"
	appName="$2"
	appSecret=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 64 ; echo '');
	dbUser="$3"
	dbPass="$4"
	dbName="$5"

	cp "copy/env.local" "$fname"
	
	sed -i "s/{dbUser}/$dbUser/g" "$fname" 
        sed -i "s/{dbPass}/$dbPass/g" "$fname"
        sed -i "s/{dbName}/$dbName/g" "$fname"
	sed -i "s/{appName}/$appName/g" "$fname"
	sed -i "s/{stackName}/$stackName/g" "$fname"
	sed -i "s/{appSecret}/$appSecret/g" "$fname"
	
	cp "$fname" "nginx/www/.env"
}

function do_install ()
{
	stackName="$1"
	appName="$2"
	sudo chmod u+x run.sh
	./run.sh "$1"
	sed -i "s/{sysEnv1}/development/g" "nginx/www/.env.local"
	sed -i "s/{sysEnv2}/dev/g" "nginx/www/.env.local"

	cp "nginx/www/.env.local" "nginx/www/.env"
	
	cp "copy/installscript.sh" "nginx/www/install.sh"
	sudo chmod u+x "nginx/www/install.sh"
	sudo docker restart "${stackName}_php-fpm_1"
	sudo docker restart "${stackName}_database_1"
	sudo docker restart "${stackName}_nginx_1"

	sudo docker exec -it "${stackName}_php-fpm_1" "../install.sh"
	
	sudo docker exec -it "${stackName}_php-fpm_1" php /var/www/bin/console doctrine:database:drop --force -n
	sudo docker exec -it "${stackName}_php-fpm_1" php /var/www/bin/console doctrine:database:create -n
	sudo docker exec -it "${stackName}_php-fpm_1" php /var/www/bin/console doctrine:migrations:migrate -n
	sudo docker exec -it "${stackName}_php-fpm_1" php /var/www/bin/console doctrine:fixtures:load -n

	sed -i "s/development/production/g" "nginx/www/.env.local"
        sed -i "s/dev/prod/g" "nginx/www/.env.local"

	cp "nginx/www/.env.local" "nginx/www/.env"
	
	sudo docker exec -it "${stackName}_php-fpm_1" php /var/www/bin/console cache:clear -n
        p=$(pwd);
        cd "nginx/www";
        git stash
        cd  "$p";
}

#
#        HERE IS THE INITAL CODE
#

# check if parameters set
check_stack_name   "$1"
check_set_appName  "$2"
check_set_dbUser   "$3"
check_set_dbPass   "$4"
check_set_domain   "$5"

# set local space variables
stackName="$1"
appName="$2"
dbUser="$3"
dbPass="$4"
domain="$5"
dbName="$stackName"    # appName


echo -e "AppName: $appName\ndbUser: $dbUser\ndbPass: $dbPass\nStackName: $stackName\nDBName: $dbName\n\nDomain: $domain";

clear_nginx_folder

download_HintHub "$branch" "$repo"
configureGit

copy_rpl_nginx "$domain"
copy_and_replace_docker_compose_vars "$dbUser" "$dbPass" "$dbName"
copy_and_replace_local_env "$stackName" "$appName" "$dbUser" "$dbPass" "$dbName"

do_install "$stackName" "$appName"

cd "$startPath";
cp "nginx/www/.env" "nginx/www/.env.local"

sudo docker network connect "${stackName}_default" "nginx"


