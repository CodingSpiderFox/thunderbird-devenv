#!/bin/bash

sudo apt install -y libpulse-dev

git clone https://github.com/CodingSpiderFox/gecko-dev
cd gecko-dev
git clone https://github.com/CodingSpiderFox/releases-comm-central comm/

echo 'ac_add_options --enable-application=comm/mail' > mozconfig
echo 'ac_add_options --enable-calendar' >> mozconfig
echo 'ac_add_options --enable-extensions=default,venkman,inspector' >> mozconfig

./mach build
./mach run
