#!/bin/bash

releasePath=$(realpath "${releasePath:-release}")
executable=${executable:-electron}
buildDescription=${buildDescription:-a void game}
manifestFile="$releasePath/manifest.vdf"

steamdir=$HOME/.steam/steam
config_dir=$steamdir/config
config_file=$config_dir/config.vdf

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

if [ ! -d "$releasePath" ]; then
  echo "$releasePath not found"
  exit 1
fi

mkdir -p /output

echo "************************************"
echo "Copy SteamGuard $config_file"
echo "************************************"
mkdir -p "$config_dir"
echo "$configVdf" | base64 -d > "$config_file"

echo "**********************"
echo " Generate Manifest"
echo "**********************"

cat << EOF > "$manifestFile"
"AppBuild"
{
  "AppID" "$appId"
  "Desc" "$buildDescription"
  "ContentRoot" "$releasePath"
  "BuildOutput" "$releasePath"
EOF

if [[ ! -z "$setLiveBranch" ]]; then
cat << EOF >> "$manifestFile"
  "SetLive" "$setLiveBranch"
EOF
fi

cat << EOF >> "$manifestFile"
  "Depots"
  {
EOF

if [[ ! -z "$windowsDepotId" ]]; then
echo "... including windows depot"
cat << EOF >> "$manifestFile"
    "$windowsDepotId"
    {
      "FileMapping"
      {
        "LocalPath" "./$executable-win32-x64/*"
        "DepotPath" "."
        "recursive" "1"
      }
    }
EOF
fi

if [[ ! -z "$macosDepotId" ]]; then
echo "... including macos depot"
cat << EOF >> "$manifestFile"
    "$macosDepotId"
    {
      "FileMapping"
      {
        "LocalPath" "./$executable-darwin-x64/*"
        "DepotPath" "."
        "recursive" "1"
      }
    }
EOF
fi

if [[ ! -z "$linuxDepotId" ]]; then
echo "... including linux depot"
cat << EOF >> "$manifestFile"
    "$linuxDepotId"
    {
      "FileMapping"
      {
        "LocalPath" "./$executable-linux-x64/*"
        "DepotPath" "."
        "recursive" "1"
      }
    }
EOF
fi

cat << EOF >> "$manifestFile"
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

echo "**************************************************"
echo "Upload Build for $username, manifest $manifestFile"
echo "**************************************************"
steamcmd +login "$username" +run_app_build "$manifestFile" +quit
result=$?

if [ $result -ne 0 ]; then
  echo "Steam upload failed"
  echo "Exit code: $result"

  echo ""
  echo "Displaying error log"
  echo ""
  cat "$steamdir/logs/stderr.txt"
  echo ""
  echo "Displaying bootstrapper log"
  echo ""
  cat "$steamdir/logs/bootstrap_log.txt"

  for f in "$steamdir"/logs/*; do
    if [ -e "$f" ]; then
      echo "######## $f"
      cat "$f"
      echo
    fi
  done

  for f in "$releasePath"/*.log; do
    echo "######## $f"
    cat "$f"
    echo
  done

  exit $result
fi
