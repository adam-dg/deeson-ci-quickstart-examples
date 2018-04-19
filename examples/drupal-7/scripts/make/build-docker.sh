#!/usr/bin/env bash

script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path"
cd ../..
repo_root=$(pwd)

# Uncomment to install dependencies managed by Composer or Drush Make
# Remember to match the wodby/drupal-php container image version to what is in your docker-compose.yml
#docker run -ti -v $repo_root:/var/www/html -w /var/www/html wodby/drupal-php:7.1-2.4.3 /bin/bash -c './scripts/make/build-drupal.sh'

#if [ $? -ne 0 ] ; then
#  exit $?
#fi

# Uncomment to have Grunt compile front-end assets
#docker run -ti -v $repo_root/frontend:/app -w /app deeson/fe-node /bin/bash -c 'npm install && ./node_modules/.bin/grunt build'

# Uncomment to have Yarn compile front-end assets
#docker run -ti -v $repo_root/frontend:/app -w /app deeson/fe-node /bin/bash -c 'yarn install && yarn build'

#if [ $? -ne 0 ] ; then
#  exit $?
#fi
