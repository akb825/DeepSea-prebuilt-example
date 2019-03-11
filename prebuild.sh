#!/usr/bin/env bash
set -e

# Perform build in this directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CWD="$( pwd )"
cd "$DIR"

INSTALL_DIR="$DIR/install"
DEEPSEA_DIR="$DIR/DeepSea"
BUILD_DIR="$DEEPSEA_DIR/build"
FLAGS=`cat "$DIR/scripts/flags"`
PLATFORM=native
CMAKE_ARGS=
ANDROID_NDK=
ANDROID_VERSION=android-18

function printHelp {
	echo "Usage: `basename "$0"` [options] [CMake args...]"
	echo
	echo "Builds pre-built packages for DeepSea to build the example against."
	echo
	echo "Options:"
	echo "-p, --platform <platform>    The platform to build for. Valid platforms are:"
	echo "                             - native (default)"
	echo "                             - android"
	echo "--android-ndk <dir>          Directory of the Android NDK root. Must be set"
	echo "                             when platform is set to 'android'."
	echo "--android-version <version>  Version to use when building for Android. Defaults"
	echo "                             to $ANDROID_VERSION"
}

while [ $# -gt 0 ]
do
	case "$1" in
		-h|--help)
			printHelp
			exit 0
			;;
		-p|--platform)
			shift
			case "$1" in
				native|android)
					PLATFORM=$1
					;;
				*)
					echo "Unknown platform: $1"
					echo
					printHelp
					exit 1
				;;
			esac
			;;
		--android-ndk)
			shift
			ANDROID_NDK="$1"
			;;
		--android-version)
			shift
			ANDROID_VERSION="$1"
			;;
		*)
			CMAKE_ARGS="$CMAKE_ARGS $1"
			;;
	esac
	shift
done

if [ $PLATFORM = android ]; then
	if [ -z "$ANDROID_NDK" ]; then
		echo "The --android-ndk option must be given when building for Android."
		echo
		printHelp
		exit 1
	elif [ ! -d "$ANDROID_NDK" ]; then
		echo "Android NDK locaton '$ANDROID_NDK' doesn't exist."
		exit 1
	fi

	export ANDROID_NDK
	export ANDROID_VERSION
fi

export INSTALL_DIR

rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"

pushd "$BUILD_DIR" > /dev/null

echo "Building DeepSea..."
"$DIR/scripts/$PLATFORM-compile.sh" $FLAGS $CMAKE_ARGS

popd > /dev/null

echo "Cleaning up..."
rm -rf "$BUILD_DIR"

echo "Done"
