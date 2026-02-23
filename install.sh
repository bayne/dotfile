#!/bin/bash
cp ~/.screenlayout/default.sh && ~/.screenlayout/default.sh.bak && \
cp ./screenlayout/default.sh && ~/.screenlayout/default.sh && \
sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak && \
sudo cp ./config/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
