---
layout: post
title: 搭建 musl 交叉编译环境
category: 编译
---

```bash
for chain in x86_64-linux-musl-native i686-linux-musl-native mipsel-linux-musl-cross mips-linux-musl-cross mips64el-linux-musl-cross mips64-linux-musl-cross aarch64-linux-musl-cross arm-linux-musleabi-cross; do
    curl -O "http://musl.cc/$chain.tgz"
    rm -rf /usr/local/$chain
    tar xf $chain.tgz -C /usr/local
    rm -f $chain.tgz

    sed -i "/$chain/d" ~/.bashrc
    echo "export PATH=\$PATH:/usr/local/$chain/bin" >>~/.bashrc
    . ~/.bashrc
done
```