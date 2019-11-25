#!/bin/bash

while true;do
	bundle exec jekyll s --host 0.0.0.0 --port 808 &
	jekyll_pid=$!
	read
	kill $jekyll_pid
done
