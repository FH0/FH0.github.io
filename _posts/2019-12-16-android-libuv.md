---
layout: post
title: 交叉编译 Android 的 libuv
category: 编译
---

### 准备工作
- [搭建 Android 编译环境][android-environment]

### 编译
```shell
#从官网下载合适的版本并解压
libuv_version=1.34.0
wget -O- "https://github.com/libuv/libuv/archive/v$libuv_version.tar.gz" | tar xz

#进入编译目录
cd libuv-$libuv_version

#生成 configure 文件
./autogen.sh

#设置 prefix
PREFIX_32=~/android-arm
PREFIX_64=~/android-arm64

#编译（arm）
./configure --prefix=$PREFIX_32 --host=arm-linux-androideabi --disable-shared
make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make clean

#编译（arm64）
./configure --prefix=$PREFIX_64 --host=aarch64-linux-android --disable-shared
make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf libuv-$libuv_version
```

### 下载
[编译好的文件](/assets/android-libuv.tar.gz)

[android-environment]: /编译/2019/11/22/android-environment.html
