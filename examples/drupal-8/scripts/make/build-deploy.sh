#!/usr/bin/env bash

set -e

# Remove any sub repositories.
if [ "${BITBUCKET_CLONE_DIR}" != "" ] ; then
  find ./* -name .git -type d | xargs -I{} rm -Rf {}
fi

# Unignore the assets.
echo "!assets" >> src/frontend/.gitignore

if [ "${GIT_RELAY_TYPE}" == "snapshot" ] ; then
  # If we are deploying using git relay, we have to make sure we're
  # actually committing everything and therefore disable all git hooks.
  echo "Disabling git hooks"
  chmod -x .git/hooks/*
fi
