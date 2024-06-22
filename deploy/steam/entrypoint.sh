#!/bin/bash

STEAM_HOME=${STEAM_HOME:-$HOME/.steam/steam}
STEAM_CONFIG_DIR=${STEAM_HOME}/config
STEAM_CONFIG_FILE=${STEAM_CONFIG_DIR}/config.vdf

if [ $1="login" ]; then
  if [[ -z $2 ]]; then
    echo "username required"
    exit 1
  fi
  OUTPUT=${OUTPUT:-/output}
  if [ ! -d ${OUTPUT} ]; then
    echo "must mount ${OUTPUT} volume. Try -v .:${OUTPUT}"
    exit 1
  fi
  steamcmd +login $2 +quit
  if [ $? -eq 0 ]; then
    mkdir -p /out
    cat "${STEAM_CONFIG_FILE}" | base64 > "${OUTPUT}/config.vdf"
    echo "config.vdf saved"
    exit 0
  else
    echo "invalid password"
    exit 1
  fi
fi

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
