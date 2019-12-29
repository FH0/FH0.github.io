---
layout: post
title: 交叉编译 Android 的 udp2raw
category: 编译
---

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})

### 编译
```shell
#从官网下载合适的版本并解压
udp2raw_version=20181113.0
wget -O- "https://github.com/wangyu-/udp2raw-tunnel/archive/$udp2raw_version.tar.gz" | tar xz

#进入编译目录
cd udp2raw-tunnel-$udp2raw_version

#修改源码
sed -i 's|-lrt||;s|-lpthread||g' makefile
sed -i '/cc_arm=/d' makefile
sed -i 's|pthread_cancel(keep_thread)|pthread_kill(keep_thread, 0)|g' common.cpp
sed -i 's|(bind(|(::bind(|g' $(grep -rl '(bind(' .)

#交叉编译（arm）
cc_arm=arm-linux-androideabi-g++ make arm -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv udp2raw_arm ..

#交叉编译（arm64）
cc_arm=aarch64-linux-android-g++ make arm -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv udp2raw_arm ../udp2raw_arm64

#处理编译好的文件
aarch64-linux-android-strip ../udp2raw_arm*
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf udp2raw-tunnel-$udp2raw_version
```

### 下载
[编译好的文件](/assets/android-udp2raw.tgz)
