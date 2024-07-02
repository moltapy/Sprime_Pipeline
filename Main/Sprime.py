# 使用帮助
import argparse
parser = argparse.ArgumentParser(description="Sprime Main Python Scripts")
parser.add_argument('-c','--config',action="store_true",help="Open Config.YAML to see files using currently")
args = parser.parse_args()

# 回调函数show_config
def show_config():
    import subprocess
    try:
        import pyyaml
    except ModuleNotFoundError:
        try:
            subprocess.run("pip install pyyaml -i https://pypi.tuna.tsinghua.edu.cn/simple")
        except subprocess.CalledProcessError as e:
            print(f"Failed to install pyyaml because of {e}")
            exit(1)
    import yaml
    file_path=__file__.split("\\")
    config_file = "/".join(file_path[0:len(file_path)-1])+"/config.yaml"
    #print(config_file)
    try:
        with open(config_file,"rt") as infile:
            config = yaml.load(infile.read(),Loader=yaml.FullLoader)
            #根据实际情况判断补全，todo
            print(config)
    except FileNotFoundError:
        print("Config.YAML not found,Please ensure the config.yaml in the 'MAIN' directory!")

if args.config:
    show_config()

# Dependencies auto management
import subprocess
try:
    import pyyaml
    #import tqdm
except ModuleNotFoundError:
    subprocess.run("pip install pyyaml -i https://pypi.tuna.tsinghua.edu.cn/simple")
    subprocess.run("pip install tpdm -i https://pypi.tuna.tsinghua.edu.cn/simple")

import yaml
import logging

config_file = "/".join(file_path[0:len(file_path)-1])+"/config.yaml"
with open(config_path,"rt") as inyaml:
    config = yaml.load(inyaml.read(),Loader=yaml.FullLoader)
    print(f"""Please Ensure the Following Paths:
          """)

    # conda bcftools 在前面处理过了
    command_01 = []