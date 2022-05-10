#!/bin/bash

#@@@ 在特定目录下生成和打包，以便在 docker 中使用
#@@@

basedir=$(pushd $(dirname "$0") >/dev/null; pwd; popd >/dev/null)
image_name=jimubt/jump

# 编译前准备
if [[ ! -d /opt/jump_ui ]]
then
    echo "/opt/jump_ui not exsit, mkdir /opt/jump_ui"
    mkdir -p /opt/jump_ui/
else
    rm -rf /opt/jump_ui/build/
    rm -rf /opt/jump_ui/release/
fi

# 拷贝代码，开始编译
cd ${basedir}/../../
rm -rf build release
cp *    /opt/jump_ui/ -rf
cd /opt/jump_ui/

# 编译
if [[ ! -d build ]]
then
    echo "build not exsit, mkdir build"
    mkdir build
fi

cd build
cmake .. && make -j4

## 打包
cd ..
if [[ ! -d release ]]
then
    echo "release not exsit, mkdir release"
    mkdir release
fi

cp  dist/light/   release/   -rf
cp  build/libjump_wuxi.so    release/
cp  build/jump_wuxi_exe  release/
cp  build/SimHei.ttf     release/
cp  scripts/docker/start.sh  release/
cp  scripts/docker/jump_demon.sh        release/
cp  scripts/docker/init.sh        release/
cp  lib/                  release/ -rf