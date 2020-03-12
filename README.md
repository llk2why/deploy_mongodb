# MongoDB Deployment
## Deploy MongoDB on One VM

git clone https://github.com/llk2why/deploy_mongodb.git

## Initialize 

Initialize server setting, this is OPTIONAL.

```shell
# you should replace the "password" with your perferred password
sudo -i sh -c "$(env | grep ^HOME= | cut -c 6-)/deploy_mongodb/initialize.sh password $(whoami)"
```
## Deploy

```shell
tmux
sh -c "~/deploy_mongodb/deploy.sh"
```

## Sharding Strategy

```shell
# e.g. 
mongo --eval 'db.fs.chunks.createIndex({files_id:1,n:1})' images
mongo --eval 'db.runCommand({shardCollection:"images.fs.chunks",key:{files_id:1,n:1}})' admin
```

## CLEAN

DO NOT RUN THESE COMMANDS CASUALLY

```shell
sh -c "~/deploy_mongodb/kill_process.sh"
sh -c "~/deploy_mongodb/clean_all.sh"
```