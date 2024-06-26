# Steam Authorization File

Deploying to Steam requires authorization performed using the `steamcmd` executable included with
the SteamWorks SDK. This command generates a file `config.vdf` that includes an authorization
token. Unfortunately, this is currently a fairly manual process, and the token has
an expiration date so this process must be repeated (approximately) every 30 days

For GitHub actions that deploy to steam you will need to include the contents of a recent
Steam `config.vdf` file (base64 encoded) as the `configVdf` input argument. This should be
provided via a GitHub secret

```
  configVdf: ${{ secrets.STEAM_CONFIG_VDF }}
```

There are 2 options for generating the `config.vdf` file that you will need to copy into the
GitHub secret

  * **via Docker** - we provide a docker container that makes it easy to run the `steamcmd` to generate the file
  * **via steamcmd directly** - if you prefer you can follow the instructions below to use `steamcmd` directly

## Generating the secret via Docker

If you have Docker installed, the easiest way to generate the `config.vdf` file is to use
the [vaguevoid/steam-login](https://hub.docker.com/r/vaguevoid/steam-login)
Docker image from your terminal:

```bash
> docker run -it -v .:/out vaguevoid/steam-login [USERNAME]

Steam> Enter you password:
Steam> Enter your Steam Guard code:

> cat ./config.vdf    # copy the contents of this file as your `STEAM_CONFIG_VDF` GitHub secret
```

## Generating the secret via steamcmd directly

If you prefer to generate the `config.vdf` file directly using `steamcmd` instead of our docker
image, you can download the [latest Steam SDK from here](https://partner.steamgames.com/doc/sdk)
and once downloaded, you will find the `steamcmd` executable for your platform in one
of the following locations

  * **Windows**: sdk/tools/ContentBuilder/builder/steamcmd.exe
  * **MacOS**: sdk/tools/ContentBuilder/builder_osx/steamcmd
  * **Linux**: sdk/tools/ContentBuilder/builder_linux/linux32/steamcmd

You will need to ensure that `steamcmd` is executable:

```bash
> chmod ugo+x steamcmd
```

Once installed, you can use `steamcmd` to perform a manual login

```bash
> steamcmd +login [USERNAME] +quit                  # REPLACE [USERNAME] WITH YOUR STEAM USERNAME

# <SNIP loading output>...
Loading Steam API...OK

Logging in user 'username' to Steam Public...
password: **********                                # <----- ENTER YOUR PASSWORD

Enter the current code from your Steam Guard Mobile Authenticator app
Two-factor code: *****                              # <----- ENTER YOUR STEAM GUARD CODE HERE
OK
```

The Two-factor-code that you will be asked for depends on your MFA setup:
  * **via email** - code will be sent via email,  copy it into the terminal
  * **via mobile app** - launch the Steam app on your phone but instead of scanning a QR code you
    will click the "show steam guard code" button instead - copy the code to your terminal.

Once the `steamcmd +login` command is complete, a `config.vdf` file will be generated in the Steam
configuration directory:

  * **Windows** - `C:\Program Files (x86)\Steam\config\config.vdf`
  * **Mac OS** - `~/Library/Application Support/Steam/config/config.vdf`
  * **Linux** - `~/.steam/steam/config/config.vdf`

One final step before you can save the contents into a GitHub Actions secret is to base64 encode it:

```bash
cat config.vdf | base64 > encoded.config.vdf
cat encoded.config.vdf                             # COPY CONTENTS OF THIS FILE TO GITHUB SECRETS
```

Unfortunately, you may need to repeat these steps every 30 days! I recommend using the docker
image to simplify this process.
