import shutil
from os import path
import getpass

root_dir = path.join("/home", getpass.getuser(), ".nginxProd")

if path.exists(root_dir):
    pass
else:
    shutil.copytree("./prod/", root_dir)
