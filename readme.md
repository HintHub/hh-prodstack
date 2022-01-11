# Hinthub Stack - Prod and Dev

This docker stack allows you to run the production version of Hinthub as well the pre-prod (dev) version.

# Installation

Unpack the .tar.gz by using `tar xvzf tarname.tar.gz`

cd into the dir

Run `sudo chmod u+x install.sh` to make the install.sh executable

After making it executable, run it. `sudo ./install.sh <appName> <dbUser> <dbPass> <domain>`

The Script should do all the rest for you.

In addition you can add the IP of the nginx_1 container (of the stack) to `/etc/hosts`, use the docker inspect command for that.

## Front nginx

If you want to use a nginx in front of the stack nginx, you should proxy_pass the traffic to it. Don't forget to generate a Lets Encrypt certificate by using certbot. Configure the main nginx to use TLS. 

# Updating

You need to run updates yourself, especially changes in migrations needing an update of the database schema.

Either use `php bin/console doctrine:schema:update --force -n`

or `php bin/console doctrine:migrations:migrate -n`

The issue is that old data structures may be damaged, so backup the data before upgrading.

Then do a `git pull`, which should download the remote changes to local.

Additionally you could do a `git reset --hard HEAD` (which destroys everything in the local repository and resets it to the HEAD of the branch)**



# Removal

Use `sudo ./destroy.sh <appName>` then it removes all the files, except the files of this repo.

# Configuration

### General Environment

docker-compose.yml - Adjusting the docker containers, if you exchange User or PW, please adjust the code examples above, especially when you change SQL root

.env.local - contains DB Credentials and stuff like that

### Interesting Folders

nginx/conf (Configuration for nginx)

nginx/www (WWW Folder, where all the Symfony Files and your Code are located)

nginx/sites (Vhost configuration, by default only one File, by the installer gets a new vhost created, with the entered domain)

nginx/conf.d/ (Nginx configuration)

### DB Config (Dockerfile noticed)

database/ (Database Data and Configs)

database/data.sql (local MySQL DB, acts like SQL)



*created 06 Nov 2021 - Template by SAAD-IT | changed 01/2021*
