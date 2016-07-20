# !/usr/bin/sh

#本ファイルのパス
DIR=`pwd`
# DIR=`dirname ${0}`

#SDK
SDK="iphoneos"

# コンフィグレーション 「Debug」、「Release」、「Ad hoc」
CONFIGURATION="Release"

# Xcodeのプロジェクトへのパス
PROJ_FILE_PATH="${DIR}/SharpScanPrint.xcodeproj"

# ターゲット名
TARGET_NAME_1="SharpScanPrint"
TARGET_NAME_2="SharpScanPrint_Int"
TARGET_NAME_3="SharpScanPrint_Ent"
TARGET_NAME_4="SharpScanPrint_EntInt"

#「Build Settings」にある、プロダクト名
PRODUCT_NAME_1="SharpdeskMobile"
PRODUCT_NAME_2="SharpdeskMobileInt"
PRODUCT_NAME_3="SharpdeskMobileEnt"
PRODUCT_NAME_4="SharpdeskMobileEntInt"

# app出力先ディレクトリ名
OUT_APP_DIR="${DIR}/build/app"
# 出力先ipaディレクトリ名
OUT_IPA_DIR="${DIR}/build/ipa"

# 出力されるipaファイル名
IPA_FILE_NAME_1="SharpScanPrint"
IPA_FILE_NAME_2="SharpScanPrint_Int"
IPA_FILE_NAME_3="SharpScanPrint_Ent"
IPA_FILE_NAME_4="SharpScanPrint_EntInt"

# ディレクトリ作成
if [ ! -d "${OUT_APP_DIR}" ] ; then
    echo "${OUT_APP_DIR}";
	mkdir -p "${OUT_APP_DIR}"
fi

if [ ! -d "${OUT_IPA_DIR}" ] ; then
    echo "${OUT_IPA_DIR}";
    mkdir -p "${OUT_IPA_DIR}"
fi

# クリーン
xcodebuild clean -project "${PROJ_FILE_PATH}"

# ビルド & ipa作成
xcodebuild -project "${PROJ_FILE_PATH}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -target "${TARGET_NAME_1}" install DSTROOT="${OUT_APP_DIR}"
xcrun -sdk "${SDK}" PackageApplication "${OUT_APP_DIR}/Applications/${PRODUCT_NAME_1}.app" -o "${OUT_IPA_DIR}/${IPA_FILE_NAME_1}.ipa"

xcodebuild -project "${PROJ_FILE_PATH}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -target "${TARGET_NAME_2}" install DSTROOT="${OUT_APP_DIR}"
xcrun -sdk "${SDK}" PackageApplication "${OUT_APP_DIR}/Applications/${PRODUCT_NAME_2}.app" -o "${OUT_IPA_DIR}/${IPA_FILE_NAME_2}.ipa"

xcodebuild -project "${PROJ_FILE_PATH}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -target "${TARGET_NAME_3}" install DSTROOT="${OUT_APP_DIR}"
xcrun -sdk "${SDK}" PackageApplication "${OUT_APP_DIR}/Applications/${PRODUCT_NAME_3}.app" -o "${OUT_IPA_DIR}/${IPA_FILE_NAME_3}.ipa"

xcodebuild -project "${PROJ_FILE_PATH}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -target "${TARGET_NAME_4}" install DSTROOT="${OUT_APP_DIR}"
xcrun -sdk "${SDK}" PackageApplication "${OUT_APP_DIR}/Applications/${PRODUCT_NAME_4}.app" -o "${OUT_IPA_DIR}/${IPA_FILE_NAME_4}.ipa"
