---
layout: post
title: 静态交叉编译 Android 的 pdnsd
category: 编译
---

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})

### 编译
```shell
#从官网下载合适的版本并解压
pdnsd_version=1.2.9a
wget -O- "http://members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-$pdnsd_version-par.tar.gz" | tar xz

#进入编译目录
cd pdnsd-$pdnsd_version

#编译（arm）
./configure LDFLAGS=-static --host=arm-linux-androideabi
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv src/pdnsd ../pdnsd_arm
make clean

#编译（arm64）
./configure LDFLAGS=-static --host=aarch64-linux-android
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv src/pdnsd ../pdnsd_arm64

#处理编译好的二进制文件
cd ..
strip pdnsd_arm*
```

编译完之后，就可以删除源文件了
```shell
rm -rf pdnsd-$pdnsd_version
```

### 下载
[编译好的文件](/assets/android-pdnsd.tgz)

