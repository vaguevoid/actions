#!/bin/bash

set -x

bun install
bun run build --base "./"
