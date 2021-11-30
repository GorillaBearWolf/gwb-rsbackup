!/bin/bash

# Required permissions for this file:
# sudo chmod 777 FILEPATH
# sudo chmod a+x FILEPATH

# Disable sudo password:
# sudo visudo
# User privilege specification
# root    ALL=(ALL) ALL
# %admin  ALL=(ALL) NOPASSWD:ALL

# Launch Control commands:
# launchctl load ~/Library/LaunchAgents/mpr.backup.plist
# launchctl unload ~/Library/LaunchAgents/mpr.backup.plist
# launchctl start mpr.backup
# launchctl stop mpr.backup
# launchctl list | grep mpr.backup

LOG="/tmp/backup.log"

OPTS=("-azP" "--exclude=.DS_Store" "--exclude=Parallels" "--exclude=Desktop/$RECYCLE.BIN")

BKUP=("$HOME/Desktop" "$HOME/Documents" "$HOME/Downloads" "$HOME/Google Drive")

BDIR="/Users/mpr/Shares/Backup"

W10="//USERNAME:PASSWORD@BACKUP-LOCATION"

MNT="/Users/mpr/Shares"

printf "#####################################################################\nSCRIPT START: `date`\n\nSLEEPING FOR 30 SECONDS...\n\n" > $LOG

sleep 30

printf "UNMOUNTING NETWORK SHARE... " >> $LOG

umount $MNT

sleep 1

printf "SUCCESS.\n\nREFRESHING MOUNT POINT... " >> $LOG

rm -r $MNT

sleep 1

mkdir $MNT

sleep 1

chmod 777 $MNT

sleep 1

printf "SUCCESS.\n\nMOUNTING NETWORK SHARE... " >> $LOG

mount -t smbfs $W10 $MNT

sleep 2

printf "SUCCESS.\n\nBACKUP START: `date`\n\n" >> $LOG

START=`date +%s`

sudo rsync "${OPTS[@]}" "${BKUP[@]}" $BDIR >> $LOG

END=`date +%s`

printf "\nBACKUP END: `date`\n\nCOMPLETED IN $(($END-$START)) SECONDS\n#####################################################################" >> $LOG
