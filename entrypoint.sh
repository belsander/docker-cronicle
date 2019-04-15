#!/bin/bash

ROOT_DIR=/opt/cronicle
CONF_DIR=$ROOT_DIR/conf
BIN_DIR=$ROOT_DIR/bin
LIB_DIR=$ROOT_DIR/lib
INIT_DIR=$ROOT_DIR/init
# DATA_DIR needs to be the same as the exposed Docker volume in Dockerfile
DATA_DIR=$ROOT_DIR/data
# PLUGINS_DIR needs to be the same as the exposed Docker volume in Dockerfile
PLUGINS_DIR=$ROOT_DIR/plugins

# The env variables below are needed for Docker and cannot be overwritten
export CRONICLE_Storage__Filesystem__base_dir=${DATA_DIR}
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
export CRONICLE_echo=1
export CRONICLE_foreground=1

# Only run setup when setup needs to be done
if [ ! -f $DATA_DIR/.setup_done ]
then
  $BIN_DIR/control.sh setup

  cp $CONF_DIR/config.json $CONF_DIR/config.json.origin

  if [ -f $INIT_DIR/config.json.import ]
  then
    # Move in custom configuration
    echo "using the custom config file from $INIT_DIR/config.json.import"
    cp $INIT_DIR/config.json.import $INIT_DIR/config.json
  fi

  if [ -f $INIT_DIR/cronicle.json.backup ]
  then
    # restore the backup file
    echo "restoring backup file: $INIT_DIR/cronicle.json.backup"
    /opt/cronicle/bin/control.sh import $INIT_DIR/cronicle.json.backup
  fi

  # Create plugins directory
  mkdir -p $PLUGINS_DIR

  # Marking setup done
  touch $DATA_DIR/.setup_done
fi

# Run cronicle
/usr/local/bin/node "$LIB_DIR/main.js"
