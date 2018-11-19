#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROCESSORS="$( "$DIR/processors.sh" )"
ANDROID_TOOLCHAIN="$ANDROID_SDK/ndk-bundle/build/cmake/android.toolchain.cmake"
ANDROID_ABIS=(x86 x86_64 armeabi-v7a arm64-v8a)

for ANDROID_ABI in ${ANDROID_ABIS[@]}
do
	INSTALL_PREFIX="$INSTALL_DIR/android-$ANDROID_ABI"
	rm -rf "$INSTALL_PREFIX"
	rm -rf *
	# Install to an intermediate location first to ensure absolute paths aren't used.
	cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_TOOLCHAIN_FILE="$ANDROID_TOOLCHAIN" \
		-DANDROID_PLATFORM=$ANDROID_VERSION -DANDROID_ABI=$ANDROID_ABI \
		-DCMAKE_INSTALL_PREFIX=install $@
	make -j$PROCESSORS
	make install
	mv install "$INSTALL_PREFIX"
done
