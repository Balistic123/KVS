#!/bin/bash
# KVS: Kernel Version Switcher
# Written by kxtzownsu / kxtz#8161
# https://kxtz.dev
# Licensed under GNU Affero GPL v3

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "$0 $(printf '\033[1;31mMUST\033[0m') be ran as root/sudo!"
    exit
fi

version=1
GITHUB_URL="https://github.com/kxtzownsu/KVS"
tpmver=$(tpmc tpmver)

if [ "$tpmver" == "2.0" ]; then
  tpmdaemon="trunksd"
else
  tpmdaemon="tscd"
fi

# give me thy kernver NOW
case "$(crossystem tpm_kernver)" in
  "0x00000000")
    kernver="0"
    ;;
  "0x00010001")
    kernver="1"
    ;;
  "0x00010002")
    kernver="2"
    ;;
  "0x00010003")
    kernver="3"
    ;;
  *)
    panic "invalid-kernver"
    ;;
esac

# detect if booted from usb boot or from recovery boot
if [ "$(crossystem mainfw_type)" == "recovery" ]; then
  source /usr/sbin/kvs/tpmutil.sh
  source /usr/share/kvs/functions.sh
  mkdir /mnt/state &2> /dev/zero
  mount /dev/disk/by-label/KVS /mnt/state
elif [ "$(crossystem mainfw_type)" == "developer" ]; then
  panic "non-reco"
  clear
  sleep infinity
  . ./functions.sh
  . ./tpmutil.sh
  source ./functions.sh
  source ./tpmutil.sh
  style_text "YOU ARE RUNNING A DEBUG VERSION OF KVS, THIS WAS OPTIMIZED TO RUN ON CHROMEOS ONLY! ALL ACTIONS ARE PURELY VISUAL AND NOT FUNCTIONAL IN THIS MODE!!!"
  sleep 5
  clear
fi

credits(){
  echo "KVS: Kernel Version Switcher"
  echo "v$version"
  echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  echo "kxtzownsu - Writing KVS, Providing kernver 0 & kernver 1 files."
  echo "??? - Providing kernver 2 files."
  echo "TBD - Providing kernver 3 files."
  echo "Google - Writing the `tpmc` command :3"
}

endkvs(){
  # reboot now
  stopwatch
}


main(){
  if [ $() ]
  echo "KVS: Kernel Version Switcher v$version"
  echo "Current kernver: $kernver"
  echo "TPM Version: $tpmver"
  echo "TPMD: $tpmdaemon"
  echo "=-=-=-=-=-=-=-=-=-=-"
  echo "1) Set New kernver"
  echo "2) Backup kernver (WIP, Kinda Broken)"
  echo "3) Credits"
  echo "4) Exit"
  read -rep "> " sel
  
  selection $sel
}


while true; do
  main
done
