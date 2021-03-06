#!/bin/sh

set -e

CONFIG_EMACSCLIENT="${EMACSCLIENT:-/usr/local/bin/emacsclient}"
CONFIG_BROWSER="${BROWSWER:-Google Chrome}"

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

if [ "$VAR_APP" = "Emacs" ]; then
  if [ "$VAR_PROTOCOL" = "echo" ]; then
    echo "${CONFIG_EMACSCLIENT}" -e '(with-current-buffer (window-buffer (car (window-list))) (org-capture))'
  else
    echo "Capture current Emacs buffer"
    ${CONFIG_EMACSCLIENT} -e '(with-current-buffer (window-buffer (car (window-list))) (org-capture))' &> /dev/null
  fi
  return
fi

oIFS="$IFS"
IFS=$'\n'
VAR_LINES=($(osascript capture.applescript "$VAR_APP" "$CONFIG_BROWSER"))
IFS="$oIFS"

for VAR_DATA in "${VAR_LINES[@]}"; do
  if [ "$VAR_PROTOCOL" = "echo" ]; then
    echo "${CONFIG_EMACSCLIENT}" "org-protocol://capture://b/${VAR_DATA}"
  else
    echo "${VAR_DATA%/*}" | ruby -ruri -pe '$_ = URI.unescape($_.split("/").reverse.join(" "))'
    ${CONFIG_EMACSCLIENT} "org-protocol://${VAR_PROTOCOL}://${VAR_TEMPLATE}${VAR_DATA}" &> /dev/null
  fi
done
