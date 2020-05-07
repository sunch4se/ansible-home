#!/bin/sh

### wake up nas
/usr/bin/wakeonlan 00:11:32:51:85:CD

### wait for nas.fritz.box to be reachable
until ping -c1 nas.fritz.box >/dev/null 2>&1; do :; done

### mount nas nfs target
/usr/bin/sudo /bin/mount /backup

### synch /docker/config to nas
sudo /usr/bin/rsync -avh --delete /docker/config/ /backup/docker/config/

### umount nas nfs target
/usr/bin/sudo /bin/umount /backup
