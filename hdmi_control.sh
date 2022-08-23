#!/bin/sh

############ FUNCTIONS ############

printd(){
        echo "`date +%x%t%X%t` $1"
}

send_rs232(){
        sudo echo -e $1 > $2
}

############ VARIABLES ############

HOSTDEV="RASPI" #Use TEGRA for Jetson embedded

###################################

# 1. Insert drivers ATEN-UC232A1 which is prolific chip based
# sudo insmod /lib/modules/4.9.253-tegra/kernel/drivers/usb/serial/pl2303.ko
# sudo insmod /lib/modules/5.15.0-1013-raspi/kernel/drivers/usb/serial/pl2303.ko

MODRS232=`lsmod | grep -ie pl2303`


if [ -z "$MODRS232" ]
then
	echo "Inserting module for PL2303 Prolific USB to RS232"
	case "$HOSTDEV" in
		"RASPI")
			echo "Inserting module for RASPI"
			sudo insmod /lib/modules/$(uname -r)/kernel/drivers/usb/serial/pl2303.ko
		;;
		"TEGRA")
			echo "Inserting module for TEGRA"
			sudo insmod /lib/modules/$(uname -r)/kernel/drivers/usb/serial/pl2303.ko
		;;
	esac
else
	echo "PL2303 module already inserted"
fi

# 2. Add prolific ID so it is listed in: lsusb
#   Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
#   Bus 001 Device 006: ID 067b:23a3 Prolific Technology, Inc.
#   Bus 001 Device 003: ID 046d:c05a Logitech, Inc. M90/M100 Optical Mouse
# If this does not work, try with sudo, if not again change to root (sudo su).
#	Only need to do it once, e.g. first time setup for a new host device.
# 	Device ID number might be different for different cables. Pay attention.
# echo "067b 23a3" > /sys/bus/usb-serial/drivers/pl2303/new_id

echo "*** ### HDMI HUB CONTROL START ### ***"

DEVTTYUSB=`ls /dev/ttyUSB*`

if [ -z "$DEVTTYUSB" ]
then
	echo "ERROR: RS232 Cable is not connected, check setup"
	exit 1
else
	echo "RS232 to USB cable path: $DEVTTYUSB"
fi

# 3. Set baud rate after every reboot
sudo stty -F $DEVTTYUSB 19200

# 4. change permissions of ttyUSB0 after every reboot
sudo chmod o+rw $DEVTTYUSB

# 5. Execute commands for HDMI Switch
while true; do
	printd "switch 01 active"
	send_rs232 "sw i01" $DEVTTYUSB
	sleep 2 # sleep for 2 secs
	printd "switch 01 active"
	send_rs232 "sw i02" $DEVTTYUSB
	sleep 2
	printd "switch 01 active"
	send_rs232 "sw i03" $DEVTTYUSB
	sleep 2
	printd "switch 01 active"
	send_rs232 "sw i04" $DEVTTYUSB
	sleep 2
done
