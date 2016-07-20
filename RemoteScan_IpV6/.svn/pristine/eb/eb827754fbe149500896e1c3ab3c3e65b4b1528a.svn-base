#!/bin/sh

export LIB_NAME=libmyFtpServer.a

export OS_VER=9.2
export IPHONEOS_SDK=iphoneos${OS_VER}
export IPHONESIMULATOR_SDK=iphonesimulator${OS_VER}

export DSTROOT=./

# Build For iphoneos
xcodebuild -sdk ${IPHONEOS_SDK} DSTROOT=${DSTROOT} OTHER_CFLAGS="-fembed-bitcode"   
# Build For iphonesimulator
xcodebuild -sdk ${IPHONESIMULATOR_SDK} DSTROOT=${DSTROOT} OTHER_CFLAGS="-fembed-bitcode"

# Create Universal Binariy
lipo -create build/Release-iphoneos/${LIB_NAME} build/Release-iphonesimulator/${LIB_NAME} -output build/${LIB_NAME}

# chmod
chmod 755 build/${LIB_NAME}

# Show lib arch
lipo -info build/${LIB_NAME}
