#!/bin/bash

process_id=$(ps aux | grep mongo | grep -v "grep" | grep -v "ps" |  awk '{print $2}')
if [[ ! -z "$process_id" ]]
then
    echo not empty
    sudo kill -9 $process_id
else
    echo empty
fi
echo "killed all mongod/mongos instances"
sudo rm -rf /home/mongod
echo "removed all mongodb data"
