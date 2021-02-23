---
layout: post
title: 重新编译 wsl2 的内核（增加 TPROXY 等特性）
category: 编译
---

&emsp;&emsp;wsl2 原本的内核并不支持 TPROXY，搜索得知是编译内核时没有勾选上相关的选项。其实其它基于 linux 的系统都可以的了，像是 android，openwrt 都可以重新编译内核来获取某一些开发者未开启的特性。

```bash
curl -L "https://github.com/microsoft/WSL2-Linux-Kernel/archive/linux-msft-5.4.91.tar.gz" | tar xz
cd WSL2-Linux-Kernel-linux-msft-5.4.91/
apt install g++ make flex bison libssl-dev libelf-dev bc -y
make KCONFIG_CONFIG=Microsoft/config-wsl menuconfig # 图形化的安装界面，键入 / 进行搜索
make KCONFIG_CONFIG=Microsoft/config-wsl bzImage -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
cp arch/x86/boot/bzImage ../kernel
rm -rf $(pwd)
cd ..
```

&emsp;&emsp;大概编译了 8 分钟（编译的过程中遇到了常量的错误，需要修改源码。如果不想修改源码可以试试其它的版本，上面的版本是 5.4.91）。使用 PowerShell 执行 `wsl --shutdown`，将 C:\Windows\System32\lxss\tools\kernel 替换为刚刚编译好的，最好先备份。重启 windows。

&emsp;&emsp;成果就是这样的
```bash
# uname -a
Linux DESKTOP-AS277IS 5.4.91-microsoft-standard-WSL2 #1 SMP Tue Feb 23 15:04:12 CST 2021 x86_64 x86_64 x86_64 GNU/Linux
# grep -i tproxy /proc/net/ip_tables_targets
TPROXY
TPROXY
```

&emsp;&emsp;也可以参考 <https://blog.csdn.net/qq_40856284/article/details/106535962>
