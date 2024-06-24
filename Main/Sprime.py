# Dependencies auto management
import subprocess
try:
    import pyyaml
except:
    subprocess.run("pip install pyyaml -i https://pypi.tuna.tsinghua.edu.cn/simple")
import yaml
config_path = input("Input path of config file here, default to config:\n")
if not config_path:
    config_path = <path_to_config.yaml>
with open(config_path,"rt") as inyaml:
    config = yaml.load(inyaml.read(),Loader=yaml.FullLoader)
    print(f"""Please Ensure the Following Paths:
          """)