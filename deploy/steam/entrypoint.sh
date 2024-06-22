#!/bin/bash
set -xeuo pipefail

if [[ -z "${CONFIG_VDF}" ]]; then
  echo "\$CONFIG_VDF required"
  exit 1
fi

if [[ -z "${STEAM_USERNAME}" ]]; then
  echo "\$STEAM_USERNAME required"
  exit 1
fi

steam_home=$HOME/.steam/steam
steam_config_dir=$steam_home/config
steam_config_file=$steam_config_dir/config.vdf

echo "************************************"
echo "Copy SteamGuard $steam_config_file"
echo "************************************"
mkdir -p "$steam_config_dir"
echo "${CONFIG_VDF}" | base64 -d > "$steam_config_file"

echo "****************"
echo "Test Steam Login"
echo "****************"
steamcmd +login "${STEAM_USERNAME}" +quit;
result = $?

if [ $result -ne 0 ]; then
  echo "Steam login failed"
  echo "Exit code: $result"
  exit $result
fi

echo "***********************"
echo "Generate Depot Manifest"
echo "***********************"
echo ">>> TODO: generate depot manifest(s) here <<<"

echo "**********************"
echo "Generate App Manifest"
echo "**********************"
echo ">>> TODO: generate app manifest here <<<"

echo "************"
echo "Upload Build"
echo "************"
echo ">>> TODO: run steamcmd upload here <<<"

# steamcmd +login "${STEAM_USERNAME}" +run_app_build manifest.vdf +quit
# result = $?
#
# if [ $result -ne 0 ]; then
#   echo "Steam upload failed"
#   echo "Exit code: $result"
#   echo ">>> TODO: display logs here <<<"
#   exit $result
# fi
