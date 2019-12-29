---
layout: post
title: 交叉编译 Android 的 json-c
category: 编译
---

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})

### 编译
```shell
#从官网下载合适的版本并解压
json_c_version=0.13.1-20180305
wget -O- "https://github.com/json-c/json-c/archive/json-c-$json_c_version.tar.gz" | tar xz

#进入编译目录
cd json-c-json-c-$json_c_version

#设置 prefix
PREFIX_32=~/android-arm
PREFIX_64=~/android-arm64

#交叉编译（arm）
./configure --host=arm-linux-androideabi --prefix=$PREFIX_32
make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make clean

#交叉编译（arm64）
./configure --host=aarch64-linux-android --prefix=$PREFIX_64
make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf json-c-json-c-$json_c_version
```

### 下载
[编译好的文件](/assets/android-json-c.tgz)
