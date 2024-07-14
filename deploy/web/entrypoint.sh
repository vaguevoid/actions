#!/bin/bash

host="${host:-https://play.void.dev/}"
path="${path:-release/web}"
bundle="$(dirname "${path}")/web.tgz"
organization="${organization}"
game="${game}"
label="${label}"
token="${token}"
password="${password}"
endpoint="${host}api/${organization}/${game}/share/${label}"

if [[ -z "$host" ]]; then
  echo "host required"
  exit 1
fi

if [[ -z "$path" ]]; then
  echo "path required"
  exit 1
fi

if [[ -z "$organization" ]]; then
  echo "organization required"
  exit 1
fi

if [[ -z "$game" ]]; then
  echo "game required"
  exit 1
fi

if [[ -z "$label" ]]; then
  echo "label required"
  exit 1
fi

if [[ -z "$token" ]]; then
  echo "token required"
  exit 1
fi

tar -czf ${bundle} -C ${path} .

echo "Uploading ${bundle} to ${endpoint}"
OUTPUT=$(curl -s -X POST --fail-with-body --connect-timeout 180 --max-time 180 -H "X-Deploy-Password: ${password}" -H "Authorization: Bearer ${token}" --data-binary "@${bundle}" ${endpoint})
if [ $? -ne 0 ]; then
  echo $OUTPUT
  echo "Sorry, upload failed, please try again in a few minutes or contact support@void.dev"
  exit 1
fi

echo $OUTPUT
