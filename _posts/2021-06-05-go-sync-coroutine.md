---
layout: post
title: go 同步网络协程
category: 折腾
---

&emsp;&emsp;在代理、转发、中继的时候会用到这样的模型。第一个协程负责客户端，第二个协程负责服务端，第三个协程负责超时之类的事件处理。

&emsp;&emsp;然后有这样的逻辑

- 三个协程中的任意一个协程出错，三个协程都要退出
- 客户端和服务端超时，三个协程都要退出

&emsp;&emsp;然后 chan 没有设置缓冲的原因是协程之间并不是同步的。不能依赖缓冲实现上面的逻辑。所以也就有了大量的 select 设计。

&emsp;&emsp;之前用的是一个主协程加一个副协程的模型，select 所有的管道，但是这样一次只能处理一个管道，如果管道阻塞了同时其他的管道就绪，那么数据就不流通了。后来换成了两个协程，一个负责客户端，一个负责服务端，但是这样超时就被分开了。实现的逻辑就不是上面的第二点了，而是客户端或服务端超时，退出。所以下面的的模型是第三代，实际使用中还没有遇到问题，遇到问题再改嘛，这又不是一成不变的。

```go
package tests

import (
	"net"
	"testing"
	"time"
)

func TestFramework(t *testing.T) {
	clientTx := make(chan []byte)
	clientRx := make(chan []byte)
	done := make(chan struct{})
	exitOrUpdateTimer := make(chan bool)
	conn, _ := net.Dial("tcp", "")

	// client
	go func() {
		defer func() {
			// exit
			select {
			case exitOrUpdateTimer <- true:
			case <-done:
			}
		}()

		for {
			// read client
			var data []byte
			select {
			case data = <-clientRx:
			case <-done:
				return
			}

			// write server
			_, err := conn.Write(data)
			if err != nil {
				return
			}

			// update timer
			select {
			case exitOrUpdateTimer <- false:
			case <-done:
				return
			}
		}
	}()
	// server
	go func() {
		defer func() {
			close(clientTx)

			// exit
			select {
			case exitOrUpdateTimer <- true:
			case <-done:
			}
		}()

		for {
			// read server
			buf := make([]byte, 1024)
			nread, err := conn.Read(buf)
			if err != nil {
				return
			}

			// write client
			select {
			case clientTx <- append([]byte(nil), buf[:nread]...):
			case <-done:
				return
			}

			// update timer
			select {
			case exitOrUpdateTimer <- false:
			case <-done:
				return
			}
		}
	}()
	// timeout and others
	go func() {
		defer func() {
			close(done)
			conn.Close()
		}()

		for {
			select {
			case <-time.After(time.Second):
				return
			case exit := <-exitOrUpdateTimer:
				if exit {
					return
				} else {
					continue
				}
			}
		}
	}()
}
```
