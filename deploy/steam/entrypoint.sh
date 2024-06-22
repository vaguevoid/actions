#!/bin/bash

prefix=${prefix:-release}

if [[ -z "$configVdf" ]]; then
  echo "\$configVdf required"
  exit 1
fi

if [[ -z "$username" ]]; then
  echo "\$username required"
  exit 1
fi

if [[ -z "$appId" ]]; then
  echo "\$appId required"
  exit 1
fi

buildDescription=${buildDescription:-a void game}

steam_home=$HOME/.steam/steam
config_dir=$steam_home/config
config_file=$config_dir/config.vdf

mkdir -p /output

echo "************************************"
echo "Copy SteamGuard $config_file"
echo "************************************"
mkdir -p "$config_dir"
echo "$configVdf" | base64 -d > "$config_file"

echo "**********************"
echo " Generate Manifest"
echo "**********************"

cat << EOF > "manifest.vdf"
"AppBuild"
{
  "AppID" "$appId"
  "Desc" "$buildDescription"
  "ContentRoot" "./"
  "BuildOutput" "/output"
  "Depots"
  {
EOF

if [[ ! -z "$windowsDepotId" ]]; then
echo "... including windows depot"
cat << EOF >> "manifest.vdf"
    "$windowsDepotId"
    {
      "FileMapping"
      {
        "LocalPath" "./$prefix-win32-x64/*"
        "DepotPath" "."
        "recursive" "1"
      }
    }
EOF
fi

if [[ ! -z "$appleIntelDepotId" ]]; then
echo "... including apple (intel) depot"
cat << EOF >> "manifest.vdf"
    "$appleIntelDepotId"
    {
      "FileMapping"
      {
        "LocalPath" "./$prefix-darwin-x64/*"
        "DepotPath" "."
        "recursive" "1"
      }
    }
EOF
fi

if [[ ! -z "$appleArmDepotId" ]]; then
echo "... including apple (arm) depot"
cat << EOF >> "manifest.vdf"
    "$appleArmDepotId"
    {
      "FileMapping"
      {
        "LocalPath" "./$prefix-darwin-arm64/*"
        "DepotPath" "."
        "recursive" "1"
      }
    }
EOF
fi

cat << EOF >> "manifest.vdf"
  }
}
EOF

echo "****************"
echo "Test Steam Login"
echo "****************"
steamcmd +login "$username" +quit;
result=$?

if [ $result -ne 0 ]; then
  echo "Steam login failed"
  echo "Exit code: $result"
  exit $result
fi

echo "************"
echo "Upload Build"
echo "************"
echo ">>> TODO: run steamcmd upload here <<<"

# steamcmd +login "$username" +run_app_build manifest.vdf +quit
# result = $?
#
# if [ $result -ne 0 ]; then
#   echo "Steam upload failed"
#   echo "Exit code: $result"
#   echo ">>> TODO: display logs here <<<"
#   exit $result
# fi
