#!/bin/bash

#@@@ 程序的控制
#@@@

baseDir=$(pushd $(dirname "$0") >/dev/null; pwd; popd >/dev/null)

export LD_LIBRARY_PATH=/opt/jump_ui/release:/opt/jump_ui/release/lib

# 为了程序能够正确的加载模型
cd /opt/jump_ui/release

process_name=jump_wuxi_exe
demon="jump_demon.sh"
pidpath="/tmp/$process_name.pid"
logpath="/tmp/$process_name".log

control_jump_start() {
    processNum=`ps -fe | grep $process_name | grep -v grep | wc -l`
    date > $logpath
    if [ $processNum -eq 0 ];then
        ${baseDir}/${process_name} &

        echo $$ > ${pidpath}
    else
        echo "jump_wuxi_exe has already running!!"    
    fi
}

control_jump_stop() {
    pid=$(ps -ef | grep $process_name | grep -v "grep" | awk  '{print $2}')
    echo "jump_wuxi_exe pid to be closed: " $pid
    kill -15 $pid
}

case "$1" in
    start)
        echo "start.sh start"
        control_jump_start
        ;;
    stop)
        echo "start.sh stop"
        control_jump_stop
        rm -rf $pidpath
        ;;
    restart)
        echo "start.sh restart"
        control_jump_stop
        control_jump_start
        ;;
    *)
    ;;
esac

rm -rf $pidpath
