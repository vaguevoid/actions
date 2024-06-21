# Void GitHub Actions

This public repository contains GitHub actions for use with the [Void](https://void.dev) game development platform

## Build

The following action can be used to build the web version of a Void game

```yaml
  steps:
    - name: Build Web
      uses: vaguevoid/actions/build/web@alpha
```

## Package

The following action can be used to package a Void game in Electron

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

 * COMING SOON

