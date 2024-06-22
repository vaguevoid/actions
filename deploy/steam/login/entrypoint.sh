#!/bin/bash
set -euo pipefail

STEAM_HOME=${STEAM_HOME:-$HOME/.steam/steam}
STEAM_CONFIG_DIR=${STEAM_HOME}/config
STEAM_CONFIG_FILE=${STEAM_CONFIG_DIR}/config.vdf

usage () {
cat << 'EOF'

DESCRIPTION:
  Run this docker image to perform an interactive steamcmd MFA login and save the
  resulting config.vdf to be used as input to the vaguevoid/actions/deploy/steam Action

USAGE:
  docker run -it -v .:/out vaguevoid/actions/deploy/steam/login [USERNAME]
EOF
}

if [[ -z $1 ]]; then
  echo "ERROR: missing [USERNAME]"
  usage
  exit 1
fi

OUTPUT=${OUTPUT:-/out}
if [ ! -d ${OUTPUT} ]; then
  echo "ERROR: missing output directory"
  echo "...don't forget to mount ${OUTPUT} volume so we can save config.vdf for you. Try -v .:${OUTPUT}"
  usage
  exit 1
fi

steamcmd +login $1 +quit
if [ $? -ne 0 ]; then
  echo "invalid password"
  exit 1
fi

cat "${STEAM_CONFIG_FILE}" | base64 > "${OUTPUT}/config.vdf"
echo "config.vdf has been saved to your output directory"
exit 0
