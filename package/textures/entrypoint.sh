#!/bin/bash

path=${path:-release/web}
ignore=${ignore:-favicon.png}
format=${format:-DXT}
threads=${threads:-4}

set -x

date
/usr/local/bin/image_compressor -d ${path} -i ${ignore} --delete-original-images -c ${format} -t ${threads}
date
