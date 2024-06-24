#!/bin/bash
set -x

output=${output:-./release/web}
baseUrl=${baseUrl:-./}

mkdir -p $output

bun install
bun run build --base "${baseUrl}" --outDir "${output}" --emptyOutDir
