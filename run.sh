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
CS2_SERVER_PORT="${CS2_SERVER_PORT:-27015}"
CS2_SERVER_MAXPLAYERS="${CS2_SERVER_MAXPLAYERS:-16}"
CS2_SERVER_MAP="${CS2_SERVER_MAP:-de_dust2}"
CS2_SERVER_SVLAN="${CS2_SERVER_SVLAN:-0}"
CS2_SERVER_HOSTNAME="${CS2_SERVER_HOSTNAME:-CS2 Server}"
CS2_SERVER_STEAMACCOUNT="${CS2_SERVER_STEAMACCOUNT:-}"
CS2_SERVER_GAME_TYPE="${CS2_SERVER_GAME_TYPE:-0}"
CS2_SERVER_GAME_MODE="${CS2_SERVER_GAME_MODE:-0}"
CS2_SERVER_GAME_MODE_CONFIG="${CS2_SERVER_GAME_MODE_CONFIG:-}"
CS2_SERVER_MAPGROUP="${CS2_SERVER_MAPGROUP:-mg_active}"
CS2_SERVER_UPDATE_ON_START="${CS2_SERVER_UPDATE_ON_START:-true}"
CS2_SERVER_VALIDATE_ON_START="${CS2_SERVER_VALIDATE_ON_START:-false}"
CS2_SERVER_REMOTE_CFG="${CS2_SERVER_REMOTE_CFG:-}"
CS2_SERVER_GOTV_ENABLE="${CS2_SERVER_GOTV_ENABLE:-0}"
CS2_SERVER_GOTV_PORT="${CS2_SERVER_GOTV_PORT:-27020}"
CS2_SERVER_GOTV_NAME="${CS2_SERVER_GOTV_NAME:-CS2 TV}"
CS2_SERVER_GOTV_DELAY="${CS2_SERVER_GOTV_DELAY:-60}"
CS2_SERVER_GOTV_PASSWORD="${CS2_SERVER_GOTV_PASSWORD:-}"
CS2_SERVER_GOTV_TITLE="${CS2_SERVER_GOTV_TITLE:-CS2 TV}"
CS2_SERVER_GOTV_AUTORECORD="${CS2_SERVER_GOTV_AUTORECORD:-1}"
CS2_SERVER_GOTV_MAXCLIENTS="${CS2_SERVER_GOTV_MAXCLIENTS:-3}"
CS2_SERVER_GOTV_BROADCAST="${CS2_SERVER_GOTV_BROADCAST:-1}"
CS2_SERVER_LOGS_DIRECTORY="${CS2_SERVER_LOGS_DIRECTORY:-logs}"
[[ -n "$CS2_SERVER_IP" ]] && CS2_SERVER_IP="-ip $CS2_SERVER_IP"
[[ -n "$CS2_SERVER_PW" ]] && CS2_SERVER_PW="+sv_password $CS2_SERVER_PW"
[[ -n "$CS2_SERVER_RCONPW" ]] && CS2_SERVER_RCONPW="+rcon_password $CS2_SERVER_RCONPW"

## Validate numeric inputs
## ==============================================
if [[ ! "$CS2_SERVER_PORT" =~ ^[0-9]+$ ]]; then
  echo "Error: CS2_SERVER_PORT must be a valid number"
  exit 1
fi
if [[ ! "$CS2_SERVER_MAXPLAYERS" =~ ^[0-9]+$ ]]; then
  echo "Error: CS2_SERVER_MAXPLAYERS must be a valid number"
  exit 1
fi




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

  "$STEAMCMD_DIR/steamcmd.sh" \
  +force_install_dir "$GAME_DIR" \
  +login "$STEAMCMD_USER" "$STEAMCMD_PASSWORD" "$STEAMCMD_AUTH_CODE" \
  +app_update "$STEAMCMD_APP" $VALIDATE_FLAG \
  +quit

fi


## Download server config if needed
## ==============================================
if [[ -n "$CS2_SERVER_REMOTE_CFG" ]]; then
echo "
╔═══════════════════════════════════════════════╗
║ Downloading remote config                     ║
╚═══════════════════════════════════════════════╝"
  ## Check if we are casual or competitive gamemode
  if [[ "$CS2_SERVER_GAME_TYPE" -eq "0" ]] && [[ "$CS2_SERVER_GAME_MODE" -eq "0" ]]; then
    echo " - Downloading Casual config..."
    wget -q "$CS2_SERVER_REMOTE_CFG" -O "$GAME_DIR/game/csgo/cfg/gamemode_casual_server.cfg"

  elif [[ "$CS2_SERVER_GAME_TYPE" -eq "0" ]] &&  [[ "$CS2_SERVER_GAME_MODE" -eq "1" ]]; then
    echo " - Downloading Competitive config..."
    wget -q "$CS2_SERVER_REMOTE_CFG" -O "$GAME_DIR/game/csgo/cfg/gamemode_competitive_server.cfg"

  elif [[ "$CS2_SERVER_GAME_TYPE" -eq "1" ]] &&  [[ "$CS2_SERVER_GAME_MODE" -eq "0" ]]; then
    echo " - Downloading Arms Race config..."
    wget -q "$CS2_SERVER_REMOTE_CFG" -O "$GAME_DIR/game/csgo/cfg/gamemode_armsrace_server.cfg"
  fi

fi



## Download gamemode config if needed
## ==============================================
if [[ -n "$CS2_SERVER_GAME_MODE_CONFIG" ]]; then
echo "
╔═══════════════════════════════════════════════╗
║ Downloading gamemode config                   ║
╚═══════════════════════════════════════════════╝"
  echo " - Downloading gamemode config..."
  wget -q "$CS2_SERVER_GAME_MODE_CONFIG" -O "$GAME_DIR/game/csgo/gamemodes_server.txt"
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
║ Starting server                               ║
╚═══════════════════════════════════════════════╝"

"$GAME_DIR/game/bin/linuxsteamrt64/cs2" -dedicated -usercon -secure \
+hostname \"${CS2_SERVER_HOSTNAME}\" \
$CS2_SERVER_IP \
-port "$CS2_SERVER_PORT" \
-maxplayers "$CS2_SERVER_MAXPLAYERS" \
+map "$CS2_SERVER_MAP" \
+game_type "$CS2_SERVER_GAME_TYPE" \
+game_mode "$CS2_SERVER_GAME_MODE" \
+mapgroup "$CS2_SERVER_MAPGROUP" \
$CS2_SERVER_RCONPW \
$CS2_SERVER_PW \
+sv_setsteamaccount "$CS2_SERVER_STEAMACCOUNT" \
+tv_enable "$CS2_SERVER_GOTV_ENABLE" \
+tv_port "$CS2_SERVER_GOTV_PORT" \
+tv_name \"${CS2_SERVER_GOTV_NAME}\" \
+tv_delay "$CS2_SERVER_GOTV_DELAY" \
+tv_password \"${CS2_SERVER_GOTV_PASSWORD}\" \
+tv_title \"${CS2_SERVER_GOTV_TITLE}\" \
+tv_maxclients "$CS2_SERVER_GOTV_MAXCLIENTS" \
+tv_autorecord "$CS2_SERVER_GOTV_AUTORECORD" \
+tv_broadcast "$CS2_SERVER_GOTV_BROADCAST" \
+sv_logfile 1 -serverlogging \
+sv_logsdir "$CS2_SERVER_LOGS_DIRECTORY"