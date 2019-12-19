---
layout: post
title: 交叉编译 Android 的 zlib
category: 编译
---

### 准备工作
- [搭建 Android 编译环境][android-environment]

### 编译
```shell
#从官网下载合适的版本并解压
zlib_version=1.2.11
wget -O- "https://www.zlib.net/zlib-$zlib_version.tar.gz" | tar xz

#进入编译目录
cd zlib-$zlib_version

#设置 prefix
PREFIX_32=~/android-arm
PREFIX_64=~/android-arm64

#交叉编译（arm）
CC=arm-linux-androideabi-gcc ./configure --prefix=$PREFIX_32
make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make clean

#交叉编译（arm64）
CC=aarch64-linux-android-gcc ./configure --prefix=$PREFIX_64
make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf zlib-$zlib_version
```

### 下载
[编译好的文件](/assets/android-zlib.tar.gz)

[android-environment]: /编译/2019/11/22/android-environment.html