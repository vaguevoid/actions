#!/bin/bash
set -xeuo pipefail

NAME=${NAME:-release}
DIST=${DIST:-dist}
ELECTRON_VERSION=${ELECTRON_VERSION:-31.0.2}

if [[ -z "${PLATFORM}" ]]; then
  echo "\$PLATFORM required"
  exit 1
fi

if [[ -z "${ARCH}" ]]; then
  echo "\$ARCH required"
  exit 1
fi

if [ ! -f ${DIST}/package.json ]; then
cat << 'EOF' > ${DIST}/package.json
{
  "name": "${NAME}",
  "main": "electron.js"
}
EOF
fi

if [ ! -f ${DIST}/electron.js ]; then
cat << 'EOF' > ${DIST}/electron.js
  const { app, BrowserWindow } = require("electron")
  const path = require("node:path")

  app.commandLine.appendSwitch("enable-unsafe-gpu")
  app.commandLine.appendSwitch("enable-vulkan")

  const createWindow = () => {
    const win = new BrowserWindow({
      width: 800,
      height: 600
    })
    win.setMenu(null)
    win.loadFile("index.html")
  }

  app.on("window-all-closed", () => {
    if (process.platform !== "darwin") {
      app.quit()
    }
  })

  app.whenReady().then(() => {
    createWindow()
    app.on("activate", () => {
      if (BrowserWindow.getAllWindows().length === 0) {
        createWindow()
      }
    })
  })
EOF
fi

npx @electron/packager ${DIST} ${NAME} \
  --electron-version=${ELECTRON_VERSION} \
  --platform ${PLATFORM} \
  --arch ${ARCH}

chmod go+rx ${NAME}-${PLATFORM}-${ARCH}
