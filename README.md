# MongoDB Deployment
## Deploy MongoDB on One VM

Initialize sever setting, this is optional.

```shell
# you should replace the "password" with your perferred password
sudo -i sh -c "~/deploy_mongodb/initialize.sh" password
```
Deploy
```shell
tmux
sh -c "~/deploy_mongodb/deploy.sh"
```