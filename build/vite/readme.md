# Build with Vite

This action can be used to build the web version of a Void game using Vite.

Assumptions:
  * Has a `build` script defined inside `package.json`
  * `build` script ends with `vite build`

```yaml
  steps:
    - name: Checkout Repo
      uses: actions/checkout@v4

    - name: Build
      uses: vaguevoid/actions/build/vite@v1
      with:
        output: "release/web"  # output directory for bundled web game
```
