cmake_minimum_required(VERSION 3.1)

# Set up CMake to find the pre-installed binaries.
if (ANDROID)
	set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install/android-${ANDROID_ABI})
elseif (WIN32)
	if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
		set(CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/install/win64)
	else()
		set(CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/install/win32)
	endif()
elseif (APPLE)
	# TODO: iOS
	if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
		set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install/mac)
	endif()
else()
	if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
		set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install/linux)
	endif()
endif()

add_subdirectory(TestVectorDraw)
