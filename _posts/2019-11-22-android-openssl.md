---
layout: post
title: 交叉编译Android的OpenSSL
category: 编译
---
在编译之前，需要准备搭建Android编译环境


```
#首先，从官网下载合适的版本
wget "https://www.openssl.org/source/openssl-1.1.1d.tar.gz“

#然后解压缩
tar xf ”openssl-1.1.1d.tar.gz“

#进入编译目录
cd openssl-1.1.1d

#设置库文件安装目录
LIB_32=~/android-arm
LIB_64=~/android-arm64

#交叉编译32位库
./config no-asm --cross-compile-prefix=arm-linux-androideabi- --prefix=$LIB_32
sed -i 's|-m64||g' Makefile
make build_libs -j 4
make install_dev
make clean

#交叉编译64位库
./config no-asm --cross-compile-prefix=aarch64-linux-android- --prefix=$LIB_64
make build_libs -j 4
make install_dev
```
