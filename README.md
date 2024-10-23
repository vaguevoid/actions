# Void GitHub Actions

This public repository contains GitHub actions for use with the [Void](https://void.dev) game development platform

The following high level composite actions are recommended

  * **Share on Web** - Build, Package, and Deploy to the Web on https://play.void.dev/
  * **Share on Steam** - Build, Package, and Deploy to Steam
  * **Share on Discord** - Build, Package, and Deploy to Discord
  * _...more to come_

## Share on Web

This [action](share/on/web/action.yml) can be used to build and share your game on https://play.void.dev/

```yaml
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Build, Package, and Deploy to Web
        uses: vaguevoid/actions/share/on/web@v1
        with:
          label:        "latest"                          # label your deploy
          organization: "acme"                            # your play.void.dev organization name
          game:         "pong"                            # your play.void.dev game name
          token:        ${{ secrets.VOID_ACCESS_TOKEN }}  # your play.void.dev personal access token
```

## Share on Steam

This [action](share/on/steam/action.yml) can be used to build, package, and deploy your Void game to Steam

```yaml
  runs-on: ubuntu-latest
  steps:
    - name: Checkout Repo
      uses: actions/checkout@v4
    
    - name: Build, Package, and Deploy to Steam
      uses: vaguevoid/actions/share/on/steam@v1
      with:
        executable:        "my-game"                       # name (without extension) to use for generated executables
        username:          gordonja                        # your Steam username
        configVdf:         ${{ secrets.STEAM_CONFIG_VDF }} # a Saved Steam login session (see below)
        appId:             "xxxx"                          # the Steam Application ID
        windowsDepotId:    "xxxx"                          # the Steam Depot ID for your Windows binaries
        macosDepotId:      "xxxx"                          # the Steam Depot ID for your MacOS binaries (optional)
        linuxDepotId:      "xxxx"                          # the Steam Depot ID for your Linux binaries (optional)
        setLiveBranch:     "beta"                          # the Steam branch to set live with this build (optional)
        buildDescription:  "latest and greatest"           # a build description (optional)
        compressTextures:  "true"                          # enable texture compressor (optional)
        ignoreTextures:    "favicon.png"                   # do not compress these textures (optional)
```

For actions that deploy to steam you will need to provide the contents of a Steam `config.vdf`
configuration file generated by the `steamcmd +login` action and stored as a GitHub secret. You
may have to manually regenerate and upload a new secret every 30 days - [see detailed instructions](doc/steam-authorization.md).

## Share on Discord

> coming soon

## Other Actions

The high level share actions above make many simplifying assumptions. If they do not meet your needs
you can drop down to the lower level actions below and combine them to build your
own workflow steps:

  * [Build with Vite](build/vite/readme.md) - Build for the web using Vite
  * [Package Textures](package/textures/action.yml) - compress .png images to optimized .dxt textures
  * [Package with Electron](package/electron/readme.md) - Package existing web build using Electron
  * [Deploy to Web](deploy/web/readme.md) - Deploy existing built game to the Web at https://play.void.dev
  * [Deploy to Steam](deploy/steam/readme.md) - Deploy existing packaged game to Steam
  * [Deploy Label](deploy/label/action.yml) - Extract a suitable deploy label from the GitHub branch name
  * _...more to come_
