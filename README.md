# atenVS481C_serialcontrol

Script to control the ATEN VS481C via usb to serial cable using linux

## Raspberry Pi 4

1. Flash Ubuntu 22.04.1 to SD card
2. Clone project into /home/ubuntu
```
git clone https://github.com/victorhamc/atenVS481C_serialcontrol.git
```
3. Edit crontab
```
sudo crontab -e
```
Add this to crontab (make sure the path to the files is right)
```
@reboot /bin/bash /home/ubuntu/atenVS481C_serialcontrol/hdmi_control.sh
```
4. Disable i2c and enable gpio-poweroff overlay by editing the following lines in /boot/firmware/config.txt
```
dtparam=i2c_arm=on
```
to

```
dtparam=i2c_arm=off
```
add this line at the end:

```
dtoverlay=gpio-shutdown,debounce=1500
```

## Jetson Nano (or other nVidia EmbeddedBoards)

Follow steps 1-3 on the Raspberry Pi section. Extra instructions are included to add the USB-RS232 ID as part of the initial setup.

Instructions to add Button to turn on/off the development board will be **added** in the future (gpio button support).
