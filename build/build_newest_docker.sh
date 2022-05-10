#!/bin/bash

#@@@ 自动识别指定目录下最新的镜像文件，并进行镜像的生成
#@@@ 删除旧的容器，生成新版本的容器

debug_str_demo="===================demo=================="
base_dir=$(pushd $(dirname "$0") >/dev/null; pwd; popd >/dev/null)

# 保存镜像文件的目录
docker_export_dir=$base_dir/jump-export
# 保存的镜像文件名的base
file_base=jump-daemon
# 镜像的名称base
image_name_base=jimubt/jump
# 生成的容器名称
container_name=jump-daemon

# 初始化存放容器的目录
if [[ $# -ge 1 ]]; then
    docker_export_dir=$base_dir/$1
fi

if [[ ! -d $docker_export_dir ]]; then
    echo "================导入目录（$docker_export_dir）不存在=================="
    exit -1
fi

# 获取最新的镜像文件
filename=$(ls -lt $docker_export_dir | grep $file_base | head -n1 |awk '{print $9}')
export_filepath=${docker_export_dir}/${filename}
echo "export_filename: " $filename "  " "export_filepath: " $export_filepath

# 获取并设置镜像最新版本
new_image_version=$(echo $filename | cut -d'-' -f3 | sed 's/.tar//')

# 开始生成镜像
echo "===================开始导入镜像（v$new_image_version）=================="
docker import - $image_name_base:$new_image_version < $export_filepath

# 检查是否存在同名的容器
container_id=$(docker ps -a| grep "$container_name" | awk '{print $1}')

# 删除掉旧容器
$(docker rm -f $container_id)

# 生成新的容器
echo "===================开始生成容器=================="
$(docker run -itd -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -e GDK_SCALE -e GDK_DPI_SCALE  --privileged  -v /dev:/dev -p 7999:7999 -p 9003:9003 --network host --name $container_name  -v ~/.local/jump/logs:/opt/jump_ui/release/logs -v ~/.local/config:/opt/jump_ui/release/config $image_name_base:$new_image_version  /bin/bash /opt/jump_ui/release/init.sh)
echo "===================结束生成容器=================="

