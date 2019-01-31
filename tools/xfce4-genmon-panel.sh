#!/bin/bash

set -euo pipefail

_DATE="$(date --iso-8601=minutes)"
_USER="$(whoami)"
_HOST="$(hostname)"
_WIFI="$(nmcli --terse --fields name connection show --active | tr ' ' _ | xargs | tr ' ' ,)"
_UPTIME="$(uptime --pretty)"
_IP="$(ip -json route show scope link | jq --raw-output '.[].prefsrc' | xargs | tr ' ' ,)"
_PUBLIC_IP="$(curl --connect-timeout 1 --silent --fail https://httpbin.org/ip | jq --raw-output .origin)"
_BAT="$(for bat in $(ls /sys/class/power_supply); do [[ -e "/sys/class/power_supply/${bat}/capacity" ]] && echo ${bat} $(cat "/sys/class/power_supply/${bat}/capacity")\%; done)"
[[ -z ${_BAT} ]] && _BAT='AC'

_MSG="<span fgcolor='YellowGreen' font-style='italic'>${_USER}</span>@<span fgcolor='Yellow'>${_HOST}</span> ⏰ $_UPTIME 🔋 $_BAT 🖧  <span fgcolor='Turquoise'>$_WIFI</span> ($_IP) 🌐 $_PUBLIC_IP 📆 <span fgcolor='LightGreen'>$_DATE</span>"
echo "<txt>${_MSG}</txt>"
echo "<tool>${_MSG}</tool>"
