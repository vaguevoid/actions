# Void GitHub Actions

This public repository contains GitHub actions for use with the [Void](https://void.dev) game development platform

## Build

The following action can be used to build the web version of a Void game.

Assumptions:
  * Has a `build` script defined inside `package.json`

```yaml
  steps:
    - name: Build Web
      uses: vaguevoid/actions/build/web@alpha
```

## Package

The following action can be used to package a Void game in Electron

Assumptions
  * Game has been built using action above

```yaml
  steps:
    - name: Package Windows (x64)
      uses: vaguevoid/actions/package/electron@alpha
      with:
        platform: win-32
        arch: x64
```

## Deploy

The following action can be used to deploy a Void game to Steam

Assumptions
  * Game has been built and packaged using actions above
  * A GitHub secret `STEAM_CONFIG_VDF` exists containing Steam user authorization

```yaml
  steps:
    - name: Deploy to Steam
      uses: vaguevoid/actions/deploy/steam@alpha
      with:
        username:          gordonja
        configVdf:         ${{ secrets.STEAM_CONFIG_VDF }}
        appId:             "xxxx" # your Steam Application ID
        windowsDepotId:    "xxxx" # the Steam Depot ID for your win32-x64 binaries
        appleIntelDepotId: "xxxx" # the Steam Depot ID for your darwin-x64 binaries
        appleArmDepotId:   "xxxx" # the Steam Depot ID for your darwin-arm64 binaries
```

Use the `vaguevoid/actions/deploy/login` Docker image to generate a `STEAM_CONFIG_VDF` for your
Steam user. You may have to manually regenerate and upload a new secret every 30 days.

From your terminal:

```bash
> docker run -it vaguevoid/actions/deploy/steam/login [USERNAME]

Steam> Enter you password:
Steam> Enter your Steam Guard code:

> cat ./config.vdf    # copy the contents of this file to your `STEAM_CONFIG_VDF` GitHub secret
```


### Development

For developing these packages, you can use bun (or npm) as a task runner

```bash
> bun install
> bun run images   # build all docker images
```

Some of these GitHub actions expect to be mounted so that the CWD maps to the GitHub Actions
workspace folder on the host so that they can generate files and have them available to the
host (or subsequent actions). In order to test that behavior from your local machine you may
have to...
  * mount the cwd as a volume
  * pass any required environment variables

E.g.

```bash
> docker run -it -e [ENV] -v .:/workspace -w /workspace [IMAGE] [ARGS]
```
