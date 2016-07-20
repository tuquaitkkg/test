
#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import "Define.h"
#import "NetworkInformation.h"
#import "PrinterDataManager.h"
#import "ProfileDataManager.h"
#import "PrintOutDataManager.h"
#import "PunchData.h"
#import "FinishingData.h"
#include <mach/host_info.h>
#include <mach/mach_init.h>
#include <mach/mach_host.h>
#import <netdb.h>      // IPv6対応
@class SnmpManager;

@interface SharpScanPrintUserAuthentication : NSObject
{
}
- (NSData *)encryptionAES128Data:(NSData *)encData :(NSString *)key;
- (NSData *)encryptionAES128Data:(NSData *)encData :(NSString *)key :(NSString *)iv;
- (NSData *)decryptionAES128Data:(NSData *)decData :(NSString *)key;
- (NSData *)decryptionAES128Data:(NSData *)decData :(NSString *)key :(NSString *)iv;
- (NSString*) base64Encoding:(NSData *)encData;
- (NSData *)base64Decoding:(NSString *)base64String;

- (NSString*) getAccountLogin:(NSString*)accountLogin SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding;
- (NSString*) getAccountPassword:(NSString*)accountPassword SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding;
- (NSString*) getAccountLoginw:(NSString*)accountLogin SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding;
- (NSString*) getAccountPasswordw:(NSString*)accountPassword SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding;

- (NSString*) getRetentionPassword:(NSString*)retentionPassword SpoolTime:(NSString*)spoolTome;

@end

@interface CommonUtil : NSObject 
{
    SharpScanPrintUserAuthentication    *SSPA;
}

//一時保存ファイル用ファイル名を作成する
+(NSString *)createFileName :(NSString *)suffix;
//UUIDを取得する
+ (NSString *)createUUID;
//一時保存ファイル格納ディレクトリを取得する
+ (NSString *)tmpDir;

//FTP受信ディレクトリを取得する
+ (NSString *)ftpDir;

//保存ファイル格納ディレクトリを取得する
+ (NSString *)documentDir;

////サムネイル画像格納ディレクトリを取得する
//+ (NSString *)pngDir:(NSString *)path;

//添付ファイル用一時保存ファイル格納ディレクトリを取得する
+ (NSString *)tmpAttachmentDir;

////zip解凍用一時保存ファイル格納ディレクトリを取得する
//+ (NSString *)zipArchiveDir:(NSString *)path;

//保存画像のサムネイル画像パスを取得する
+ (NSString *)thumbnailPath:(NSString *)path;

//削除画像のサムネイル画像パスを取得する（検索時の複数選択）
+ (NSString *)deleteThumbnailPath:(NSString *)path;

////旧仕様の保存画像のサムネイル画像パスを取得する
//+ (NSString *)oldThumbnailPath:(NSString *)path;

//設定ファイル格納ディレクトリを取得する
+ (NSString *)settingFileDir;

// IPアドレス取得する
+ (NSString *) getIPAdder;

// 通信に使用する端末とプリンターのIPアドレスを取得する
+ (NSDictionary*)getIPAddrDicForComm:(NSString*)mfpIPAddr port:(NSString*)strPort;

// 対応拡張子チェック(拡張子指定)
+ (BOOL)extensionCheck:(NSString*)extension;

// 拡張子チェック(ファイル名指定)
+ (BOOL)extensionFileCheck:(NSString*)fileName;

// tiffファイルチェック
+ (BOOL)tiffExtensionCheck:(NSString*)pstrFilePath;

// jpegファイルチェック
+ (BOOL)jpegExtensionCheck:(NSString*)pstrFilePath;   

// pdfファイルチェック
+ (BOOL)pdfExtensionCheck:(NSString*)pstrFilePath; 

// pngファイルチェック
+ (BOOL)pngExtensionCheck:(NSString*)pstrFilePath;

// Officeファイルチェック
+ (BOOL)officeExtensionCheck:(NSString*)pstrFilePath;

// Wordファイルチェック
+ (BOOL)wordExtensionCheck:(NSString*)pstrFilePath;

// Excelファイルチェック
+ (BOOL)excelExtensionCheck:(NSString*)pstrFilePath;

// PowerPointファイルチェック
+ (BOOL)powerpointExtensionCheck:(NSString*)pstrFilePath;

//// sarch keyを取得  local　設定に変更
//+ (NSString*) searchKey;
//
//// sarch keyを設定
//+ (void)setSearchKey:(NSString*) searchKey;

// sortTypeを取得
+ (enum ScanDataSortType) scanDataSortType;

// sortTypeを設定
+ (void)setScanDataSortType:(enum ScanDataSortType) scanDataSortType;

// sortDirを取得
+ (enum ScanDataSortDirectionType) scanDataSortDirectionType;

// sortTypeを設定
+ (void)ScanDataSortDirectionType:(enum ScanDataSortDirectionType) scanDataSortDirectionType;

// 除外フォルダチェック(Cache-フォルダやDIRZIP-フォルダーは除外対象)
// TempAttachmentFileの場合に使用する
+ (BOOL)exclusionDirectoryCheck:(NSString*)directoryPath name:(NSString*)directoryName;

// フォルダーチェック(ファイル一覧表示用)
+ (BOOL)directoryCheck:(NSString*)directoryPath name:(NSString*)directoryName;

// フォルダーチェック(ファイル、サムネイルフォルダ用)
+ (BOOL)directoryCheck2:(NSString*)directoryPath name:(NSString*)directoryName;

// UUID作成
+ (NSString *)CreatUUID;

// 文字数取得
+ (int) strLength :(NSString *)strValue;

// 半角文字であるかの判定
+ (BOOL) hasHalfChar :(NSString*) strValue;

// 全角チェック
+ (BOOL)isZen   :(NSString*)orgData;

// 表示名チェック
+ (int)isProfileName:(NSString*)orgData;

// 機種依存文字チェック
+ (BOOL)charCheck:(NSString*)orgData;

// 使用不可文字チェック
+ (BOOL)fileNameCheck:(NSString*)orgData;

// IPアドレスチェック
+ (int)isIPAddr:(NSString*)orgData;

// 名前解決を行って取得できたIPアドレスを返す
+ (NSString*)resolveMfpHostname:(NSString*)strHostname port:(NSString*)strPort priorityIPv6:(BOOL)bPriorityIPv6;

// 自動追加か手動追加かのチェック
+ (BOOL)isAutoScanPrinter:(NSString *)hostName;

// 文字列がIPv4形式かどうかチェック
+ (BOOL)isValidIPv4StringFormat:(NSString*)ipAddr;

// 文字列がIPv6形式かどうかチェック
+ (BOOL)isValidIPv6StringFormat:(NSString*)ipAddr;

// 文字列がIPv6形式の場合は[]を付けて返す
+ (NSString*)optIPAddrForComm:(NSString*)ipAddr;

// 文字列から[]を削除して返す
+ (NSString*)removeParenthese:(NSString*)string;

// 16進数文字列 → int
+ (unsigned int)hexadecimalToDecimal:(NSString*)string;

// int → 2進数文字列
+ (NSString*)decimalToBinaryString:(int)x;

// 省略IPv6アドレスを非省略IPv6アドレスにする
+ (NSString *)convertOmitIPv6ToFullIPv6:(NSString*)strParam;

// in6_addrからIPv6アドレスの文字列を取得する
+ (NSString *)in6addrToString:(struct in6_addr)addr6;

// IPv6グローバルユニキャストアドレスであるかの判定
+ (BOOL)isIPv6GlobalAddress:(NSString*)string;

// ポート番号チェック
+ (NSInteger)IsPortNo:(NSString*)pstrPortNo;

// ジョブ送信のタイムアウト(秒)の入力チェック
+ (NSInteger)IsJobTimeOut:(NSString*)pstrJobTimeOut;

// 名称チェック
+ (NSInteger)IsDeviceName:(NSString*)pstrDeviceName;

// 製品名チェック
+ (NSInteger)IsProductName:(NSString*)pstrProductName;

// 設置場所チェック
+ (NSInteger)IsPlace:(NSString*)pstrPlace;

// ファイル名チェック
+ (NSInteger)IsFileName:(NSString*)pstrFileName;

// ユーザー名のエスケープ
+(NSString *) escapeForUserName:(NSString*)strUserName;

// Sharp製の複合機で取り込まれたファイルかチェック
+(BOOL)IsPDFMakeFromSharp:(NSString*)pstrFilePath;

// Sharp製高圧縮PDFかチェック
+(BOOL)IsCompactPDFFromSharp:(NSString*)pstrFilePath;

// 半角英数字記号であるかの判定
+ (BOOL) isAplhaNumericSymbol :(NSString *) strValue;

// 半角英数字であるかの判定（記号は含まない）
+ (BOOL) isAplhanumeric :(NSString*) strValue;

// 印刷数字チェックの正規表現
+ (BOOL) isMatchPrintNumber :(NSString*) strValue;

// 印刷数字チェック(数字数字)の正規表現
+ (BOOL) isMatchPrintNumber_NumberNumber :(NSString*) strValue;

// 印刷数字チェック(ハイフン数字ハイフン)の正規表現
+ (BOOL) isMatchPrintNumber_HyphenNumberHyphen :(NSString*) strValue;

// 印刷数字チェック(ハイフンハイフン)の正規表現
+ (BOOL) isMatchPrintNumber_HyphenHyphen :(NSString*) strValue;

// 印刷数字チェック(区切り文字のみ)の正規表現
+ (BOOL) isMatchPrintNumber_OnlySeparater :(NSString*) strValue;

// IPアドレスの形式チェック(数字とカンマ区切り)の正規表現
+ (BOOL)isMatchIPAdrrFormat:(NSString*)strValue;

// IPアドレスの数値チェック(0始まりの数値かチェック)の正規表現
+ (BOOL)isMatchIPAdrrNumeric:(NSString*)strValue;


// 接続中のWiFiのSSID取得
+(NSString*)GetCurrentWifiSSID;

// 同じ名前のディレクトリ/ファイルのチェック
+ (NSInteger)getSameNameData:(NSString*)fullPath beforePath:(NSString*)beforePath;

// ディレクトリ直下のファイル名をフルパスで取得
+ (NSMutableArray*)getlocalPathData:(NSString*)fullPath;

+(NSString*)GetCacheDirName:(NSString*) scanFileName;

+(NSString*)GetCacheDirByScanFilePath:(NSString*)filePath;

+(BOOL)CreateDir:(NSString*) dirName;

+(BOOL)CreateDir2:(NSString*) dirName;

+(BOOL)CreatePrintFileDir:(NSString*) dirName;

+(BOOL)DeleteDir:(NSString*) dirName;

+(UIImage*)GetUIImageByDataProvider:(CGDataProviderRef)dataProvider
                       maxPixelSize:(float)maxPixelSize;

+(BOOL)OutputJpegByDataProvider:(CGDataProviderRef)dataProvider
                 outputFilePath:(NSString*)outputFilePath
                   maxPixelSize:(float)maxPixelSize;

+(BOOL)OutputJpegByDataProviderWithOrientation:(CGDataProviderRef)dataProvider
            outputFilePath:(NSString*)outputFilePath
              maxPixelSize:(float)maxPixelSize
               orientation:(UIImageOrientation)orientation;

+(BOOL)OutputJpegByUrl:(NSString*)pstrFilePath
        outputFilePath:(NSString*)pstrOutputFilePath
          maxPixelSize:(float)maxPixelSize
            pageNumber:(int)nPageNumber;

/**
 * CGImageRefをBitMapデータに変換する
 */
+ (unsigned char *) convertCGImageRefToBitmap:(CGImageRef)imageRef;

/**
 * CGImageRefからBitMapContextを生成する
 */
+ (CGContextRef) newBitmapContextFromCGImageRef:(CGImageRef)imageRef;

/**
 * BitMapデータをUIImageに変換する
 */
+ (UIImage *) convertBitmapToUIImage:(unsigned char *)buffer
                           withWidth:(size_t)width
                          withHeight:(size_t)height;

// AES128暗号化
+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key;
// AES128暗号化(各国の文字コードで暗号化)
+ (NSData*) encryptStringLangId:(NSString*)plaintext withKey:(NSString*)key;
// AES128暗号化(IVあり)
+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key iv:(NSString*)iv;
// AES128複合化
+ (NSString*) decryptString:(NSData*)ciphertext withKey:(NSString*)key;
// AES128複合化(IVあり)
+ (NSString*) decryptString:(NSData*)ciphertext withKey:(NSString*)key iv:(NSString*)iv;
// base64暗号化
+ (NSString*) base64encodeString:(NSData*)encodeData;
// base64複合化
+ (NSData *)base64Decoding:(NSString *)base64String;

+ (NSString*) getAccountLogin:(NSString*)accountLogin SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding;
+ (NSString*) getAccountPassword:(NSString*)accountLogin SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding;
+ (NSString*) getAccountLoginw:(NSString*)accountLogin SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding;
+ (NSString*) getAccountPasswordw:(NSString*)accountLogin SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding;
+ (NSString*) getRetentionPassword:(NSString*)retentionPassword SpoolTime:(NSString*)spoolTome;

+(NSString*)GetSelectedCountry;

// 絵文字を使用しているか
+ (BOOL)IsUsedEmoji:(NSString*)org;
// 予約語かどうか
+ (BOOL)IsReserved:(NSString*)targetPath;
// ReservedWord.plistに含まれるかどうか
+ (BOOL)checkReservedWord:(NSString*)name;

// 絵文字を削除した文字列を返す
+ (NSString*)RemoveEmojiString:(NSString*)org;

+(NSStringEncoding)getStringEncodingById:(NSString*) langId;
// リモートスキャン用vkeyの生成
+ (NSString*)createVkey:(NSString*) uiSessionId;

// 指定した桁数の数値文字列をランダムに生成する
+ (NSString*)createRandomNumber:(int) length;

// 文字列をUTF-8でURLEncodeする
+ (NSString*)urlEncode:(NSString*) str;

// リモートスキャン対応可否を返却する
+ (BOOL)isCapableRemoteScan;

// リモートスキャン対応可否を返却する
+ (BOOL)isCapableRemoteScan:(PrinterData*) printerData;

// カスタムサイズの名称チェック
+ (NSInteger)IsRSCustomSizeName:(NSString*)pstrCustomSizeName;

// 確認コードチェック
+ (int)checkVerifyCode:(NSString*)verifyCode;

// 文字列を(半角は１，全角は２としてカウント）する文字数で切り取る
+ (NSString*)trimString:(NSString*)aString halfCharNumber:(int)maxNumber;

// 取り込みファイル名から印刷用ファイル名を取得する（PNGファイル用）
+(NSString*)GetPrintFileName:(NSString*) scanFileName;

// PNGからJPEG抽出が行えるだけの空きメモリがあるかを取得（PNGファイル用）
+(BOOL)isExistsFreeMemoryJpegConvert:(NSString*) scanFilePath;

// 検索ワードと文字列が一致するかチェックする
+ (BOOL)rangeOfString:(NSString*)searchText fileName:(NSString*)pstrFileName isShowDir:(BOOL)isDir;

// 未使用のためコメント
//// 指定ファイルの現在のディレクトリ位置を返す（フルパスからDocumentDirを省く）
//+ (NSString*)rootDirPath:(NSString*)filePath;

// SSIDを取得する
+ (NSString*)getSSID;

// Modified UTF-7(kCFStringEncodingUTF7_IMAP)を文字列に変換
+ (NSString*)FromModifiedUTF7String:(NSString*)str;

/**
 * プリンターがPCL, PS対応かどうかをチェック
 * @param [in] snmpManager SnmpManagerクラスのインスタンス
 * @param [out] isExistsPCL PCL対応判定結果
 * @param [out] isExistsPS  PS対応判定結果
 * @return  プリンター情報を取得できればYES
 */
+ (BOOL)checkPrinterSpecWithSnmpManager:(SnmpManager*)snmpManager
                                    PCL:(BOOL*)p_isExistsPCL
                                     PS:(BOOL*)p_isExistsPS;


/**
 * ステープルチェックで使用するSNMPManagerの初期化
 */
+ (SnmpManager*)createSnmpManager:(PrinterData*)printerData;

/**
 @brief プリンターが仕上げ対応かどうかをチェックする
 */
+ (FinishingData*)checkPrinterSpecStaplePunchWithSnmpManager:(SnmpManager*)snmpManager;

/**
 * プリンターのフィニッシャー状態をチェックする
 * ステープル対応(1箇所とじ/2箇所とじ)
 * パンチ対応(2穴/3穴/4穴/4穴(幅広))
 */
+ (FinishingData*)checkPrinterSpecFinisherWithSnmpManager:(SnmpManager*)snmpManager;

/**
 * プリンターがステープル対応かどうかをチェック(針なしステープル)
 */
+ (BOOL)checkPrinterSpecStaplelessStaple:(SnmpManager*)snmpManager;

#pragma mark - for debug

/*
 * ビュー構成を表示（デバグ用）
 */
+(void)showViewTree;

/**
 * 子ビューをインデント付きで表示（デバグ用）
 */
+(void) showSubviewsOfView:(UIView*)view indent:(int)indent;

/**
 * ViewControllerのクラス名を表示
 */
+(void)showClassNameOfViewControlller:(UIViewController*)vc;

//viewの座標を変更
+ (id)setView:(UIView*)view frameOriginY:(CGFloat)y;

/**
 * ファイル名の拡張子を除いた末尾が_\d{4}にマッチする場合、YES
 */
+ (BOOL)isSerialNoLengthIsFour:(NSString*) filenameWithoutExtention;
@end
