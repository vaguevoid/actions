#!/bin/bash

path=${path:-release/web}
ignore=${ignore:-favicon.png}

set -x

/usr/local/bin/png_compressor -d ${path} -i ${ignore}
