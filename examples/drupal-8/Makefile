ROOT_DIR=${PWD}
RUN_DESTRUCTIVE?=false
ENVIRONMENT?=docker
DRUSH_ARGS?=-y --nocolor
DRUSH_CMD?=${ROOT_DIR}/vendor/bin/drush @$(ENVIRONMENT)
DRUSH?=${DRUSH_CMD} $(DRUSH_ARGS)
COMPOSER?=$(shell command -v composer 2> /dev/null)



#
# Targets for interacting with Docker Compose
#

# Start Docker Compose services and perform build steps
docker-start: docker-up
docker-up: build-docker docker-local-ssl
	@echo Bringing docker containers up
	docker-compose up -d
	docker-compose ps

# Start Docker Compose services but assume build has already taken place
docker-start-quick: docker-local-ssl
	@echo Bringing docker containers up
	docker-compose up -d
	docker-compose ps

# Stop docker
docker-stop: docker-down
docker-down:
	@echo Bringing docker containers down
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
	rm -rf src/frontend/node_modules

# Remove all front-end build artefacts including NodeJS modules
clean-frontend: clean-node
	rm -Rf src/frontend/assets

# Remove dependencies managed by Composer
clean-composer:
	rm -rf vendor bin

# Remove Drupal dependencies managed by Drush Make including Composer dependencies
clean-drupal: clean-composer
	rm -Rf docroot web



#
# Targets for Drush orchestration
#



#
# Targets for Bitbucket Pipelines
#

# Relay to hosting platform provided Git repository
deploy: pre-deploy
	/opt/ci-tools/deployer.sh



#
# Targets for utility functions
#



#
# Targets specific to the project
#
# Note: Do not forget to precede the target definition with a comment explaining what it does!
#

#
pre-deploy:
	./scripts/make/build-deploy.sh

# Do stuff to Drupal now it's in a live environment.
post-deploy:
	# No master yet :-( .
	cd docroot && $(DRUSH) cim sync
	cd docroot && $(DRUSH) updb
	cd docroot && $(DRUSH) cr
	cd docroot && $(DRUSH) cc css-js
