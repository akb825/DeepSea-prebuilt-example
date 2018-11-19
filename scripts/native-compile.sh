#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROCESSORS="$( "$DIR/processors.sh" )"

if [ "$(uname)" = "Darwin" ]; then
	INSTALL_PREFIX="$INSTALL_DIR/mac"
else
	INSTALL_PREFIX="$INSTALL_DIR/linux"
fi

rm -rf "$INSTALL_PREFIX"

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_ROOT_PATH="$INSTALL_DIR" \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" $@
make -j$PROCESSORS
make install
