# Hinthub Stack - Prod and Dev

This docker stack allows you to run the production version of Hinthub as well the pre-prod (dev) version.

# Installation

Unpack the .tar.gz by using `tar xvzf tarname.tar.gz`

cd into the dir

Run `chmod u+x run.sh` to make the run.sh executable for the owner (user).

do `./run.sh`

Now the stack should be building as well spinning up three containers. You can observe that by using `docker ps`. 

if your user is not root and not in the docker group, you should use sudo.

If fixtures not loading, you should do that manually.

Also you have to, depending on your Stack, add the docker container IP to `/etc/hosts`.
docker inspect <container_name> helps you.  

## Front nginx

If you want to use a nginx in front of the stack nginx, you should proxy_pass the traffic to it. Don't forget to generate a Lets Encrypt certificate by using certbot. Configure the main nginx to use TLS. 

## Configuration

### General Environment

docker-compose.yml - Adjusting the docker containers, if you exchange User or PW, please adjust the code examples above, especially when you change SQL root

.env.local - contains DB Credentials and stuff like that

### Interesting Folders

nginx/conf (Configuration for nginx)

nginx/www (WWW Folder, where you usually put the PHP Filez)

nginx/sites (Vhost configuration, usually only one File, named "default" or "default.conf")

nginx/conf.d/ (...)

### DB Config (Dockerfile noticed)

database/ (Database Data and Configs)

database/data.sql (local MySQL DB, acts like SQL)

## Updating

You need to run updates yourself, especially changes in migrations needing an update of the database schema.

Either use `php bin/console doctrine:schema:update --force -n` 

or `php bin/console doctrine:migrations:migrate -n`

The issue is that old data structures may be damaged, so backup the data before upgrading.



*edited 06 Nov 2021 - Template by SAAD-IT*
