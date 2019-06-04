#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROCESSORS="$( "$DIR/processors.sh" )"

INSTALL_PREFIX="$INSTALL_DIR/ios"

rm -rf "$INSTALL_PREFIX"

# Install to an intermediate location first to ensure absolute paths aren't used.
cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_ROOT_PATH="$INSTALL_DIR" \
	-DCMAKE_INSTALL_PREFIX=install -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake $@
make -j$PROCESSORS
make install
mv install "$INSTALL_PREFIX"
