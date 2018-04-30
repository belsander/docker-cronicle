#!/bin/bash

ROOT_DIR=/opt/cronicle
CONF_DIR=$ROOT_DIR/conf
BIN_DIR=$ROOT_DIR/bin
DATA_DIR=$ROOT_DIR/data

# Only run setup when setup needs to be done
if [ ! -f $DATA_DIR/.setup_done ]
then
  $BIN_DIR/control.sh setup

  mv $CONF_DIR/config.json $CONF_DIR/config.json.origin

  if [ -f $DATA_DIR/config.json.import ]
  then
    # Move in custom configuration
    cp $DATA_DIR/config.json.import $CONF_DIR/config.json

  else
    # Use default configuration with changes through ENV variables
    _WEBSERVER_HTTP_PORT=${WEBSERVER_HTTP_PORT:-3012}

    cat $CONF_DIR/config.json.origin | \
      jq ".web_socket_use_hostnames = ${WEB_SOCKET_USE_HOSTNAMES:-1}" | \
      jq ".server_comm_use_hostnames = ${SERVER_COMM_USE_HOSTNAMES:-1}" | \
      jq ".WebServer.http_port = ${_WEBSERVER_HTTP_PORT}" | \
      jq ".WebServer.https_port = ${WEBSERVER_HTTPS_PORT:-443}" | \
      jq ".base_app_url = \"${BASE_APP_URL:-http://${HOSTNAME}:${_WEBSERVER_HTTP_PORT}}\"" \
      > $CONF_DIR/config.json

  fi

  # Marking setup done
  touch $DATA_DIR/.setup_done
fi

# Run cronicle
NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt $BIN_DIR/debug.sh
