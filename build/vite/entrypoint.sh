#!/bin/bash
set -x

git config --global --add safe.directory $(pwd) # enable build to use git binary

taskName=${taskName:-build}
output=${output:-./release/web}
baseUrl=${baseUrl:-./}

export VITE_DEPLOY_TARGET=${deployTarget:-web}

mkdir -p $output

bun install

bun run ${taskName} --base "${baseUrl}" --outDir "${output}" --emptyOutDir
