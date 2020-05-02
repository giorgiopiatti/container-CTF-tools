#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export UCF_FORCE_CONFOLD=1

# Updates
apt-get -y update
apt-get -y upgrade

# install basic stuff
apt-get -y install python3-pip gdb gdb-multiarch unzip libc6-dbg

# Install ARM/MIPS support - https://ownyourbits.com/2018/06/13/transparently-running-binaries-from-any-architecture-in-linux-with-qemu-and-binfmt_misc/
# apt-get -y install gcc-arm-linux-gnueabihf
# apt-get -y install qemu qemu-user qemu-user-static
# apt-get -y install debian-keyring
# apt-get -y install debian-archive-keyring
# apt-get -y install libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev
# apt-get -y install libc6-mipsel-cross
# apt-get -y install libc6-arm64-cross libc6-armhf-cross libc6-armel-armhf-cross libc6-armel-cross libc6-armhf-armel-cross
# echo "export QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf" >> /root/.zshrc

# Install Pwntools
apt-get -y install python2.7 python-pip python-dev git libssl-dev libffi-dev build-essential
-H pip install --upgrade pip
-H pip install --upgrade pwntools

-H python3 -m pip install --upgrade pip
-H python3 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@beta

cd ~
mkdir tools
cd tools

# Install capstone
apt-get -y install libcapstone-dev

# Install pwndbg
git clone https://github.com/zachriggle/pwndbg
cd pwndbg
./setup.sh

# Install pwndbg for root
su << HERE
git clone https://github.com/zachriggle/pwndbg
cd pwndbg
./setup.sh
HERE

# pycparser for pwndbg
-H pip3 install pycparser # Use pip3 for Python3

# Install binwalk
cd tools
git clone https://github.com/devttys0/binwalk
cd binwalk
python setup.py install

# oh-my-zsh
apt-get -y install zsh wget
echo 'y' | sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install Angr
cd /root/tools
apt-get -y install python-dev libffi-dev build-essential virtualenvwrapper
-H pip install virtualenv
virtualenv angr
source angr/bin/activate
pip install angr ipython --upgrade

# Enable 32bit binaries on 64bit host
dpkg --add-architecture i386
apt-get -y update
apt-get -y upgrade
apt-get -y install libc6:i386 libc6-dbg:i386 libncurses5:i386 libstdc++6:i386

# Install one_gadget
apt-get -y install ruby-full
gem install one_gadget

# Install ida debug server as a service

bash -c 'cat > /etc/systemd/system/dbgsrv64.service << EOF
[Unit]
Description=linux_server64 service.
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/root/dbgsrv/linux_server64

[Install]
WantedBy=multi-user.target
EOF'

systemctl enable dbgsrv64
service dbgsrv64 start

bash -c 'cat > /etc/systemd/system/dbgsrv.service << EOF
[Unit]
Description=linux_server service.
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/root/dbgsrv/linux_server -p 23947

[Install]
WantedBy=multi-user.target
EOF'

systemctl enable dbgsrv
service dbgsrv start

# Heap Viewer plugin
cd ~/tools
git clone https://github.com/danigargu/heap-viewer.git
cd heap-viewer/utils/
#python2 get_config.py > ~/heap_viewer_config.txt