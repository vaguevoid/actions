#!/bin/bash

path=${path:-dist}
config=$(realpath ${config:-image-compressor.json})
threads=${threads:-4}

if [ ! -f "$config" ]; then
  echo "$config doesn't exist"
  exit 1
fi

set -x

date
cd ${path}
/usr/local/bin/image_compressor compress -c ${config}
result=$?
date

if [ $result -ne 0 ]; then
  echo "Image Compressor Failed"
  echo "Exit code: $result"
  exit $result
fi
