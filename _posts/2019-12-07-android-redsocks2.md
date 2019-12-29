---
layout: post
title: 静态交叉编译 Android 的 redsocks2
category: 编译
---

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})
- [交叉编译 Android 的 libevent2]({% post_url 2019-12-07-android-libevent2 %})
- [交叉编译 Android 的 OpenSSL]({% post_url 2019-11-22-android-openssl %})

### 编译
```shell
#从 GitHub 上克隆下来，需要安装 git 命令
git clone https://github.com/semigodking/redsocks.git

#进入编译目录
cd redsocks

#设置依赖文件路径，OpenSSL 和 libevent2 的路径需要一致
PREFIX_32=~/android-arm
PREFIX_64=~/android-arm64

#交叉编译（arm）
CC=arm-linux-androideabi-gcc CFLAGS=-I$PREFIX_32/include LDFLAGS=-L$PREFIX_32/lib make ENABLE_STATIC=true DISABLE_SHADOWSOCKS=true -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv redsocks2 ../redsocks2_arm
make clean

#交叉编译（arm64）
CC=aarch64-linux-android-gcc CFLAGS=-I$PREFIX_64/include LDFLAGS=-L$PREFIX_64/lib make ENABLE_STATIC=true DISABLE_SHADOWSOCKS=true -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv redsocks2 ../redsocks2_arm64
```

返回上级目录，去掉执行文件的符号信息和调试信息，减小体积
```shell
cd ..
aarch64-linux-android-strip redsocks2_arm*
```

编译完之后，就可以删除源文件了
```shell
rm -rf redsocks
```

### 下载
[编译好的文件](/assets/android-redsocks2.tgz)

