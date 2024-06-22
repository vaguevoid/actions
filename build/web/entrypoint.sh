#!/bin/bash
set -x

base=${base:-./}
dist=${dist:./dist}

bun install
bun run build --base "${base}" --outDir "${dist}" --emptyOutDir
