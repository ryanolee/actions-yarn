#!/bin/sh

set -e

if [ -n "$NPM_AUTH_TOKEN" ]; then
  # Respect NPM_CONFIG_USERCONFIG if it is provided, default to $HOME/.npmrc
  NPM_CONFIG_USERCONFIG="${NPM_CONFIG_USERCONFIG:-"$HOME/.npmrc"}"
  NPM_REGISTRY_URL="${NPM_REGISTRY_URL:-registry.npmjs.org}"
  NPM_STRICT_SSL="${NPM_STRICT_SSL:-true}"
  NPM_REGISTRY_SCHEME="https"
  if ! $NPM_STRICT_SSL
  then
    NPM_REGISTRY_SCHEME="http"
  fi

  # Allow registry.npmjs.org to be overridden with an environment variable
  printf "//%s/:_authToken=%s\\nregistry=%s\\nstrict-ssl=%s" "$NPM_REGISTRY_URL" "$NPM_AUTH_TOKEN" "${NPM_REGISTRY_SCHEME}://$NPM_REGISTRY_URL" "${NPM_STRICT_SSL}" > "$NPM_CONFIG_USERCONFIG"

  chmod 0600 "$NPM_CONFIG_USERCONFIG"
fi

if [ -n "$GIT_OAUTH_KEY" ]; then
  echo "Setting up git..."
  #mkdir -p $HOME/.config/git/ || true
  #echo "https://$GIT_USER:$GIT_OAUTH_KEY@$GIT_REPO" > $HOME/.config/git/credentials

  #git config --global credential.helper store
  git config --global url.https://github.com/.insteadOf ssh://git@github.com/ 
  git config --global --add url.https://github.com/.insteadOf git@github.com:
  # Write docker machine urls using netrc
  echo -e "machine github.com\n  login $GIT_USER  \n  password $GIT_OAUTH_KEY" > ~/.netrc
  #git config --global url."https://$GIT_OAUTH_KEY:x-oauth-basic@".insteadOf https://
  echo "Done for user $GIT_USER"
fi

sh -c "yarn $*"
