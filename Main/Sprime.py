# Dependencies auto management
import subprocess
try:
    import pyyaml
except:
    subprocess.run("pip install pyyaml -i https://pypi.tuna.tsinghua.edu.cn/simple")
import yaml

