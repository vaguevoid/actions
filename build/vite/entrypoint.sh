#!/bin/bash
set -x

output=${output:-./release/web}
baseUrl=${baseUrl:-./}

export VITE_DEPLOY_TARGET=${deployTarget:-web}

mkdir -p $output

bun install
bun run build --base "${baseUrl}" --outDir "${output}" --emptyOutDir
