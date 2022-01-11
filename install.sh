#!/bin/bash
# Install Script 01/2021 | Hinthub | Karim S

# store git creds
git config credential.helper 'store'

# Download the stuff from gitlab
cd "nginx/www/"
git clone  "https://git-se.iubh.de/ali-kemal.yalama/Hinthub.git" .

# step 1 copy docker-compose.yaml
# step 2 replace values
# step 3 copy env.local to nginx/www/.env.local
# step 4 replace values


# run install.sh

# in copy func cp ../../copy/env.local .env.local
