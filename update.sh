#!/usr/bin/env bash
set -e

# Perform update in this directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"

function printHelp {
	echo "Usage: `basename "$0"` [options]"
	echo
	echo "Updates the DeepSea code to create the pre-built packages."
	echo
	echo "Options:"
	echo "-c, --checkout <checkout>  Perform a git checkout rather than pulling from master."
	echo "-p, --platform <platforms> Download the pre-built library dependencies for the list of"
	echo "                           platforms. The following platforms are supported:"
	echo "                           - linux (Linux for x86-64)"
	echo "                           - mac (macOS for x86-64)"
	echo "                           - win32 (Windows for x86)"
	echo "                           - win64 (Windows for x86_64)"
	echo "                           - android (Android for all supported ABIs)"
}

CHECKOUT=
PLATFORMS=()

while [ $# -gt 0 ]
do
	case "$1" in
		-h|--help)
			printHelp
			exit 0
			;;
		-c|--checkout)
			shift
			CHECKOUT="$1"
			;;
		-p|--platform)
			shift
			while [ $# -gt 0 -a "${1:0:1}" != '-' ]
			do
				if [ "$1" = "android" ]; then
					PLATFORMS+=("android-all")
				else
					PLATFORMS+=("$1")
				fi
				shift
			done
			continue
			;;
		*)
			CMAKE_ARGS="$CMAKE_ARGS $1"
			;;
	esac
	shift
done

DEEPSEA_DIR="$DIR/DeepSea"
if [ ! -d "$DEEPSEA_DIR" ]; then
	git clone https://github.com/akb825/DeepSea.git
fi

cd "$DEEPSEA_DIR"
if [ -z "$CHECKOUT" ]; then
	git pull
else
	git checkout "$CHECKOUT"
fi

./update.sh -s -t -l ${PLATFORMS[@]}
