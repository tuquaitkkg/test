#!/bin/sh
export DIR=`pwd`

##############################
# Build FTPServer2
##############################
cd ${DIR}/FTPServer2
sh ./create_myFtpServer.sh

##############################
# Build ImgeProcessing
##############################
cd ${DIR}/ImageProcessing
sh ./create_ImageProcessing.sh

##############################
# Build MailCore
##############################
cd ${DIR}/MailCore
sh ./create_MailCore.sh

##############################
# Build SharpScanPrintRemoteScan
##############################
cd ${DIR}/SharpScanPrintRemoteScan
sh ./create_SharpScanPrintRemoteScan.sh

##############################
# Build Snmp_pp
##############################
cd ${DIR}/Snmp_pp/Snmp/
sh ./create_Snmp.sh

##############################
# 成果物のコピー
##############################
cd ${DIR}
mkdir -p lib

cp FTPServer2/build/*.a lib/

cp -fr ImageProcessing/build/*.a lib/
cp -fr ImageProcessing/build/Release-iphoneos/include lib

cp -fr MailCore/build/*.a lib/
cp -fr MailCore/build/Release-iphoneos/include lib

cp -fr SharpScanPrintRemoteScan/build/*.a lib/
cp -fr SharpScanPrintRemoteScan/build/Release-iphoneos/include lib

cp -fr Snmp_pp/Snmp/build/*.a lib/
