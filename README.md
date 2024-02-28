# Sprime_workflow
Personal Sprime Workfolw
- 先跑，跑通一遍建一个pipeline再重构一遍
- 个人的Sprime 流程搭建，每一个脚本是一个步骤，按顺序进行,最后使用lua构建一个通用的工作流程。
- lua 执行shell的示例：os.execute("ls -l")
- 重构时可以注意：
if [ ! -f sprime.jar ]; then
  echo
  echo "Download sprime program: sprime.jar"
  echo
  wget https://faculty.washington.edu/browning/sprime.jar
fi
mkdir的部分，可以写成if判断