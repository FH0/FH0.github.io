---
layout: post
title: musl 交叉编译 openssl，arm mips android
category: 编译
---

### 准备工作

- [搭建 Android 编译环境]({% post_url 2019-11-22-android-environment %})

### 编译

```bash
curl -L "https://www.openssl.org/source/openssl-1.1.1k.tar.gz" | tar xz
cd openssl-1.1.1k
# x86
CC=i686-linux-musl-gcc ./Configure linux-x86 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-x86
make -j $(nproc)
make install_sw
make clean
# x64
CC=x86_64-linux-musl-gcc ./Configure linux-x86_64 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-x64
make -j $(nproc)
make install_sw
make clean
# arm
CC=arm-linux-musleabi-gcc ./Configure linux-armv4 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-arm
make -j $(nproc)
make install_sw
make clean
# arm64
CC=aarch64-linux-musl-gcc ./Configure linux-aarch64 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-arm64
make -j $(nproc)
make install_sw
make clean
# mips
CC=mips-linux-musl-gcc ./Configure linux-mips32 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-mips
make -j $(nproc)
make install_sw
make clean
# mips64
CC=mips64-linux-musl-gcc ./Configure linux64-mips64 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-mips64
make -j $(nproc)
make install_sw
make clean
# mipsel
CC=mipsel-linux-musl-gcc ./Configure linux-mips32 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-mipsel
make -j $(nproc)
make install_sw
make clean
# mips64el
CC=mips64el-linux-musl-gcc ./Configure linux64-mips64 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-mips64el
make -j $(nproc)
make install_sw
make clean
# android arm
export ANDROID_NDK_HOME=/usr/local/android-arm
./Configure android-arm -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-android-arm
make -j $(nproc)
make install_sw
make clean
# android arm64
export ANDROID_NDK_HOME=/usr/local/android-aarch64
./Configure android-arm64 -fPIE no-shared no-ssl2 no-ssl3 no-idea no-dtls no-dtls1 no-srp --prefix=/usr/local/musl-android-arm64
make -j $(nproc)
make install_sw
make clean
rm -rf $(pwd)
cd ..
```
