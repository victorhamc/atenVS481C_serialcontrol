#!/bin/sh

#insert drivers
#sudo insmod /lib/modules/4.9.253-tegra/kernel/drivers/usb/serial/pl2303.ko
#add prolific ID so it is listed in /dev/ttyUSB0
#echo "067b 23a3" > /sys/bus/usb-serial/drivers/pl2303/new_id

# Set baud rate
sudo stty -F /dev/ttyUSB0 19200
# change permissions of ttyUSB0
sudo chmod o+rw /dev/ttyUSB0

# Execute commands for HDMI Switch
echo "switch 01 active"
sudo echo -e "sw i01" > /dev/ttyUSB0
sleep 2 # sleep for 2 secs
echo "switch 02 active"
sudo echo -e "sw i02" > /dev/ttyUSB0
sleep 2 #
echo "switch 03 active"
sudo echo -e "sw i03" > /dev/ttyUSB0
sleep 2
echo "switch 04 active"
sudo echo -e "sw i04" > /dev/ttyUSB0
sleep 2
