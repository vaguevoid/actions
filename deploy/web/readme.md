# Deploy to Web

This action can be used to deploy a built Void game to the Web at https://play.void.dev.

Assumptions:
  * Game was built using a Void build action
  * A GitHub secret `VOID_ACCESS_TOKEN` exists containing your access token for https://play.void.dev

```yaml
  steps:
    - name: Checkout Repo
      uses: actions/checkout@v4

    - name: Build
      uses: vaguevoid/actions/build/vite@alpha

    - name: Deploy to Web
      uses: vaguevoid/actions/deploy/web@alpha
      with:
        label:        "latest"                          # label your deploy
        organization: "acme"                            # your play.void.dev organization name
        game:         "pong"                            # your play.void.dev game name
        token:        ${{ secrets.VOID_ACCESS_TOKEN }}  # your play.void.dev personal access token
```
