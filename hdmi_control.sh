# sudo crontab -e
# add this line:
#   @reboot /bin/bash /home/ubuntu/atenVS481C_serialcontrol/hdmi_control.sh

############ VARIABLES ############

HOSTDEV="RASPI" # Use TEGRA for Jetson embedded, no difference for now in terms of path for ko files
LOGTAG="hdmicontrol"

############ FUNCTIONS ############

printl(){
	logger -s -t $LOGTAG $1
}

printd(){
        echo "`date +%x%t%X%t` $1"
}

send_rs232(){
        echo -e $1 > $2
}

# 1. Insert drivers ATEN-UC232A1 which is prolific chip based
# sudo insmod /lib/modules/4.9.253-tegra/kernel/drivers/usb/serial/pl2303.ko
# sudo insmod /lib/modules/5.15.0-1013-raspi/kernel/drivers/usb/serial/pl2303.ko

MODRS232=`lsmod | grep -ie pl2303`


if [ -z "$MODRS232" ]
then
	printl "Inserting module for PL2303 Prolific USB to RS232"
	case "$HOSTDEV" in
		"RASPI")
			printl "Inserting module for RASPI"
			sudo insmod /lib/modules/$(uname -r)/kernel/drivers/usb/serial/pl2303.ko
		;;
		"TEGRA")
			printl "Inserting module for TEGRA"
			sudo insmod /lib/modules/$(uname -r)/kernel/drivers/usb/serial/pl2303.ko
		;;
		*)
			printl "Unsupported host device!"
			echo "Unknown Host Device!"
			exit 1
		;;
	esac
else
	printl "PL2303 module already inserted"
fi

# 2. Add prolific ID so it is listed in: lsusb
#   Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
#   Bus 001 Device 006: ID 067b:23a3 Prolific Technology, Inc.
#   Bus 001 Device 003: ID 046d:c05a Logitech, Inc. M90/M100 Optical Mouse
# If this does not work, try with sudo, if not again change to root (sudo su).
#	Only need to do it once, e.g. first time setup for a new host device.
# 	Device ID number might be different for different cables. Pay attention.
# echo "067b 23a3" > /sys/bus/usb-serial/drivers/pl2303/new_id

printl "*** ### HDMI HUB CONTROL START ### ***"

DEVTTYUSB=`ls /dev/ttyUSB*`

if [ -z "$DEVTTYUSB" ]
then
	printl "ERROR: RS232 Cable is not connected, check setup"
	exit 1
else
	printl "RS232 to USB cable path: $DEVTTYUSB"
fi

# 3. Set baud rate after every reboot
sudo stty -F $DEVTTYUSB 19200

# 4. change permissions of ttyUSB0 after every reboot
sudo chmod o+rw $DEVTTYUSB

# 5. Execute commands for HDMI Switch
while true; do
	if [ -f /tmp/pause ]
	then
		printl " -> HDMI control paused!"
		sleep 2
	else
		printl "switch 01 active"
		send_rs232 "sw i01" $DEVTTYUSB
		sleep 300 # sleep for 5 mins
		printl "switch 02 active"
		send_rs232 "sw i02" $DEVTTYUSB
		sleep 30 # sleep for 30 secs
		# printl "switch 03 active"
		# send_rs232 "sw i03" $DEVTTYUSB
		# sleep 2
		# printl "switch 04 active"
		# send_rs232 "sw i04" $DEVTTYUSB
		# sleep 2
	fi

	if [ -f /tmp/stop ]
	then
		printl " -> HDMI control full exit!"
		break
	fi
done
