# Void GitHub Actions

This public repository contains GitHub actions for use with the [Void](https://void.dev) game development platform

The following high level composite actions are recommended

  * [Share on Steam](#share-on-steam) - Build, Package, and Deploy to Steam

The high level actions above make some simplifying assumptions. If they do not meet your needs
you can drop down to the lower level actions below and combine them to build your
own workflow steps:

  * [Build with Vite](build/vite/readme.md) - Build for the web using Vite
  * [Package with Electron](package/electron/readme.md) - Package existing web build using Electron
  * [Deploy to Steam](deploy/steam/readme.md) - Deploy existing packaged game to Steam


## Share on Steam

This [action](share/on/steam/action.yml) can be used to build, package, and deploy your Void game to Steam

```yaml
  steps:
    - name: Build, Package, and Deploy to Steam
      uses: vaguevoid/actions/share/on/steam@alpha
      with:
        executable:       "my-game"                       # name (without extension) to use for generated executables
        username:         gordonja                        # Steam username
        configVdf:        ${{ secrets.STEAM_CONFIG_VDF }} # Saved Steam login session (see below)
        appId:            "xxxx"                          # your Steam Application ID
        windowsDepotId:   "xxxx"                          # the Steam Depot ID for your Windows binaries
        macosDepotId:     "xxxx"                          # the Steam Depot ID for your MacOS binaries (if any)
        linuxDepotId:     "xxxx"                          # the Steam Depot ID for your Linux binaries (if any)
        setLiveBranch:    "beta"                          # (optional) Steam branch to set live with this build (if any)
        buildDescription: "latest and greatest"           # (optional) build description
```

---

## Steam Authorization File (config.vdf)

For actions that deploy to steam you will need to provide a `configVdf` configuration file generated
by the `steamcmd +login` action. To generate this file you can use the `ghcr.io/vaguevoid/steam/login`
Docker image from your local development machine to generate a `config.vdf` file which you can then
copy into a `STEAM_CONFIG_VDF` GitHub actions secret. You may have to manually regenerate and
upload a new secret every 30 days.

From your terminal:

```bash
> docker run -it -v .:/out ghcr.io/vaguevoid/steam/login [USERNAME]

Steam> Enter you password:
Steam> Enter your Steam Guard code:

> cat ./config.vdf    # copy the contents of this file to your `STEAM_CONFIG_VDF` GitHub secret
```

> NOTE: the `vaguevoid/steam/login` docker image is currently private, and you will need
to (a) ask Jake to add you as a user
and (b) perform a [docker login with a GitHub personal access token](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic)

---

### Development

For developing these actions, you can use bun (or npm) as a task runner

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
