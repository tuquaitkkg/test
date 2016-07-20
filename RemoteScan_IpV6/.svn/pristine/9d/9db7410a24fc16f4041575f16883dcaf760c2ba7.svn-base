
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ImageIO/ImageIO.h>
#import "CommonUtil.h"
#import "Define.h"
#import "NetworkInformation.h"
#import "SnmpManager.hh"
#import "SharpScanPrintAppDelegate.h"
#import "CommonManager.h"
#import "GeneralFileUtility.h"
#import <netdb.h>      // IPv6対応
#include <arpa/inet.h>  // IPv6判定用

@implementation CommonUtil

//ファイル名を新たに作成する
+(NSString *)createFileName :(NSString *)suffix{
    if(!suffix){
        suffix = @".tmp";
    }
    NSString * fileName =[[self createUUID] stringByAppendingString:suffix];
    return  fileName;
}

+ (NSString *)createUUID{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);

    
    CFRelease(theUUID);
    NSString* returnValue = (__bridge NSString *)string;
    CFRelease(string);
    return returnValue;
}



//一時保存ファイル格納ディレクトリを取得する
+ (NSString *)tmpDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Library/PrivateDocuments のパス
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];

    // Library/PrivateDocuments/TempFile のパス
    NSString *tmpDir = [privateDocumentsPath stringByAppendingPathComponent:@"TempFile"];

    // TempFileが存在しない場合は作成する。
    [fileManager createDirectoryAtPath:tmpDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
	return tmpDir;
}


//FTP受信ディレクトリを取得する
+ (NSString *)ftpDir
{
	//一時保存ディレクトリと同じ。
	//一時保存ディレクトリがFTP公開できない場合は、ホームディレクトリ下に/FTPディレクトリを作成する。
	return CommonUtil.tmpDir;
}

//保存ファイル格納ディレクトリを取得する
+ (NSString *)documentDir
{
	// ホームディレクトリ/Documments の取得
	NSArray *docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES );
	NSString *homeDir  = [docFolders lastObject];
    
	// 保存ファイルのディレクトリ
	NSFileManager *fileManager = [NSFileManager defaultManager];
    // 保存ファイルのディレクトリは、ホームディレクトリ/Documments直下に決定
    NSString *docDir = homeDir;
	
	// 保存ファイルのディレクトリが存在しない場合は作成する。
	[fileManager createDirectoryAtPath:docDir
           withIntermediateDirectories:YES
							attributes:nil
								 error:NULL];

    // Library/PrivateDocuments/CacheDirectory の作成
    [self cacheDir];

	return docDir;
}

////PrivateDocumentsを取得する
//+ (NSString *)privateDocuments
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    // Library/PrivateDocuments のパス
//    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
//    
//    // PrivateDocumentsが存在しない場合は作成する。
//    [fileManager createDirectoryAtPath:privateDocumentsPath
//           withIntermediateDirectories:YES
//                            attributes:nil
//                                 error:NULL];
//    
//    return privateDocumentsPath;
//}

//CacheDirectoryを取得する
+ (NSString *)cacheDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Library/PrivateDocuments のパス
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
    
    // Library/PrivateDocuments/CacheDirectory のパス
    NSString *cacheDirectoryPath = [privateDocumentsPath stringByAppendingPathComponent:@"CacheDirectory"];
    
    // CacheDirectoryが存在しない場合は作成する。
    [fileManager createDirectoryAtPath:cacheDirectoryPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    return cacheDirectoryPath;
}

////サムネイル画像格納ディレクトリを取得する
//+ (NSString *)pngDir:(NSString *)path
//{
//    // PNG保存ファイルのディレクトリ
//    NSString *pngDirPath = [NSString stringWithFormat:@"%@/PNGFILE",path];
//    
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//	// PNG保存ファイルのディレクトリが存在しない場合は作成する。
//	[fileManager createDirectoryAtPath:pngDirPath
//           withIntermediateDirectories:YES
//							attributes:nil
//								 error:NULL];
//    return pngDirPath;
//}

////印刷用一時保存ファイル格納ディレクトリを取得する
//+ (NSString *)tmpPrintDir
//{
//	//印刷用一時保存ファイルのディレクトリ取得
//	// ホームディレクトリ/Documments の取得
//	NSArray *docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES );
//	NSString *homeDir  = [docFolders lastObject];
//    
//	// 保存ファイルのディレクトリ
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSString *tmpDir = [NSString stringWithFormat:@"%@/TempPrintFile",homeDir];
//	
//	// 保存ファイルのディレクトリが存在しない場合は作成する。
//	[fileManager createDirectoryAtPath:tmpDir
//           withIntermediateDirectories:YES
//							attributes:nil
//								 error:NULL];
//	return tmpDir;
//}

//添付ファイル用一時保存ファイル格納ディレクトリを取得する
+ (NSString *)tmpAttachmentDir
{    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Library/PrivateDocuments のパス
    NSString *privateDocumentsPath = [GeneralFileUtility getPrivateDocuments];
    
    // Library/PrivateDocuments/TempAttachmentFile のパス
    NSString *tmpDir = [privateDocumentsPath stringByAppendingPathComponent:@"TempAttachmentFile"];
    
    // TempFileが存在しない場合は作成する。
    [fileManager createDirectoryAtPath:tmpDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    return tmpDir;
}

////zip解凍用一時保存ファイル格納ディレクトリを取得する
//+ (NSString *)zipArchiveDir:(NSString *)path
//{
//	//zip解凍用一時保存ファイルのディレクトリ取得
//	// 保存ファイルのディレクトリ
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSString *tmpDir = [NSString stringWithFormat:@"%@/ZipArchiveFile",path];
//	
//	// 保存ファイルのディレクトリが存在しない場合は作成する。
//	[fileManager createDirectoryAtPath:tmpDir
//           withIntermediateDirectories:YES
//							attributes:nil
//								 error:NULL];
//	return tmpDir;
//}

//保存画像のサムネイル画像パスを取得する
+ (NSString *)thumbnailPath:(NSString *)path
{
    // 拡張子を除いたファイル名の取得
    NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
    // 拡張子の取得
    NSString *extension = [[path lastPathComponent] pathExtension];
    // PNGFILEディレクトリを取得
    NSString *pngDir = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"Cache-%@-%@", fileName, extension]];
    // 合成する [〜/Cache-ファイル名-拡張子/thumbnail.png]
    NSString *pngDirPath = [pngDir stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnail.png"]];
    
    return pngDirPath;
};

//削除画像のサムネイル画像パスを取得する（検索時の複数選択）
+ (NSString *)deleteThumbnailPath:(NSString *)path
{
    // 拡張子を除いたファイル名の取得
    NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
    // 拡張子の取得
    NSString *extension = [[path lastPathComponent] pathExtension];
    // PNGFILEディレクトリを取得
    NSString *pngDir = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"Cache-%@-%@", fileName, extension]];
    // 合成する [〜/Cache-ファイル名-拡張子/thumbnail.png]
    NSString *pngDirPath = [pngDir stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnail.png"]];
    
    return pngDirPath;
};

////旧仕様の保存画像のサムネイル画像パスを取得する
//+ (NSString *)oldThumbnailPath:(NSString *)path
//{
//    // PNGFILEディレクトリを取得
//    NSString *pngDir = [self pngDir:[path stringByDeletingLastPathComponent]];
//    // 拡張子を除いたファイル名の取得
//    NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
//    // 合成する [〜/PINGFILE/〜.png]
//    NSString *pngDirPath = [pngDir stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"png"]];
//    
//    return pngDirPath;
//};

//設定ファイル格納ディレクトリを取得する
+ (NSString *)settingFileDir
{
	
    // ホームディレクトリ/Library/PrivateDocuments の取得
    NSString *homeDir = [GeneralFileUtility getPrivateDocuments];

	return homeDir;
}

//
// IPアドレスの取得
//

+(NSString *) getIPAdder
{
    
    NetworkInformation *niManager = [[NetworkInformation alloc] init];
    NSString *ip = niManager.primaryIPv4Address;
    
    if (ip != nil) {
        return ip;
    }
#ifdef IPV6_VALID
    ip = niManager.primaryIPv6Address;
#endif
    return ip;
    
    /*
     NSArray		*adders	= [[NSHost currentHost] addresses];
     NSString	*iPaddr	= [adders objectAtIndex:1];
     
     NSRange searchResult = [iPaddr rangeOfString:@"::"];
     if (searchResult.location == NSNotFound)
     {
     // 見つからない（接続時）
     return iPaddr;
     }
     else
     {
     // 見つかった（接続時）
     return nil;
     }
     */
}

/**
 @brief 通信時用の自端末/プリンターIPアドレスを返す
 @details 自端末とプリンターのIPアドレスを可能な限り同じアドレス形式で返す
 */
+ (NSDictionary*)getIPAddrDicForComm:(NSString*)mfpIPAddr port:(NSString*)strPort
{
    
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc] init];
    
    if (mfpIPAddr == nil) {
        [resDic setObject:@"" forKey:S_MY_IPADDRESS_DIC_KEY];
        [resDic setObject:@"" forKey:S_TARGET_IPADDRESS_DIC_KEY];
        return resDic;
    }
    
    NSString *resMyIPAddr = nil;
    NSString *resMfpIPAddr = nil;
    
    NSString *myIPv4Address = nil;
    NSString *myIPv6Address = nil;
    
    NSString *chkString = [[CommonUtil removeParenthese:mfpIPAddr] copy];   // 括弧を外す
    
    NetworkInformation *niManager = [[NetworkInformation alloc] init];
    myIPv4Address = niManager.primaryIPv4Address;
#ifdef IPV6_VALID
    myIPv6Address = niManager.primaryIPv6Address;
#endif
    BOOL bPriorityIPv6 = NO;
    
    if (myIPv4Address == nil && myIPv6Address != nil) {
        // 自端末がIPv6のみの場合
        bPriorityIPv6 = YES;
        resMyIPAddr = myIPv6Address;   // 自端末はIPv6
        if ([CommonUtil isValidIPv4StringFormat:chkString] || [CommonUtil isValidIPv6StringFormat:chkString]) {
            // MFPのホスト名がアドレス形式
            resMfpIPAddr = mfpIPAddr;   // プリンター情報に登録されているものをそのまま使う
        }
        else {
            // MFPのホスト名がホスト名
            // 名前解決を行いIPv6を優先に取得する
            resMfpIPAddr = [CommonUtil resolveMfpHostname:mfpIPAddr port:strPort priorityIPv6:bPriorityIPv6];
            
        }
        
    }
    else if (myIPv4Address != nil && myIPv6Address != nil) {
        // 自端末がIPv4/IPv6両方ある場合 端末のIPアドレスをプリンターのIPアドレス形式に合わせる
        if ([CommonUtil isValidIPv4StringFormat:chkString]) {
            // IPv4
            resMyIPAddr = myIPv4Address;
            resMfpIPAddr = mfpIPAddr;
        }
        else if ([CommonUtil isValidIPv6StringFormat:chkString]) {
            // IPv6
            resMyIPAddr = myIPv6Address;
            resMfpIPAddr = mfpIPAddr;
        }
        else {
            // ホスト名
            // 名前解決を行う
            resMfpIPAddr = [CommonUtil resolveMfpHostname:mfpIPAddr port:strPort priorityIPv6:bPriorityIPv6];
            // MFPのアドレス形式と合わせる
            if ([CommonUtil isValidIPv6StringFormat:resMfpIPAddr]) {
                resMyIPAddr = myIPv6Address;
            }
            else {
                resMyIPAddr = myIPv4Address;
            }
        }
    }
    else {
        // 自端末がIPv4のみもしくは全く取れない場合
        resMyIPAddr = myIPv4Address;    // IPv4もしくはnil
#ifdef IPV6_VALID
        // プリンター
        if ([CommonUtil isValidIPv4StringFormat:chkString] || [CommonUtil isValidIPv6StringFormat:chkString]) {
            // プリンターのIPアドレスがアドレス形式の場合
            resMfpIPAddr = mfpIPAddr;   // プリンター情報に登録されているものをそのまま使う
        }
        else {
            // MFPのIPアドレスがホスト名の場合
            // 名前解決を行い取得できたアドレスを使う
            resMfpIPAddr = [CommonUtil resolveMfpHostname:mfpIPAddr port:strPort priorityIPv6:bPriorityIPv6];
            
        }
#else
        resMfpIPAddr = mfpIPAddr;   // プリンター情報に登録されているものをそのまま使う
#endif
    }
    
    if (resMyIPAddr == nil) {
        resMyIPAddr = @"";
    }
    if (resMfpIPAddr == nil) {
        resMfpIPAddr = @"";
    }
    [resDic setObject:resMyIPAddr forKey:S_MY_IPADDRESS_DIC_KEY];
    [resDic setObject:resMfpIPAddr forKey:S_TARGET_IPADDRESS_DIC_KEY];
    
    return [resDic copy];

}

// 対応拡張子チェック(拡張子指定)
+ (BOOL)extensionCheck:(NSString*)extension
{
    if ([extension caseInsensitiveCompare:@"tif"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"tiff"] == NSOrderedSame ||
        [extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame ||
        [extension caseInsensitiveCompare:@"jpe"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"png"] == NSOrderedSame
        /* *TODO:Officeは対象外
         ||
         [extension caseInsensitiveCompare:@"doc"] == NSOrderedSame  ||
         [extension caseInsensitiveCompare:@"docx"] == NSOrderedSame ||
         [extension caseInsensitiveCompare:@"xls"] == NSOrderedSame  ||
         [extension caseInsensitiveCompare:@"xlsx"] == NSOrderedSame ||
         [extension caseInsensitiveCompare:@"ppt"] == NSOrderedSame  ||
         [extension caseInsensitiveCompare:@"pptx"] == NSOrderedSame*/)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

// 拡張子チェック(ファイル名指定)
+ (BOOL)extensionFileCheck:(NSString*)fileName
{
    NSString *extension = [fileName pathExtension];
    if ([extension caseInsensitiveCompare:@"tif"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"tiff"] == NSOrderedSame ||
        [extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame ||
        [extension caseInsensitiveCompare:@"jpe"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"png"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"docx"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"xlsx"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"pptx"] == NSOrderedSame)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

// tiffファイルチェック(フルパス指定)
+ (BOOL)tiffExtensionCheck:(NSString*)pstrFilePath        // 画面表示ファイルパス
{
    NSString *extension = [pstrFilePath pathExtension];
    if ([extension caseInsensitiveCompare:@"tif"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"tiff"] == NSOrderedSame)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
}
// jpegファイルチェック(フルパス指定)
+ (BOOL)jpegExtensionCheck:(NSString*)pstrFilePath        // 画面表示ファイルパス
{
    NSString *extension = [pstrFilePath pathExtension];
    if ([extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame  ||
        [extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame ||
        [extension caseInsensitiveCompare:@"jpe"] == NSOrderedSame)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
}

// pdfファイルチェック
+ (BOOL)pdfExtensionCheck:(NSString*)pstrFilePath        // 画面表示ファイルパス
{
    if ([[pstrFilePath pathExtension] caseInsensitiveCompare:@"pdf"] == NSOrderedSame)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
}

// pngファイルチェック
+ (BOOL)pngExtensionCheck:(NSString*)pstrFilePath        // 画面表示ファイルパス
{
    if ([[pstrFilePath pathExtension] caseInsensitiveCompare:@"png"] == NSOrderedSame)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
}

// Officeファイルチェック
+ (BOOL)officeExtensionCheck:(NSString*)pstrFilePath
{
    if([self wordExtensionCheck:pstrFilePath] || [self excelExtensionCheck:pstrFilePath] || [self powerpointExtensionCheck:pstrFilePath]) {
        return YES;
    }
    return NO;
}

// Wordファイルチェック
+ (BOOL)wordExtensionCheck:(NSString*)pstrFilePath
{
    if ([[pstrFilePath pathExtension] caseInsensitiveCompare:@"docx"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

// Excelファイルチェック
+ (BOOL)excelExtensionCheck:(NSString*)pstrFilePath
{
    if ([[pstrFilePath pathExtension] caseInsensitiveCompare:@"xlsx"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

// PowerPointファイルチェック
+ (BOOL)powerpointExtensionCheck:(NSString*)pstrFilePath
{
    if ([[pstrFilePath pathExtension] caseInsensitiveCompare:@"pptx"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}


//// sarch keyを取得
//+ (NSString*) searchKey
//{
//    NSUserDefaults* commonSearchKey = [NSUserDefaults standardUserDefaults];
//    if([commonSearchKey integerForKey: S_SEARCH_KEY])
//    {
//        // sortTypeを取得
//        return [commonSearchKey stringForKey: S_SEARCH_KEY];
//    }
//    else
//    {
//        // keyが存在しない場合
//        return @""; //default
//    }
//}
//
//// sarch keyを設定
//+ (void)setSearchKey:(NSString*) searchKey
//{
//    NSUserDefaults* commonSearchKey = [NSUserDefaults standardUserDefaults];
//    if([commonSearchKey integerForKey: S_SEARCH_KEY])
//    {
//        // sortTypeを設定
//        [commonSearchKey setValue: searchKey forKey:S_SEARCH_KEY];
//    }
//    else
//    {
//        // keyが存在しない場合
//        [commonSearchKey setValue: searchKey forKey:S_SEARCH_KEY];
//    }
//    [commonSearchKey synchronize];
//}

// sortTypeを取得
+ (enum ScanDataSortType) scanDataSortType
{
    NSUserDefaults* commonSortTypeMode = [NSUserDefaults standardUserDefaults];
    if([commonSortTypeMode integerForKey: S_SCANDATA_TYPE])
    {
        // sortTypeを取得
        return (enum ScanDataSortType)[commonSortTypeMode integerForKey: S_SCANDATA_TYPE];
    }
    else
    {
        // keyが存在しない場合
        return SCANDATA_FILEDATE; //default
    }
};

// sortTypeを設定
+ (void)setScanDataSortType:(enum ScanDataSortType) scanDataSortType
{
    NSUserDefaults* commonSortTypeMode = [NSUserDefaults standardUserDefaults];
    if([commonSortTypeMode integerForKey: S_SCANDATA_TYPE])
    {
        // sortTypeを設定
        [commonSortTypeMode setInteger:scanDataSortType forKey:S_SCANDATA_TYPE];
    }
    else
    {
        // keyが存在しない場合
        [commonSortTypeMode setInteger:scanDataSortType forKey:S_SCANDATA_TYPE];
    }
    [commonSortTypeMode synchronize];
};

// sortDirを取得
+ (enum ScanDataSortDirectionType) scanDataSortDirectionType
{
    NSUserDefaults* commonSortDirMode = [NSUserDefaults standardUserDefaults];
    if([commonSortDirMode integerForKey: S_SCANDATA_DIR])
    {
        // sortTypeを取得
        return (enum ScanDataSortDirectionType)[commonSortDirMode integerForKey: S_SCANDATA_DIR];
    }
    else
    {
        // keyが存在しない場合
        return SCANDATA_ASC; //default
    }
};

// sortTypeを設定
+ (void)ScanDataSortDirectionType:(enum ScanDataSortDirectionType) scanDataSortDirectionType
{
    NSUserDefaults* commonSortDirMode = [NSUserDefaults standardUserDefaults];
    if([commonSortDirMode integerForKey: S_SCANDATA_DIR])
    {
        // sortTypeを設定
        [commonSortDirMode setInteger:scanDataSortDirectionType forKey:S_SCANDATA_DIR];
    }
    else
    {
        // keyが存在しない場合
        [commonSortDirMode setInteger:scanDataSortDirectionType forKey:S_SCANDATA_DIR];
    }
    [commonSortDirMode synchronize];
};


// 除外フォルダチェック(Cache-フォルダやDIRZIP-フォルダーは除外対象)
// TempAttachmentFileの場合に使用する
+ (BOOL)exclusionDirectoryCheck:(NSString*)directoryPath name:(NSString*)directoryName
{
    BOOL isDir;
    NSFileManager *lFileManager	= [NSFileManager defaultManager];
    
    if(([lFileManager fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir) &&
        ([directoryName hasPrefix:@"Cache-"] || [directoryName hasPrefix:@"DIRZIP-"]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// フォルダーチェック(ファイル一覧表示用)
+ (BOOL)directoryCheck:(NSString*)directoryPath name:(NSString*)directoryName
{
    BOOL isDir;
    NSFileManager *lFileManager	= [NSFileManager defaultManager];
    
//    if((([lFileManager fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir)&& [directoryName hasPrefix:@"DIR-"]))
    if(([lFileManager fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir) && ![self IsReserved:directoryPath])
    {
        //        DLog(@"is Dir [%d] %@", isDir, directoryName);
        return YES;
    }
    else
    {
        //        DLog(@"No Dir [%d] %@", isDir, directoryName);
        
        return NO;
    }
}

// フォルダーチェック(ファイル、サムネイルフォルダ用)
+ (BOOL)directoryCheck2:(NSString*)directoryPath name:(NSString*)directoryName
{
    BOOL isDir;
    NSFileManager *lFileManager	= [NSFileManager defaultManager];
    
//    if((([lFileManager fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir)&& ([directoryName hasPrefix:@"DIR-"] ||
//                                                                                       [directoryName hasPrefix:@"Cache-"])))
    if([lFileManager fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// UUID作成
+ (NSString *)CreatUUID
{
    CFUUIDRef uuidObject = CFUUIDCreate(nil);
    
    NSString *uuidStr = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil,uuidObject));
    
    CFRelease(uuidObject);
    
    return uuidStr;
}

// 文字の数を戻す（半角は１，全角は２としてカウント）
+ (int) strLength :(NSString *) aValue
{
    int strCount = 0;
    for (int i = 0; i < [aValue length]; i++)
    {
        NSString *oneStr = [aValue substringWithRange:NSMakeRange(i,1)];
        // 文字は存在しているので１をカウント
        strCount++;
        // 全角だった場合はもう一つカウント
        if (![self hasHalfChar:oneStr])
        {
            strCount++;
        }
    }
    return strCount;
}

+ (BOOL) hasHalfChar :(NSString *) aValue
{
    if ([aValue isEqualToString:@"€"]) {
        return YES;
    }
    
    NSRange match = [aValue rangeOfString:@"[\\x20-¥x7E｡-ｿﾀ-ﾟ]" options:NSRegularExpressionSearch];
    
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

//
// 全角チェック
//
+ (BOOL)isZen:(NSString*)orgData
{
    NSData* sjisData = [ orgData dataUsingEncoding:NSShiftJISStringEncoding allowLossyConversion:YES];
    DLog(@"orgData[%@] orgData[%lu] sjisData[%lu]",orgData, (unsigned long)[orgData length], (unsigned long)[sjisData length]);
    
    if ([orgData length] < [sjisData length])
    {
        return YES; // 全角あり
    }
    
    return NO; // 全角なし
}

//
// 表示名チェック
// 入力　 表示名
// 戻り値  1: OK
//       -1: NG(未入力)
//       -2: NG(文字数を超え)
//       -4: NG(不正な文字が含まれている)
//
+ (int)isProfileName:(NSString*)orgData
{
	// 未入力チェック
	if ([orgData length] <= 0)
	{
		return  -1;				// 未入力 NG
	}
    
	// 機種依存文字チェック
	if([self charCheck:orgData] == YES)
	{
		return -4;				// 不正な文字が含まれている NG
	}
	
	NSData* sjiData = [orgData dataUsingEncoding:NSShiftJISStringEncoding allowLossyConversion:YES];
	NSUInteger orgLength		 = [orgData length];		// sjis  長さ
	NSUInteger sjiLength		 = [sjiData length];		// UTF-8 長さ
	
	// 全角  文字数
	NSUInteger zenCnt	 = sjiLength - orgLength;
	// 半角  文字数
	NSUInteger hanCnt	 = sjiLength - (zenCnt * 2);
	
	if(((zenCnt * 3) + hanCnt) > 36)
	{
		// MFP 側での表示名の同一判定不具合対応
		// 全角文字数 * 3 + 半角文字数 > 36 の場合 NGとする
		return -2;			// 文字数を超え NG
	}
	return 1;					// OK
}

//
// 機種依存文字チェック
//
+ (BOOL)charCheck:(NSString*)orgData
{
    
	@autoreleasepool
    {
        @try
        {
            
            NSArray *escapeChars = [NSArray arrayWithObjects:
                                    @"⁉"
                                    , @"⁇"
                                    , @"⁈"
                                    , nil];
            
            for(int i=0; i<[escapeChars count]; i++)
            {
                NSRange range = [orgData rangeOfString:[escapeChars objectAtIndex:i]];
                if (range.length > 0)
                {
                    return YES;
                }
            }
            return NO;
        }
        @finally
        {
        }
    }
}

//
// 使用不可文字チェック
//
+ (BOOL)fileNameCheck:(NSString*)orgData
{
	@autoreleasepool
    {
        @try
        {
            
            NSArray *escapeChars = [NSArray arrayWithObjects:
                                    @"<"
                                    ,@">"
                                    ,@":"
                                    ,@"*"
                                    ,@"?"
                                    ,@"\""
                                    ,@"/"
                                    ,@"|"
                                    ,@"¥"
                                    ,@"\\"
                                    , nil];
            
            for(int i=0; i<[escapeChars count]; i++)
            {
                NSRange range = [orgData rangeOfString:[escapeChars objectAtIndex:i]];
                if (range.length > 0)
                {
                    return YES;
                }
            }
            return NO;
        }
        @finally
        {
		}
	}
}

//
// IPアドレスチェック
// 入力　 半角文字列
// 戻り値  1: OK
//       -1: NG(未入力)
//       -2: NG(文字数を超え)
//       -3: NG(全角あり)
//       -4: NG(アルファベット有り)
//       -5: NG(範囲外)
//       -6: NG(フォーマットエラー(xxx.xxx.xxx.xxx))
+ (int)isIPAddr:(NSString*)ipaddr
{
    NSCharacterSet *chSet;
    NSString       *strData;
    NSScanner       *scanner;
    
	// 長さチェック
	if ([ipaddr length] <= 0)
	{
		return  ERR_NO_INPUT;
	}
	else if ([ipaddr length] > 15)
	{
		return  ERR_INVALID_FORMAT;
	}
	// 書式チェック
    if (![CommonUtil isMatchIPAdrrFormat:ipaddr]) {
        return ERR_INVALID_FORMAT;
    }
    
	// 半角・範囲チェック
	unsigned int cnt = 0;
	scanner = [NSScanner scannerWithString:ipaddr];
	chSet	= [NSCharacterSet characterSetWithCharactersInString:@"."];
	while(![scanner isAtEnd])
	{
		//
		// 文字列をトークンに分割
		//
		if([scanner scanUpToCharactersFromSet:chSet intoString:&strData])
		{
			long long int nsInt	= [strData longLongValue];
			if (nsInt < 0 || nsInt > 255)
			{
				// NG(範囲外):範囲(1 〜255}
				return  ERR_INVALID_FORMAT;
			}
            // 0始まりの数値の場合
            if ([CommonUtil isMatchIPAdrrNumeric:strData]) {
                return ERR_INVALID_FORMAT;
            }
            
			cnt++;
		}
		[scanner scanCharactersFromSet:chSet intoString:nil];
	}
    
	return ERR_SUCCESS;
}

/**
 @brief プリンターのホスト名の名前解決を行う
 @details bPriorityIPv6がYESの場合、名前解決時にIPv6を優先的に返却する。
 */
+ (NSString*)resolveMfpHostname:(NSString*)strHostname port:(NSString*)strPort priorityIPv6:(BOOL)bPriorityIPv6
{
    
    struct addrinfo hints;
    struct addrinfo *ai0 = NULL;    // addrinfoリストの先頭の要素
    struct addrinfo *ai;            // 処理中のaddrinfoリストの要素
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_addrlen = sizeof(hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    //hints.ai_flags = AI_PASSIVE;
    hints.ai_flags = AI_V4MAPPED | AI_ADDRCONFIG;
    
    char buf[1024];
    
    int err = getaddrinfo([strHostname UTF8String], [strPort UTF8String], &hints, &ai0);
    if (err != 0) {
        NSLog(@"getaddringoError : GetIpAddressFromHostName");
        return @"";
    }
    
    NSString *strRes = nil;
    NSString *address = nil;
    NSString *address6 = nil;
    // 得られたアドレス情報のループ
    for (ai = ai0; ai != NULL; ai = ai->ai_next) {
        
        if (ai != NULL) {
            
            if(!address && ai->ai_family == AF_INET)
            {
                struct in_addr addr = ((struct sockaddr_in *)(ai->ai_addr))->sin_addr;
                if(inet_ntop(AF_INET, &addr, buf, sizeof(buf)) == NULL){
                    perror("inet_ntop() of IPv6");
                    printf("inet_ntop() error\n");
                    //return;
                }
                address = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                
            }
#ifdef IPV6_VALID
            if (!address6 && ai->ai_family == AF_INET6)
            {
                // 16進数の一般的な表記に変換 bufに結果が入る
                struct in6_addr addr6 = ((struct sockaddr_in6 *)(ai->ai_addr))->sin6_addr;
                if(inet_ntop(AF_INET6, &addr6, buf, sizeof(buf)) == NULL){
                    perror("inet_ntop() of IPv6");
                    printf("inet_ntop() error\n");
                    //return;
                }
                printf("%s\n", buf);
                
                if ([CommonUtil isIPv6GlobalAddress:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]]) {
                    address6 = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                }
                
            }
#endif
        }
    }
    freeaddrinfo(ai0);
    
    if (bPriorityIPv6 && address6 != nil) {
        strRes = address6;
    }
    else if (address) {
        strRes = address;
    }
    else if (address6) {
        strRes = address6;
    }
    
    return strRes;
    
}


// ホスト名の情報がある場合は自動追加と判定する
+ (BOOL)isAutoScanPrinter:(NSString *)hostName
{
    if ([hostName length] > 0 ) {
        return YES;
    }
    return NO;
}

// 文字列がIPv4形式かどうか(ホスト名を渡された場合もNOを返す)
+ (BOOL)isValidIPv4StringFormat:(NSString*)ipAddr
{
    if ([ipAddr length] <= 0) {
        return NO;
    }
    struct sockaddr_in6 mgr_addr;
    memset(&mgr_addr, 0, sizeof(mgr_addr));
    
    if (inet_pton(AF_INET, [ipAddr UTF8String],
                  &mgr_addr.sin6_addr) == 1)
    {
        return YES;
    }
    
    return NO;
    
}

// 文字列がIPv6形式かどうか(ホスト名を渡された場合もNOを返す)
+ (BOOL)isValidIPv6StringFormat:(NSString*)ipAddr
{
    if ([ipAddr length] <= 0) {
        return NO;
    }
    struct sockaddr_in6 mgr_addr;
    memset(&mgr_addr, 0, sizeof(mgr_addr));
    
    if (inet_pton(AF_INET6, [ipAddr UTF8String],
                  &mgr_addr.sin6_addr) == 1)
    {
        return YES;
    }
    
    return NO;
    
}

// 文字列がIPv6形式の場合は[]を付けて返す
+ (NSString*)optIPAddrForComm:(NSString*)ipAddr
{
    
    NSString *resString = [ipAddr copy];
    
    if ([self isValidIPv6StringFormat:ipAddr]) {
        
        NSMutableString *mString = [NSMutableString stringWithCapacity:0];
        [mString insertString:@"]" atIndex:0];
        [mString insertString:resString atIndex:0];
        [mString insertString:@"[" atIndex:0];
        
        resString = [mString copy];
    }
    
    return resString;
}

// 文字列から[]を削除して返す
+ (NSString*)removeParenthese:(NSString*)string {
    
    NSString *strRes = [string copy];
    strRes = [string stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strRes = [strRes stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    return strRes;
}

/**
 @brief 16進数文字列 → int
 */
+ (unsigned int)hexadecimalToDecimal:(NSString*)string {
    NSScanner* pScanner = [NSScanner scannerWithString:string];
    unsigned int iValue;
    [pScanner scanHexInt: &iValue];
    
    return iValue;
}

/**
 @brief int → 2進数文字列
 */
+ (NSString*)decimalToBinaryString:(int)x {
    
    const int BitSize = sizeof(int); //バイトをビットに直してる(sizeofはバイト単位で返すので)
    
    int bit = 1;
    int i = 0;
    //char c[BitSize];
    
    NSString *resStr = [NSString string];
    
    for (i = 0; i < BitSize; i++) {
        if (x & bit) {
            //c[i] = '1';
            resStr = [resStr stringByAppendingString:@"1"];
        }
        else {
            //c[i] = '0';
            resStr = [resStr stringByAppendingString:@"0"];
        }
        bit <<= 1;//次の桁へ
    }
    
    return resStr;
    
}

/**
 @brief 省略IPv6アドレスを非省略IPv6アドレスにする
 @details 引数の文字列がIPv6形式であることを前提とする
 */
+ (NSString *)convertOmitIPv6ToFullIPv6:(NSString*)strParam {
    
    struct in6_addr addr6;
    int ret;

    ret = inet_pton(AF_INET6, (char *)[strParam UTF8String], &addr6);
    if (ret != 1)
    {
        NSLog(@"convert ip address error for \"%@\"", strParam);
    }
    
    return [self in6addrToString:addr6];
}

/**
 @brief in6_addrからIPv6アドレスの文字列を取得する
 @details inet_ptonやgetaddrinfoの処理で得られたin6_addrのデータを使用すること前提
 */
+ (NSString *)in6addrToString:(struct in6_addr)addr6 {
    
    NSString *strAddr6 = [NSString string];
    for (NSInteger i = 0; i < 8; i++) { // __u6_addr16の要素数は8で定義されている。
        NSString *strU6addr = [NSString stringWithFormat:@"%04x", addr6.__u6_addr.__u6_addr16[i]];  // 0埋め4桁16進数に変換して格納
        // 逆になっているので入れ替え("fe80"の場合"80fe"となっている。addr6に格納されている時点でこの状態)
        NSString *strFstUnit = [strU6addr substringToIndex:2];
        NSString *strSndUnit = [strU6addr substringFromIndex:2];
        NSString *strUnion = [strSndUnit stringByAppendingString:strFstUnit];
        // コロン追加
        if (i < 7) {
            strUnion = [strUnion stringByAppendingString:@":"];
        }
        strAddr6 = [strAddr6 stringByAppendingString:strUnion];
    }
    NSLog(@"%@", strAddr6);
    
    return strAddr6;
}

/**
 @brief IPv6グローバルアドレスであるかの判定
 @details 引数の文字列がIPv6形式であることを前提とする
*/
+ (BOOL)isIPv6GlobalAddress:(NSString*)string {
    
    NSString *chkStr = [string substringToIndex:1];
    
    if ([chkStr compare:@"2"] == NSOrderedSame ||
        [chkStr compare:@"3"] == NSOrderedSame ||
        [chkStr compare:@"4"] == NSOrderedSame ||
        [chkStr compare:@"5"] == NSOrderedSame ||
        [chkStr compare:@"6"] == NSOrderedSame ||
        [chkStr compare:@"7"] == NSOrderedSame ||
        [chkStr compare:@"8"] == NSOrderedSame ||
        [chkStr compare:@"9"] == NSOrderedSame ||
        [chkStr compare:@"a"] == NSOrderedSame ||
        [chkStr compare:@"b"] == NSOrderedSame ||
        [chkStr compare:@"c"] == NSOrderedSame ||
        [chkStr compare:@"d"] == NSOrderedSame )
    {
        return YES;
    }
    else if ([chkStr compare:@"e"] == NSOrderedSame)
    {
        chkStr = [string substringToIndex:4];
        if ([chkStr compare:@"e000"] == NSOrderedSame) {
            return YES;
        }
    }
    
    return NO;
    
}

// ポート番号チェック
+ (NSInteger)IsPortNo:(NSString*)pstrPortNo
{
	// 長さチェック
	if ([pstrPortNo length] <= 0)
	{
		return  ERR_NO_INPUT;
	}
	// 全角チェック
	if([self isZen: pstrPortNo] == YES)
	{
		return  ERR_INVALID_CHAR_TYPE;
	}
    // 先頭が0かつ2文字以上の場合
    if([pstrPortNo hasPrefix:@"0"] && [pstrPortNo length] > 1)
    {
        // 全ての0を削除
        pstrPortNo = [pstrPortNo stringByReplacingOccurrencesOfString:@"0" withString:@""];
        
        if([pstrPortNo length] > 0)
        {
            // 先頭に-を付与し、0始まりで数値のみで構成された文字列の場合に範囲外エラーとする。
            pstrPortNo = [NSString stringWithFormat:@"-%@", pstrPortNo];
        }
        else
        {
            // 0だけで構成された文字列の場合は、-1を設定して範囲外エラーとする。
            pstrPortNo = @"-1";
        }
    }
    
	long long int nPortChk = [pstrPortNo longLongValue];
	NSString *pstrPortChk = [NSString stringWithFormat:@"%lld",nPortChk];
	NSComparisonResult res= [pstrPortNo compare:pstrPortChk];
	if (nPortChk < 0 || nPortChk > 65535)
	{
		// 範囲外
		return  ERR_OVER_NUM_RANGE;
	}
	
	if (res != NSOrderedSame )
	{
		// アルファベットあり
		return  ERR_INVALID_CHAR_TYPE;
	}
	return ERR_SUCCESS;
}

// ジョブ送信のタイムアウト(秒)の入力チェック
+ (NSInteger)IsJobTimeOut:(NSString*)pstrJobTimeOut
{
    // 長さチェック
    if ([pstrJobTimeOut length] <= 0)
    {
        return  ERR_NO_INPUT;
    }
    // 全角チェック
    if([self isZen: pstrJobTimeOut] == YES)
    {
        return  ERR_INVALID_CHAR_TYPE;
    }
    // 先頭が0かつ2文字以上の場合
    if([pstrJobTimeOut hasPrefix:@"0"] && [pstrJobTimeOut length] > 1)
    {
        // 全ての0を削除
        pstrJobTimeOut = [pstrJobTimeOut stringByReplacingOccurrencesOfString:@"0" withString:@""];
        
        if([pstrJobTimeOut length] > 0)
        {
            // 先頭に-を付与し、0始まりで数値のみで構成された文字列の場合に範囲外エラーとする。
            pstrJobTimeOut = [NSString stringWithFormat:@"-%@", pstrJobTimeOut];
        }
        else
        {
            // 0だけで構成された文字列の場合は、-1を設定して範囲外エラーとする。
            pstrJobTimeOut = @"-1";
        }
    }
    
    long long int nJobChk = [pstrJobTimeOut longLongValue];
    NSString *pstrJobChk = [NSString stringWithFormat:@"%lld",nJobChk];
    NSComparisonResult res= [pstrJobTimeOut compare:pstrJobChk];
    if (res != NSOrderedSame )
    {
        // アルファベットあり
        return  ERR_INVALID_CHAR_TYPE;
    }
    
    if (nJobChk < 60 || nJobChk > 300)
    {
        // 範囲外
        return  ERR_OVER_NUM_RANGE;
    }
    
    return ERR_SUCCESS;
}

// 名称チェック
// 入力　 名称
// 戻り値  1: OK
//       -2: NG(文字数を超え)
//       -4: NG(不正な文字が含まれている)
+ (NSInteger)IsDeviceName:(NSString*)pstrDeviceName
{
    int len;
	len = [CommonUtil strLength:[pstrDeviceName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	
    if(len > 255)
	{
		return ERR_OVER_NUM_RANGE;			// 文字数を超え NG
	}
	return ERR_SUCCESS;					// OK
}

// 製品名チェック
// 入力　 名称
// 戻り値  1: OK
//       -2: NG(文字数を超え)
//       -4: NG(不正な文字が含まれている)
+ (NSInteger)IsProductName:(NSString*)pstrProductName
{
    int len;
    len = [CommonUtil strLength:[pstrProductName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if(len > 120)
    {
        return ERR_OVER_NUM_RANGE;			// 文字数を超え NG
    }
    return ERR_SUCCESS;					// OK
}

// 設置場所チェック
// 入力　 名称
// 戻り値  1: OK
//       -2: NG(文字数を超え)
//       -4: NG(不正な文字が含まれている)
+ (NSInteger)IsPlace:(NSString*)pstrPlace
{
    int len;
    len = [CommonUtil strLength:[pstrPlace stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if(len > 120)
    {
        return ERR_OVER_NUM_RANGE;			// 文字数を超え NG
    }
    return ERR_SUCCESS;					// OK
}


// ファイル名チェック
// 入力　 ファイル名
// 戻り値  1: OK
//       -2: NG(文字数を超え)
+ (NSInteger)IsFileName:(NSString*)pstrFileName
{
    NSUInteger len;
	len = [[pstrFileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
	
    if(len > 200)
	{
		return ERR_INVALID_FORMAT;			// 文字数を超え NG
	}
	return ERR_SUCCESS;					// OK
}

// 文字列をエスケープ
+(NSString *) escapeForUserName:(NSString*)strUserName
{
    // ダブルクォーテーションを除外
    NSString* strEscape = [strUserName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strEscape;
}

// Sharp製の複合機で取り込まれたファイルかチェック
+(BOOL)IsPDFMakeFromSharp:(NSString*)pstrFilePath
{
    NSFileHandle* fhdlSend = [NSFileHandle fileHandleForReadingAtPath:pstrFilePath];
    [fhdlSend seekToFileOffset:0L];
    BOOL bPDFHeaderCheck = false;
    @try
    {
        NSData* pdfHeader = [fhdlSend readDataOfLength:S_PDF_SHARP_SCANHEADER_SEARCH_BYTE];
        NSString *pstrSharpHeader = [[NSString alloc]initWithData:pdfHeader encoding:NSASCIIStringEncoding];
        
        NSRange sharpPdfResult1 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_SHARP options:NSCaseInsensitiveSearch];
        NSRange sharpPdfResult2 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_SCANNED options:NSCaseInsensitiveSearch];
//        NSRange sharpPdfResult3 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_COMPACT options:NSCaseInsensitiveSearch];
        
        // PDF,PDF/Aの先頭から指定のバイト数(S_PDF_SHARP_SCANHEADER_SEARCH_BYTE)まで検索を行う
        // "sharp","scanned"が含まれ、"compact"が含まれない場合にSharp製とみなす
//        if((sharpPdfResult1.location != NSNotFound) && (sharpPdfResult2.location != NSNotFound) && (sharpPdfResult3.location == NSNotFound) && pstrSharpHeader != nil)
        if((sharpPdfResult1.location != NSNotFound) && (sharpPdfResult2.location != NSNotFound) && pstrSharpHeader != nil)
        {
            bPDFHeaderCheck = true;
        }
        
        /*
         NSData* sharpPdfHeader = [S_PDF_SHARP_SCANHEADER dataUsingEncoding:NSUTF8StringEncoding];
         
         NSData* pdfHeader = [fhdlSend readDataOfLength:[sharpPdfHeader length]];
         NSString *pstrSharpHeader = [[[NSString alloc]initWithData:pdfHeader encoding:NSASCIIStringEncoding]autorelease];
         
         NSRange sharpPdfResult1 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_SHARP options:NSCaseInsensitiveSearch];
         NSRange sharpPdfResult2 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_SCANNED options:NSCaseInsensitiveSearch];
         NSRange sharpPdfResult3 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_COMPACT options:NSCaseInsensitiveSearch];
         
         // PDFの１行目が指定の文字列と一致していればSharp製とみなす
         //        if ([pdfHeader isEqualToData:sharpPdfHeader])
         //        {
         //            bPDFHeaderCheck = true;
         //        }
         // PDFの1行目に"sharp","scanned"が含まれ、"compact"が含まれない場合にSharp製とみなす
         if((sharpPdfResult1.location != NSNotFound) && (sharpPdfResult2.location != NSNotFound) && (sharpPdfResult3.location == NSNotFound) && pstrSharpHeader != nil)
         {
         bPDFHeaderCheck = true;
         }
         else
         {
         // PDF/Aかどうかチェック
         NSMutableData* sharpPdfaHeader = [NSMutableData dataWithData:[S_PDFA_SHARP_SCANHEADER_PREFIX dataUsingEncoding:NSUTF8StringEncoding]];
         int byte[1] = {4008636142}; // eeeeeeee
         [sharpPdfaHeader appendData:[NSData dataWithBytes:byte length:sizeof(byte)]];
         [sharpPdfaHeader appendData:[S_PDFA_SHARP_SCANHEADER_SUFIX dataUsingEncoding:NSUTF8StringEncoding]];
         
         [fhdlSend seekToFileOffset:0L];
         pdfHeader = [fhdlSend readDataOfLength:[sharpPdfaHeader length]];
         // PDFの１~3行目が指定の文字列と一致していればSharp製とみなす
         //            if ([pdfHeader isEqualToData:sharpPdfaHeader])
         //            {
         //                bPDFHeaderCheck = true;
         //            }
         pstrSharpHeader = [[NSString alloc]initWithData:pdfHeader encoding:NSASCIIStringEncoding];
         sharpPdfResult1 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_SHARP options:NSCaseInsensitiveSearch];
         sharpPdfResult2 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_SCANNED options:NSCaseInsensitiveSearch];
         sharpPdfResult3 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_COMPACT options:NSCaseInsensitiveSearch];
         
         // PDFの1~3行目に"sharp","scanned"が含まれ、"compact"が含まれない場合にSharp製とみなす
         if((sharpPdfResult1.location != NSNotFound) && (sharpPdfResult2.location != NSNotFound) && (sharpPdfResult3.location == NSNotFound) && pstrSharpHeader != nil)
         {
         bPDFHeaderCheck = true;
         }
         }
         */
    }
    @catch(id error)
    {
    }
    return bPDFHeaderCheck;
    
}

+(BOOL)IsCompactPDFFromSharp:(NSString*)pstrFilePath
{
    NSFileHandle* fhdlSend = [NSFileHandle fileHandleForReadingAtPath:pstrFilePath];
    [fhdlSend seekToFileOffset:0L];
    BOOL bPDFHeaderCheck = false;
    @try
    {
        NSData* pdfHeader = [fhdlSend readDataOfLength:S_PDF_SHARP_SCANHEADER_SEARCH_BYTE];
        NSString *pstrSharpHeader = [[NSString alloc]initWithData:pdfHeader encoding:NSASCIIStringEncoding];
        
        NSRange sharpPdfResult = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_COMPACT_CREATOR options:NSRegularExpressionSearch];
        CommonManager * commonManager = [[CommonManager alloc]init];
        if([commonManager checkPdfBySharp:pstrFilePath]){
            return  TRUE;
        }
        // 条件１：高圧縮PDFの場合は、　「/Creator (Sharp BS-PDF Version 1.0)」
        if(sharpPdfResult.location != NSNotFound)
        {
            return true;
        }
        
        // 条件２：高圧縮PDFの場合は、　「Sharp Scanned CompactPDF」
        NSRange sharpPdfResult1 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_SHARP options:NSCaseInsensitiveSearch];
        NSRange sharpPdfResult2 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_SCANNED options:NSCaseInsensitiveSearch];
        NSRange sharpPdfResult3 = [pstrSharpHeader rangeOfString:S_PDF_SHARP_SCANHEADER_COMPACT options:NSCaseInsensitiveSearch];
        
        if((sharpPdfResult1.location != NSNotFound) && (sharpPdfResult2.location != NSNotFound) && (sharpPdfResult3.location != NSNotFound) && pstrSharpHeader != nil)
        {
            return true;
        }
        
    }
    @catch(id error)
    {
    }
    return bPDFHeaderCheck;
}

// 半角英数記号チェック
+ (BOOL) isAplhaNumericSymbol :(NSString *) strValue
{
    
    //「^[!-~]+$」=「^[a-zA-Z0-9!-/:-@¥[-`{-~]+$」　ASCIIコード
    // 「^[a-zA-Z0-9 -/:-@\\[-\\`\\{-\\~]+$」UTF-8
    NSRange match = [strValue rangeOfString:@"^[ -~]+$" options:NSRegularExpressionSearch];
    //NSRange match = [strValue rangeOfString:@"^[a-zA-Z0-9 -/:-@\\[-\\`\\{-\\~]+$]" options:NSRegularExpressionSearch];
    //NSRange match = [strValue rangeOfString:@"^[a-zA-Z0-9 -/:-@\[-`{-~]+$]" options:NSRegularExpressionSearch];
    //NSRange match = [strValue rangeOfString:@"^[a-zA-Z0-9 -/:-@\[-\[\\-\\]-`{-~]+$]" options:NSRegularExpressionSearch];
    
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (BOOL) isAplhanumeric :(NSString*) strValue
{
    NSRange match = [strValue rangeOfString:@"^[A-Za-z0-9]+$" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
    
    
}

+ (BOOL) isMatchPrintNumber :(NSString*) strValue
{
    NSRange match = [strValue rangeOfString:@"^[0-9 ¥¥,¥¥-]+$" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (BOOL) isMatchPrintNumber_NumberNumber :(NSString*) strValue
{
    NSRange match = [strValue rangeOfString:@".*[0-9]+ +[0-9]+.*" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (BOOL) isMatchPrintNumber_HyphenNumberHyphen :(NSString*) strValue
{
    NSRange match = [strValue rangeOfString:@".*-+ *[0-9]+ *-+.*" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (BOOL) isMatchPrintNumber_HyphenHyphen :(NSString*) strValue
{
    NSRange match = [strValue rangeOfString:@".*- *-.*" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (BOOL) isMatchPrintNumber_OnlySeparater :(NSString*) strValue
{
    NSRange match = [strValue rangeOfString:@"^[- ,]+$|\\¥" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

// IPアドレスの形式チェック(数字とカンマ区切り)
+ (BOOL)isMatchIPAdrrFormat:(NSString*)strValue {
    
    NSRange match = [strValue rangeOfString:@"^[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+$" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
    
}

// 0始まりの数値かチェック
+ (BOOL)isMatchIPAdrrNumeric:(NSString*)strValue {
    
    NSRange match = [strValue rangeOfString:@"^[0][0-9]+$" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound)
    {
        return YES;
    }
    return NO;
    
}

// 接続中のWiFiのSSID取得
+(NSString*)GetCurrentWifiSSID
{
    NSString* strSSID = nil;
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if(interfaces != nil)
    {
        CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
        if(dicRef)
        {
            CFStringRef ssid = CFDictionaryGetValue(dicRef, kCNNetworkInfoKeySSID);
            strSSID = [NSString stringWithFormat:@"%@", ssid];
            CFRelease(dicRef);
        }
        
        CFRelease(interfaces);
    }
    return strSSID;
}

+(NSString*)GetCacheDirName:(NSString*) scanFileName
{
    return [[NSString alloc]initWithFormat:@"Cache-%@-%@",
            [[scanFileName lastPathComponent] stringByDeletingPathExtension],
            [scanFileName pathExtension]];
}


+(BOOL)CreateDir:(NSString*) dirName
{
    BOOL bRet = TRUE;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 念のため削除
    bRet = [CommonUtil DeleteDir:dirName];
    
    if(!bRet)
    {
        return FALSE;
    }
    
    // 作成
    bRet = [fileManager createDirectoryAtPath:dirName
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:NULL];
    
    
    return bRet;
}

+(BOOL)CreateDir2:(NSString*) dirName
{
    BOOL bRet = TRUE;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //    // 念のため削除
    //    bRet = [CommonUtil DeleteDir:dirName];
    //    if(!bRet)
    //    {
    //        return FALSE;
    //    }
    
    // 作成
    bRet = [fileManager createDirectoryAtPath:dirName
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:NULL];
    
    if(!bRet)
    {
        return FALSE;
    }
    
    // PNGの印刷用JPEGファイル格納ディレクトリの作成
    bRet = [self CreatePrintFileDir:dirName];
    
    return bRet;
}

+(BOOL)CreatePrintFileDir:(NSString*) dirName
{
    // CacheDirectoryがなければ作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bRet = [fileManager createDirectoryAtPath:dirName
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:NULL];
    
    return bRet;
}

+(BOOL)DeleteDir:(NSString*) dirName
{
    BOOL bRet = TRUE;
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = YES;
    if([fileManager fileExistsAtPath:dirName isDirectory:&isDirectory])
    {
        bRet = [fileManager removeItemAtPath:dirName error:NULL];
    }
    return bRet;
}

+(NSString*)GetCacheDirByScanFilePath:(NSString*)filePath
{
    return [[NSString stringWithFormat:@"%@", [filePath stringByDeletingLastPathComponent]] stringByAppendingPathComponent:[CommonUtil GetCacheDirName:[filePath lastPathComponent]]];
}

+(UIImage*)GetUIImageByDataProvider:(CGDataProviderRef)dataProvider
                       maxPixelSize:(float)maxPixelSize
{
    UIImage* image;
    
    @try {
        CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                             (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
                                                             (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
                                                             (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageAlways,
                                                             (id)[NSNumber numberWithFloat:maxPixelSize], (id)kCGImageSourceThumbnailMaxPixelSize,
                                                             nil];
        
        CGImageSourceRef imageSource = CGImageSourceCreateWithDataProvider(dataProvider, options);
        CGImageRef imgRef= CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
        
        image = [UIImage imageWithCGImage:imgRef];
        
        CGImageRelease(imgRef);
        CFRelease(imageSource);
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return image;
}

+(BOOL)OutputJpegByDataProvider:(CGDataProviderRef)dataProvider
                 outputFilePath:(NSString*)outputFilePath
                   maxPixelSize:(float)maxPixelSize
{
    return [self OutputJpegByDataProviderWithOrientation:dataProvider outputFilePath:outputFilePath maxPixelSize:maxPixelSize orientation:UIImageOrientationUp];
}

+(BOOL)OutputJpegByDataProviderWithOrientation:(CGDataProviderRef)dataProvider
                                outputFilePath:(NSString*)outputFilePath
                                  maxPixelSize:(float)maxPixelSize
                                   orientation:(UIImageOrientation)orientation
{
    BOOL bRet = TRUE;
    @try {
        UIImage* image = [self GetUIImageByDataProvider:dataProvider maxPixelSize:maxPixelSize];
        image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:orientation];
        
        NSData  *data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.8)];
        [data writeToFile:outputFilePath atomically:YES];
    }
    @catch (NSException *exception) {
        bRet = NO;
    }
    @finally {
    }
    
    return bRet;
}

+(BOOL)OutputJpegByUrl:(NSString*)pstrFilePath
        outputFilePath:(NSString*)pstrOutputFilePath
          maxPixelSize:(float)maxPixelSize
            pageNumber:(int)nPageNumber
{
    BOOL bRet = TRUE;
    @autoreleasepool
    {
        
        @try {
            CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
                                                                 (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
                                                                 (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageAlways,
                                                                 (id)[NSNumber numberWithFloat:maxPixelSize], (id)kCGImageSourceThumbnailMaxPixelSize,
                                                                 nil];
            //元のファイルを読み込み
            NSURL* purlFilePath = [[NSURL alloc] initFileURLWithPath:pstrFilePath];
            CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)purlFilePath, options);
            //指定ページの情報を取得
            CGImageRef imgRef = CGImageSourceCreateThumbnailAtIndex(imageSource, nPageNumber, options);
//            UIImage* image = [UIImage imageWithCGImage:imgRef];
//            
//            CGImageRelease(imgRef);
            CFRelease(imageSource);
            
            size_t width = CGImageGetWidth(imgRef);
            size_t height = CGImageGetHeight(imgRef);

            // (色深度を32ビットに変換するために)BitMapデータを作成する
            unsigned char *bitmap = [self convertCGImageRefToBitmap:imgRef];
            CGImageRelease(imgRef);

            // BitMapデータからUIImageを再作成する
            UIImage *image = [self convertBitmapToUIImage:bitmap withWidth:width withHeight:height];
            
            // Cleanup
            if(bitmap) {
                free(bitmap);
                bitmap = NULL;
            }
            
            // JPEGへの変換
            if (image != nil) {
                NSData* data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.8)];
                [data writeToFile:pstrOutputFilePath atomically:YES];
            }
            else
            {
                bRet = NO;
            }
        }
        @catch (NSException *exception) {
            bRet = NO;
        }
        @finally {
        }
    }
    return bRet;
}

/**
 * CGImageRefをBitMapデータに変換する
 */
+ (unsigned char *) convertCGImageRefToBitmap:(CGImageRef) imageRef {
    
    // CGImageRefからBitmapコンテキストを作成する
    CGContextRef context = [self newBitmapContextFromCGImageRef:imageRef];
    
    if(!context) {
        return NULL;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGContextDrawImage(context, rect, imageRef);
    
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t bufferLength = bytesPerRow * height;
    
    unsigned char *newBitmap = NULL;
    
    if(bitmapData) {
        newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height);
        
        if(newBitmap) {
            for(int i = 0; i < bufferLength; ++i) {
                newBitmap[i] = bitmapData[i];
            }
        }
        
        free(bitmapData);
        
    } else {
        DLog(@"Bitmapピクセルデータ取得失敗")
    }
    
    CGContextRelease(context);
    
    return newBitmap;
}

/**
 * CGImageRefからBitMapContextを生成する
 */
+ (CGContextRef) newBitmapContextFromCGImageRef:(CGImageRef) imageRef {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        DLog(@"colorSpace割り当て失敗")
        return NULL;
    }
    
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        DLog(@"bitmapDataメモリ割り当て失敗")
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast);
    
    if(!context) {
        free(bitmapData);
        DLog(@"bitmapコンテキスト生成失敗")
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

/**
 * BitMapデータをUIImageに変換する
 */
+ (UIImage *) convertBitmapToUIImage:(unsigned char *) buffer
                           withWidth:(size_t) width
                          withHeight:(size_t) height {
    
    
    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if(colorSpaceRef == NULL) {
        DLog(@"colorSpace割り当て失敗")
        CGDataProviderRelease(provider);
        return nil;
    }
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,	// data provider
                                    NULL,		// decode
                                    YES,		// should interpolate
                                    renderingIntent);
    
    uint32_t* pixels = (uint32_t*)malloc(bufferLength);
    
    if(pixels == NULL) {
        DLog(@"bitmapメモリ割り当て失敗")
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(iref);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpaceRef,
                                                 bitmapInfo);
    
    if(context == NULL) {
        DLog(@"コンテキスト生成失敗")
        free(pixels);
    }
    
    UIImage *image = nil;
    if(context) {
        
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
            float scale = [[UIScreen mainScreen] scale];
            image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        } else {
            image = [UIImage imageWithCGImage:imageRef];
        }
        
        CGImageRelease(imageRef);
        CGContextRelease(context);
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(iref);
    CGDataProviderRelease(provider);
    
    if(pixels) {
        free(pixels);
    }
    return image;
}

//
// 同じ名前のディレクトリ/ファイルのチェック
//
+ (NSInteger)getSameNameData:(NSString*)fullPath beforePath:(NSString*)beforePath
{
	
    @autoreleasepool
    {
        NSInteger ret = 0;
        @try {
            //
            // ディレクトリ以下のファイルやディレクトリを順番に取得する
            //
            NSString		*tempDir;
            
            tempDir	= [NSString stringWithFormat:@"%@/",fullPath];
            NSError	*err = nil;
            NSString *fname;
            
            // ディレクトリ用の列挙子を取得する
            NSFileManager *localFileManager	= [NSFileManager defaultManager];
            
            // ディレクトリ以下を検索する
            for(fname in [localFileManager contentsOfDirectoryAtPath:tempDir error:&err])
            {
                @autoreleasepool
                {
                    
                    // ファイルやディレクトリのフルパス取得
                    NSString *directoryPath = [tempDir stringByAppendingPathComponent:fname];
                    
                    // 同じ名前のファイルがみつかった場合
                    if([directoryPath isEqualToString:beforePath])
                    {
                        //ファイルなら1
                        if(![CommonUtil directoryCheck2:directoryPath name: fname])
                        {
                            return 1;
                        }
                        //ディレクトリなら2
                        else
                        {
                            return 2;
                        }
                    }
                }
            }
        }
        @finally
        {
        }
        
        return ret;
    }
}

//
// ディレクトリ直下のファイル名をフルパスで取得
//
+ (NSMutableArray*)getlocalPathData:(NSString*)fullPath
{
	
    @autoreleasepool
    {
        NSMutableArray *fullMuPath = [[NSMutableArray alloc] init ];
        @try {
            //
            // ディレクトリ以下のファイルやディレクトリを順番に取得する
            //
            NSString		*tempDir;
            
            tempDir	= [NSString stringWithFormat:@"%@/",fullPath];
            NSError	*err = nil;
            NSString *fname;
            
            // ディレクトリ用の列挙子を取得する
            NSFileManager *localFileManager	= [NSFileManager defaultManager];
            
            // ディレクトリ以下を検索する
            for(fname in [localFileManager contentsOfDirectoryAtPath:tempDir error:&err])
            {
                @autoreleasepool
                {
                    
                    // ファイルやディレクトリのフルパス取得
                    NSString *directoryPath = [tempDir stringByAppendingPathComponent:fname];
                    
                    if([CommonUtil tiffExtensionCheck:fname] || [CommonUtil jpegExtensionCheck:fname] ||
                       [CommonUtil pdfExtensionCheck:fname] || [CommonUtil pngExtensionCheck:fname] ||
                       [CommonUtil directoryCheck2:directoryPath name:fname])
                    {
                        [fullMuPath addObject:directoryPath];
                    }
                    
                }
            }
        }
        @finally
        {
        }
        return fullMuPath;
    }
}

// AES128暗号化
+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString *)key
{
    SharpScanPrintUserAuthentication    *SSPA;
    SSPA = [[SharpScanPrintUserAuthentication alloc]init];
    
    NSData *mData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    [data setData:mData];//dataを置き換える
    [data setLength:(([mData length] + 15) / 16) * 16 ]; //16の倍数の長さに変更(末尾0埋め)
    
    return [SSPA encryptionAES128Data:data :key];
}

// AES128暗号化(各国の文字コードで暗号化)
+ (NSData*) encryptStringLangId:(NSString*)plaintext withKey:(NSString *)key
{
    SharpScanPrintUserAuthentication    *SSPA;
    SSPA = [[SharpScanPrintUserAuthentication alloc]init];
    
    NSData *mData = [plaintext dataUsingEncoding:[self getStringEncodingById:S_LANG]];
    NSMutableData* data = [NSMutableData data];
    [data setData:mData];//dataを置き換える
    [data setLength:(([mData length] + 15) / 16) * 16 ]; //16の倍数の長さに変更(末尾0埋め)
    
    return [SSPA encryptionAES128Data:data :key];
}

// AES128暗号化(IV、パディングあり)
+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString *)key iv:(NSString *)iv
{
    SharpScanPrintUserAuthentication    *SSPA;
    SSPA = [[SharpScanPrintUserAuthentication alloc]init];
    
    NSData *mData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    [data setData:mData];//dataを置き換える
    
    return [SSPA encryptionAES128Data:data :key :iv];
}

// AES128複合化
+ (NSString*) decryptString:(NSData*)ciphertext withKey:(NSString *)key
{
    SharpScanPrintUserAuthentication    *SSPA;
    
    SSPA = [[SharpScanPrintUserAuthentication alloc]init];
    
    // AES複合化
    NSString *AESdecruptString = [[NSString alloc] initWithData:[SSPA decryptionAES128Data:ciphertext :key] encoding:NSUTF8StringEncoding];
    
    
    NSData *Data = [AESdecruptString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *modData = [NSMutableData data];
    NSMutableData *newData = [NSMutableData data];
    [newData setLength:1];
    
    // 末尾0埋め対応
    for (int i = 0; i < [Data length]; i++)
    {
        NSData* tmpData = [Data subdataWithRange:NSMakeRange([Data length] -i -1, 1)];
        if ([newData isEqualToData:tmpData])
        {
            continue;
        }
        modData = [NSMutableData dataWithData:[Data subdataWithRange:NSMakeRange(0, [Data length] -i)]];
        break;
    }
    NSString *aesDecodedStr = [[NSString alloc] initWithData:modData encoding:NSUTF8StringEncoding];
    
    return aesDecodedStr;
}

// AES128複合化(IV、パディングあり)
+ (NSString*) decryptString:(NSData*)ciphertext withKey:(NSString *)key iv:(NSString *)iv
{
    SharpScanPrintUserAuthentication    *SSPA;
    
    SSPA = [[SharpScanPrintUserAuthentication alloc]init];
    
    // AES複合化
    NSString *AESdecruptString = [[NSString alloc] initWithData:[SSPA decryptionAES128Data:ciphertext :key :iv] encoding:NSUTF8StringEncoding];
    
    
    NSData *Data = [AESdecruptString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *modData = [NSMutableData data];
    NSMutableData *newData = [NSMutableData data];
    [newData setLength:1];
    
    // 末尾0埋め対応
    for (int i = 0; i < [Data length]; i++)
    {
        NSData* tmpData = [Data subdataWithRange:NSMakeRange([Data length] -i -1, 1)];
        if ([newData isEqualToData:tmpData])
        {
            continue;
        }
        modData = [NSMutableData dataWithData:[Data subdataWithRange:NSMakeRange(0, [Data length] -i)]];
        break;
    }
    NSString *aesDecodedStr = [[NSString alloc] initWithData:modData encoding:NSUTF8StringEncoding];
    
    return aesDecodedStr;
}

// base64暗号化
+ (NSString*) base64encodeString:(NSData*)encodeData
{
    SharpScanPrintUserAuthentication    *SSPA;
    
    SSPA = [[SharpScanPrintUserAuthentication alloc]init];
    
    return [SSPA base64Encoding:encodeData];
    
}

// base64複合化
+ (NSData *)base64Decoding:(NSString *)base64String
{
    SharpScanPrintUserAuthentication    *SSPA;
    
    SSPA = [[SharpScanPrintUserAuthentication alloc]init];
    
    return [SSPA base64Decoding:base64String];
}

+ (NSString*) getAccountLogin:(NSString*)accountLogin SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding
{
    SharpScanPrintUserAuthentication* SSPA = [[SharpScanPrintUserAuthentication alloc] init];
    
    return [SSPA getAccountLogin:accountLogin SpoolTime:spoolTome encoding:encoding];
    
}
+ (NSString*) getAccountPassword:(NSString*)accountPassword SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding
{
    SharpScanPrintUserAuthentication* SSPA = [[SharpScanPrintUserAuthentication alloc] init];
    
    return [SSPA getAccountPassword:accountPassword SpoolTime:spoolTome encoding:encoding];
    
}
+ (NSString*) getAccountLoginw:(NSString*)accountLogin SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding
{
    SharpScanPrintUserAuthentication* SSPA = [[SharpScanPrintUserAuthentication alloc] init];
    
    return [SSPA getAccountLoginw:accountLogin SpoolTime:spoolTome encoding:encoding];
    
    
}
+ (NSString*) getAccountPasswordw:(NSString*)accountPassword SpoolTime:(NSString*)spoolTome encoding:(NSStringEncoding)encoding
{
    SharpScanPrintUserAuthentication* SSPA = [[SharpScanPrintUserAuthentication alloc] init];
    
    return [SSPA getAccountPasswordw:accountPassword SpoolTime:spoolTome encoding:encoding];
}

+ (NSString*) getRetentionPassword:(NSString*)retentionPassword SpoolTime:(NSString*)spoolTome
{
    SharpScanPrintUserAuthentication* SSPA = [[SharpScanPrintUserAuthentication alloc] init];
    
    return [SSPA getRetentionPassword:retentionPassword SpoolTime:spoolTome];
}

+(NSString*)GetSelectedCountry
{
    NSString* locale = [[NSLocale currentLocale] localeIdentifier];
    NSArray* arr = [locale componentsSeparatedByString:@"_"];
    if ([arr count] < 2) {
        return @"";
    }
    
    return [arr objectAtIndex:1];
}

// 絵文字を使用しているか
+ (BOOL)IsUsedEmoji:(NSString*)org
{
    BOOL ret = NO;
    
    NSUInteger len = org.length;
    //    NSMutableArray* removeList = [NSMutableArray array];
    
    for(int i = 0; i < len; i++){
        unichar c = [org characterAtIndex:i];
        // 囲み数字
        if (0x20E3 == c) {
            ret = YES;
            break;
        }
        
        // 固定文字コード範囲を除外する
        else if((0x2194 <= c && c <= 0x21F9) ||     // 矢印
                (0x2300 <= c && c <= 0x23FF) ||     // その他の技術用記号
                (0x249C <= c && c <= 0x24E9) ||     // 囲みアルファベット
                (0x2500 <= c && c <= 0x27FF) ||     // 罫線素片、ブロック要素、その他の記号、装飾記号、その他の数学記号A、補助矢印A
                (0x2900 <= c && c <= 0x297F) ||     // 補助矢印B
                (0x2B00 <= c && c <= 0x2BFF) ||     // その他の記号及び矢印
                (0x3290 <= c && c <= 0x32B0) ||     // 囲みCJK文字・月
                (0xE000 <= c && c <= 0xF8FF)        // 私用領域（外字領域）
                ){
            ret = YES;
            break;
        }
        
        else if (0xD800 <= c && c <= 0xDBFF) {
            // 上位サロゲート
            ret = YES;
            break;
        }
        
        else {
            // その他、固定文字の除外判定
            if(c == 0x00A9 ||   // ©
               c == 0x00AE ||   // ®
               c == 0x2122 ||   // ™
               c == 0x2139 ||   // ℹ
               c == 0x3030 ||   // 〰
               c == 0x303D      // 〽
               ){
                ret = YES;
                break;
            }else{
                // 通常文字
            }
        }
    }
    
    return ret;
}

// 予約語であるかどうか
+ (BOOL)IsReserved:(NSString*)targetPath
{
    BOOL ret = NO;

    // ホームディレクトリ/Documments の取得
    NSArray *docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *documentsPath  = [docFolders lastObject];
    
    NSString *tDirectory = [targetPath stringByDeletingLastPathComponent];
    NSString *tFile = [targetPath lastPathComponent];
    
    // Documents直下かどうか
    if ([documentsPath isEqualToString:tDirectory]) {
        
        // ReservedWord.plistに含まれるかどうか
        if ([self checkReservedWord:tFile]) {
            ret = YES;
        }
    }
    return ret;
}

// ReservedWord.plistに含まれるかどうか
+ (BOOL)checkReservedWord:(NSString*)name
{
    // ファイル（ReservedWord.plist）からNSArrayを生成する
    NSString *p = [[NSBundle mainBundle] pathForResource:@"ReservedWord" ofType:@"plist"];
    NSArray *reservedArray = [NSArray arrayWithContentsOfFile:p];
    
    // ReservedWord.plistに含まれるかどうか
    BOOL ret = [reservedArray containsObject:name];

    return ret;
}

// 絵文字を削除した文字列を返す
+ (NSString*)RemoveEmojiString:(NSString*)org
{
    NSMutableString* ret = [NSMutableString stringWithString:org];
    
    NSUInteger len = org.length;
    NSMutableArray* removeList = [NSMutableArray array];
    
    for(int i = 0; i < len; i++){
        
        unichar c = [org characterAtIndex:i];
        
        // 囲み数字
        if (0x20E3 == c) {
            //            DLog(@"囲み数字:(%d)%@,0x%04X 0x%04X", i, [org substringWithRange:NSMakeRange(i-1, 2)], [org characterAtIndex:i-1], c);
            [removeList addObject:[NSNumber numberWithInt:i-1]];
            [removeList addObject:[NSNumber numberWithInt:i]];
        }
        
        // 固定文字コード範囲を除外する
        else if((0x2194 <= c && c <= 0x21F9) ||     // 矢印
                (0x2300 <= c && c <= 0x23FF) ||     // その他の技術用記号
                (0x249C <= c && c <= 0x24E9) ||     // 囲みアルファベット
                (0x2500 <= c && c <= 0x27FF) ||     // 罫線素片、ブロック要素、その他の記号、装飾記号、その他の数学記号A、補助矢印A
                (0x2900 <= c && c <= 0x297F) ||     // 補助矢印B
                (0x2B00 <= c && c <= 0x2BFF) ||     // その他の記号及び矢印
                (0x3290 <= c && c <= 0x32B0) ||     // 囲みCJK文字・月
                (0xE000 <= c && c <= 0xF8FF)        // 私用領域（外字領域）
                ){
            //            DLog(@"区分例外:(%d)%@,0x%04X", i, [org substringWithRange:NSMakeRange(i, 1)], c);
            [removeList addObject:[NSNumber numberWithInt:i]];
        }
        
        // 国旗
        else if (0xD83C == c) {
            unichar c1 = [org characterAtIndex:i+1];
            if ((0xDDE6 <= c1) && (c1 <= 0xDDFF)) {
                unichar c2 = [org characterAtIndex:i+2];
                if (0xD83C == c2) {
                    unichar c3 = [org characterAtIndex:i+3];
                    if ((0xDDE6 <= c3) && (c3 <= 0xDDFF)) {
                        //                        DLog(@"国旗:%@ 0x04%X 0x04%X 0x04%X 0x04%X", [org substringWithRange:NSMakeRange(i, 4)], c, c1, c2, c3);
                        [removeList addObject:[NSNumber numberWithInt:i]];
                        [removeList addObject:[NSNumber numberWithInt:i+1]];
                        [removeList addObject:[NSNumber numberWithInt:i+2]];
                        [removeList addObject:[NSNumber numberWithInt:i+3]];
                        i += 3;
                        continue;
                    }
                }
            }
            [removeList addObject:[NSNumber numberWithInt:i]];
            [removeList addObject:[NSNumber numberWithInt:i+1]];
            i++;
        }
        
        else if (0xD800 <= c && c <= 0xDBFF) {
            // 上位サロゲート
            [removeList addObject:[NSNumber numberWithInt:i]];
            [removeList addObject:[NSNumber numberWithInt:i+1]];
            i++;
        }
        else if (0xDC00 <= c && c <= 0xDFFF) {
            // 下位サロゲート(上位サロゲートで同時に削除しているので、通らない)
            [removeList addObject:[NSNumber numberWithInt:i]];
        }
        
        else {
            // その他、固定文字の除外判定
            if(c == 0x00A9 ||   // ©
               c == 0x00AE ||   // ®
               c == 0x2122 ||   // ™
               c == 0x2139 ||   // ℹ
               c == 0x3030 ||   // 〰
               c == 0x303D      // 〽
               ){
                //                DLog(@"固定除外文字:(%d)%@,0x%04X", i, [org substringWithRange:NSMakeRange(i, 1)], c);
                [removeList addObject:[NSNumber numberWithInt:i]];
            }else{
                // 通常文字
            }
        }
    }
    
    // 削除文字リストの文字を削除
    for(NSNumber* n in [removeList reverseObjectEnumerator]){
        [ret deleteCharactersInRange:NSMakeRange(n.intValue, 1)];
    }
    
    return ret;
}

+(NSStringEncoding)getStringEncodingById:(NSString*) langId
{
    if([langId isEqualToString:S_LANG_JA])
    {
        return NSShiftJISStringEncoding;
    }
    if([langId isEqualToString:S_LANG_ZN_CH])
    {
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    if([langId isEqualToString:S_LANG_ZN_TW])
    {
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
    }
    if([langId isEqualToString:S_LANG_HU] || [langId isEqualToString:S_LANG_PL] || [langId isEqualToString:S_LANG_CS] || [langId isEqualToString:S_LANG_SK])
    {
        return NSWindowsCP1250StringEncoding;//Latin2
    }
    if([langId isEqualToString:S_LANG_TR])
    {
        return NSWindowsCP1254StringEncoding;//Latin5
    }
    if([langId isEqualToString:S_LANG_RU])
    {
        return NSWindowsCP1251StringEncoding;//KOI8-R
    }
    if([langId isEqualToString:S_LANG_EL])
    {
        return NSWindowsCP1253StringEncoding;//iSO-8859-7
    }
    
    // その他はLatin1
    return NSWindowsCP1252StringEncoding;//Latin1
}

// リモートスキャン用vkeyの生成
+ (NSString*)createVkey:(NSString*) uiSessionId
{
    if([uiSessionId length] < 16)
    {
        return @"";
    }
    
    NSString* venderKey = @"VOdhRan7yFBQU8VOopBzcdKnTkFhqSZUqFX6TpamCWP9f9fi6o5AhYX+2/RkRjzxDFHHclC4nZNfjS2WgHiWCQ==";
    NSString* key = [uiSessionId substringFromIndex:[uiSessionId length] - 16];
    
    NSData* encrypted_data = [CommonUtil encryptString:venderKey withKey:key iv:key];
    
    NSString* enc_base64_string = [CommonUtil base64encodeString:encrypted_data];
    return  enc_base64_string;
}

// 0から指定した値までの数値文字列をランダムに生成する
+ (NSString*)createRandomNumber:(int) max
{
    srand((unsigned)time(nil));
    int val = rand()%(max+1);
    
    return [NSString stringWithFormat:@"%04d", val];
}

// 文字列をUTF-8でURLEncodeする
+ (NSString*)urlEncode:(NSString*) str
{
    NSString * retStr = ((NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                              (CFStringRef)str,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8)));
    return retStr;
}

// リモートスキャン対応可否を返却する
+ (BOOL)isCapableRemoteScan
{
    BOOL isCapableRemoteScan = NO;
    
    // PROFILE情報の取得
    ProfileDataManager* profileManager = [[ProfileDataManager alloc] init];
    ProfileData* profileData = [profileManager loadProfileDataAtIndex:0];
    
    PrintOutDataManager* printOutManager = [[PrintOutDataManager alloc] init];
    
    PrinterDataManager* printerManager = [[PrinterDataManager alloc] init];
    
    // 最新プライマリキー取得
    NSString* pstrKey = [printOutManager GetLatestPrimaryKey];
    // 接続先WiFiの最新プライマリキー取得
    NSString* pstrKeyForCurrentWiFi = [printOutManager GetLatestPrimaryKeyForCurrentWiFi];
    // 選択中MFP取得
    [printerManager SetDefaultMFPIndex:pstrKey PrimaryKeyForCurrrentWifi:pstrKeyForCurrentWiFi];
    // 選択中MFP情報取得
    PrinterData* printerData = [printerManager LoadPrinterDataAtIndexInclude2:printerManager.DefaultMFPIndex];
    
    if( ([printerManager countRemoteScanCapableScanner] > 0) && !profileData.configScannerSetting && printerData.IsCapableRemoteScan )
    {
        isCapableRemoteScan = YES;
    }
    
    
    return isCapableRemoteScan;
}

// リモートスキャン対応可否を返却する
+ (BOOL)isCapableRemoteScan:(PrinterData*) printerData
{
    BOOL isCapableRemoteScan = NO;
    
    // PROFILE情報の取得
    ProfileDataManager* profileManager = [[ProfileDataManager alloc] init];
    ProfileData* profileData = [profileManager loadProfileDataAtIndex:0];
    
    PrinterDataManager* printerManager = [[PrinterDataManager alloc] init];
    
    if( ([printerManager countRemoteScanCapableScanner] > 0) && !profileData.configScannerSetting && printerData.IsCapableRemoteScan )
    {
        isCapableRemoteScan = YES;
    }
    
    
    return isCapableRemoteScan;
}

// カスタムサイズの名称チェック
// 入力　 名称
// 戻り値  1: OK
//       -1: NG(未入力)
//       -2: NG(文字数を超え)
+ (NSInteger)IsRSCustomSizeName:(NSString*)pstrCustomSizeName
{
    // 長さチェック
	if ([pstrCustomSizeName length] <= 0)
	{
		return  ERR_NO_INPUT;
	}
    else if([pstrCustomSizeName length] > 50)
    {
		return ERR_INVALID_FORMAT;			// 文字数を超え NG
    }
    
	return ERR_SUCCESS;					// OK
}

// 確認コードチェック
+ (int)checkVerifyCode:(NSString*)verifyCode
{
    // 長さチェック
	if (verifyCode.length <= 0)
	{
		return  ERR_NO_INPUT;
	}
    
    // 半角数字チェック
    char* chars = (char*)[verifyCode UTF8String];
    for(int i = 0; i < verifyCode.length; i++){
        //        if(chars[i] >= 'a' && chars[i] <= 'z'){
        //            continue;
        //        }else if(chars[i] >= 'A' && chars[i] <= 'Z'){
        //　           continue;
        //        }else
        if(chars[i] >= '0' && chars[i] <= '9'){
            continue;
        }else if(chars[i] == '\0'){
            // 終端文字
            break;
        }
        
        // NG
        return ERR_INVALID_CHAR_TYPE;
    }
    
    // 文字数チェック
    if(verifyCode.length > 8){
        return ERR_OVER_NUM_RANGE;
    }
    
    return ERR_SUCCESS;
}

// 文字列を(半角は１，全角は２としてカウント）する文字数で切り取る
+ (NSString*)trimString:(NSString*)aString halfCharNumber:(int)maxNumber
{
    if(aString == nil) return nil;
    int strCount = 0;
    int stringIndex;
    for (stringIndex = 0; stringIndex < [aString length]; stringIndex++)
    {
        NSString *oneStr = [aString substringWithRange:NSMakeRange(stringIndex,1)];
        // 文字は存在しているので１をカウント
        strCount++;
        // 半角だった場合は半分
        if (![self hasHalfChar:oneStr])
        {
            strCount++;
        }
        if((maxNumber > 0) && (strCount > maxNumber))
        {
            break;}
    }
    if(stringIndex==0)return nil; //maxNumberが1で全角で始まっている場合
    return [aString substringWithRange:NSMakeRange(0,stringIndex)];
}

+(NSString*)GetPrintFileName:(NSString*) scanFileName
{
    return [[NSString stringWithFormat:@"%@-%@", [[scanFileName lastPathComponent] stringByDeletingPathExtension], [scanFileName pathExtension]] stringByAppendingPathExtension:@"jpg"];
}

+(BOOL)isExistsFreeMemoryJpegConvert:(NSString*) scanFilePath
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:scanFilePath])
    {
        return NO;
    }
    
    CGFloat imgWidth = 0;
    CGFloat imgHeight = 0;
    
    NSURL* url = [[NSURL alloc] initFileURLWithPath:scanFilePath];
    CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                         (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
                                                         (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
                                                         (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageAlways,
                                                         nil];
    CGImageSourceRef imageSource =CGImageSourceCreateWithURL((__bridge CFURLRef)url, options);
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil);
    
    
    if (imageProperties != nil)
    {
        CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
        if (widthNum != NULL) {
            CFNumberGetValue(widthNum, kCFNumberFloatType, &imgWidth);
        }
        
        CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        if (heightNum != NULL) {
            CFNumberGetValue(heightNum, kCFNumberFloatType, &imgHeight);
        }
    }
    if(imageProperties)
    {
        CFRelease(imageProperties);
    }
    if(imageSource)
    {
        CFRelease(imageSource);
    }
    
    
    // 空きメモリ容量取得
    struct vm_statistics a_vm_info;
    mach_msg_type_number_t a_count = HOST_VM_INFO_COUNT;
    host_statistics(mach_host_self(), HOST_VM_INFO,(host_info_t)&a_vm_info, &a_count);
    CGFloat freeCount = ((a_vm_info.free_count * vm_page_size)/1024)/1024;
    
    CGFloat pixelsize = imgWidth * imgHeight;
    // 描画に必要なバイト数取得
    CGFloat imgByte = (((pixelsize * 32)/8)/1024)/1024;
    
    if((freeCount * N_NUM_PDF_ACTIVEMEMORY_MAXSIZE) <= imgByte)
    {
        return NO;
    } else {
        return YES;
    }
    
}

// 検索ワードと文字列が一致するかチェックする
+ (BOOL)rangeOfString:(NSString*)searchText fileName:(NSString*)pstrFileName isShowDir:(BOOL)isDir
{
    NSRange searchResult;
    
    if([searchText isEqualToString:@""] || searchText == nil)
    {
        // 検索テキストが空白の場合は検索しない
        return NO;
    }

    // フォルダ名にDIR-はなくなっているので不要
//    // フォルダーで@"DIR-"が先頭についている場合
//    if(isDir && [pstrFileName hasPrefix:@"DIR-"])
//    {
//        pstrFileName = [pstrFileName substringFromIndex:4];
//    }
    // 大文字小文字を区別せず文字列を検索する
    searchResult = [pstrFileName rangeOfString:searchText options:NSCaseInsensitiveSearch];
    if(searchResult.location != NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

// 未使用のためコメント
//// 指定ファイルの現在のディレクトリ位置を返す（フルパスからDocumentDirを省く）
//+ (NSString*)rootDirPath:(NSString*)filePath
//{
//    NSString* pstrDocumentDir = [self documentDir];
//    // ファイル名チェック
//    if([filePath hasPrefix:pstrDocumentDir])
//    {
//        // DocumentDirを省いてから/で分割して配列に格納する
//        NSArray* removeArray = [[filePath substringFromIndex:pstrDocumentDir.length] componentsSeparatedByString:@"/"];
//        
//        NSString* removeDir = @"/";
//        
//        for(int i = 0; i <[removeArray count]; i++)
//        {
//            // 各フォルダー階層のDIR-の文字を取り除き、パスを結合する
//            if([[removeArray objectAtIndex:i] hasPrefix:@"DIR-"])
//            {
//                removeDir = [removeDir stringByAppendingPathComponent:[[removeArray objectAtIndex:i]substringFromIndex:4]];
//            }
//        }
//        return removeDir;
//    }
//    return pstrDocumentDir;
//}

// SSIDを取得する
+ (NSString*)getSSID
{
    NSString *ssid = S_TITLE_WIFI_UNCONNECT;
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if(interfaces == nil)
    {
        return ssid;
    }
    CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
    
    if (dicRef) {
        ssid = [NSString stringWithFormat:S_TITLE_WIFI_CONNECT, CFDictionaryGetValue(dicRef, kCNNetworkInfoKeySSID)];
        DLog(@"SSID=%@", ssid);
        CFRelease(dicRef);
    }
    CFRelease(interfaces);

    return ssid;
}

// Modified UTF-7(kCFStringEncodingUTF7_IMAP)を文字列に変換
+ (NSString*)FromModifiedUTF7String:(NSString*)str
{
    NSString* pstrDecode = @"";
    NSUInteger len = str.length;
    
    for (NSUInteger i = 0; i < len; i++)
    {
        // 文字列をASCIIにエンコード
        NSData* data = [str dataUsingEncoding:NSASCIIStringEncoding];
        unsigned char aBuffer[1];
        [data getBytes:aBuffer range:NSMakeRange(i, 1)];
        
        // In modified UTF-7, printable US-ASCII characters, except for "&",
        // represent themselves
        // "&" is used to shift to modified BASE64
        // "&"ではない場合
        if (0x26 != aBuffer[0])
        {
            pstrDecode = [pstrDecode stringByAppendingString:[str substringWithRange:NSMakeRange(i,1)]];
            continue;
        }
        
        if (len <= ++i)
        {
            // incorrect form
            return str;
        }
        
        // '-'
        if (0x2d == aBuffer[0])
        {
            // The character "&" (0x26) is represented by the two-octet sequence "&-".
            pstrDecode = [pstrDecode stringByAppendingString:@"&"];
            continue;
        }
        
        NSString* pstrNonPrintable = @"";
        
        for ( ; i < len ; i++)
        {
            NSData* data2 = [str dataUsingEncoding:NSASCIIStringEncoding];
            unsigned char bBuffer[1];
            [data2 getBytes:bBuffer range:NSMakeRange(i, 1)];
            
            if(0x2d == bBuffer[0])
                break;
            
            pstrNonPrintable = [pstrNonPrintable stringByAppendingString:[str substringWithRange:NSMakeRange(i,1)]];
            
        }
        // modified UTF7 -> string
        pstrDecode = [pstrDecode stringByAppendingString:[self FromModifiedUTF7:pstrNonPrintable]];
        
    }
    
    return pstrDecode;
}

// Modified UTF-7複合化
+ (NSString*)FromModifiedUTF7:(NSString*)str
{
    NSString* pstrModifiedUTF7 = @"";
    NSData* data1 = [self FromModifiedBase64:str];
    
    if (data1 != nil)
    {
        pstrModifiedUTF7 = [[NSString alloc]initWithData:data1 encoding:NSUTF16StringEncoding];
    }
    else
    {
        pstrModifiedUTF7 = str;
    }
    return pstrModifiedUTF7;
}

// Modified Base64複合化
+ (NSData*)FromModifiedBase64:(NSString*)str
{
    NSString* pstrModifiedBase64;
    // "," is used instead of "/"
    pstrModifiedBase64 = [str stringByReplacingOccurrencesOfString:@"," withString:@"/"];
    
    if (str.length % 4 == 0)
    {
        return [self base64Decoding:pstrModifiedBase64];
    }
    else if (str.length % 4 == 2)
    {
        return [self base64Decoding:[pstrModifiedBase64 stringByAppendingString:@"=="]];
    }
    else if (str.length % 4 == 3)
    {
        return [self base64Decoding:[pstrModifiedBase64 stringByAppendingString:@"="]];
    }
    else
    {
        // incorrect form
        return nil;
    }
}

#pragma mark - SNMP

/**
 * プリンターがPCL, PS対応かどうかをチェック
 * @param [in] snmpManager SnmpManagerクラスのインスタンス
 * @param [out] isExistsPCL PCL対応判定結果
 * @param [out] isExistsPS  PS対応判定結果
 * @return  プリンター情報を取得できればYES
 */
+ (BOOL)checkPrinterSpecWithSnmpManager:(SnmpManager*)snmpManager
                                    PCL:(BOOL*)p_isExistsPCL
                                     PS:(BOOL*)p_isExistsPS
{
    BOOL result;
    
    //-------------------------
    //以下のフラグについて判定を行う
    BOOL isExistsPCL = NO;
    BOOL isExistsPS  = NO;
    //-------------------------
    
//    *p_isExistsPCL = YES;//*** 仮 tiff出力確認
//    *p_isExistsPS  = NO;
//    return YES;
    
    NSMutableArray* arrOid = [[NSMutableArray alloc]init];
    
    [arrOid addObject:S_SNMP_OID_PRINTEROPTIONS];
    
    
    //getNextでプリンターの情報取得
    
    int count = 0;//カウンタ
    
    while (YES)
    {
        DLog(@"while loop");
        BOOL isScanComplete = NO;//完了フラグ
        
        //次のデータを１つ読み込み
        NSMutableDictionary* mibDic = [snmpManager getNextByOid:arrOid];
        
        DLog(@"mibDic= %@", mibDic);
        
        //データが無ければループを抜ける
        if( !mibDic || mibDic.count ==0 )break;
        
        //キー取得
        NSString* key = [mibDic allKeys][0];
        DLog(@"%@ = %@",key, mibDic[key]);
        
        // GetNextで取得したOIDがGetNextのリクエスト送信時に指定したものと同じ場合、
        // 無限ループとなってしまうので、処理を抜ける
        if([key isEqualToString:[arrOid objectAtIndex:0]]) {
            break;
        }
        
        //判定
        if([key hasPrefix:S_SNMP_OID_PRINTEROPTIONS])
        {//要判定key
            if(  [[mibDic objectForKey:key] isEqual:S_SNMP_OID_PRINTEROPTION_PCL_1]
               ||[[mibDic objectForKey:key] isEqual:S_SNMP_OID_PRINTEROPTION_PCL_2])
            {//PCL
                isExistsPCL = YES;
                DLog(@"isExistsPCL = YES")
            }
            if([[mibDic objectForKey:key] isEqual:S_SNMP_OID_PRINTEROPTION_PS_1])
            {//PS
                isExistsPS = YES;
                DLog(@"isExistsPS = YES");
            }
            if(isExistsPCL && isExistsPS)
            {//PCL,PSともにYESになればループを抜ける
                isScanComplete = YES;
            }
            if(isScanComplete)
            {
                break;
            }
        }
        else
        {//判定不要key
            break;
        }
        
        //次の読み込みを行うための更新
        arrOid=[[mibDic allKeys] mutableCopy];
        
        count++;
    }
    
    if(count == 0)
    {//取得失敗
        DLog(@"取得失敗");
        *p_isExistsPCL = NO;
        *p_isExistsPS  = NO;
        result      = NO;
    }
    else
    {//取得成功
        *p_isExistsPCL = isExistsPCL;
        *p_isExistsPS  = isExistsPS;
        result         = YES;
    }
    

    return result;
}

/**
 * ステープルチェックで使用するSNMPManagerの初期化
 */
+ (SnmpManager*)createSnmpManager:(PrinterData*)printerData
{
    ProfileDataManager* pManager = [[ProfileDataManager alloc]init];
    ProfileData* pData = [pManager loadProfileDataAtIndex:0];
    
    // Community String の設定
    NSMutableArray* communityString = [[NSMutableArray alloc]init];
    if(!pData.snmpSearchPublicMode)
    {
        [communityString addObject:S_SNMP_COMMUNITY_STRING_DEFAULT];
    }
    NSArray *strStrings = [pData.snmpCommunityString componentsSeparatedByString:@"\n"];
    for (NSString* strTmp in strStrings) {
        [communityString addObject:strTmp];
    }
    
    NSDictionary *dicIPAddr = [CommonUtil getIPAddrDicForComm:[printerData getIPAddress] port:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:N_SNMP_PORT]]];
    SnmpManager* snmpManager = [[SnmpManager alloc]initWithIpAddress:[dicIPAddr objectForKey:S_TARGET_IPADDRESS_DIC_KEY] port:N_SNMP_PORT];
    [snmpManager setCommunityString:communityString];
    
    return snmpManager;
}

/**
 @brief プリンターが仕上げ対応かどうかをチェックする
 */
+ (FinishingData*)checkPrinterSpecStaplePunchWithSnmpManager:(SnmpManager*)snmpManager {
    
    // フィニッシャー(ステープル/パンチ)
    FinishingData *finishingData = [self checkPrinterSpecFinisherWithSnmpManager:snmpManager];

    if (finishingData == nil) {
        return nil;
    }
    
    // 1箇所とじ/2箇所とじ
    STAPLE stapleSpec = finishingData.staple;
        
    // 針なしステープル
    BOOL canStaplelessStaple = [self checkPrinterSpecStaplelessStaple:snmpManager];
    
    if (canStaplelessStaple) {
        switch (stapleSpec) {
            case STAPLE_NONE:
                stapleSpec = STAPLE_NONE_STAPLELESS;
                break;
            case STAPLE_ONE:
                stapleSpec = STAPLE_ONE_STAPLELESS;
                break;
            case STAPLE_TWO:
                stapleSpec = STAPLE_TWO_STAPLELESS;
                break;
            default:
                break;
        }
    }
    
    NSLog(@"### ステープルスペック：%d ###", stapleSpec);
    // 針なしステープルを加味した状態に変更
    finishingData.staple = stapleSpec;
    
    return finishingData;
}

/**
 @brief 針なしステープル対応か判定
 */
+ (BOOL)checkPrinterSpecStaplelessStaple:(SnmpManager*)snmpManager {
    
    /*
     【針なしステープル判定】
     1：OID「1.3.6.1.2.1.43.30.1.1.10」以下をWALK
     2：前方一致でOIDが上記以外になったら、処理をやめる
     3：取得した値が「Stapleless Staple」と完全一致する場合、針なしステープル対応と判定
     
     */
    
    BOOL canStaplelessStaple = NO;
    
    NSMutableArray* arrOid = [[NSMutableArray alloc]init];
    [arrOid addObject:S_SNMP_OID_STAPLELESS_STAPLE];
    
    //    getNextで情報取得
    while (YES) {
        //次のデータを１つ読み込み
        NSMutableDictionary* mibDic = [snmpManager getNextByOid:arrOid];
        DLog(@"mibDic= %@", mibDic);
        
        //データが無ければループを抜ける
        if( !mibDic || mibDic.count ==0 ) {
            return STAPLE_ERR;
        }
        
        NSString* key = [mibDic allKeys][0];
        DLog(@"%@ = %@",key, mibDic[key]);
        
        // GetNextで取得したOIDがGetNextのリクエスト送信時に指定したものと同じ場合、
        // 無限ループとなってしまうので、処理を抜ける
        if([key isEqualToString:[arrOid objectAtIndex:0]]) {
            break;
        }
        
        if ([key hasPrefix:S_SNMP_OID_STAPLELESS_STAPLE]) {
            NSString* chkVal = [mibDic objectForKeyedSubscript:key];
            if ([chkVal isEqualToString:S_SNMP_OID_FINISHER_STAPLELESS_STAPLE]) {
                // 針なしステープルあり
                canStaplelessStaple = YES;
            }
        }
        else {
            // 別のOIDになったので終了
            break;
        }
        
        //次の読み込みを行うための更新
        arrOid=[[mibDic allKeys] mutableCopy];
         
    }
    
    return canStaplelessStaple;
    
}

/**
 * プリンターのフィニッシャー状態をチェックする
 * ステープル対応(1箇所とじ/2箇所とじ)
 * パンチ対応(2穴/3穴/4穴/4穴(幅広))
 */
+ (FinishingData*)checkPrinterSpecFinisherWithSnmpManager:(SnmpManager*)snmpManager
{
    /*
     【判定方法】
     finDeviceAttributeValueAsInterger(1.3.6.1.2.1.43.33.1.1.3)をGetNextで取得し、
     ResponseのOIDが、1.3.6.1.2.1.43.33.1.1.4になったら取得をやめる。
     
     取得が出来なかった場合は、フィニッシャーは装着されていなく、ステープル及びパンチ機能なしと判定する。
     
     取得が出来た場合は、ステープル機能の場合、
     finDeviceAttributeValueAsInterger.1.x.30.x (xは任意の数字)の値を確認する。
     finDeviceAttributeValueAsInterger.1.x.30.x が取得できていない場合は、
     "stitchingType (30)"がない、つまり、ステープル機能なしと判定する。
     
     finDeviceAttributeValueAsInterger.1.x.30.x が取得できた場合は、
     ステープル機能ありと判定し、
     取得できた値が、
     stapleTopLeft (4)、または、stapleTopRight(6)の場合・・・1箇所とじが可能
     
     上記の他に値が取得でき、その値が、
     stapleDual (10)の場合・・・1箇所とじに加え、と2箇所とじも可能
     
     上記の他に値が取得でき、その値が、
     saddleStitch (8)の場合・・・1箇所とじと2箇所とじに加え、中とじ(Saddle Stitch)が可能
     　　　　　　　　　　　　　　(現時点のSDMでは指定できなので関係なし)
     
     
     取得が出来た場合は、パンチ機能の場合、
     finDeviceAttributeValueAsInterger.1.x.83.x (xは任意の数字)の値を確認する。
     finDeviceAttributeValueAsInterger.1.x.83.x が取得できていない場合は、
     "punch_switchingType (83)"がない、つまり、パンチ機能なしと判定する。
     
     finDeviceAttributeValueAsInterger.1.x.83.x が取得できた場合は、
     パンチ機能ありと判定し、
     取得できた値が、
     threeHoleUS(5)の場合  ・・・3穴パンチ可能
     twoHoleDIN(6)の場合   ・・・2穴パンチ可能
     fourHoleDIN(7)の場合  ・・・4穴パンチ可能
     swedish4Hole(11)の場合・・・4穴(ワイド)パンチ可能
     */
    
    BOOL canOneStaple = NO;
    BOOL canTowStaple = NO;
    
    BOOL canPunch2Holes = NO;
    BOOL canPunch3Holes = NO;
    BOOL canPunch4Holes = NO;
    BOOL canPunch4HolesWide = NO;
    
    NSMutableArray* arrOid = [[NSMutableArray alloc]init];
    [arrOid addObject:S_SNMP_OID_FINISHER];
    
    //getNextで情報取得
    while (YES) {
        //次のデータを１つ読み込み
        NSMutableDictionary* mibDic = [snmpManager getNextByOid:arrOid];
        DLog(@"mibDic= %@", mibDic);
        
        //データが無ければループを抜ける
        if( !mibDic || mibDic.count ==0 ) {
            return nil;
        }
        
        NSString* key = [mibDic allKeys][0];
        DLog(@"%@ = %@",key, mibDic[key]);
        
        // GetNextで取得したOIDがGetNextのリクエスト送信時に指定したものと同じ場合、
        // 無限ループとなってしまうので、処理を抜ける
        if([key isEqualToString:[arrOid objectAtIndex:0]]) {
            break;
        }
        
        if([key hasPrefix:S_SNMP_OID_FINISHER]) {
            // 判定処理
            NSString* tmp = [key substringFromIndex:[S_SNMP_OID_FINISHER length]];
            NSArray* splitVal = [tmp componentsSeparatedByString:@"."];
            if([splitVal count] >= 4) {
                NSString* val3 = [splitVal objectAtIndex:3];
                if([val3 isEqualToString:S_SNMP_OID_FINISHER_STITCHING_TYPE]) {
                    //ステープルあり
                    NSString* val = [mibDic objectForKeyedSubscript:key];
                    
                    if([val isEqualToString:S_SNMP_OID_FINISHER_STAPLE_TOP_LEFT] ||
                       [val isEqualToString:S_SNMP_OID_FINISHER_STAPLE_TOP_RIGHT]) {
                        canOneStaple = YES;
                    } else if([val isEqualToString:S_SNMP_OID_FINISHER_STAPLE_DUAL]) {
                        canTowStaple = YES;
                    }
                } else if([val3 isEqualToString:S_SNMP_OID_FINISHER_PUNCH_SWITCHING_TYPE]) {
                    //パンチ機能あり
                    NSString* val = [mibDic objectForKeyedSubscript:key];
                    
                    if([val isEqualToString:S_SNMP_OID_FINISHER_PUNCH_3HOLES]) {
                        canPunch3Holes = YES;
                    } else if([val isEqualToString:S_SNMP_OID_FINISHER_PUNCH_2HOLES]) {
                        canPunch2Holes = YES;
                    } else if([val isEqualToString:S_SNMP_OID_FINISHER_PUNCH_4HOLES]) {
                        canPunch4Holes = YES;
                    } else if([val isEqualToString:S_SNMP_OID_FINISHER_PUNCH_4HOLESWIDE]) {
                        canPunch4HolesWide = YES;
                    }
                }
            }
        }
        else {
            // 別のOIDになったので終了
            break;
        }
        
        //次の読み込みを行うための更新
        arrOid=[[mibDic allKeys] mutableCopy];
    }
    
    FinishingData *finishingData = [[FinishingData alloc] init];

    // ステープル
    STAPLE staple = STAPLE_NONE;
    if (canTowStaple) {
        staple = STAPLE_TWO;
    }else if (canOneStaple) {
        staple = STAPLE_ONE;
    } else {
        staple = STAPLE_NONE;
    }
    finishingData.staple = staple;
    
    // パンチ
    PunchData *punchData = [[PunchData alloc] init];
    if (canPunch2Holes) {
        punchData.canPunch2Holes = YES;
        punchData.canPunch = YES;
        NSLog(@"### パンチスペック：%@ ###", @"2HOLES");
    }
    if (canPunch3Holes) {
        punchData.canPunch3Holes = YES;
        punchData.canPunch = YES;
        NSLog(@"### パンチスペック：%@ ###", @"3HOLES");
    }
    if (canPunch4Holes) {
        punchData.canPunch4Holes = YES;
        punchData.canPunch = YES;
        NSLog(@"### パンチスペック：%@ ###", @"4HOLES");
    }
    if (canPunch4HolesWide) {
        punchData.canPunch4HolesWide = YES;
        punchData.canPunch = YES;
        NSLog(@"### パンチスペック：%@ ###", @"4HOLESWIDE");
    }
    finishingData.punchData = punchData;
    
    return finishingData;
}

#pragma mark -

/**
 * ビュー構成を表示（デバグ用）
 */
+ (void)showViewTree
{
    SharpScanPrintAppDelegate* appDel = (SharpScanPrintAppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self showSubviewsOfView:appDel.window indent:0];
}


/**
 * 子ビューをインデント付きで表示
 */
+ (void)showSubviewsOfView:(UIView*)view indent:(int)indent{
    
    NSMutableString*space = [NSMutableString string];
    for (int i= 0; i<indent; i++) {
        [space appendString:@"-"];
    }
    
    for (UIView* sv in view.subviews) {
        NSLog(@"%@%@", space, [sv class]);
        [self showSubviewsOfView:sv indent:indent+1];
    }
}

/**
 * ViewControllerのクラス名を表示
 */
+ (void)showClassNameOfViewControlller:(UIViewController*)vc
{
    UILabel* label = [UILabel init];
    label.text = [NSString stringWithFormat:@"%@:%@", [vc class], [vc.superclass class]];
    label.font = [UIFont systemFontOfSize:8];
    [label sizeToFit];
    [vc.view addSubview:label];
}

+ (id)setView:(UIView*)view frameOriginY:(CGFloat)y
{
    CGRect rect = view.frame;
    rect.origin.y = y;
    view.frame =rect;
    return view;
}

/**
 * ファイル名の拡張子を除いた末尾が_\d{4}にマッチする場合、YES
 */
+ (BOOL)isSerialNoLengthIsFour:(NSString*) filenameWithoutExtention
{
    NSError *error = nil;
    NSString *pattern = @"^.+_\\d{4}$";
    NSString* filenameWothoutPathExtension = filenameWithoutExtention;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if(error != nil) {
        return NO;
    }
    NSTextCheckingResult *match = [regex firstMatchInString:filenameWothoutPathExtension options:0 range:NSMakeRange(0, filenameWothoutPathExtension.length)];
    
    return (match.numberOfRanges > 0) ? YES : NO;
}

@end
