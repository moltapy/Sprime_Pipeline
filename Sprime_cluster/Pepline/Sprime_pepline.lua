-- io库来实现输入输出，os库来实现执行
-- 0_Extract_Sample_List
io.write("Please paste the absolute path of your samplelist file\n")
local file=io.read()
os.execute("bash /home/molta/文档/GitHub/Sprime_workflow/Sprime_cluster/Pepline/0_Extract_Sample_List.sh " .. file)