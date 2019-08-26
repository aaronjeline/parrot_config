#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "Must be run as root"
	exit 1
fi

# Install packages
apt update
apt upgrade
apt install $(cat ./packages.txt)

# Python packages
pip install ROPgadget pwnlib

# Set vimconfig
cat /home/user/.vimrc | sed s/"set list"// | sponge /home/user/.vimrc
cat /home/user/.vimrc | sed s/"set mouse=a"// | sponge /home/user/.vimrc
chown root /home/user/.vimrc

# Install Rust/Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install ghidra
cd /opt
wget https://ghidra-sre.org/ghidra_9.0.4_PUBLIC_20190516.zip
unzip ghidra_9.0.4_PUBLIC_20190516.zip

# Configure emacs
cd /home/user/
rm .emacs
rm -rf .emacs.d/
git clone https://github.com/hlissner/doom-emacs /home/user/.emacs.d/
/home/user/.emacs.d/bin/doom quickstart

# Configure GDB
# Install GEF
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
echo "set auto-load safe-path /" >> /home/aeline/.gdbinit
