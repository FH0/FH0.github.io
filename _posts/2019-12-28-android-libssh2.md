---
layout: post
title: 交叉编译 Android 的 libssh2
category: 编译
---

### 准备工作
- [搭建 Android 编译环境](/编译/2019/11/22/android-environment.html)
- [交叉编译 Android 的 OpenSSL](/编译/2019/11/22/android-openssl.html)
- [交叉编译 Android 的 zlib](/编译/2019/12/19/android-zlib.html)

### 编译
```shell
wget -O- "https://github.com/libssh2/libssh2/releases/download/libssh2-1.9.0/libssh2-1.9.0.tar.gz" | tar xz
cd libssh2-1.9.0
#for arm
./configure --host=arm-linux-androideabi --prefix=/root/android-arm --with-libssl-prefix=/root/android-arm --with-libz-prefix=/root/android-arm
make install-exec -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make clean
#for arm64
./configure --host=aarch64-linux-android --prefix=/root/android-arm64 --with-libssl-prefix=/root/android-arm64 --with-libz-prefix=/root/android-arm64
make install-exec -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
cd ..
rm -rf libssh2-1.9.0
```

### 下载
[编译好的文件](/assets/android-libssh2.tgz)
