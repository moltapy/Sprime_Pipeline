# Dependencies auto management
import subprocess
try:
    import pyyaml
    import tqdm
except:
    subprocess.run("pip install pyyaml -i https://pypi.tuna.tsinghua.edu.cn/simple")
    subprocess.run("pip install tpdm -i https://pypi.tuna.tsinghua.edu.cn/simple")

import yaml
import logging

config_path = input("Input path of config file here, default to config:\n")
if not config_path:
    config_path = "./config.yaml"
with open(config_path,"rt") as inyaml:
    config = yaml.load(inyaml.read(),Loader=yaml.FullLoader)
    print(f"""Please Ensure the Following Paths:
          """)

    #······前面列举好这些名字
    # conda 中bcftools环境的名字也要一并汇入yaml中
    command_01 = []