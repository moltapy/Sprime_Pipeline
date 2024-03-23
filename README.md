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