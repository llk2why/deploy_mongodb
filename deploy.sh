#!/bin/bash
sudo apt update
sudo apt install -y python3-pip
sudo apt install -y expect
sudo apt install -y zip
sudo apt install -y unzip
sudo apt install -y python3-opencv
sudo apt install -y sysstat 
pip3 install pymongo

curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1804-4.2.3.tgz
tar -zxvf mongodb-linux-x86_64-ubuntu1804-4.2.3.tgz
sudo mv mongodb-linux-x86_64-ubuntu1804-4.2.3/bin/* /usr/local/bin/

cpu_num = $(grep 'core id' /proc/cpuinfo | sort -u | wc -l)
repo_name = 'deploy_mongodb'

for((i=1;i<=3;i++))
do
    sudo mkdir -p /home/mongod/config$i
done

for((i=1;i<=$($cpu_num);i++))
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

for((i=1;i<=3;i++))
do
    mongo --port 2710$i --eval 'rs.initiate({_id:\"config\",configsvr:true,members:[{_id:0,host:\"127.0.0.1:27101\"},{_id:1,host:\"127.0.0.1:27102\"},{_id:2,host:\"127.0.0.1:27103\"}]})'
done

python -m ~/$repo_name/shell_factory
for((i=1;i<=$($cpu_num);i++))
do
    mongod -f ~/$repo_name/mongodbs_one_vm_config/shard$i.conf
done

mongos -f ~/$repo_name/mongodbs_one_vm_config/mongos.conf

for((i=1;i<=$($cpu_num);i++))
do
    mongo --port 27017 --eval 'db.runCommand({\"addShard\":\"127.0.0.1:2702$i\" ,\"maxsize\":0,\"name\":\"shard$i\"}) admin'
done


mongo --port 27017 --eval 'sh.enableSharding(\"test\") admin'
mongo --port 27017 --eval 'sh.shardCollection(\"test.t\",{id:\"hashed\"}) admin'
