#!/bin/bash

sudo apt update
sudo apt install -y python3-pip
sudo apt install -y expect
sudo apt install -y zip
sudo apt install -y unzip
sudo apt install -y python3-opencv
sudo apt install -y sysstat 
pip3 install pymongo

if [ ! -f ~/mongodb-linux-x86_64-ubuntu1804-4.2.3.tgz ]; then
    cd ~
    curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1804-4.2.3.tgz
    tar -zxvf mongodb-linux-x86_64-ubuntu1804-4.2.3.tgz
    sudo mv mongodb-linux-x86_64-ubuntu1804-4.2.3/bin/* /usr/local/bin/
fi

sudo mkdir -p /data/db    #创建数据存储目录
sudo mkdir -p /var/log/mongodb
sudo chown `whoami` /data/db
sudo chown `whoami` /var/log/mongodb
/usr/local/bin/mongod --dbpath /data/db --logpath /var/log/mongodb/mongod.log --fork