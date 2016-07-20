# !/usr/bin/sh

# version_countup.sh

#本ファイルのパス
DIR=`pwd`

# Xcodeのプロジェクトへのパス
PROJ_FILE_PATH="${DIR}/SharpScanPrint.xcodeproj"

# plistの場所
PLIST_1="SharpScanPrint-Info.plist"
PLIST_2="SharpScanPrint_Int-Info.plist"
PLIST_3="SharpScanPrint_Ent-Info.plist"
PLIST_4="SharpScanPrint_EntInt-Info.plist"

# バージョン番号ありなしの確認
if (test ! -z ${SDM_VERSION}) ; then
  echo "SDM_VERSIONあり"
elif(test ! -z $1) ; then
  echo "SDM_VERSIONなし・引数あり"
  SDM_VERSION=$1
else
  echo "SDM_VERSIONなし・引数なし。終了。"
  exit -1
fi

# バージョン番号更新
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${SDM_VERSION}" ${DIR}/${PLIST_1}
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${SDM_VERSION}" ${DIR}/${PLIST_2}
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${SDM_VERSION}" ${DIR}/${PLIST_3}
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${SDM_VERSION}" ${DIR}/${PLIST_4}

# SVNへコミット
svn ci -m "VersionNo Count up to ${SDM_VERSION}"
# SVN更新
svn update
# SVNでタグ付け
svn copy ../ http://10.8.2.150/svn/repos/SharpdeskMobile/tags/iOS/SharpScanPrint_${SDM_VERSION}/ -m "Add Tag : ${SDM_VERSION}_SharpScanPrint"
exit 0
