#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
myver="0.0"
if [ -f /usr/share/myver ]; then
        myver=$(cat /usr/share/myver)
fi

if [[ $myver != 1.1 ]]; then
	echo "Updating U-Boot to Improve Support for booting other distros..."
	SYSPART=$(findmnt -n -o SOURCE /)
	if echo $SYSPART | grep -qE 'p[0-9]$' ; then
		DEVID=$(echo $SYSPART | sed -e s+'p[0-9]$'+''+)
	else
		DEVID=$(echo $SYSPART | sed -e s+'[0-9]$'++)
	fi
	echo Identified $DEVID as device to flash uboot to...
	if [ -f $DIR/idbloader.img ] ; then
		echo "Upgrading idbloader.img..."
		dd if=$DIR/idbloader.img of=$DEVID bs=32k seek=1 conv=fsync &>/dev/null
	fi
	if [ -f $DIR/uboot.img ] ; then
		echo "Upgrading uboot.img..."
		dd if=$DIR/uboot.img of=$DEVID bs=64k seek=128 conv=fsync &>/dev/null
	fi
	if [ -f $DIR/trust.img ] ; then
		echo "Upgrading trust.img..."
		dd if=$DIR/trust.img of=$DEVID bs=64k seek=192 conv=fsync &>/dev/null
	fi
fi

echo "Updating Kernel Modules to 4.4.196..."
mv $DIR/4.4.196 /lib/modules

echo
echo "Installing WiDevine Update Script..."
mv $DIR/*.desktop /home/rock/Desktop
mv $DIR/update_widevine.sh /usr/bin

