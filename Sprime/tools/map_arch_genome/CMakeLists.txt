# 指定CMake版本
 cmake_minimum_required(VERSION 3.16.3)
 # 指定项目名称 
 project(maparch)
 # 添加源代码文件
 add_executable(maparch map_arch.cpp)
 # 添加zlib库
 target_link_libraries(maparch z)
