# Build with Vite

This action can be used to build the web version of a Void game using Vite.

Assumptions:
  * Has a `build` script defined inside `package.json`
  * `build` script uses some combination of `vite build`

```yaml
  steps:
    # ...

    - name: Build
      uses: vaguevoid/actions/build/vite@alpha
      with:
        output: "release/web"  # output directory for bundled web game
        baseUrl: "./"          # ensure vite generates relative links
```
