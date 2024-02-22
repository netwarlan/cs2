#!/usr/bin/env bash

echo "


╔═══════════════════════════════════════════════╗
║                                               ║
║       _  _____________      _____   ___       ║
║      / |/ / __/_  __/ | /| / / _ | / _ \      ║
║     /    / _/  / /  | |/ |/ / __ |/ , _/      ║
║    /_/|_/___/ /_/   |__/|__/_/ |_/_/|_|       ║
║                                 OFFICIAL      ║
║                                               ║
╠═══════════════════════════════════════════════╣
║ Thanks for using our DOCKER image! Should you ║
║ have issues, please reach out or create a     ║
║ github issue. Thanks!                         ║
║                                               ║
║ For more information:                         ║
║ github.com/netwarlan                          ║
╚═══════════════════════════════════════════════╝"


## Set default values if none were provided
## ==============================================
[[ ! -z "$CS2_SERVER_IP" ]] && CS2_SERVER_IP="-ip $CS2_SERVER_IP"
[[ -z "$CS2_SERVER_PORT" ]] && CS2_SERVER_PORT="27015"
[[ -z "$CS2_SERVER_MAXPLAYERS" ]] && CS2_SERVER_MAXPLAYERS="16"
[[ -z "$CS2_SERVER_MAP" ]] && CS2_SERVER_MAP="de_dust2"
[[ -z "$CS2_SERVER_SVLAN" ]] && CS2_SERVER_SVLAN="0"
[[ -z "$CS2_SERVER_HOSTNAME" ]] && CS2_SERVER_HOSTNAME="CS2 Server"
[[ ! -z "$CS2_SERVER_PW" ]] && CS2_SERVER_PW="+sv_password $CS2_SERVER_PW"
[[ ! -z "$CS2_SERVER_RCONPW" ]] && CS2_SERVER_RCONPW="+rcon_password $CS2_SERVER_RCONPW"
[[ -z "$CS2_SERVER_STEAMACCOUNT" ]] && CS2_SERVER_STEAMACCOUNT=""
[[ -z "$CS2_SERVER_GAME_TYPE" ]] && CS2_SERVER_GAME_TYPE="0"
[[ -z "$CS2_SERVER_GAME_MODE" ]] && CS2_SERVER_GAME_MODE="0"
[[ -z "$CS2_SERVER_GAME_MODE_CONFIG" ]] && CS2_SERVER_GAME_MODE_CONFIG=""
[[ -z "$CS2_SERVER_MAPGROUP" ]] && CS2_SERVER_MAPGROUP="mg_active"
[[ -z "$CS2_SERVER_UPDATE_ON_START" ]] && CS2_SERVER_UPDATE_ON_START=true
[[ -z "$CS2_SERVER_VALIDATE_ON_START" ]] && CS2_SERVER_VALIDATE_ON_START=false
[[ -z "$CS2_SERVER_GOTV_ENABLE" ]] && CS2_SERVER_GOTV_ENABLE="0"
[[ -z "$CS2_SERVER_GOTV_PORT" ]] && CS2_SERVER_GOTV_PORT="27020"
[[ -z "$CS2_SERVER_GOTV_NAME" ]] && CS2_SERVER_GOTV_NAME="CS2 TV"
[[ -z "$CS2_SERVER_GOTV_DELAY" ]] && CS2_SERVER_GOTV_DELAY="60"
[[ -z "$CS2_SERVER_GOTV_PASSWORD" ]] && CS2_SERVER_GOTV_PASSWORD=""
[[ -z "$CS2_SERVER_GOTV_TITLE" ]] && CS2_SERVER_GOTV_TITLE="CS2 TV"
[[ -z "$CS2_SERVER_GOTV_MAXCLIENTS" ]] && CS2_SERVER_GOTV_MAXCLIENTS="3"
[[ -z "$STEAMCMD_USER" ]] && STEAMCMD_USER="anonymous"
[[ -z "$STEAMCMD_PASSWORD" ]] && STEAMCMD_PASSWORD=""
[[ -z "$STEAMCMD_AUTH_CODE" ]] && STEAMCMD_AUTH_CODE=""

## Update on startup
## ==============================================
if [[ "$CS2_SERVER_UPDATE_ON_START" = true ]] || [[ "$CS2_SERVER_VALIDATE_ON_START" = true ]]; then
echo "
╔═══════════════════════════════════════════════╗
║ Checking for updates                          ║
╚═══════════════════════════════════════════════╝"
  if [[ "$CS2_SERVER_VALIDATE_ON_START" = true ]]; then
    VALIDATE_FLAG='validate'
  else
    VALIDATE_FLAG=''
  fi

  $STEAMCMD_DIR/steamcmd.sh \
  +force_install_dir $GAME_DIR \
  +login $STEAMCMD_USER $STEAMCMD_PASSWORD $STEAMCMD_AUTH_CODE \
  +app_update $STEAMCMD_APP $VALIDATE_FLAG \
  +quit

fi


## Download gamemode config if needed
## ==============================================
if [[ "$CS2_SERVER_GAME_MODE_CONFIG" ]]; then
echo "
╔═══════════════════════════════════════════════╗
║ Downloading gamemode config                   ║
╚═══════════════════════════════════════════════╝"
  echo " - Downloading gamemode config..."
  wget -q $CS2_SERVER_GAME_MODE_CONFIG -O $GAME_DIR/game/csgo/gamemodes_server.txt
fi





## Print Variables
## ==============================================
echo "
╔═══════════════════════════════════════════════╗
║ Server set with provided values               ║
╚═══════════════════════════════════════════════╝"
printenv | grep CS2




## Run
## ==============================================
echo "
╔═══════════════════════════════════════════════╗
║ Starting SERVER                               ║
╚═══════════════════════════════════════════════╝"

$GAME_DIR/game/bin/linuxsteamrt64/cs2 -dedicated -usercon -secure \
+hostname \"${CS2_SERVER_HOSTNAME}\" \
$CS2_SERVER_IP \
-port $CS2_SERVER_PORT \
-maxplayers $CS2_SERVER_MAXPLAYERS \
+map $CS2_SERVER_MAP \
+game_type $CS2_SERVER_GAME_TYPE \
+game_mode $CS2_SERVER_GAME_MODE \
+mapgroup $CS2_SERVER_MAPGROUP \
$CS2_SERVER_RCONPW \
$CS2_SERVER_PW \
+sv_setsteamaccount $CS2_SERVER_STEAMACCOUNT \
+tv_enable $CS2_SERVER_GOTV_ENABLE \
+tv_port $CS2_SERVER_GOTV_PORT \
+tv_name \"${CS2_SERVER_GOTV_NAME}\" \
+tv_delay $CS2_SERVER_GOTV_DELAY \
+tv_password \"${CS2_SERVER_GOTV_PASSWORD}\" \
+tv_title \"${CS2_SERVER_GOTV_TITLE}\" \
+tv_maxclients $CS2_SERVER_GOTV_MAXCLIENTS