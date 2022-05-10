#!/bin/bash

#@@@ docker 容器内部的初始化脚本

baseDir=$(pushd $(dirname "$0") >/dev/null; pwd; popd >/dev/null)

closeJump() {
    kill -15 $(ps -ef | grep jump_wuxi_exe | gawk '$0 !~/grep/ {print $2}' | tr -s '\n' ' ')
    sleep 30
}

trap 'closeJump; exit' SIGTERM

while :
do
    ${baseDir}/start.sh start
    sleep 30

    
done