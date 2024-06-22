#!/bin/bash

prefix=${prefix:-release}
dist=${dist:-dist}
electronVersion=${electronVersion:-31.0.2}

if [[ -z "$platform" ]]; then
  echo "\$platform required"
  exit 1
fi

if [[ -z "$arch" ]]; then
  echo "\$arch required"
  exit 1
fi

if [ ! -f "$dist/package.json" ]; then
cat << 'EOF' > "$dist/package.json"
{
  "main": "electron.js"
}
EOF
fi

if [ ! -f "$dist/electron.js" ]; then
cat << 'EOF' > "$dist/electron.js"
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

set -x

npx @electron/packager $dist $prefix \
  --electron-version=$electronVersion \
  --platform $platform \
  --arch $arch

chmod go+rx $prefix-$platform-$arch
