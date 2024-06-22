#!/bin/bash

STEAM_HOME=${STEAM_HOME:-$HOME/.steam/steam}
STEAM_CONFIG_DIR=${STEAM_HOME}/config
STEAM_CONFIG_FILE=${STEAM_CONFIG_DIR}/config.vdf

if [[ -z "${CONFIG_VDF}" ]]; then
  echo "\$CONFIG_VDF required"
  exit 1
fi

if [[ -z "${STEAM_USERNAME}" ]]; then
  echo "\$STEAM_USERNAME required"
  exit 1
fi

set -x

echo "****************************"
echo "Copying ${STEAM_CONFIG_FILE}"
echo "****************************"
mkdir -p "${STEAM_CONFIG_DIR}"
echo "${CONFIG_VDF}" | base64 -d > "${STEAM_CONFIG_FILE}"

echo "****************"
echo "Test Steam Login"
echo "****************"
steamcmd +login "${STEAM_USERNAME}" +quit;
