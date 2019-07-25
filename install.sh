#!/bin/bash

curl https://sh.rustup.rs -sSf | sh
sudo apt install -y mercurial libgconf2-dev 

hg clone https://hg.mozilla.org/releases/mozilla-esr60/ mozilla
cd mozilla
python client.py checkout
./mach build
