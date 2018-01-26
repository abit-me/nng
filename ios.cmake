# refer to https://github.com/sheldonth/ios-cmake

cmake_minimum_required (VERSION 3.1)

set(IPHONEOS_DEPLOYMENT_TARGET 8.0)

set (CMAKE_CROSSCOMPILING, TRUE)

# Force the compilers to Clang for iOS
include (CMakeForceCompiler)
set (CMAKE_C_COMPILER /usr/bin/clang)
set (CMAKE_CXX_COMPILER /usr/bin/clang++)
set (CMAKE_AR ar CACHE FILEPATH "" FORCE)

# Skip the platform compiler checks for cross compiling
set (CMAKE_CXX_COMPILER_WORKS TRUE)
set (CMAKE_C_COMPILER_WORKS TRUE)

# Set cross compiling
set (CMAKE_SYSTEM_NAME "Darwin")
set (CMAKE_SYSTEM_VERSION "8.0")
set (CMAKE_SYSTEM_PROCESSOR "arm")
set (CMAKE_CROSSCOMPILING TRUE)

# All iOS/Darwin specific settings - some may be redundant
set (CMAKE_SHARED_LIBRARY_PREFIX "lib")
set (CMAKE_SHARED_LIBRARY_SUFFIX ".dylib")
set (CMAKE_SHARED_MODULE_PREFIX "lib")
set (CMAKE_SHARED_MODULE_SUFFIX ".so")
set (CMAKE_MODULE_EXISTS 1)
set (CMAKE_DL_LIBS "")

set (CMAKE_C_OSX_COMPATIBILITY_VERSION_FLAG "-compatibility_version 1.0.0")
set (CMAKE_C_OSX_CURRENT_VERSION_FLAG "-current_version 1.0.0")
set (CMAKE_CXX_OSX_COMPATIBILITY_VERSION_FLAG "${CMAKE_C_OSX_COMPATIBILITY_VERSION_FLAG}")
set (CMAKE_CXX_OSX_CURRENT_VERSION_FLAG "${CMAKE_C_OSX_CURRENT_VERSION_FLAG}")

set (CMAKE_C_FLAGS_INIT "-miphoneos-version-min=8.0")
set (CMAKE_CXX_FLAGS_INIT "-miphoneos-version-min=8.0")

set (CMAKE_C_FLAGS "-std=c99 -x objective-c -DNDEBUG=1 ${CMAKE_C_FLAGS_INIT}")
set (CMAKE_CXX_FLAGS "-std=c++11 -x objective-c++ -DNDEBUG=1 ${CMAKE_CXX_FLAGS_INIT}")

set (CMAKE_C_LINK_FLAGS "-Wl,-search_paths_first ${CMAKE_C_LINK_FLAGS}")
set (CMAKE_CXX_LINK_FLAGS "-Wl,-search_paths_first ${CMAKE_CXX_LINK_FLAGS}")

set (CMAKE_PLATFORM_HAS_INSTALLNAME 1)
set (CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-dynamiclib -headerpad_max_install_names")
set (CMAKE_SHARED_MODULE_CREATE_C_FLAGS "-bundle -headerpad_max_install_names")
set (CMAKE_SHARED_MODULE_LOADER_C_FLAG "-Wl,-bundle_loader,")
set (CMAKE_SHARED_MODULE_LOADER_CXX_FLAG "-Wl,-bundle_loader,")
set (CMAKE_FIND_LIBRARY_SUFFIXES ".dylib" ".so" ".a")


if (NOT DEFINED CMAKE_INSTALL_NAME_TOOL)
	find_program(CMAKE_INSTALL_NAME_TOOL install_name_tool)
endif (NOT DEFINED CMAKE_INSTALL_NAME_TOOL)

# Setup iOS platform unless specified manually with IOS_PLATFORM
if (NOT DEFINED IOS_PLATFORM)
	set (IOS_PLATFORM "OS")
endif (NOT DEFINED IOS_PLATFORM)
set (IOS_PLATFORM ${IOS_PLATFORM} CACHE STRING "Type of iOS Platform")

# Check the platform selection and setup for developer root
if (IOS_PLATFORM STREQUAL "OS")
	
	set (IOS_PLATFORM_LOCATION "iPhoneOS.platform")
	# This causes the installers to properly locate the output libraries
	set (CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphoneos")

elseif (IOS_PLATFORM STREQUAL "OS64")
	
	set (IOS_PLATFORM_LOCATION "iPhoneOS.platform")
	# This causes the installers to properly locate the output libraries
	set (CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphoneos")

elseif (IOS_PLATFORM STREQUAL "SIMULATOR")
	
    set (SIMULATOR true)
	set (IOS_PLATFORM_LOCATION "iPhoneSimulator.platform")
	# This causes the installers to properly locate the output libraries
	set (CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphonesimulator")

elseif (IOS_PLATFORM STREQUAL "SIMULATOR64")

    set (SIMULATOR true)
	set (IOS_PLATFORM_LOCATION "iPhoneSimulator.platform")
	# This causes the installers to properly locate the output libraries
	set (CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphonesimulator")
	
else ()
	message (FATAL_ERROR "Unsupported IOS_PLATFORM value selected. Please choose OS or SIMULATOR")
endif ()

set (IPHONE_DEV_ROOT "/Applications/Xcode.app/Contents/Developer/Platforms/${IOS_PLATFORM_LOCATION}/Developer")
set (CMAKE_IOS_DEVELOPER_ROOT ${IPHONE_DEV_ROOT})
set (CMAKE_IOS_DEVELOPER_ROOT ${CMAKE_IOS_DEVELOPER_ROOT} CACHE PATH "Location of iOS Platform")


# Find and use the most recent iOS sdk unless specified manually with CMAKE_IOS_SDK_ROOT
if (NOT DEFINED CMAKE_IOS_SDK_ROOT)
	file (GLOB _CMAKE_IOS_SDKS "${CMAKE_IOS_DEVELOPER_ROOT}/SDKs/*")
	if (_CMAKE_IOS_SDKS) 
		list (SORT _CMAKE_IOS_SDKS)
		list (REVERSE _CMAKE_IOS_SDKS)
		list (GET _CMAKE_IOS_SDKS 0 CMAKE_IOS_SDK_ROOT)
	else (_CMAKE_IOS_SDKS)
		message (FATAL_ERROR "No iOS SDK's found in default search path ${CMAKE_IOS_DEVELOPER_ROOT}. Manually set CMAKE_IOS_SDK_ROOT or install the iOS SDK.")
	endif (_CMAKE_IOS_SDKS)
	message (STATUS "Toolchain using default iOS SDK: ${CMAKE_IOS_SDK_ROOT}")
endif (NOT DEFINED CMAKE_IOS_SDK_ROOT)
set (CMAKE_IOS_SDK_ROOT ${CMAKE_IOS_SDK_ROOT} CACHE PATH "Location of the selected iOS SDK")

# Set the sysroot default to the most recent SDK
set (CMAKE_OSX_SYSROOT ${CMAKE_IOS_SDK_ROOT} CACHE PATH "Sysroot used for iOS support")

# set the architecture for iOS 
if (IOS_PLATFORM STREQUAL "OS")
    set (IOS_ARCH armv7)
elseif (IOS_PLATFORM STREQUAL "OS64")
    set (IOS_ARCH arm64)  
elseif (IOS_PLATFORM STREQUAL "SIMULATOR")
    set (IOS_ARCH i386)
elseif (IOS_PLATFORM STREQUAL "SIMULATOR64")
    set (IOS_ARCH x86_64)
endif ()

set (CMAKE_OSX_ARCHITECTURES ${IOS_ARCH} CACHE string  "Build architecture for iOS")

# Set the find root to the iOS developer roots and to user defined paths
set (CMAKE_FIND_ROOT_PATH ${CMAKE_IOS_DEVELOPER_ROOT} ${CMAKE_IOS_SDK_ROOT} ${CMAKE_PREFIX_PATH} CACHE string  "iOS find search path root")

# default to searching for frameworks first
set (CMAKE_FIND_FRAMEWORK FIRST)

# set up the default search directories for frameworks
set (CMAKE_SYSTEM_FRAMEWORK_PATH
	${CMAKE_IOS_SDK_ROOT}/System/Library/Frameworks
	${CMAKE_IOS_SDK_ROOT}/System/Library/PrivateFrameworks
	${CMAKE_IOS_SDK_ROOT}/Developer/Library/Frameworks
)

# only search the iOS sdks, not the remainder of the host filesystem
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


# This little macro lets you set any XCode specific property
macro (set_xcode_property TARGET XCODE_PROPERTY XCODE_VALUE)
	set_property (TARGET ${TARGET} PROPERTY XCODE_ATTRIBUTE_${XCODE_PROPERTY} ${XCODE_VALUE})
endmacro (set_xcode_property)


# This macro lets you find executable programs on the host system
macro (find_host_package)
	set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
	set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
	set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
	set (IOS FALSE)

	find_package(${ARGN})

	set (IOS TRUE)
	set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
	set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
	set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
endmacro (find_host_package)


