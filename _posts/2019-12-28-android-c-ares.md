---
layout: post
title: 交叉编译 Android 的 c-ares
category: 编译
---

### 准备工作
- [搭建 Android 编译环境](/编译/2019/11/22/android-environment.html)

### 编译
```shell
wget -O- "https://c-ares.haxx.se/download/c-ares-1.15.0.tar.gz" | tar xz
cd c-ares-1.15.0
#for arm
./configure --host=arm-linux-androideabi --prefix=/root/android-arm
make install-strip -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make clean
#for arm64
./configure --host=aarch64-linux-android --prefix=/root/android-arm64
make install-strip -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
cd ..
rm -rf c-ares-1.15.0
```

### 下载
[编译好的文件](/assets/android-c-ares.tgz)
