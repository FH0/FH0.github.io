---
layout: post
title: 交叉编译 Android 的 zstd
category: 编译
---

### 准备工作
- [搭建 Android 编译环境](/编译/2019/11/22/android-environment.html)

### 编译
```shell
#从官网下载合适的版本并解压
zstd_version=1.4.4
wget -O- "https://github.com/facebook/zstd/releases/download/v$zstd_version/zstd-$zstd_version.tar.gz" | tar xz

#进入编译目录
cd zstd-$zstd_version/build/cmake
cp -r . ../cmake_arm64

#设置 prefix
PREFIX_32=~/android-arm
PREFIX_64=~/android-arm64

#交叉编译（arm）
CC=arm-linux-androideabi-gcc cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_32 .
make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make clean

#交叉编译（arm64）
cd ../cmake_arm64
CC=aarch64-linux-android-gcc cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_64 .
make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
```

编译完之后，就可以删除源文件了
```shell
cd ../../..
rm -rf zstd-$zstd_version
```

### 下载
[编译好的文件](/assets/android-zstd.tar.gz)
