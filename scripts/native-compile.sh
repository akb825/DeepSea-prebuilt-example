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

# Install to an intermediate location first to ensure absolute paths aren't used.
cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_ROOT_PATH="$INSTALL_DIR" \
	-DCMAKE_INSTALL_PREFIX=install $@
make -j$PROCESSORS
make install
mv install "$INSTALL_PREFIX"
