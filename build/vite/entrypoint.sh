#!/bin/bash
set -x

git config --global --add safe.directory $(pwd) # enable build to use git binary

taskName=${taskName:-build}
export VITE_DEPLOY_TARGET=${deployTarget:-web}

bun install
bun run ${taskName}
