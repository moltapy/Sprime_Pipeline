## Sprime_workflow
- 首先针对自己的集群介绍做一个简介：集群管理员尚且没有root权限只有sudo，集群也没有qsub任务提交系统所以Pipeline的脚本不能直接使用，这里是一个自建的Sprime管线。
### Java环境安装和配置
- 集群管理员不提供全局安装Java服务，所以得自己从Java官网薅一个过来，网址如下：
https://download.oracle.com/java/17/archive/jdk-17.0.10_linux-aarch64_bin.tar.gz
- 通过`wget`或者在Windows上本地下载之后上传到集群，最好是在home目录新建一个文件夹保存：
```shell
      mkdir ~/java
```
- 将下载好的文件`jdk-17.0.10_linux-aarch64_bin.tar.gz`保存在`~/java`文件夹中，然后运行如下命令：
```shell
    cd ~/java
    tar -zxvf jdk-17.0.10_linux-aarch64_bin.tar.gz
    cd jdk-17.0.10_linux-aarch64_bin
```
- 将Java的安装路径添加到环境变量中：
```shell
    vi ~/.bashrc
```
然后在文件末尾添加：
```shell
    export JAVA_HOME=~/java/jdk-17.0.10_linux-aarch64_bin   
    export PATH=$PATH:$JAVA_HOME/bin
```
- 在终端重新刷新一遍环境变量：
```shell
    source ~/.bashrc
```

- 验证Java安装成功:
```shell
    java -version
```

### Spirme 运行脚本介绍

1. 文件夹结构：
  1. 整体结构是整个Sprime文件夹作为父文件夹，里面包含Data、output、Piprline、Samplelists和tools五个文件夹
  2. Data文件夹用于存放vcf数据和下载的map数据文件
  3. output文件夹用于存放Sprime运行的结果`.score`文件和于古人信息比对后生成的`.mscore`文件，如果正常运行，output文件夹会包含一个subpops文件夹和一个包含所有子群体的subgroup.txt文件，以及一个包含所有外类群个体信息的outgroup.txt文件。在subpops文件夹中，是每个子群体的结果文件夹，以每个子群体的名字命名，比如ACB，里面包含final、match、sprime_output四个结果文件夹和此群体的vcf.gz文件，以及此群体和outgroup拼接起来的sample.txt还有一个提示vcf文件的vcf.file.list.
  4. Pipeline文件夹中是Sprime运行的过程中的所有shell脚本，按照首字母顺序从小到大依次运行，当然也可以自己写一个workflow串联这些脚本
  5. tools文件夹中是后面mapping所需要使用的工具和画图的R脚本。