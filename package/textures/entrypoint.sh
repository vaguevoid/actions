#!/bin/bash

path=${path:-release/web}
ignore=${ignore:-favicon.png}
format=${format:-DXT}

set -x

/usr/local/bin/image_compressor -d ${path} -i ${ignore} --delete-original-images -c ${format}
