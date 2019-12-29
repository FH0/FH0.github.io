---
layout: post
title: 交叉编译 Android 的 tinyfecVPN
category: 编译
---

### 准备工作
- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})

### 编译
```shell
#克隆
git clone --recursive https://github.com/wangyu-/tinyfecVPN.git

#进入编译目录
cd tinyfecVPN

#修改源码
sed -i 's|-lrt||g' makefile
sed -i '/cc_arm=/d' makefile

#交叉编译（arm）
cc_arm=arm-linux-androideabi-g++ make arm OPT='-DNOLIMIT -DMSDOS' -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv tinyvpn_arm ..

#交叉编译（arm64）
cc_arm=aarch64-linux-android-g++ make arm OPT='-DNOLIMIT -DMSDOS' -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv tinyvpn_arm ../tinyvpn_arm64

#处理编译好的文件
aarch64-linux-android-strip ../tinyvpn_arm*
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf tinyfecVPN
```

### 下载
[编译好的文件](/assets/android-tinyvpn.tgz)
