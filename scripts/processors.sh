#!/bin/sh
set -e

if [ "$(uname)" = "Darwin" ]; then
	echo `sysctl -n hw.ncpu`
else
	echo `grep -c ^processor /proc/cpuinfo`
fi
