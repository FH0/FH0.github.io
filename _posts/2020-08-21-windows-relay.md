---
layout: post
title: 安卓手机通过 USB 使用电脑的网络
category: 折腾
---

&emsp;&emsp;距离上一次更新博客已经很久了，时间还真是过得快呢。回忆是淡淡的，无聊是压抑的。

&emsp;&emsp;为什么我会想到中继电脑的网络呢？其实就是打游戏的时候总是时不时卡一下，想试试新的方法来解决一下。有线的方式比无线的方式来得稳定，就想能不能通过 USB 使用电脑的网络。当然是可以的，通过谷歌的英文搜索，我发现在安卓 4.4 的那个年代，设置里面是集成了这个功能的，但是在后来的更新中不知道为什么去掉了这个功能。在几个 stackoverflow 的帖子中提到了 [gnirehtet](https://github.com/Genymobile/gnirehtet)。

&emsp;&emsp;试了一下，真的很强。这个软件大概的原理就是：通过`adb`启动手机上被自动安装的客户端，客户端启动 vpn 让数据通过 USB 到达电脑上的服务端，服务端实现了自己的协议栈来连接真正的服务端。

&emsp;&emsp;不想去 GitHub 里慢慢研究的话可以看看我的简易教程。
- 下载并解压[服务端文件](https://github.com/FH0/nubia/blob/master/gnirehtet-rust-win64.zip?raw=true)
![img](/assets/gnirehtet解压.png)
- 手机开启 USB 调试模式后连接电脑
![img](/assets/gnirehtet手机.jpg)
- 双击 gnirehtet-run.cmd
![img](/assets/gnirehtet_cmd.png)

&emsp;&emsp;但是我在使用过程中发现了几个问题：
- 如果 USB 线松动的话必须重启服务端
- 清理后台之后必须重启服务端

&emsp;&emsp;那我就很郁闷了呀，这个方案还是不够成熟。我现在并没有采取这种方式来打游戏，因为我发现把热点从 5G 频段换成 2.4G 频段之后就没问题了。