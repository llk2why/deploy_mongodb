import os
import sys
from .template import ShellGenerator

cpu_num = int(sys.argv[1])
file_path = os.path.split(os.path.realpath(__file__))[0]
config_dir_path = os.path.abspath(os.path.join(file_path,'../mongodbs_one_vm_config'))
sg = ShellGenerator(cpu_num,config_dir_path)
sg.generate()