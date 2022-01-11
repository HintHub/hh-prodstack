#!/bin/bash
cd ../
composer install -n
yarn install --non-interactive
npm i --silent
composer require symfony/runtime -n
php /var/www/bin/console cache:clear -n
chmod 000 /var/www/var/log -R
chmod 7777 /var/www/var/log -R
rm install.sh # self-remove this script
