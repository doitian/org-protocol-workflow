#!/bin/sh

set -e

CONFIG_EMACSCLIENT="${EMACSCLIENT:-/usr/local/bin/emacsclient}"

VAR_PROTOCOL=${1:-capture}

VAR_TEMPLATE=
if [ "$VAR_PROTOCOL" = capture ]; then
  VAR_TEMPLATE="b/"
fi

if [ -n "$2" ]; then
  VAR_APP="$2"
else
  VAR_APP=$(osascript -e '
    tell application "System Events"
      item 1 of (get short name of processes whose frontmost is true)
    end tell')
fi

oIFS="$IFS"
IFS=$'\n'
VAR_LINES=($(osascript capture.applescript "$VAR_APP"))
IFS="$oIFS"

for VAR_DATA in "${VAR_LINES[@]}"; do
  if [ "$VAR_PROTOCOL" = "echo" ]; then
    echo "${CONFIG_EMACSCLIENT}" "org-protocol://capture://b/${VAR_DATA}"
  else
    ${CONFIG_EMACSCLIENT} "org-protocol://${VAR_PROTOCOL}://${VAR_TEMPLATE}${VAR_DATA}"
  fi
done
