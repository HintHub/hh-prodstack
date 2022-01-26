#!/bin/bash

# updates the docker-compose stack and the app
# author: karim.saad (karim.saad@iubh.de)
# date: 26.01.2022

appName="$1"    # appName / stackName
prod="$2"       # prod flag if set it's prod

# check if e.g. hhprod given
if [ -z "$appName" ]; then
        echo "ERROR $0 <dockerStackName/appName> [prodFlag]";
        exit;
fi

echo "[i] AppName: $appName";

if [ -z "$prod" ]; then
        prod=0
        echo "[+] Prod disabled";
else
        prod=1
        echo "[+] Prod enabled";
fi

startPath=$(pwd);

# upgrading the current stack (./)
git fetch
git reset --hard HEAD
git pull

chmod u+x update.sh

# upgrade the stuff in nginx/www
cd "nginx/www/";
git fetch
git pull
cd "$startPath";

phpfpm="${appName}_php-fpm_1"

if [ -f "docker-compose.yaml" ]; then
        # upgrades, cache clearings etc in each env
        if [ "$prod" == "1" ]; then
                # when prod

                # upgrade the DB
                sudo docker exec -it "$phpfpm" php /var/www/bin/console doctrine:migrations:migrate -n

                # optimize autoloader
                sudo docker exec -it "$phpfpm" bash -c 'cd /var/www/ && composer dump-autoload --no-dev -o -a'

                # clear cache
                sudo docker exec -it "$phpfpm" php /var/www/bin/console cache:clear -n

        else
                # when not prod

                # upgrade DB and load new fixtures
                sudo docker exec -it "$phpfpm" php /var/www/bin/console doctrine:database:drop --force -n
                sudo docker exec -it "$phpfpm" php /var/www/bin/console doctrine:database:create -n
                sudo docker exec -it "$phpfpm" php /var/www/bin/console doctrine:migrations:migrate -n
                sudo docker exec -it "$phpfpm" php /var/www/bin/console doctrine:fixtures:load -n 

                # optimize autoloader
                sudo docker exec -it "$phpfpm" bash -c 'cd /var/www/ && composer dump-autoload -o -a'

                # clear cache
                sudo docker exec -it "$phpfpm" php /var/www/bin/console cache:clear -n 
        fi
fi

chmod u+x update.sh
