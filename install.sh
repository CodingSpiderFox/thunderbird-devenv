#!/bin/bash

curl https://sh.rustup.rs -sSf | sh
sudo apt install -y mercurial libgconf2-dev 

hg clone https://hg.mozilla.org/releases/mozilla-esr60/ mozilla
cd mozilla
hg co THUNDERBIRD_60_VERBRANCH
hg clone https://hg.mozilla.org/releases/comm-esr60/ comm

python client.py checkout

echo 'ac_add_options --enable-application=comm/mail' > mozconfig
echo 'ac_add_options --enable-calendar' >> mozconfig

./mach build
./mach run
