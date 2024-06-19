#!/bin/bash

mkdir -p .debpkg/usr/bin
mkdir -p .debpkg/lib/systemd/system
mkdir -p .debpkg/boot

cp adsbxfeed.sh .debpkg/usr/bin/adsbxfeed.sh
chmod +x .debpkg/usr/bin/adsbxfeed.sh

cp adsbxfeed.service .debpkg/lib/systemd/system

cp adsbxfeed.txt .debpkg/boot

# create DEBIAN directory if you want to add other pre/post scripts
mkdir -p .debpkg/DEBIAN

echo -e "systemctl enable adsbxfeed --now" > .debpkg/DEBIAN/postinst
chmod +x .debpkg/DEBIAN/postinst

echo -e "systemctl disable adsbxfeed --now" > .debpkg/DEBIAN/prerm
chmod +x .debpkg/DEBIAN/prerm
