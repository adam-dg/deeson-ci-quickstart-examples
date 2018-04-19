#!/usr/bin/env bash

cwd=$(pwd)
script_path=$(dirname $0)
cd "$script_path" && cd ../..

# Uncomment below to have Composer managed depdencies installed.
#composer install

# Uncomment below to make settings directories writeable.
#chmod u+w docroot/sites/* docroot/sites/*/settings.php
