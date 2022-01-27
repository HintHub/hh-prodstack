# Hinthub Stack - Prod and Dev

This docker stack allows you to run the production version of Hinthub as well the pre-prod (dev) version.

# Installation

check if docker-compose is installed.

Unpack the .tar.gz by using `tar xvzf tarname.tar.gz` or use git clone (preffered is git! Scripts using it!)

cd into the dir

Run `sudo chmod u+x install_<env>.sh` to make the install_<env>_.sh executable

**Copy Paste commands:**
`sudo ./install_prod.sh "<stackName>" "<appName>" "<dbUser>" "<dbPass>" "<domain>" `

`sudo ./install_dev.sh "<stackName>" "<appName>" "<dbUser>" "<dbPass>" "<domain>"`

In the usual circumstances the script does everything for you.

In addition you can add the IP of the nginx_1 container (of the stack) to `/etc/hosts`, use the docker inspect command for that.

## Using a nginx reverse proxy in front

If you want to use a nginx in front of the nginx inside the stack, you should proxy_pass the traffic to <stackName>_nginx_1. 

Don't forget to generate a Lets Encrypt certificate by using certbot. Configure the main nginx to use TLS. 

# Updating

Our Technology provides you with a script `update.sh` in the directory of the stack.

It allows you to dynamically update the system. 

**Usage:**

`sudo ./update.sh <stackName> [prodFlag]`

You can also jump into the container and execute the following commands.

Either use `php bin/console doctrine:schema:update --force -n`

or `php bin/console doctrine:migrations:migrate -n`

The issue is that old data structures may be damaged, so backup the data before upgrading.

Before doing a  `git pull`, which should download the remote changes to local, you need to use git fetch, if our / your repository had changes in the branches.

Additionally you could do a `git reset --hard HEAD` (which destroys everything in the local repository and resets it to the HEAD of the branch)**

# Removal

Use `sudo ./destroy.sh <stackName>` then it removes all the files, except the files of this repo.

# Configuration

## General Environment

docker-compose.yml - contains the docker-compose Stack Configuration

.env.local - contains DB Credentials and stuff like that (overrides .env in most cases!)

.env - should contain the same information like .env.local

## Nginx Configuration Files

nginx/conf - Configuration for nginx

nginx/www - WWW Folder, where all the Symfony Files and your Code are located

nginx/sites - Vhost configuration, by default only one File, by the installer gets a new vhost created, with the entered domain

nginx/conf.d/ - Nginx configuration

## DB Config  & DB Data Files

database/  - Database Data and Configs

database/data.sql - local MySQL DB, acts like SQL

*created 06 Nov 2021 - Template by SAAD-IT | changed 01/2022*
