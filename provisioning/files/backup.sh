#!/bin/sh

BACKUPLOG=/tmp/backuplog
DATE=`date +%F`

### wake up nas
/usr/bin/wakeonlan 00:11:32:51:85:CD

### wait for nas.fritz.box to be reachable
until ping -c1 nas.fritz.box >/dev/null 2>&1; do :; done

### mount nas nfs target
/usr/bin/sudo /bin/mount /backup

### synch /docker/config to nas
/usr/bin/sudo /usr/bin/rsync --stats -ah --delete /docker/config/ /backup/docker/config/ > /tmp/backuplog

### telegram send
/usr/bin/sed -i '1s/^/***** BACKUP COMPLETED *****\n\nDate: $DATE\n\n/' /tmp/backuplog
/usr/bin/printf "\n***** BACKUP COMPLETED *****" >> /tmp/backuplog
/usr/bin/cat $BACKUPLOG | /usr/local/bin/telegram-send --stdin

### synch .env file for traefik docker
/usr/bin/sudo /usr/bin/rsync -avh /docker/docker-compose/traefik/.env /backup/docker/docker-compose/traefik/

### umount nas nfs target
/usr/bin/sudo /bin/umount /backup

### cleanup
/usr/bin/rm $BACKUPLOG