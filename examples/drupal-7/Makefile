ENVIRONMENT=vdd
DRUSH_ARGS= -y --nocolor
HOST=php
COMMAND=/bin/bash



#
# Targets for interacting with Docker Compose
#

# Start Docker Compose services and perform build steps
docker-start: docker-up
docker-up: build-docker docker-local-ssl
	docker-compose up -d
	docker-compose ps

# Start Docker Compose services but assume build has already taken place
docker-start-quick: docker-local-ssl
	docker-compose up -d
	docker-compose ps

# Stop docker
docker-stop: docker-down
docker-down:
	docker-compose down --remove-orphans

# Restart docker
docker-restart: docker-stop docker-start

# Create a self-signed certificate for HTTPS
docker-local-ssl: .persist/certs/local.key .persist/certs/local.crt
.persist/certs/local.%:
	mkdir -p ./.persist/certs
	./scripts/make/genlocalcrt.sh ./.persist/certs

# Connect to the shell on a docker host, defaults to HOST=php COMMAND=/bin/bash
# Usage: make docker-shell HOST=[container name] COMMAND=[command]
docker-shell:
	docker exec -i -t `docker ps | grep $(HOST)_1 | cut -d' ' -f 1` $(COMMAND)



#
# Targets for orchestrating project build
#

# Build Drupal and front-end using Docker containers
build-docker:
	./scripts/make/build-docker.sh

# Initialise Apache Solr core in service container
build-docker-solr:
	make docker-shell HOST=solr COMMAND='make core=core1 -f /usr/local/bin/actions.mk'



#
# Targets for cleaning project build artefacts
#

# Remove everything that's re-buildable. Running make build will reverse this.
clean: clean-drupal clean-node

# Remove NodeJS modules required by front-end
clean-node:
	rm -rf frontend/node_modules

# Remove all front-end build artefacts including NodeJS modules
clean-frontend: clean-node
	unlink frontend/assets/js/min/plugins.min.js
	unlink frontend/assets/js/min/app.min.js
	unlink frontend/assets/css/abc-brand/base/abc-fonts.css
	unlink frontend/assets/css/abc-brand.css
	unlink frontend/assets/css/fonts.css
	unlink frontend/assets/css/print-styles-seven-theme.css
	unlink frontend/assets/css/stage_overrides.css
	unlink frontend/assets/css/style.css
	unlink frontend/assets/css/theme-overrides.css
	unlink frontend/assets/css/wireframe.css

# Remove dependencies managed by Composer
clean-composer:
	rm -rf vendor bin

# Remove Drupal dependencies managed by Drush Make including Composer dependencies
clean-drupal: clean-composer
	rm -rf docroot/includes
	rm -rf docroot/misc
	rm -rf docroot/modules
	rm -rf docroot/profiles
	rm -rf docroot/scripts
	rm -rf docroot/themes
	rm -rf docroot/.htaccess
	rm -rf docroot/.editorconfig
	rm -rf docroot/.gitignore
	rm -rf docroot/authorize.php
	rm -rf docroot/CHANGELOG.txt
	rm -rf docroot/COPYRIGHT.txt
	rm -rf docroot/cron.php
	rm -rf docroot/index.php
	rm -rf docroot/INSTALL.mysql.txt
	rm -rf docroot/INSTALL.pgsql.txt
	rm -rf docroot/install.php
	rm -rf docroot/INSTALL.sqlite.txt
	rm -rf docroot/INSTALL.txt
	rm -rf docroot/LICENSE.txt
	rm -rf docroot/MAINTAINERS.txt
	rm -rf docroot/PATCHES.txt
	rm -rf docroot/README.txt
	rm -rf docroot/robots.txt
	rm -rf docroot/update.php
	rm -rf docroot/UPGRADE.txt
	rm -rf docroot/web.config
	rm -rf docroot/xmlrpc.php
	rm -rf docroot/pantheon.upstream.yml
	rm -rf docroot/*.patch
	rm -rf docroot/sites/example.sites.php
	rm -rf docroot/sites/README.txt
	rm -rf docroot/sites/default/default.settings.php
	rm -rf docroot/sites/all/libraries/README.txt
	rm -rf docroot/sites/all/modules/contrib
	rm -rf docroot/sites/all/modules/README.txt
	rm -rf docroot/sites/all/themes/contrib
	rm -rf docroot/sites/all/themes/README.txt



#
# Targets for Drush orchestration
#

drush-make-recreate: check-env
	cd docroot && \
	  ../vendor/bin/drush @$(ENVIRONMENT) $(DRUSH_ARGS) make-generate ../drush-make.lock.ini

drush-make-apply-patch:
	cd docroot && \
	  ../vendor/bin/drush $(DRUSH_ARGS) make --no-core --projects=$(MODULES) ../drush-make.yml

drupal-update: check-env build-drupal
	cd docroot && \
	  ../vendor/bin/drush @$(ENVIRONMENT) $(DRUSH_ARGS) cc drush && \
	  ../vendor/bin/drush @$(ENVIRONMENT) $(DRUSH_ARGS) master-execute --no-cache-clear && \
	  ../vendor/bin/drush @$(ENVIRONMENT) $(DRUSH_ARGS) updb && \
	  ../vendor/bin/drush @$(ENVIRONMENT) $(DRUSH_ARGS) fra



#
# Targets for Bitbucket Pipelines
#



#
# Targets for utility functions
#

# Need to check if the user specified the ENVIRONMENT arg where appropriate.
check-env:
	@if test "$(ENVIRONMENT)" = "" ; then \
	    echo "ENVIRONMENT is undefined. Usage: make [command] ENVIRONMENT=[vddp|vddm]"; \
	    exit 1; \
	fi



#
# Targets specific to the project
#
# Note: Do not forget to precede the target definition with a comment explaining what it does!
#
