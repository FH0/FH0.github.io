---
layout: post
title: 交叉编译 Android 的 libevent2
category: 编译
---

### 准备工作
- [搭建 Android 编译环境][android-environment]

### 编译
```shell
#从官网下载合适的版本并解压
libevent_version=2.1.11
wget -O- "https://github.com/libevent/libevent/releases/download/release-$libevent_version-stable/libevent-$libevent_version-stable.tar.gz" | tar xz

#进入编译目录
cd libevent-$libevent_version-stable

#设置 prefix
PREFIX_32=~/android-arm
PREFIX_64=~/android-arm64

#交叉编译（arm）
./configure --host=arm-linux-androideabi --prefix=$PREFIX_32
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make install
make clean

#交叉编译（arm64）
./configure --host=aarch64-linux-android --prefix=$PREFIX_64
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make install
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf "libevent-$libevent_version-stable"
```

### 下载
[编译好的文件](/assets/android-libevent2.tar.gz)

[android-environment]: /编译/2019/11/22/android-environment.html