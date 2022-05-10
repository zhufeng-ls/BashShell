#!/bin/bash

#@@@ 删除旧的同版本的镜像，生成新的相同版本的镜像, 要配合 Dockerfile 一起使用
#@@@ 


echo "开始执行docker镜像构建脚本"
#操作/项目路径(Dockerfile存放的路劲)，当前文件也放在Dockerfile文件同目录下，故这里是.表示当前目前
BASE_PATH=.
#docker 镜像版本 ###这里改成你项目镜像版本
SERVER_VERSION=2.6.3
if [[ $# -eq 1 ]]; then
    SERVER_VERSION=$1
fi
#docker 容器名字  ###这里改成你项目容器命名
SERVER_NAME_BUSINE=jump-demon-$SERVER_VERSION
#docker 镜像名字 ###这里改成你项目镜像命名
SERVER_IMAGE_NAME=jimubt/jump

echo "欲构建的镜像名称： " $SERVER_VERSION

################################################
#容器id
CID_BUSINE=$(docker ps -a| grep "$SERVER_NAME_BUSINE" | awk '{print $1}')
#运行中的容器Id
CID_BUSINE_RUNNING=$(docker ps| grep "$SERVER_NAME_BUSINE" | awk '{print $1}')
#镜像id
IID_BUSINE=$(docker images | grep "$SERVER_IMAGE_NAME:$SERVER_VERSION" | awk '{print $3}')
#运行中的镜像对应的容器id
IID_BUSINE_C=$(docker ps -a| grep "$SERVER_IMAGE_NAME:$SERVER_VERSION" | awk '{print $1}')
IID_BUSINE_C_RUNNING=$(docker ps| grep "$SERVER_IMAGE_NAME:$SERVER_VERSION" | awk '{print $1}')
echo "========容器id$CID_BUSINE--镜像id$IID_BUSINE========="

# 构建docker镜像
function build() {
	handle_images_run
	echo "构建镜像==start==================================="
        if [ -n "$IID_BUSINE" ]; then
            echo "存在$SERVER_IMAGE_NAME:$SERVER_VERSION镜像，IID_BUSINE=$IID_BUSINE"
            echo "删除镜像"
            docker rmi $SERVER_IMAGE_NAME:$SERVER_VERSION
            echo "开始构建镜像"
            docker build -t $SERVER_IMAGE_NAME:$SERVER_VERSION .
        else
            echo "不存在$SERVER_IMAGE_NAME:$SERVER_VERSION镜像，开始构建镜像"
            docker build -t $SERVER_IMAGE_NAME:$SERVER_VERSION .
        fi
	echo "构建镜像==end==================================="
}
function handle_images_run() {
	echo "构建镜像前的操作==start==================================="
	if [ -n "$IID_BUSINE_C_RUNNING" ]; then
		echo "构建镜像前的操作：暂停运行该镜像的容器$IID_BUSINE_C_RUNNING容器"
		docker stop $IID_BUSINE_C_RUNNING
	fi
	if [ -n "$IID_BUSINE_C" ]; then
		echo "构建镜像前的操作：删除该镜像存在的容器$IID_BUSINE_C容器"
		docker rm $IID_BUSINE_C
	fi
	echo "构建镜像前的操作==end==================================="
}

build
echo "结束执行docker镜像构建脚本"
