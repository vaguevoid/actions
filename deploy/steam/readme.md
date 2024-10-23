# Deploy to Steam

This action can be used to deploy a Void game to Steam

Assumptions
  * Game was built using a Void build action
  * Game was packaged using a Void package action
  * A GitHub secret `STEAM_CONFIG_VDF` exists containing Steam user authorization

```yaml
  env:
    executable: "my-game" # name (without extension) used for generated executables

  steps:
    - name: Checkout Repo
      uses: actions/checkout@v4

    - name: Build
      uses: vaguevoid/actions/build/vite@v1

    - name: Package for Windows
      uses: vaguevoid/actions/package/electron@v1
      with:
        executable: ${{ env.executable }}
        platform: "win-32"

    - name: Package for Mac OS
      uses: vaguevoid/actions/package/electron@v1
      with:
        executable: ${{ env.executable }}
        platform: "darwin"

    - name: Package for Linux
      uses: vaguevoid/actions/package/electron@v1
      with:
        executable: ${{ env.executable }}
        platform: "linux"

    - name: Deploy to Steam
      uses: vaguevoid/actions/deploy/steam@v1
      with:
        executable:        ${{ env.executable }}           # name (without extension) used for generated executables
        username:          gordonja                        # your Steam username
        configVdf:         ${{ secrets.STEAM_CONFIG_VDF }} # a Saved Steam login session (see below)
        appId:             "xxxx"                          # the Steam Application ID
        windowsDepotId:    "xxxx"                          # the Steam Depot ID for your Windows binaries
        macosDepotId:      "xxxx"                          # the Steam Depot ID for your MacOS binaries (optional)
        linuxDepotId:      "xxxx"                          # the Steam Depot ID for your Linux binaries (optional)
        setLiveBranch:     "beta"                          # the Steam branch to set live with this build (optional)
        buildDescription:  "latest beta test"              # a build description (optional)
```
