---
layout: post
title: go 中 select 与 net.Conn 的联动
category: 折腾
---

&emsp;&emsp;要是可以这样就好了，但是不行，得自己想办法。

```go
select {
    case nread, err := conn.Read(buf):
}
```

&emsp;&emsp;初步的框架是这样的，conn 读取的内容通过 chan 发送到 select。但是因为 chan 只能在发送端关闭，所以我们需要一个 chan 来通知 conn 的读取函数。

```go
select {
    case <- time.After(timeout):
        // timeout logic
    case clientData := <-clientRx:
        // client logic
}
```

&emsp;&emsp;那么代码就变成了这样，通过 defer 来保证代码不会忘记执行。readClientConn 函数把读取到的数据通过 clientRx 发送回来。

```go
done := make(chan struct{})
go readClientConn(clientConn, done)
defer func() {
    done <- struct{}{}
    close(done)
}()
select {
    case <- time.After(timeout):
        // timeout logic
    case clientData := <-clientRx:
        // client logic
}
```

&emsp;&emsp;readClientConn 大概的逻辑是这样，用上 select 是因为上面的函数可能已经退出了，要避免阻塞。还有一些细节，比如 clientTx 发送的内容中不应该只包含 buf，还应该有 err，同时 conn 要设置读取超时，退出的时候应该关闭 clientTx。

```go
func readClientConn() {
    nread, err := conn.Read(buf)

    select {
        case clientTx <- buf:
        case <-done:
    }
}
```
