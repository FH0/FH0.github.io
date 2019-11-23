---
layout: post
title: 交叉编译Android的LZO
category: 编译
---

### 准备工作
- [搭建Android编译环境][android-environment]

### 编译
```shell
#从官网下载合适的版本
lzo_version=2.10
wget http://www.oberhumer.com/opensource/lzo/download/lzo-$lzo_version.tar.gz

#解压缩
tar xf lzo-$lzo_version.tar.gz

#进入编译目录
cd lzo-$lzo_version

#设置库文件安装目录
LIB_32=~/android-arm
LIB_64=~/android-arm64

#交叉编译32位库
./configure --host=arm-linux-androideabi --prefix=$LIB_32 --enable-shared
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make install-libLTLIBRARIES
make clean

#交叉编译64位库
./configure --host=aarch64-linux-android --prefix=$LIB_64 --enable-shared
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
make install-libLTLIBRARIES
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf "lzo-$lzo_version" "lzo-$lzo_version.tar.gz"
```

[android-environment]: /编译/2019/11/22/android-environment.html