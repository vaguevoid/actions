#!/bin/bash
set -x

output=${output:-./release/web}
baseUrl=${baseUrl:-./}
prebuild=${prebuild}

export VITE_DEPLOY_TARGET=${deployTarget:-web}

mkdir -p $output

bun install

if [[ ! -z "$prebuild" ]]; then
  bun run $prebuild
fi

bun run build --base "${baseUrl}" --outDir "${output}" --emptyOutDir
