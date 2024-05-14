#!/bin/bash

set -e

# Set admin user
echo "Setting admin user"
cps -p $CALIBRE_APP_DB_PATH -s $CALIBRE_ADMIN_USERNAME:$CALIBRE_ADMIN_PASSWORD

# Set config from '^_CALIBRE_' environment variables
echo "Configuring calibre-web"
for env in $(env|grep "^_CALIBRE_"|awk -F'=' '{print $1}'); do
  param=$(echo $env|sed -E 's/^_CALIBRE_(.*)/\L\1/g')
  value=${!env}

  if ! [[ $value =~ ^-?[0-9]+$ ]]; then
    value="'$value'"
  fi

  echo "  setting '$param'"
  sqlite3 $CALIBRE_APP_DB_PATH "UPDATE settings SET $param=$value"
done

if ! [[ -f "$CALIBRE_LIBRARY_PATH/metadata.db" ]]; then
  echo "Initializing empty database"
  calibredb restore_database --really-do-it --with-library $CALIBRE_LIBRARY_PATH
fi

echo "Starting calibre-web"
exec "$@"
