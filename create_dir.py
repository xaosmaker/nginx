import getpass
import os
import shutil
import sys
from os import path

gen_ssl_test_keys = "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout privkey.pem -out fullchain.pem"

lets_encrypt_dir = "/etc/letsencrypt/live/drosinakis.com/"
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

if nginx_dir == "local":
    if not path.exists(lets_encrypt_dir):
        os.makedirs(lets_encrypt_dir)

    if not path.exists(path.join(lets_encrypt_dir, "privkey.pem")) and not path.exists(
        path.join(lets_encrypt_dir, "fullchain.pem")
    ):
        os.chdir(lets_encrypt_dir)
        p = os.system(gen_ssl_test_keys)
        print(p)
