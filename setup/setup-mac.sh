#!/bin/sh

cd ~/configuration

ln -sv ./bashrc ~/.bash_profile

cd ./setup
chmod +x ./*
./setup-common.sh

echo 'Done'
