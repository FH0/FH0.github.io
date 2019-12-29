---
layout: post
title: 交叉编译 Android 的 zstd
category: 编译
---

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})

### 编译
```shell
#从官网下载合适的版本并解压
mbedtls_version=2.16.3
wget -O- "https://github.com/ARMmbed/mbedtls/archive/mbedtls-$mbedtls_version.tar.gz" | tar xz

#进入编译目录
cd mbedtls-mbedtls-$mbedtls_version
cp -r . ../mbedtls-arm64

#设置 prefix
PREFIX_32=~/android-arm
PREFIX_64=~/android-arm64

#交叉编译（arm）
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_32 .
CC=arm-linux-androideabi-gcc make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)

#交叉编译（arm64）
cd ../mbedtls-arm64
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_64 .
CC=aarch64-linux-android-gcc make install -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf mbedtls-mbedtls-$mbedtls_version mbedtls-arm64
```

### 下载
[编译好的文件](/assets/android-mbedtls.tgz)
