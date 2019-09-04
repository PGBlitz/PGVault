#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /pg/pgvault/functions/initial.sh
source /pg/pgvault/functions/restorecheck.sh

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
  rclone config --config /pg/rclone/blitz.conf
}

runningcheck() {
  initial2
  runcheck5=$(docker ps | grep ${program_var})
  if [ "$runcheck5" != "" ]; then running=1; else running=0; fi
}

final() {
  echo
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  read -p '✅ Process Complete! | PRESS [ENTER] ' typed </dev/tty
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  bash /pg/pgvault/pgvault.sh
  exit
}

queued() {
  echo
  read -p "⛔️ ERROR - $typed Already Queued! | Press [ENTER] " typed </dev/tty
}

badserver() {
  echo
  read -p '⛔️ ERROR - Type an Exact Server Name | Press [ENTER] ' typed </dev/tty
}

#not used yet
rclonelist() {
  ls -l /mnt/gdrive/plexguide/backup | grep "^d" | awk '{print $9}' >pgvault.serverlist
}

pgboxrecall() {
  ls -p /pg/apps/programs | grep -v / >/pg/var/pgvault.apprecall
  while read p; do
    sed -i "/^$p\b/Id" /pg/var/pgvault.apprecall
  done </pg/pgvault/exempt.list

  while read p; do
    sed -i "/^$p\b/Id" /pg/var/pgvault.apprecall
    basename "$p" .yml >>/pg/var/pgvault.apprecall
  done </pg/var/pgvault.apprecall
}

mathprime() {
  ### List Out Apps In Readable Order (One's Not Installed)
  num=0
  rm -rf /pg/var/program.temp 1>/dev/null 2>&1
  while read p; do
    echo -n $p >>/pg/var/program.temp
    echo -n " " >>/pg/var/program.temp
    num=$((num + 1))
    if [ "$num" == 7 ]; then
      num=0
      echo " " >>/pg/var/program.temp
    fi
  done </pg/var/pgvault.apprecall
}

################################################ FOR BACKUP - START
apprecall() {
  tree -d -L 1 /pg/data | awk '{print $2}' | tail -n +2 | head -n -2 >/pg/var/pgvault.apprecall
  while read p; do
    sed -i "/^$p\b/Id" /pg/var/pgvault.apprecall
  done </pg/pgvault/exempt.list

  ### Blank Out Temp List
  rm -rf /pg/var/program.temp && touch /pg/var/program.temp
  mathprime
}

buildup() {
  echo "$typed" >>/pg/var/pgvault.buildup
  sed -i "/^$typed\b/Id" /pg/var/pgvault.apprecall

  num=0
  rm -rf /pg/var/pgvault.output 1>/dev/null 2>&1
  while read p; do
    echo -n $p >>/pg/var/pgvault.output
    echo -n " " >>/pg/var/pgvault.output
    if [ "$num" == 7 ]; then
      num=0
      echo " " >>/pg/var/pgvault.output
    fi
  done </pg/var/pgvault.buildup

  mathprime
  vaultbackup
}
################################################ FOR BACKUP - END
serverprime() {
  tree -d -L 1 /mnt/gdrive/plexguide/backup | awk '{print $2}' | tail -n +2 | head -n -2 >/tmp/server.list

  ### List Out Apps In Readable Order (One's Not Installed)
  num=0
  rm -rf /pg/var/program.temp 1>/dev/null 2>&1
  while read p; do
    echo -n $p >>/pg/var/program.temp
    echo -n " " >>/pg/var/program.temp
    num=$((num + 1))
    if [ "$num" == 7 ]; then
      num=0
      echo " " >>/pg/var/program.temp
    fi
  done </tmp/server.list

  servers=$(cat /pg/var/program.temp)
  server_id=$(cat /pg/var/server.id)

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Vault ~ Server Recall            📓 Reference: pgvault.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 Current [${server_id}] & Prior Servers Detected:

$servers

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Type Server Name | Press [ENTER]: ' server </dev/tty
  echo $server >/tmp/server.select

  if [[ "$server" == "exit" || "$server" == "Exit" || "$server" == "EXIT" || "$server" == "z" || "$server" == "Z" ]]; then exit; fi

  current2=$(cat /tmp/server.list | grep "\<$server\>")
  if [ "$current2" == "" ]; then
    badserver
    serverprime
  fi

  tempserver=$server
  ls -l /mnt/gdrive/plexguide/backup/$tempserver | awk '{print $9}' | tail -n +2 >/pg/var/pgvault.restoreapps

  ### Blank Out Temp List
  rm -rf /pg/var/pgvault.apprecall 1>/dev/null 2>&1
  touch /pg/var/pgvault.apprecall

  while read p; do
    basename "$p" .tar >>/pg/var/pgvault.apprecall
  done </pg/var/pgvault.restoreapps

  ### Blank Out Temp List
  rm -rf /pg/var/program.temp 1>/dev/null 2>&1
  touch /pg/var/program.temp
  mathprime
}

buildup2() {
  echo "$typed" >>/pg/var/pgvault.buildup
  sed -i "/^$typed\b/Id" /pg/var/pgvault.apprecall

  num=0
  rm -rf /pg/var/pgvault.output 1>/dev/null 2>&1
  while read p; do
    echo -n $p >>/pg/var/pgvault.output
    echo -n " " >>/pg/var/pgvault.output
    if [ "$num" == 7 ]; then
      num=0
      echo " " >>/pg/var/pgvault.output
    fi
  done </pg/var/pgvault.buildup

  mathprime
  vaultrestore
}
################################################ FOR RESTORE - START

################################################ FOR RESTORE - END

######################################################## START - PG Vault Backup

backup_all_start() {

  while read p; do
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG Vault - Backing Up: $p
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    sleep 1.5

    # Store Used Program
    echo $p >/tmp/program_var
    # Execute Main Program
    backup_process

    sleep 2
  done </pg/var/pgvault.apprecall
  final
}

backup_start() {
  while read p; do
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG Vault - Backing Up: $p
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    sleep 1.5

    # Store Used Program
    echo $p >/tmp/program_var
    # Execute Main Program
    backup_process

    sleep 2
  done </pg/var/pgvault.buildup
  final
}

backup_process() {
  initial2
  #tee <<-EOF

  #━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  #↘️  Determining Initial File Size - $program_var
  #━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  #EOF
  #size=$(du -sh --apparent-size /pg/data/$program_var | /usr/bin/awk '{print $1}')
  #sleep 2
  #echo "Initial File Size: $size"
  #sleep 2

  ##### Stop Docker Container if Running
  runningcheck
  if [ "$running" == "1" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Stopping Docker Container - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 1
    docker stop $program_var 1>/dev/null 2>&1
  fi

  ###### Start the Backup Process - Backup Locally First
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Zipping Data Locally - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  path=$(cat /pg/var/server.hd.path)
  tarlocation=$(cat /pg/var/data.location)
  server_id=$(cat /pg/var/server.id)

  tar \
    --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    --exclude-from=/pg/pgvault/exclude.list \
    -C /pg/data/${program_var} -cvf /pg/var//${program_var}.tar ./

  #tar \
  #--warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
  #--exclude-from=/pg/pgvault/exclude.list \
  #-cfv ${program_var}.tar /pg/data/${program_var}

  ##### Restart Docker Application if was Running Prior
  if [ "$running" == "1" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Restarting Docker Application - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 2
    docker restart $program_var 1>/dev/null 2>&1
  fi

  ###### Backing Up Files to GDrive
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Sending Zipped Data to Google Drive - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  rclone --config /pg/rclone/blitz.conf mkdir gdrive:/plexguide/backup/${server_id} 1>/dev/null 2>&1

  rclone --config /pg/rclone/blitz.conf \
    --stats-one-line --stats 1s --progress \
    moveto ${tarlocation}/${program_var}.tar \
    gdrive:/plexguide/backup/${server_id}/${program_var}.tar \
    -v --checksum --drive-chunk-size=64M --transfers=8

  ##### Remove File Incase
  rm -rf ${tarlocation}/${program_var}.tar 1>/dev/null 2>&1
}
######################################################## END - PG Vault Backup
#
##################################################### START - PG Vault Restore
restore_all_start() {

  while read p; do
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG Vault - Restoring: $p
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    sleep 1.5

    # Store Used Program
    echo $p >/tmp/program_var
    # Execute Main Program
    restore_process

    sleep 2
  done </pg/var/pgvault.apprecall
  final
}


restore_start() {

  while read p; do
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG Vault - Restoring: $p
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    sleep 1.5

    # Store Used Program
    echo $p >/tmp/program_var
    # Execute Main Program
    restore_process

    sleep 2
  done </pg/var/pgvault.buildup
  final
}

restore_process() {
  initial2
  srecall=$(cat /tmp/server.select)
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Determining Initial File Size - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  size=$(du -sh --apparent-size /mnt/gdrive/plexguide/backup/${srecall}/${program_var}.tar | /usr/bin/awk '{print $1}')
  sleep 2
  echo "Initial File Size: $size"
  sleep 2

  ###### Backing Up Files to GDrive
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Downloading Data From Google Drive - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  rclone --config /pg/rclone/blitz.conf --stats-one-line \
    --stats 1s --progress \
    copy gdrive:/plexguide/backup/${srecall}/${program_var}.tar \
    ${tarlocation} \
    -v --checksum --drive-chunk-size=64M --transfers=8

  ##### Stop Docker Container if Running
  runningcheck
  if [ "$running" == "1" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Stopping Docker Container - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 1
    docker stop $program_var 1>/dev/null 2>&1
  fi

  ###### Start the Backup Process - Backup Locally First
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  UnZipping & Restoring Data - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  mkdir -p "/pg/data/${program_var}"
  rm -rf "/pg/data/${program_var}/*"
  chown -R 1000:1000 "/pg/data/${program_var}"
  chmod -R 775 "/pg/data/${program_var}"
  tar -C /pg/data/${program_var} -xvf ${tarlocation}/${program_var}.tar
  chown -R 1000:1000 "/pg/data/${program_var}"
  chmod -R 775 "/pg/data/${program_var}"

  ##### Restart Docker Application if was Running Prior
  if [ "$running" == "1" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Restarting Docker Application - $program_var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 2
    docker restart $program_var 1>/dev/null 2>&1
  fi

  ##### Remove File Incase
  rm -rf ${tarlocation}/${program_var}.tar 1>/dev/null 2>&1
}
##################################################### END - PG Vault Restore
#
##################################################### START - Backup Interface
vaultbackup() {
  ### List Out Apps In Readable Order (One's Not Installed)
  notrun=$(cat /pg/var/program.temp)
  buildup=$(cat /pg/var/pgvault.output)

  if [ "$buildup" == "" ]; then buildup="NONE"; fi
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Vault ~ Data Storage             📓 Reference: pgvault.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 App Data available to Backup

$notrun

💾 Apps Queued for Backup

$buildup

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] Backup
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '🌍 Type APP for QUEUE | Type all to backup all apps | Press [ENTER]: ' typed </dev/tty

  if [[ "$typed" == "all" || "$typed" == "All" || "$typed" == "ALL" ]]; then
    backup_all_start
  fi
  if [[ "$typed" == "backup" || "$typed" == "a" || "$typed" == "A" ]]; then backup_start; fi
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then exit; fi

  current2=$(cat /pg/var/pgvault.buildup | grep "\<$typed\>")
  if [ "$current2" != "" ]; then
    queued
    vaultbackup
  fi

  cat /pg/var/pgvault.buildup >/tmp/appcheck.5
  cat /pg/var/pgvault.apprecall >>/tmp/appcheck.5
  current1=$(cat /tmp/appcheck.5 | grep "\<$typed\>")
  if [ "$current1" == "" ]; then badinput && vaultbackup; fi

  buildup
}
##################################################### END - Backup Interface
#
##################################################### START - Restore Interface
vaultrestore() {
  notrun=$(cat /pg/var/program.temp)
  buildup=$(cat /pg/var/pgvault.output)

  if [ "$buildup" == "" ]; then buildup="NONE"; fi
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Vault ~ Data Recall              📓 Reference: pgvault.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 App Data available to Restore

$notrun

💾 Apps Queued for Restore

$buildup

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] Restore
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '🌍 Type APP for QUEUE | Type all to restore all apps | Press [ENTER]: ' typed </dev/tty

  if [[ "$typed" == "all" || "$typed" == "All" || "$typed" == "ALL" ]]; then restore_all_start; fi

  if [[ "$typed" == "restore" || "$typed" == "a" || "$typed" == "A" ]]; then restore_start; fi

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then exit; fi

  current2=$(cat /pg/var/pgvault.buildup | grep "\<$typed\>")
  if [ "$current2" != "" ]; then
    queued
    vaultrestore
  fi

  cat /pg/var/pgvault.buildup >/tmp/appcheck.5
  cat /pg/var/pgvault.apprecall >>/tmp/appcheck.5
  current1=$(cat /tmp/appcheck.5 | grep "\<$typed\>")
  if [ "$current1" == "" ]; then badinput && vaultrestore; fi

  buildup2
}
##################################################### START Primary Interface
primaryinterface() {
  initial2
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁  PG Vault Interface ~ http://pgvault.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌵  PG Used Disk Space: $used of $capacity | $percentage Used Capacity

[1] Data Backup
[2] Data Restore
[3] Current Server ID  : $server_id
[4] Processing Location: $tarlocation
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty

  if [ "$typed" == "1" ]; then
    vaultbackup
    primaryinterface
  elif [ "$typed" == "2" ]; then
    serverprime
    vaultrestore
    primaryinterface
  elif [ "$typed" == "3" ]; then
    echo "0" >/pg/var/server.id.stored
    bash /pg/pgblitz/menu/interface/serverid.sh
    primaryinterface
  elif [ "$typed" == "4" ]; then
    bash /pg/pgvault/location.sh
    primaryinterface
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
    exit
  else
    badinput
    primaryinterface
  fi
}
##################################################### END Primary Interface
