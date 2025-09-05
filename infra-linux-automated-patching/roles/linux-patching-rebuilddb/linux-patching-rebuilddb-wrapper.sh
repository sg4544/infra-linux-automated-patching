#!/bin/bash
# Wrapper script to run linux-patching-rebuilddb playbook and log output

LOG_DIR="/var/log/linux-patching-rebuilddb"
DATETIME=$(date '+%Y%m%d-%H%M%S')
LOG_FILE="$LOG_DIR/linux-patching-rebuilddb-$DATETIME.log"
PLAYBOOK_PATH="$(dirname "$0")/linux-patching-rebuilddb-playbook.yml"

if [ ! -d "$LOG_DIR" ]; then
  echo "Log directory $LOG_DIR does not exist. Creating..."
  mkdir -p "$LOG_DIR"
fi

if [ ! -f "$PLAYBOOK_PATH" ]; then
  echo "Playbook $PLAYBOOK_PATH not found!"
  exit 1
fi

ansible-playbook "$PLAYBOOK_PATH" | tee "$LOG_FILE"
echo "Log saved to $LOG_FILE"
