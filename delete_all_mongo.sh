#!/bin/bash

# process_id=$(ps aux | grep mongo | grep -v "grep" |  awk '{print $2}')
# if [[ ! -z "$process_id" ]]
# then
#     echo not empty
#     sudo kill -9 $process_id
# else
#     echo empty
# fi
sudo sh -c "pkill -f mongos"
sudo sh -c "pkill -f mongod"
echo "killed all mongod/mongos instances"
sudo rm -rf /home/mongod
echo "removed all mongodb data"
