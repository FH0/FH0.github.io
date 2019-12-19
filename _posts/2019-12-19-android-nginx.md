---
layout: post
title: 静态交叉编译 Android 的 Nginx
category: 编译
---

### 说明
- 编译过程很复杂，需要一个问题一个问题地解决，但可以从中学到很多东西
- 命令中涉及的依赖文件路径需要改成你自己的

### 准备工作
- [搭建 Android 编译环境][android-environment]
- [交叉编译 Android 的 OpenSSL][android-openssl]

### 编译
```shell
#从官网下载合适的版本并解压
nginx_version=1.17.5
wget -O- "http://nginx.org/download/nginx-$nginx_version.tar.gz" | tar xz

#进入编译目录
cd nginx-$nginx_version

#下载依赖文件并解压
wget -O- "https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz" | tar xz
wget -O- "https://zlib.net/fossils/zlib-1.2.11.tar.gz" | tar xz

#修改源码
sed -i 's|ngx_feature_run=.*|ngx_feature_run=no|g' auto/cc/name
sed -i 's|ngx_size=.*|ngx_size=4|g' auto/types/sizeof
sed -i 's|include <crypt.h>|include <openssl/des.h>|' src/os/unix/ngx_linux_config.h
sed -i '1i#include <openssl/des.h>' src/os/unix/ngx_user.c
sed -i 's|value = crypt((|value = DES_crypt((|' src/os/unix/ngx_user.c
sed -i '1i#define NGX_HAVE_SCHED_SETAFFINITY 0' src/os/unix/ngx_setaffinity.h
sed -i '1i#define NGX_HAVE_CPUSET_SETAFFINITY 0' src/os/unix/ngx_setaffinity.h
cp auto/lib/pcre/make auto/lib/pcre/make.bak

#编译（arm）
sed -i 's|\./configure|\./configure --host=arm-linux-androideabi|g' auto/lib/pcre/make
NGX_PREFIX=/data CFLAGS='-I/root/android-arm/include' ./configure \
	--with-cc=arm-linux-androideabi-gcc \
	--error-log-path=/dev/null --http-log-path=/dev/null --pid-path=/dev/null \
	--prefix=/usr/local/nginx --with-cc-opt="-static" \
	--with-ld-opt="-static" --with-cpu-opt=generic \
	--with-pcre=./pcre-8.43 --with-zlib=./zlib-1.2.11 --with-http_slice_module \
	--with-http_addition_module --without-http_upstream_zone_module
echo -e '#ifndef NGX_SYS_NERR\n#define NGX_SYS_NERR  132\n#endif' >> objs/ngx_auto_config.h
echo -e '#ifndef NGX_HAVE_SYSVSHM\n#define NGX_HAVE_SYSVSHM 1\n#endif' >> objs/ngx_auto_config.h
sed -i 's|-static ./pcre-8.43/.libs/libpcre.a|-static ./pcre-8.43/.libs/libpcre.a /root/android-arm/lib/libssl.a /root/android-arm/lib/libcrypto.a|' objs/Makefile
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv objs/nginx ../nginx_arm
make clean

#编译（arm64）
cp auto/lib/pcre/make.bak auto/lib/pcre/make
sed -i 's|\./configure|\./configure --host=aarch64-linux-android|g' auto/lib/pcre/make
NGX_PREFIX=/data CFLAGS='-I/root/android-arm64/include' ./configure \
	--with-cc=aarch64-linux-android-gcc \
	--error-log-path=/dev/null --http-log-path=/dev/null --pid-path=/dev/null \
	--prefix=/usr/local/nginx --with-cc-opt="-static" \
	--with-ld-opt="-static" --with-cpu-opt=generic \
	--with-pcre=./pcre-8.43 --with-zlib=./zlib-1.2.11 --with-http_slice_module \
	--with-http_addition_module --without-http_upstream_zone_module
echo -e '#ifndef NGX_SYS_NERR\n#define NGX_SYS_NERR  132\n#endif' >> objs/ngx_auto_config.h
echo -e '#ifndef NGX_HAVE_SYSVSHM\n#define NGX_HAVE_SYSVSHM 1\n#endif' >> objs/ngx_auto_config.h
sed -i 's|-static -ldl ./pcre-8.43/.libs/libpcre.a|-static -ldl ./pcre-8.43/.libs/libpcre.a /root/android-arm64/lib/libssl.a /root/android-arm64/lib/libcrypto.a|' objs/Makefile
make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
mv objs/nginx ../nginx_arm64

#处理编译好的二进制文件
aarch64-linux-android-strip ../nginx_arm*
```

编译完之后，就可以删除源文件了
```shell
cd ..
rm -rf nginx-$nginx_version
```

### 下载
[编译好的文件](/assets/android-nginx.tar.gz)

[android-environment]: /编译/2019/11/22/android-environment.html
[android-openssl]: /编译/2019/11/22/android-openssl.html