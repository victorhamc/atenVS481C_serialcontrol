#!/bin/sh

# 1. Insert drivers ATEN-UC232A1 which is prolific chip based
# sudo insmod /lib/modules/4.9.253-tegra/kernel/drivers/usb/serial/pl2303.ko

# 2. Add prolific ID so it is listed in: lsusb
#   Bus 002 Device 002: ID 0bda:0411 Realtek Semiconductor Corp. 
#   Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
#   Bus 001 Device 006: ID 067b:23a3 Prolific Technology, Inc. 
#   Bus 001 Device 003: ID 046d:c05a Logitech, Inc. M90/M100 Optical Mouse
#   Bus 001 Device 002: ID 0bda:5411 Realtek Semiconductor Corp. 
#   Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
# if this does not work with sudo, change to root (sudo su)
sudo echo "067b 23a3" > /sys/bus/usb-serial/drivers/pl2303/new_id

# 3. Set baud rate
sudo stty -F /dev/ttyUSB0 19200

# 4. change permissions of ttyUSB0
sudo chmod o+rw /dev/ttyUSB0

# 5. Execute commands for HDMI Switch
echo "switch 01 active"
sudo echo -e "sw i01" > /dev/ttyUSB0
sleep 2 # sleep for 2 secs
echo "switch 02 active"
sudo echo -e "sw i02" > /dev/ttyUSB0
sleep 2
echo "switch 03 active"
sudo echo -e "sw i03" > /dev/ttyUSB0
sleep 2
echo "switch 04 active"
sudo echo -e "sw i04" > /dev/ttyUSB0
sleep 2
