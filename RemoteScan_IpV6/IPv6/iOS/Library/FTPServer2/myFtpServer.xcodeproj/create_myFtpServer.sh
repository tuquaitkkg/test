#!/bin/sh

export LIB_NAME=libmyFtpServer.a

export IPHONEOS_SDK=iphoneos8.1
export IPHONESIMULATOR_SDK=iphonesimulator8.1

export DSTROOT=./

# Build For iphoneos
xcodebuild -sdk ${IPHONEOS_SDK} DSTROOT=${DSTROOT}
# Build For iphonesimulator
xcodebuild -sdk ${IPHONESIMULATOR_SDK} DSTROOT=${DSTROOT}

# Create Universal Binariy
lipo -create build/Release-iphoneos/${LIB_NAME} build/Release-iphonesimulator/${LIB_NAME} -output build/${LIB_NAME}

# chmod
chmod 755 build/${LIB_NAME}

# Show lib arch
lipo -info build/${LIB_NAME}
