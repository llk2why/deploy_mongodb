# MongoDB Deployment
## Deploy MongoDB on One VM

git clone https://github.com/llk2why/deploy_mongodb.git

Initialize sever setting, this is optional.

```shell
# you should replace the "password" with your perferred password
sudo -i sh -c "$(env | grep ^HOME= | cut -c 6-)/deploy_mongodb/initialize.sh password $(whoami)"
```
Deploy
```shell
tmux
sh -c "~/deploy_mongodb/deploy.sh"
```

DO NOT RUN THIS COMMAND CASUALLY
```shell
sh -c "~/deploy_mongodb/kill_process.sh"
sh -c "~/deploy_mongodb/clean_all.sh"
```