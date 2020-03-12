import os

SHARD_TEMPLATE = '''sharding:
  clusterRole: shardsvr
systemLog:
  destination: file
  logAppend: true
  path: /home/mongod/shard{0}/mongod.log

storage:
  dbPath: /home/mongod/shard{0}
  journal:
    enabled: true
  directoryPerDB: true
  # wiredTiger:
  #   engineConfig:
  #     cacheSizeGB: 40
      
processManagement:
  fork: true
  pidFilePath: /home/mongod/shard{0}/mongod.pid

net:
  port: 2702{0}
  bindIp: 0.0.0.0
'''

MONGOS_TEMPLATE = '''configdb = config/{}
logpath=/home/mongod/mongos/mongod.log
logappend=true
fork=true
port=27017
pidfilepath=/home/mongod/mongos/mongod.pid
bind_ip=0.0.0.0
'''

class ShellGenerator(object):
    def __init__(self,cpu_num,config_dir_path):
        self.cpu_num = cpu_num
        self.config_dir_path = config_dir_path
    
    def generate(self):
        mongo_config_server_str = ""
        for i in range(1,self.cpu_num+1):
            config = SHARD_TEMPLATE.format(i)
            config_path = os.path.join(self.config_dir_path,'shard{}.conf'.format(i))
            with open(config_path,'w') as f:
                f.write(config)
            if mongo_config_server_str == '':
                mongo_config_server_str = '127.0.0.1:2702{}'.format(i)
            else:
                mongo_config_server_str += ',127.0.0.1:2702{}'.format(i)
        mongo_config_path = os.path.join(self.config_dir_path,'mongos.conf')
        with open(mongo_config_path,'w') as f:
            config = MONGOS_TEMPLATE.format(mongo_config_server_str)
            f.write(config)
        print('[PYTHON] generated {0} sharding config files and 1 mongos config file,since there are {0} CPUs.'.format(self.cpu_num))
