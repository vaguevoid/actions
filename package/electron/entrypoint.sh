#!/bin/bash

bundle=${bundle:-release/web}
releasePath=${releasePath:-release}
executable=${executable:-electron}
electronVersion=${electronVersion:-31.0.2}
arch=${arch:x64}

if [[ -z "$platform" ]]; then
  echo "platform required"
  exit 1
fi

if [ ! -d "$bundle" ]; then
  echo "$bundle doesn't exist"
  exit 1
fi

if [ ! -f "$bundle/package.json" ]; then
cat << 'EOF' > "$bundle/package.json"
{
  "main": "electron.js"
}
EOF
fi

if [ ! -f "$bundle/electron.js" ]; then
cat << 'EOF' > "$bundle/electron.js"
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

mkdir -p $releasePath

npx @electron/packager $bundle $executable \
  --electron-version=$electronVersion \
  --platform $platform \
  --arch $arch \
  --out $releasePath

chmod go+rx $releasePath/$executable-$platform-$arch
