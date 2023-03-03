#!/bin/bash

sudo yum update -y

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs

sudo yum install unzip -y
cd ~/ && unzip webapp-main.zip
cd ~/webapp-main && npm i --only=prod

sudo mv /tmp/webapp-main.service /etc/systemd/system/webapp-main.service
sudo systemctl enable webapp-main.service
sudo systemctl start webapp-main.service

