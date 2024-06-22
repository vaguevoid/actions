#!/bin/bash
set -xeuo pipefail

bun install
bun run build --base "./"
