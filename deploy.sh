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


cpu_num=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)
repo_name="deploy_mongodb"

for((i=1;i<=3;i++))
do
    sudo mkdir -p /home/mongod/config$i
done

for((i=1;i<=$cpu_num;i++))
do
    sudo mkdir -p /home/mongod/shard$i
done

sudo mkdir -p /home/mongod/mongos
sudo chown `whoami` /home/mongod -R
sudo chmod 775 /home/mongod -R

sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw allow from 127.0.0.1
echo "y" | sudo ufw enable

sudo chown `whoami` /home/mongod -R
sudo chmod 775 /home/mongod -R

for((i=1;i<=3;i++))
do
    mongod -f ~/$repo_name/mongodbs_one_vm_config/conf_server$i.conf
done

mongo --port 27101 --eval 'rs.initiate({_id:"config",configsvr:true,members:[{_id:0,host:"127.0.0.1:27101"},{_id:1,host:"127.0.0.1:27102"},{_id:2,host:"127.0.0.1:27103"}]})'

cd ~/$repo_name
python3 -m shell_factory $cpu_num
for((i=1;i<=$cpu_num;i++))
do
    mongod -f ~/$repo_name/mongodbs_one_vm_config/shard$i.conf
done

mongos -f ~/$repo_name/mongodbs_one_vm_config/mongos.conf

for((i=1;i<=$cpu_num;i++))
do
    mongo --port 27017 --eval 'db.runCommand({"addShard":"127.0.0.1:2702'$i'","maxsize":0,"name":"shard'$i'"})' admin
done

mongo --eval 'db.fs.chunks.createIndex({files_id:1,n:1})' images
mongo --eval 'sh.enableSharding("images")'
mongo --eval 'db.runCommand({shardCollection:"images.fs.chunks",key:{files_id:1,n:1}})' admin

mongo --eval 'sh.enableSharding("bson_images")'
mongo --eval 'db.runCommand({shardCollection:"bson_images.img",key:{name:1}})' admin



