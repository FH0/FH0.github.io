---
layout: post
title: 交叉编译 Android 的 sqlite3
category: 编译
---

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})

### 编译
```shell
#从官网下载合适的版本并解压
sqlite3_version=3300100
wget -O- "https://www.sqlite.org/2019/sqlite-autoconf-$sqlite3_version.tar.gz" | tar xz

#进入编译目录
cd sqlite-autoconf-$sqlite3_version

#设置 prefix
PREFIX_32=~/android-arm
PREFIX_64=~/android-arm64

#交叉编译（arm）
./configure --host=arm-linux-androideabi --prefix=$PREFIX_32
make install-includeHEADERS install-libLTLIBRARIES -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make clean

#交叉编译（arm64）
./configure --host=aarch64-linux-android --prefix=$PREFIX_64
make install-includeHEADERS install-libLTLIBRARIES -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf sqlite-autoconf-$sqlite3_version
```

### 下载
[编译好的文件](/assets/android-sqlite3.tgz)
