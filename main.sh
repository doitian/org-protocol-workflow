#!/bin/sh

set -e 

CONFIG_EMACSCLIENT=emacsclient

VAR_PROTOCOL=${1:-capture}
VAR_TEMPLATE=

if [ "$VAR_PROTOCOL" = capture ]; then
  VAR_TEMPLATE="b/"
fi

# VAR_APP=$(osascript -e '
#   tell application "System Events"
#     item 1 of (get name of processes whose frontmost is true)
#   end tell')

VAR_APP="Path Finder"

oIFS="$IFS"
IFS=$'\n'
VAR_LINES=($(osascript capture.applescript "$VAR_APP"))
IFS="$oIFS"
for VAR_DATA in "${VAR_LINES[@]}"; do
  echo "${CONFIG_EMACSCLIENT}" "org-protocol://${VAR_PROTOCOL}://${VAR_TEMPLATE}${VAR_DATA}"
done
