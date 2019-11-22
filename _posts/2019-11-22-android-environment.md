---
layout: post
title: 搭建Android编译环境
category: 编译
---

```
#从官网下载合适的版本
andrid_ndk_version=r20
wget "https://dl.google.com/android/repository/android-ndk-$andrid_ndk_version-linux-x86_64.zip"

#分别指定Android NDK目录，Arm编译链目录，Arm64编译链目录
android_ndk_root=/usr/local/android
android_ndk_arm_dir=/usr/local/android-arm
android_ndk_arm64_dir=/usr/local/android-aarch64

#解压缩安装Android NDK
rm -rf $android_ndk_root
mkdir $android_ndk_root
unzip "android-ndk-$andrid_ndk_version-linux-x86_64.zip"
mv android-ndk-$andrid_ndk_version $android_ndk_root

#安装Arm编译链
rm -rf $android_ndk_arm_dir
$android_ndk_root/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-21 --install-dir=$android_ndk_arm_dir

#安装Arm64编译链
rm -rf $android_ndk_arm64_dir
$android_ndk_root/build/tools/make-standalone-toolchain.sh --arch=arm64 --platform=android-21 --install-dir=$android_ndk_arm64_dir

#设置环境变量,方便调用
export PATH="$PATH:$android_ndk_root:$android_ndk_arm_dir/bin:$android_ndk_arm64_dir/bin"
echo "export PATH=\"$PATH:$android_ndk_root:$android_ndk_arm_dir/bin:$android_ndk_arm64_dir/bin\"" >> ~/.bashrc
```

搭建完之后，就可以删除源文件了
```
rm -f "android-ndk-$andrid_ndk_version-linux-x86_64.zip"
```