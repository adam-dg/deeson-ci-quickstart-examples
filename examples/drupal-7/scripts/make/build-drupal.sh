#!/usr/bin/env bash

cwd=$(pwd)
script_path=$(dirname $0)
cd "$script_path" && cd ../..

# Uncomment below to have Composer managed depdencies installed.
#composer install

# Uncomment below to make settings directories writeable.
#chmod u+w docroot/sites/* docroot/sites/*/settings.php

# Uncomment below to have Drush Make build Drupal Core and Contrib.
#cd docroot \
#  && ../vendor/bin/drush @none make -y --nocolor --no-recursion ../drush-make.yml
