---
layout: post
title: Bash Shell 历史记录优化
category: 折腾
---

```shell
#默认记录 500 条，调整成 100,000 条
sed -i '/HISTSIZE/d' ~/.bashrc
echo 'HISTSIZE=100000' >> ~/.bashrc
export HISTSIZE=100000

#记录命令的执行时间
sed -i '/HISTTIMEFORMAT/d' ~/.bashrc
echo "HISTTIMEFORMAT='%F %T  '" >> ~/.bashrc
export HISTTIMEFORMAT='%F %T  '

#实时记录
sed -i '/histappend/d' ~/.bashrc
sed -i '/PROMPT_COMMAND/d' ~/.bashrc
echo "shopt -s histappend" >> ~/.bashrc
echo "PROMPT_COMMAND='history -a'" >> ~/.bashrc
shopt -s histappend
export PROMPT_COMMAND='history -a'
```
