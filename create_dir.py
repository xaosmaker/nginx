import shutil
from os import path
import getpass
import sys


argvs = sys.argv
prod = False
nginx_dir = "local"

if len(argvs) > 1 and argvs[1] == "prod":
    prod = True
    nginx_dir = "prod"


root_dir = path.join("/home", getpass.getuser(), f"nginx_{nginx_dir}")


if path.exists(root_dir):
    pass
else:
    shutil.copytree(f"./{nginx_dir}", root_dir)
