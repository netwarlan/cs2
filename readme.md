# Counter Strike 2

[![Build](https://img.shields.io/github/actions/workflow/status/netwarlan/cs2/build.yml)](https://github.com/netwarlan/cs2/actions)
[![Release](https://img.shields.io/github/v/release/netwarlan/cs2)](https://github.com/netwarlan/cs2/releases)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2?logo=discord&logoColor=white)](https://discord.gg/QtqKW9xvzK)

The following repository contains the source files for building a CS2 server.

### Notice
This stuff is brand new and will certainly change over time. Some of the below settings don't appear to work anymore, like maxplayers.

### Running
To run the container, issue the following example command:
```
docker run -d \
-p 27015:27015/udp \
-p 27015:27015/tcp \
-e CS2_SERVER_HOSTNAME="DOCKER CS2" \
ghcr.io/netwarlan/cs2:latest
```

### Downloading Game Files Only
To pre-download game files without starting the server (useful for pre-populating volumes):
```
docker run --rm -v cs2-data:/app/cs2 \
-e CS2_SERVER_UPDATE_ONLY_THEN_STOP=true \
ghcr.io/netwarlan/cs2:latest
```

To download and validate game files:
```
docker run --rm -v cs2-data:/app/cs2 \
-e CS2_SERVER_VALIDATE_ONLY_THEN_STOP=true \
ghcr.io/netwarlan/cs2:latest
```

### Environment Variables
We can make dynamic changes to our CS2 containers by adjusting some of the environment variables passed to our image.
Below are the ones currently supported and their (defaults):

Environment Variable | Default Value
-------------------- | -------------
CS2_SERVER_IP | Not set
CS2_SERVER_PORT | 27015
CS2_SERVER_MAXPLAYERS | 16
CS2_SERVER_MAP | de_dust2
CS2_SERVER_HOSTNAME | CS2 Server
CS2_SERVER_PW | No password set
CS2_SERVER_RCONPW | No password set
CS2_SERVER_STEAMACCOUNT | No account set (needed for public servers)
CS2_SERVER_UPDATE_ON_START | true
CS2_SERVER_VALIDATE_ON_START | false
CS2_SERVER_UPDATE_ONLY_THEN_STOP | false
CS2_SERVER_VALIDATE_ONLY_THEN_STOP | false
CS2_SERVER_GAME_MODE_CONFIG | Not set
CS2_SERVER_GAME_TYPE | 0
CS2_SERVER_GAME_MODE | 0
CS2_SERVER_MAPGROUP | mg_active
CS2_SERVER_REMOTE_CFG | Not set
CS2_SERVER_GOTV_ENABLE | 0
CS2_SERVER_GOTV_PORT | 27020
CS2_SERVER_GOTV_NAME | CS2 TV
CS2_SERVER_GOTV_DELAY | 60
CS2_SERVER_GOTV_PASSWORD | Not set
CS2_SERVER_GOTV_TITLE | CS2 TV
CS2_SERVER_GOTV_MAXCLIENTS | 3
CS2_SERVER_GOTV_AUTORECORD | 1
CS2_SERVER_GOTV_BROADCAST | 0
CS2_SERVER_LOGS_DIRECTORY | logs