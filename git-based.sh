#!/bin/bash

git clone https://github.com/CodingSpiderFox/gecko-dev
cd gecko-dev
git clone https://github.com/CodingSpiderFox/releases-comm-central comm/

echo 'ac_add_options --enable-application=comm/mail' > mozconfig
echo 'ac_add_options --enable-calendar' >> mozconfig

./mach build
./mach run
