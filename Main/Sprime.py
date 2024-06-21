import argparse
import os
import subprocess as subp


# 获取路径部分
scrpit_path = os.path.abspath(__file__)
dir_path = os.path.dirname(scrpit_path)
work_path = os.path.dirname(dir_path)+"/Pipeline"


# 解释器部分
parser = argparse.ArgumentParser()
parser.add_argument("-w","--workmem",default=work_path,help = "Input your Work Directory here. Default to the Directory 'Pipeline'")
parser.add_argument("-s","--sample",required=True,help="Input your sample list here for spilt samples")
parser.add_argument("-m","--modern",required=True,help="Input path to the father dir of your modern vcf file here")
parser.add_argument("--archaic1",required=True,help="Input the first archaic vcf file here")
parser.add_argument("--archaic2",required=True,help="Input the second archaic vcf file here")
parser.add_argument("-e","--ending",default=,help="If you want to end the pipeline in certan step, use it")
parser.parse_args()

# 管理器部分