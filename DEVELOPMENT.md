# Development

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
