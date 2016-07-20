#!/bin/sh

##############################
#　MailCore関連ライブラリーは、実機用とシミュレータ用のライブラリーを結合しません。
##############################

export DIR=`pwd`
export OUT_DIR="${DIR}/build"

export OS_VER=9.2
export IPHONEOS_SDK=iphoneos${OS_VER}
# export IPHONESIMULATOR_SDK=iphonesimulator${OS_VER}

##############################
# Build openssl
##############################
cd $DIR/iOSPorts/ports/security/openssl

export LIB_NAME=libssl.a
xcodebuild -scheme "ssl" -configuration Release -sdk ${IPHONEOS_SDK} SYMROOT="${DIR}/build" archive
# xcodebuild -scheme "ssl" -configuration Release -sdk ${IPHONESIMULATOR_SDK} SYMROOT="${DIR}/build"

cp "${DIR}/build/Release-iphoneos/${LIB_NAME}" "${DIR}/build/${LIB_NAME}"
chmod 755 "${DIR}/build/${LIB_NAME}"

export LIB_NAME=libcrypto.a
xcodebuild -scheme "crypto" -configuration Release -sdk ${IPHONEOS_SDK} SYMROOT="${DIR}/build" archive
# xcodebuild -scheme "crypto" -configuration Release -sdk ${IPHONESIMULATOR_SDK} SYMROOT="${DIR}/build"

cp "${DIR}/build/Release-iphoneos/${LIB_NAME}" "${DIR}/build/${LIB_NAME}"
chmod 755 "${DIR}/build/${LIB_NAME}"

##############################
# cyrus-sasl
##############################
cd $DIR/iOSPorts/ports/security/cyrus-sasl

export LIB_NAME=libsasl2.a
xcodebuild -scheme "sasl2" -configuration Release -sdk ${IPHONEOS_SDK} SYMROOT="${DIR}/build" archive
# xcodebuild -scheme "sasl2" -configuration Release -sdk ${IPHONESIMULATOR_SDK} SYMROOT="${DIR}/build"

cp "${DIR}/build/Release-iphoneos/${LIB_NAME}" "${DIR}/build/${LIB_NAME}"
chmod 755 "${DIR}/build/${LIB_NAME}"

##############################
# Build libetpan
##############################
cd $DIR

export LIB_NAME=libetpan-ios.a
xcodebuild -scheme "libetpan ios" -configuration Release -sdk ${IPHONEOS_SDK} SYMROOT="${DIR}/build"
# xcodebuild -scheme "libetpan ios" -configuration Release -sdk ${IPHONESIMULATOR_SDK} SYMROOT="${DIR}/build"

cp "${DIR}/build/Release-iphoneos/${LIB_NAME}" "${DIR}/build/${LIB_NAME}"
chmod 755 "${DIR}/build/${LIB_NAME}"

##############################
# Build MailCore
##############################
cd $DIR

export LIB_NAME=libmailcore.a
xcodebuild -scheme "MailCore iOS" -configuration Release -sdk ${IPHONEOS_SDK} SYMROOT="${DIR}/build" archive
# xcodebuild -scheme "MailCore iOS" -configuration Release -sdk ${IPHONESIMULATOR_SDK} SYMROOT="${DIR}/build"

cp "${DIR}/build/Release-iphoneos/${LIB_NAME}" "${DIR}/build/${LIB_NAME}"
chmod 755 "${DIR}/build/${LIB_NAME}"
