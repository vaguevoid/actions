#!/bin/bash

steamHome=$HOME/.steam/steam
steamConfigDir=$steamHome/config
steamConfigFile=$steamConfigDir/config.vdf

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

out=${out:-/out}
if [ ! -d $out ]; then
  echo "ERROR: missing output directory"
  echo "...don't forget to mount $out volume so we can save config.vdf for you. Try -v .:$out"
  usage
  exit 1
fi

steamcmd +login $1 +quit
if [ $? -ne 0 ]; then
  echo "invalid password"
  exit 1
fi

cat "$steamConfigFile" | base64 > "$out/config.vdf"
echo "config.vdf has been saved"
exit 0
