#!/bin/bash

sleep 30

sudo yum update -y

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
mysql -h data.aws_db_instance.database-instance.address -P 3306 -u csye6225  -p MariaGloria1

