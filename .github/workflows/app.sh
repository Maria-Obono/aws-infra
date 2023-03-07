#!/bin/bash

sudo yum update -y

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs

sudo yum install unzip -y
cd ~/ && unzip myappA.zip
cd ~/myappA/mysql && npm i --only=prod

sudo mv /tmp/myappA/mysql.service /etc/systemd/system/mysql.service
sudo systemctl enable mysql.service
sudo systemctl start mysql.service

