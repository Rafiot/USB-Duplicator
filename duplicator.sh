#!/bin/bash

set -e
#set -x

SRC_DIR="./source/"

DST_DEV_LIST=`ls /dev/sd*1 | grep -v sda || true`


clean(){
    echo Done, cleaning.
    /bin/sync
    if grep -q /mnt/duplicator /proc/mounts ; then
        umount /mnt/duplicator
    fi
    rm -rf /mnt/duplicator
}

trap clean EXIT TERM INT

mkdir -p /mnt/duplicator
echo About to copy:
ls -la ${SRC_DIR}*

read -p "Do you want to continue (Y/N)?"

[ "$(echo $REPLY | tr [:upper:] [:lower:])" == "y" ] || exit

for partition in ${DST_DEV_LIST}
do
    echo Copying to ${partition}
    mount ${partition} /mnt/duplicator
    cp ${SRC_DIR}* /mnt/duplicator/
    ls -la /mnt/duplicator/
    umount /mnt/duplicator
done


