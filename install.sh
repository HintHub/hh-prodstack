#!/bin/bash

# store git creds
git config credential.helper 'store'

# Download the stuff from gitlab
cd "nginx/www/"
git clone  "https://git-se.iubh.de/ali-kemal.yalama/Hinthub.git" .

cp ../../copy/env.local .env.local
# 
