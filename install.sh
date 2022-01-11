#!/bin/bash
# Install Script 01/2021 | Hinthub | Karim S

function check_set_appName ()
{
	if [ -z "$1" ]; then
		echo "No AppName set";
		echo "ERROR: $0 <appName> <dbUser> <dbPass> ";
		exit;
	fi
}

function check_set_dbUser ()
{
        if [ -z "$1" ]; then
		echo "No dbUser set";
                echo "ERROR: $0 <appName> <dbUser> <dbPass> ";
                exit;
        fi
}

function check_set_dbPass ()
{
        if [ -z "$1" ]; then
		echo "No dbPass set";
                echo "ERROR: $0 <appName> <dbUser> <dbPass> ";
                exit;
        fi
}



function download_HintHub ()
{
	echo "[+] Downloading HintHub";
	cd "nginx/www/"
	git clone  "https://git-se.iubh.de/ali-kemal.yalama/Hinthub.git" .
	cd ../../
	echo "[=] Done";
}

function configureGit ()
{
	# store git creds
	git config credential.helper 'store'
}


#
#        HERE IS THE INITAL CODE
#

# check if parameters set
check_set_appName  "$1"
check_set_dbUser   "$2"
check_set_dbPass   "$3"

# set local space variables
appName="$1"
dbUser="$2"
dbPass="$3"
stackName="$appName" # appName
dbName="$appName"    # appName


echo -e "AppName: $appName\ndbUser: $dbUser\ndbPass: $dbPass\nStackName: $stackName\nDBName: $dbName";
#configureGit
#download_HintHub
# step 1 copy docker-compose.yaml
# step 2 replace values
# step 3 copy env.local to nginx/www/.env.local
# step 4 replace values


# run install.sh

# in copy func cp ../../copy/env.local .env.local

