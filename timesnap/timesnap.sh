#!/usr/bin/env bash

PATH=$PATH:/usr/bin

if [ -z "$1" ]
  then
    echo "No btrfs root specified!"
    exit 1
fi


if [ -z "$2" ]
  then
    echo "No src snapshot specified!"
    exit 1
fi

if [ -z "$3" ]
  then
    echo "No snapshot destination specified!"
    exit 1
fi

SNAPROOT=$1
SNAP=$SNAPROOT/$2
SNAPDIR=$SNAPROOT/$3
NSNAPS=$(( $4 - 1 ))

#mount snap root
function mountBtrfsRoot {
    if [ `mount | grep $SNAPROOT | wc -l` -eq 0 ]; then
	mount $SNAPROOT
    fi
}
mountBtrfsRoot

#delete old
function deleteOld {
    NUMSNAPS=`ls $SNAPDIR | wc -l`
    #echo Number of old snaps: $NUMSNAPS of $NSNAPS
    if [ "$NUMSNAPS" -gt "$NSNAPS" ]; then
	DEL=`ls $SNAPDIR | sort | head -1`
	#echo Deleting snap $SNAPDIR/$DEL
	btrfs subvolume delete $SNAPDIR/$DEL
	deleteOld
    fi
}

if [ -z "$4" ]; then
    echo "Number of snapsnots not specified! Assuming no limitations..."
    NSNAPS=36535
else
    deleteOld
fi



#make a new snap
DATE=`date --iso-8601=seconds --utc | cut -c -19`
#echo Creating snapshot of $SNAP into $SNAPDIR/$DATE
btrfs subvolume snapshot -r $SNAP $SNAPDIR/$DATE

