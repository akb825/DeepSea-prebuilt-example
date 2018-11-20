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

Two scripts are provided to help in building the packages:

* `update.sh`: downloads and updates the DeepSea repository. Using the `-p` option you can tell it which platforms to download dependencies for. If you don't provide `-p`, it will only update previously downloaded platforms, so it's important to use `-p` at least once for the initial platforms you intend to build.
* `prebuild.sh`/`prebuild.bat`: script to compile and install the pre-built DeepSea libraries. The `-p` option can be used to cross-compile for different platforms:
	* On Mac and Linux, you can use the `android` platform to build the Android libraries. By default it will build for the native platform.
	* On Windows, you can use `win32` and `win64` to build for 32-bit or 64-bit. By default it will build 32-bit.

## Linux and macOS

Make sure the development tools and dependencies are installed.

For example, on Ubuntu the following packages should be installed:

* cmake
* build-essential

For macOS using [Homebrew](https://brew.sh/), the following packages should be installed:

* cmake

### Pre-building DeepSea

First run the `update.sh` script with the `-p` option for your platform. In other words, run `./update.sh -p linux` on Linux or `./update.sh -p mac` on Mac. After the initial setup, you can omit the `-p` option to get the latest code.

After pulling the latest code, run `./prebuild.sh` to create the pre-built package.

### Building the test application

Once the pre-built package has been built, you can then run CMake as normal in order to build the test application. For example:

	mkdir build
	cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make -j8
	
The test application may be found under `TestVectorDraw/TestVectorDrawApp`.

Use the arrow keys to cycle through the SVGs and press 'w' to toggle wireframe.

## Android

The Android test app can be built using [Android Studio](https://developer.android.com/studio/). This can be used on any platform, though scripts to automate creating the pre-built packages are only provided for Linux and macOS.

You will need the following packages installed in Android Studio:

* SDK Platform API 18 (Android 4.3 Jelly Bean)
* SDK Tools:
	* CMake
	* LLDB
	* NDK

### Pre-building DeepSea

First run `./update.sh -p android` to download DeepSea and get the dependencies for Android. After the initial setup, you can omit the `-p` option to get the latest code.

After pulling the latest code, run `./prebuild.sh -p android --android-sdk ~/Android/Sdk` to create the pre-built package. Note that `~/Android/Sdk` is the default install location for the Android SDK, change the path as necessary if you installed in a custom location.

### Building the test application

Open the project under the android sub-directory in Android Studio. After building the APK, you should be able to deploy and run it on any reasonably up to date Android phone. Tap to view the next SVG and use a two-finger tap to view the previous SVG.

> **Note:** If you wish to run the test application in the emulator, you must enable OpenGL ES 3.1 support. In the control panel that comes off the side of the emulator, press the "..." button, go to Settings, then Advanced and set OpenGL ES API level to "Renderer maximum".

## Windows

The project on Windows can be built using Visual Studio 2015 or higher. You will also need CMake installed, with the `cmake` executable available from the `PATH` environment variable. It's assumed you have Git installed as well.

### Pre-building DeepSea

First run the `update.sh` script within either Git Bash or Cygwin, depending on how you've installed git. You must pass the `-p win32` option to download the dependencies for a 32-bit build or `-p win64` to download the dependencies for a 64-bit build. After the initial setup, you can omit the `-p` option to get the latest code for the previously installed platforms.

Within a cmd prompt, you can run the `prebuild.bat` script. By default it will build 32-bit, but you can pass `-p win64` to build for 64-bit instead.

### Building the test application

Once the pre-built package has been built, you can then run CMake as normal in order to build the test application. For example, to build a Visual Studio 2017 project:

	mkdir build
	cd build
	cmake .. -G "Visual Studio 15 2017"

Alternatively, the CMake GUI tool can be used to generate the project.

Once the Visual Studio project has been created, open it and build the TestVectorDrawApp target. Use the arrow keys to cycle through the SVGs and press 'w' to toggle wireframe.