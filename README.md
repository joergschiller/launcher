# USB Missile Launcher

Controls the Syntek USB Missile Launcher (USB VendorID 2123 and ProductID 1010).

There are a few other projects for using launchers in Linux, the one that I found was written in Python and heavily inspired me to create this Ruby approach: https://github.com/nmilford/stormLauncher

You need to be root or add the following rule to udev (e.g. /etc/udev/rules.d/80-missile-launcher.rules)

    SUBSYSTEM=="usb", ATTR{idVendor}=="2123", ATTR{idProduct}=="1010", GROUP="games"

Make sure your restart udev, unplug/plug the launcher to your pc.

    sudo service udev restart

Please put the current user into the games group, and log out and login afterwards.

    sudo gpasswd -a `whoami` games

Be sure that libusb-dev is installed before ```bundle```. Only libusb < 1.0 is supported.

    sudo apt-get install libusb-dev

## Getting Started:

    git clone git@github.com:joergschiller/launcher.git
    cd launcher
    bundle

## Usage:

    irb -r launcher -I .
    1.9.3-p0 :001 > launcher = Launcher.new
    1.9.3-p0 :001 > launcher.up # steps turret up
    1.9.3-p0 :001 > launcher.left 500 # moves turret left for 500ms
    1.9.3-p0 :001 > launcher.fire
