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
        username: vaguevoidbot
        configVdf: ${{ secrets.STEAM_CONFIG_VDF }}
```

> Use the `vaguevoid/actions/deploy/login` Docker image to generate a `STEAM_CONFIG_VDF` for your
Steam user. You may have to manually regenerate and upload a new secret every 30 days.


### Development

For developing these packages, you can use bun (or npm) as a task runner

```bash
> bun install
> bun run images   # build all docker images
```
