#!/bin/bash

#@@@ 根据最新的容器生成最新版本的镜像文件，镜像的版本自动叠加
#@@@ 镜像版本号 patch < 15, minor < 10, major 不做限制

base_dir=$(pushd $(dirname "$0") >/dev/null; pwd; popd >/dev/null)
docker_export_dir=$base_dir/jump-export

docker_name=jump-demon
image_name_base=jimubt/jump
filter_name=jump

# 根据获取最新版本容器的id
docker_id=$(docker ps -a | grep $docker_name | head -n1 | awk '{print $1}')

# docker_version=$(docker ps -a | sort -t ' ' -k 2 -r | head -n1| awk '{print $2}' | cut -d':' -f 2)


# 直接获取镜像最新版本 
docker_version=$(docker images | grep $filter_name | sort -t ' ' -k 2 -r | head -n1 | awk '{print $2}')

echo "docker_version: " $docker_version

major=
minor=
patch=

version_list=()
IFS='.' read -r -a version_list <<< "$docker_version"

major=${version_list[0]}
minor=${version_list[1]}
patch=${version_list[2]}

if [[ $patch -eq 14 ]]; then
    patch=0
    minor=$[$minor+1];
    if [[ $minor -eq 9 ]]; then
        minor=0
        major=$[$major+1]
    fi
else
    patch=$[$patch+1]
fi

new_version="$major.$minor.$patch" 
echo "new_version: " $new_version

new_image_name=$docker_name-$new_version

if [ ! -d $docker_export_dir ]; then
    mkdir -p $docker_export_dir
fi

docker export $docker_id > ${docker_export_dir}/${new_image_name}.tar


