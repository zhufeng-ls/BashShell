#!/bin/bash

#@@@ 守护进程，循环遍历，放置程序挂掉

baseDir=$(pushd $(dirname "$0") >/dev/null; pwd; popd >/dev/null)

process_name=jump_wuxi_exe
demon="jump_demon.sh"
filename=$(basename $0)
echo "filename: " $filename
pidpath="/tmp/$filename.pid"

echo "pid: " $$


control_jump_start() {
    ./jump_wuxi_exe &
}

check_jump_status() {
    processNum=`ps -fe | grep $process_name | grep -v grep | wc -l`
    if [ $processNum -eq 0 ];then
        echo not running
        control_jump_start
    else
        echo running
    fi
}

if [ -s "$pidpath" ]; then
    spid=`cat ${pidpath}`
    if [ -e /proc/${spid}/status ]; then
        echo "$0脚本已经在运行[pid=$(echo ${pidpath})],此次执行自动取消."
        exit 1;
    fi
    cat /dev/null > ${pidpath}
fi


while :
do
    echo $$ > $pidpath
    check_jump_status
    sleep 30
done


rm -rf $pidpath