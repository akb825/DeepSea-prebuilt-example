# Introduction

DeepSea-prebuilt-example has a simple test application (the VectorDraw GUI tester from DeepSea) that's set up to use a pre-built DeepSea package. This is useful as a reference for projects that want to create a package of DeepSea to be shared among developers, and is also a good test to make sure that this functionality isn't broken.

This test should work on the following platforms.

* Linux for x86-64 (glibc 2.19 or later)
* macOS (10.11 or later)
* Windows for x86 and x86-64
* Android for x86, x86-64, armeabi-v7a, and arm64-v8a.

# Compiling

While this is an example of using pre-built DeepSea, you must pre-build DeepSea yourself. The pre-built packages should be placed onder the install directory with subfolders based on the desired platform:

* linux
* mac
* win32
* win64
* android-x86
* android-x86_64
* android-armeabi-v7a
* android-arm64-v8a

Scripts are provided to help in creating these pre-built packages.

## Linux and macOS

Make sure the development tools and dependencies are installed.

For example, on Ubuntu the following packages should be installed:

* cmake
* build-essential

For macOS using [Homebrew](https://brew.sh/), the following packages should be installed:

* cmake

### Pre-building DeepSea

First run `update.sh` with the platforms you want to build for. This will download the DeepSea repository and the binary dependencies for the requested platforms. On Linux run

	./update.sh -p linux

and on Mac run

	./update.sh -p mac

Subsequent calls to `update.sh` will automatically update for the previously requested platforms.

You may then run the `prebuild.sh` script. This will build for your current native platform by default.

### Building the test application

Once the pre-built package has been built, you can then run CMake as normal in order to build the test application. For example:

	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make -j8
	
The test application may be found under `TestVectorDraw/TestVectorDraw`.
