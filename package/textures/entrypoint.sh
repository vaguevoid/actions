#!/bin/bash

path=${path:-dist}
ignore=${ignore:-favicon.png}
format=${format:-DXT}
threads=${threads:-4}

set -x

date
/usr/local/bin/image_compressor -d ${path} -i ${ignore} --delete-original-images -c ${format} -t ${threads}
result=$?
date

if [ $result -ne 0 ]; then
  echo "Image Compressor Failed"
  echo "Exit code: $result"
  exit $result
fi
