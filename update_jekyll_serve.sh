#!/bin/bash

while true;do
	cd /root/FH0.github.io
	bundle exec jekyll s --host 0.0.0.0 --port 808 --incremental &
	jekyll_pid=$!
	read
	kill $jekyll_pid
done
