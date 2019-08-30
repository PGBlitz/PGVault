#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
}

badinput1() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
  question1
}

variable() {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" >$1; fi
}

removemounts() {
  ansible-playbook /opt/plexguide/menu/remove/mounts.yml
}

readrcloneconfig() {
  touch /pg/rclone/rclone.conf
  mkdir -p /pg/rclone
  chown -R 1000:1000 /pg/rclone
  chown 0755 -R /pg/rclone

  gdcheck=$(cat /pg/rclone/blitz.conf | grep gd)
  if [[ "$gdcheck" != "" ]]; then echo "good" >/pg/var/gd.status && gdstatus="good"
  else echo "bad" >/pg/var/gd.status && gdstatus="bad"; fi

  sdcheck=$(cat /pg/rclone/blitz.conf | grep sd)
  if [[ "$sdcheck" != "" ]]; then echo "good" >/pg/var/sd.status && sdstatus="good"
  else echo "bad" >/pg/var/sd.status && sdstatus="bad"; fi

  gccheck=$(cat /pg/rclone/blitz.conf | grep gc)
  if [[ "$gccheck" != "" ]]; then echo "good" >/pg/var/gc.status && gcstatus="good"
  else echo "bad" >/pg/var/gc.status && gcstatus="bad"; fi

  sccheck=$(cat /pg/rclone/blitz.conf | grep sc)
  if [[ "$sccheck" != "" ]]; then echo "good" >/pg/var/sc.status && scstatus="good"
  else echo "bad" >/pg/var/sc.status && scstatus="bad"; fi

}

rcloneconfig() {
  rclone config --config /opt/appdata/plexguide/rclone.conf
}

keysprocessed() {
  mkdir -p /opt/appdata/plexguide/keys/processed
  ls -1 /opt/appdata/plexguide/keys/processed | wc -l >/pg/var/project.keycount
}
