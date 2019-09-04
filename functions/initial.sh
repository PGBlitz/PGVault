#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /pg/pgvault/functions/functions.sh

initial() {
  rm -rf /pg/var/pgvault.output 1>/dev/null 2>&1
  rm -rf /pg/var/pgvault.buildup 1>/dev/null 2>&1
  rm -rf /pg/var/program.temp 1>/dev/null 2>&1
  rm -rf /pg/var/app.list 1>/dev/null 2>&1
  rm -rf /pg/var/pgvault.output 1>/dev/null 2>&1
  touch /pg/var/pgvault.output
  touch /pg/var/program.temp
  touch /pg/var/app.list
  touch /pg/var/pgvault.buildup
  touch /pg/var/pgvault.output
  touch /pg/var/rclone.size

  # establish initial variables
  variable /pg/var/tar.location "/pg/tmp"

  space=$(cat /pg/var/data.location)
  # To Get Used Space
  used=$(df -h /pg/var/ | tail -n +2 | awk '{print $3}')
  # To Get All Space
  capacity=$(df -h /pg/var/ | tail -n +2 | awk '{print $2}')
  # Percentage
  percentage=$(df -h /pg/var/ | tail -n +2 | awk '{print $5}')
}

initial2() {

  file="/pg/var/restore.id"
  if [ ! -e "$file" ]; then
    echo "NO_ID" >/pg/var/restore.id
  fi
  
  path=$(cat /pg/var/server.hd.path)
  tarlocation=$(cat /pg/var/tar.location)
  program_size=$(cat /pg/var/rclone.size)
  program_var=$(cat /tmp/program_var)
  server_id=$(cat /pg/var/server.id)
}
