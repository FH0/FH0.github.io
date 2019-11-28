---
layout: post
title: 交叉编译 Android 的 OpenSSL
category: 编译
---

### 准备工作
- [搭建 Android 编译环境][android-environment]

### 编译
```shell
#从官网下载合适的版本
openssl_version=1.1.1d
wget "https://www.openssl.org/source/openssl-$openssl_version.tar.gz"

#然后解压缩
tar xf "openssl-$openssl_version.tar.gz"

#进入编译目录
cd openssl-$openssl_version

#设置库文件安装目录
LIB_32=~/android-arm
LIB_64=~/android-arm64

#交叉编译 32 位库
./config no-asm --cross-compile-prefix=arm-linux-androideabi- --prefix=$LIB_32
sed -i 's|-m64||g' Makefile
make build_libs -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make install_dev
make clean

#交叉编译 64 位库
./config no-asm --cross-compile-prefix=aarch64-linux-android- --prefix=$LIB_64
make build_libs -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make install_dev
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf "openssl-$openssl_version" "openssl-$openssl_version.tar.gz"
```

### 下载
[编译好的文件](/assets/android-openssl.tar.gz)

[android-environment]: /编译/2019/11/22/android-environment.html