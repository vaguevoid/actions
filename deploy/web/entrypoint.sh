#!/bin/bash

host="${host:-https://play.void.dev/}"
path="${path:-dist}"
bundle="$(dirname "${path}")/web.tgz"
organization="${organization}"
game="${game}"
token="${token}"
password="${password}"
pinned="${pinned}"
endpoint="${host}api/${organization}/${game}/share"

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
OUTPUT_FILE=$(mktemp)
STATUS_CODE=$(curl -s -X POST -o $OUTPUT_FILE -w "%{http_code}" --connect-timeout 180 --max-time 300 -H "X-Deploy-Label: ${label}" -H "X-Deploy-Password: ${password}" -H "X-Deploy-Pinned: ${pinned}" -H "Authorization: Bearer ${token}" --data-binary "@${bundle}" ${endpoint} 2>/dev/null)

if [[ $STATUS_CODE == "404" ]]; then
  echo "endpoint ${endpoint} not found, are the organization and game correct?"
  exit 1
fi

if [[ $STATUS_CODE != "200" ]]; then
  echo "STATUS: $STATUS_CODE"
  echo "Sorry, upload failed, please try again in a few minutes or contact support@void.dev"
  exit 1
fi

cat $OUTPUT_FILE
