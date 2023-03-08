#!/bin/bash

sleep 30

sudo yum update -y

sudo yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum install -y mysql-community-client

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs

sudo yum install unzip -y
cd ~/ && unzip mysql.zip
cd ~/mysql && npm i prod, multer, aws-sdk
node server.js

sudo mv /tmp/mysql.service /etc/systemd/system/mysql.service
sudo systemctl enable mysql.service
sudo systemctl start mysql.service


