cmake_minimum_required(VERSION 3.5)
project(DeeepSeaPrebuilt)
set(CMAKE_CXX_STANDARD 11)

# Set up CMake to find the pre-installed binaries.
if (ANDROID)
	set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install/android-${ANDROID_ABI})
elseif (WIN32)
	if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
		set(CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/install/win64)
	else()
		set(CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/install/win32)
	endif()
elseif (IOS)
		set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install/ios)
elseif (APPLE)
	if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
		set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install/mac)
	endif()
else()
	if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
		set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install/linux)
	endif()
endif()

set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
include(cmake/ConvertFlatbuffers.cmake)

function(add_test_executable target)
	if (ANDROID)
		add_library(${target} SHARED ${ARGN})
	elseif (IOS)
		add_executable(${target} MACOSX_BUNDLE ${ARGN})
		string(TOLOWER ${target} targetLower)
		set_target_properties(${target} PROPERTIES
			MACOSX_BUNDLE_GUI_IDENTIFIER com.deepsea.prebuilt.${targetLower}
			MACOSX_BUNDLE_BUNDLE_NAME ${target}
			MACOSX_BUNDLE_INFO_PLIST ${ROOT_DIR}/cmake/iOSBundleInfo.plist.in
			XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY 1,2)
	else()
		add_executable(${target} WIN32 ${ARGN})
	endif()
endfunction()

add_subdirectory(TestVectorDraw)
add_subdirectory(TestScene)
