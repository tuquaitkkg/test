#import "ScanDataManager.h"
#import "CommonUtil.h"
#import "CommonManager.h"
#import "Define.h"
#import "ScanFile.h"
#import "ScanFileUtility.h"
#import "GeneralFileUtility.h"


@implementation ScanDataManager

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize		baseDir;							// ホームディレクトリ/Documments/
//@synthesize		tView;                              // ファイル選択画面のTableView
@synthesize     fullPath = m_fullPath;
@synthesize     IsMoveView;                         // 移動する画面
@synthesize     IsSearchView;                       // 検索画面
@synthesize     IsAdvancedSearch;                   // 詳細検索画面
@synthesize     searchKeyword;                      // 検索文字
@synthesize     IsSubFolder;                        // 検索範囲(サブフォルダーを含む)
@synthesize     IsFillterFolder;                    // 検索対象(フォルダー)
@synthesize     IsFillterPdf;                       // 検索対象(PDF)
@synthesize     IsFillterTiff;                      // 検索対象(TIFF)
@synthesize     IsFillterImage;                     // 検索対象(JPEG,PNG)
@synthesize     IsFillterOffice;                    // 検索対象(OFFICE)

#pragma mark -
#pragma mark class method


#pragma mark -
#pragma mark TempDataManager delegete

//
// イニシャライザ定義
//
- (id)init
{
	LOG_METHOD;
	
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
	//
	// ホームディレクトリ/Documments の取得
	//
    
	self.baseDir = [CommonUtil documentDir];
	//
	// スキャンデータの取得
	//
    //	filteredList	= [[NSMutableArray alloc] init];	// 初期化
    //	scanDataList	= [[NSMutableArray alloc] init];	// 初期化
	scanTempDataList	= [[NSMutableArray alloc] init];	// 初期化
    ScanDataList	= [[NSMutableArray alloc] init];	// 初期化
    //	ScanDataList	= [self getScanData];
    m_indexList           = [[NSMutableArray alloc] init];    // 初期化
	
    return self;
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//
- (void)dealloc
{
	LOG_METHOD;
    
    [ScanDataList removeAllObjects];
    //    [scanDataList removeAllObjects];
    [scanTempDataList removeAllObjects];
    
    // 親クラスの解放処理を呼び出す
}


#pragma mark -
#pragma mark ScanData Manager

//
// スキャンデータの再読み込み
//
- (void)reGetScanData
{
    
	[ScanDataList removeAllObjects];
	
    ScanDataList	= [self getScanData];
	
    
}

//
// 指定したインデックスの ScanDataクラスを取り出す
//
- (ScanData *)loadScanDataAtIndexPath:(NSIndexPath *)indexPath
{
	//TRACE(@"indexPath[%@]", indexPath);
    if (indexPath.row < [[ScanDataList objectAtIndex: indexPath.section] count])
	{
        return [[ScanDataList objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
    }
    
	return nil;
}

//
// 指定したインデックスの ScanDataクラスを削除
//
- (BOOL)removeAtIndex:(NSIndexPath *)indexPath
{
	//TRACE(@"indexPath[%@]", indexPath);
    
    if (indexPath.row > [[ScanDataList objectAtIndex: indexPath.section] count])
	{
        return FALSE;
    }
	
	[[ScanDataList objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
    
    return TRUE;
}

//
// ScanDataクラスの要素数を戻す
//
- (NSUInteger)countOfScanData
{
    return [ScanDataList count];
}

//
// ScanDataクラスの登録処理 (collectionData に　addScanDataをソートしながら追加する
//
- (BOOL)addScanData:(NSMutableArray *)collectionData addScanData:(ScanData *)addScanData
{
	unsigned i;
    
	@autoreleasepool
    {
        
        if( [collectionData count] == 0)
        {
            //TRACE(@"fnam[%@]crdate[%@]crdate_yymm[%@]", addScanData.fname, addScanData.crdate, addScanData.crdate_yymm);
            [collectionData addObject:addScanData];
        }
        else
        {
            i = 0;
            for (ScanData *theScanData in collectionData)
            {
                NSComparisonResult res= [theScanData.crdate compare:addScanData.crdate];
                if (res == NSOrderedSame )
                {
                    [collectionData insertObject:addScanData atIndex:i];		// 追加
                    break;
                }
                
                else if (res == NSOrderedAscending)
                {
                    [collectionData insertObject:addScanData atIndex:i];		// 追加
                    break;
                }
                
                else if (res== NSOrderedDescending)
                {
                    // theScanData.crdate > addScanData.crdate
                    
                }
                i++;
            }
            if (i >= [collectionData count])
            {
                [collectionData insertObject:addScanData atIndex:i];			// 追加
            }
            //TRACE(@"fnam[%@]crdate[%@]crdate_yymm[%@] (%d)", addScanData.fname, addScanData.crdate, addScanData.crdate_yymm,i);
        }
	}
    
	return YES;
}

//
// index設定処理　(ソート追加のため全体を変更)
//
- (BOOL)setIndexScanData:(NSMutableArray *)scanDataLists
{
	@autoreleasepool
    {
        
        //NSString	*createDate	= [NSString stringWithString:@"000000000000"];
        //    NSString	*yymm	= @"000000";
        NSString	*sectionName = nil;
        m_indexList = [NSMutableArray array];
        
        //    NSUInteger counter = 0;
        BOOL directoryExists = NO;
        
        NSMutableArray* dirLists = nil;
        NSMutableArray* dataLists = nil;
        
        // (1) ディレクトリーを抽出する
        for (ScanData *theScanData in scanDataLists)
        {
            if(theScanData.isDirectory)
            {
                //ディレクトリならばdirListsに分類
                if(dirLists==nil)
                {
                    dirLists = [[NSMutableArray alloc] initWithObjects: theScanData, nil];
                    directoryExists = YES;
                }
                else
                {
                    [dirLists addObject:theScanData];
                }
            }
            else
            {
                //ディレクトリ以外はdataListsに分類する
                if(dataLists==nil)
                {
                    dataLists = [[NSMutableArray alloc] initWithObjects: theScanData, nil];
                }
                else
                {
                    [dataLists addObject:theScanData];
                }
            }
        }
        
        // (2) ディレクトリーをソートする
        if (directoryExists) {
            if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            {
                [dirLists sortUsingComparator: ^(ScanData *a, ScanData *b){return [a.fname localizedCaseInsensitiveCompare: b.fname];}];
            }
            else
            {
                [dirLists sortUsingComparator: ^(ScanData *a, ScanData *b){return [b.fname localizedCaseInsensitiveCompare: a.fname];}];
            }
        }
        
        // (3) ディレクトリー以外をsort key, sort-dir keyでデータをソートする
        if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
        {
            switch ([CommonUtil scanDataSortType]) {
                case SCANDATA_FILEDATE:
                    [dataLists sortUsingComparator: ^(ScanData *a, ScanData *b){return [a.crdate localizedCaseInsensitiveCompare: b.crdate];}];
                    break;
                case SCANDATA_FILENAME:
                    [dataLists sortUsingComparator: ^(ScanData *a, ScanData *b){return [a.fname localizedCaseInsensitiveCompare: b.fname];}];
                    break;
                case SCANDATA_FILESIZE:
                    
                    [dataLists sortUsingComparator: ^(ScanData *a, ScanData *b) {
                        if ([a.filesize intValue] > [b.filesize intValue]) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        
                        if ([a.filesize intValue] < [b.filesize intValue]) {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    }];
                    break;
                case SCANDATA_FILETYPE:
                    [dataLists sortUsingComparator: ^(ScanData *a, ScanData *b) {
                        if ([a fileTypeNumber] > [b fileTypeNumber]) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        
                        if ([a fileTypeNumber] < [b fileTypeNumber]) {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    }];
                default:
                    break;
            }
        }
        else
        {
            switch ([CommonUtil scanDataSortType]) {
                case SCANDATA_FILEDATE:
                    [dataLists sortUsingComparator: ^(ScanData *a, ScanData *b){return [b.crdate localizedCaseInsensitiveCompare: a.crdate];}];
                    break;
                case SCANDATA_FILENAME:
                    [dataLists sortUsingComparator: ^(ScanData *a, ScanData *b){return [b.fname localizedCaseInsensitiveCompare: a.fname];}];
                    break;
                case SCANDATA_FILESIZE:
                    [dataLists sortUsingComparator: ^(ScanData *a, ScanData *b) {
                        if ([b.filesize intValue] > [a.filesize intValue]) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        if ([b.filesize intValue] < [a.filesize intValue]) {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    }];
                    break;
                case SCANDATA_FILETYPE:
                    [dataLists sortUsingComparator: ^(ScanData *a, ScanData *b) {
                        if ([b fileTypeNumber] > [a fileTypeNumber]) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        
                        if ([b fileTypeNumber] < [a fileTypeNumber]) {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    }];
                default:
                    break;
            }
        }
        
        // (4) ディレクトリーのインデクスを設定し、名前順で並べ替える
        if(directoryExists)
        {
            for (ScanData *theScanData in dirLists)
            {
                theScanData.index = @"dir";
                [m_indexList addObject:@"dir"];   // ディレクトリのインデックスをリストに格納(キーワード検索には使用されない。セクションカウント用)
            }
            //        if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
            //        {
            //            [dirLists sortUsingComparator: ^(ScanData *a, ScanData *b){return [a.fname localizedCaseInsensitiveCompare: b.fname];}];
            //        }
            //        else
            //        {
            //            [dirLists sortUsingComparator: ^(ScanData *a, ScanData *b){return [b.fname localizedCaseInsensitiveCompare: a.fname];}];
            //        }
        }
        
        // (5) ディレクトリー以外のインデクスを設定する
        for (ScanData *theScanData in dataLists)
        {
            if (sectionName == nil) {
                switch ([CommonUtil scanDataSortType]) {
                    case SCANDATA_FILEDATE:
                        sectionName = [theScanData crdate_yymm];
                        break;
                    case SCANDATA_FILENAME:
                        //                    sectionName = [theScanData.fname substringToIndex:1];
                        sectionName = S_LABEL_FOLDER;
                        break;
                    case SCANDATA_FILESIZE:
                        //                    sectionName = [theScanData fileSizeUnit];
                        sectionName = S_LABEL_FOLDER;
                        break;
                    case SCANDATA_FILETYPE:
                        sectionName = [theScanData fileType];
                    default:
                        break;
                }
                if (sectionName != nil) {
                    [m_indexList addObject:sectionName];    // ディレクトリ以外の最初のインデックスをリストに格納
                }
            }
            //sort typeに応じたキーによりセクション分け用のキーを割り振る
            NSComparisonResult res;
            NSString* currentSectionName;
            switch ([CommonUtil scanDataSortType]) {
                case SCANDATA_FILEDATE:
                    currentSectionName = [theScanData crdate_yymm];
                    res = [sectionName compare: currentSectionName];
                    break;
                case SCANDATA_FILENAME:
                    //                currentSectionName = [theScanData.fname substringToIndex:1];
                    currentSectionName = S_LABEL_FOLDER; //固定
                    res = [sectionName compare: currentSectionName];
                    break;
                case SCANDATA_FILESIZE:
                    //                currentSectionName = [theScanData fileSizeUnit];
                    currentSectionName = S_LABEL_FOLDER; //固定
                    res = [sectionName compare: currentSectionName];
                    break;
                case SCANDATA_FILETYPE:
                    //                currentSectionName = [theScanData.fname pathExtension];
                    currentSectionName = [theScanData fileType];
                    res = [sectionName compare: currentSectionName];
                default:
                    break;
            }
            sectionName = currentSectionName;
            if (res != NSOrderedSame) {
                // currentSectionNameが更新されている場合
                [m_indexList addObject:sectionName];    // セクションのインデックスをリストに格納
            }
            // indexを設定
            theScanData.index = currentSectionName;
            
#if 0
            //TRACE(@"[%@][%@][%@][%@]", theScanData.crdate_yymm, theScanData.crdate, theScanData.fname, theScanData.index );
#endif
            
        }
        // (6)ディレクトリーをマージする
        [scanDataLists removeAllObjects];
        if (directoryExists) {
            [scanDataLists addObjectsFromArray:dirLists];
        }
        [scanDataLists addObjectsFromArray:dataLists];
	}
    
	return YES;
}

////
//// ディレクトリソート用関数
//int sortDirectry(ScanData* item1, ScanData* item2, void *context)
//{
//    return [item1.fname localizedCaseInsensitiveCompare:item2.fname];
//}

//
// スキャンデータの読み込み
//
- (NSMutableArray *)getScanData
{
	LOG_METHOD;
    [scanTempDataList removeAllObjects];
    @autoreleasepool
    {
        @try {
            //
            // ディレクトリ以下のファイルやディレクトリを順番に取得する
            //
            NSString *fullDirPath = self.fullPath;
            
            NSString *tempDir;
            if(fullDirPath == nil)
            {
                tempDir		= [self.baseDir stringByAppendingString:@"/"];
            }
            else
            {
                tempDir		= [NSString stringWithFormat:@"%@/",fullDirPath];
            }
            NSError			*err			= nil;
            NSMutableArray	*sectionArrays	= [[NSMutableArray array] init];
            
            //
            // ディレクトリ用の列挙子を取得する
            //
            //		NSFileManager *localFileManager	= [[NSFileManager alloc] init];
            NSFileManager *localFileManager	= [NSFileManager defaultManager];
            
            // サブディレクトリを検索する為、コメントアウト
            //NSDirectoryEnumerator *dirEnum	= [localFileManager enumeratorAtPath:tempDir];
            
            NSString *fname;
            // サブディレクトリを検索する為、コメントアウト
            //while (fname = [dirEnum nextObject])
            if(IsSearchView)
            {
                //        for(fname in [localFileManager contentsOfDirectoryAtPath:tempDir error:&err])
                for(fname in [localFileManager subpathsOfDirectoryAtPath:tempDir error:&err])  // サブディレクトリのデータも抽出
                {
                    @autoreleasepool
                    {
                        
                        //
                        // ディレクトリ用の列挙子を取得する
                        //
                        NSFileManager *lFileManager	= [NSFileManager defaultManager];
                        
                        NSString* fileName = nil;
                        fileName = [fname lastPathComponent];
                        
                        // ファイルやディレクトリのフルパス取得
                        NSString *directoryPath = [tempDir stringByAppendingPathComponent:fname];
                        
                        BOOL isExtensionCheck;
                        BOOL isFillterCheck = YES;
                        BOOL isShowDir = [CommonUtil directoryCheck:directoryPath name:fileName];
                        
                        isExtensionCheck = ([CommonUtil extensionFileCheck:fileName] || isShowDir )&&([CommonUtil rangeOfString:searchKeyword fileName:fileName isShowDir:isShowDir]);
                        
                        // 指定したフォルダーのサブフォルダー以下の検索に入った場合
                        NSArray *components = [fname pathComponents];
                        if([components count] > 1)
                        {
                            if(IsSubFolder)
                            {
                                isExtensionCheck = NO;
                            }
                            else
                            {
                                // ファイル一覧表示用フォルダー"DIR-"以外のファルダー以下のデータならば検索しない
                                if(![CommonUtil directoryCheck:[directoryPath stringByDeletingLastPathComponent] name:[[directoryPath stringByDeletingLastPathComponent] lastPathComponent]])
                                {
                                    isExtensionCheck = NO;
                                }
                            }
                            
                        }
                        
                        // 詳細検索時
                        if(IsAdvancedSearch && isExtensionCheck)
                        {
                            // 検索対象から外れている場合、判定を行う
                            // 検索対象から外れている種類と一致したら、検索しない
                            if(isFillterCheck && IsFillterFolder)
                            {
                                isFillterCheck = ![CommonUtil directoryCheck:directoryPath name:fileName];
                            }
                            if (isFillterCheck && IsFillterPdf)
                            {
                                isFillterCheck = ![CommonUtil pdfExtensionCheck:fileName];
                            }
                            if (isFillterCheck && IsFillterTiff)
                            {
                                isFillterCheck = ![CommonUtil tiffExtensionCheck:fileName];
                            }
                            if (isFillterCheck && IsFillterImage)
                            {
                                isFillterCheck = !([CommonUtil jpegExtensionCheck:fileName] || [CommonUtil pngExtensionCheck:fileName]);
                            }
                            if (isFillterCheck && IsFillterOffice)
                            {
                                isFillterCheck = !([CommonUtil officeExtensionCheck:fileName]);
                            }

                            isExtensionCheck = isFillterCheck;
                        }
                        
                        //            if (isExtensionCheck)
                        //            {
                        //
                        //                // 位置変更
                        //                //
                        //                // ファイルやディレクトリの情報取得
                        //                //
                        //                NSString	 *path	= [tempDir stringByAppendingString:fname];
                        //                NSDictionary *attr	= [lFileManager attributesOfItemAtPath:path error:&err];
                        //                NSDate		 *date	= [attr objectForKey:NSFileModificationDate];
                        //
                        //#if 0
                        //				LOG(@"fname:%@", fname);
                        //#endif
                        //				//
                        //				// scanData クラスにセット
                        //				//
                        //				ScanData *scanData	= [[ScanData alloc] init];
                        //				scanData.fname		= [NSString stringWithString:fileName];		// 表示名称
                        //
                        //				//
                        //				// 作成日付をフォーマッタを取得して設定する
                        //				//
                        //				NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
                        //
                        //				[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                        //				scanData.crdate			= [NSString stringWithString:[formatter stringFromDate:date]];
                        //
                        //				[formatter setDateFormat:@"yyyyMM"];
                        //				scanData.crdate_yymm	= [NSString stringWithString:[formatter stringFromDate:date]];
                        //
                        //                [formatter setDateFormat:@"yyyyMMdd"];
                        //				scanData.crdate_yymmdd	= [NSString stringWithString:[formatter stringFromDate:date]];
                        //
                        //				scanData.imagename	= [NSString stringWithFormat:@"%@png", [fname substringToIndex: ([fname length] - [[fname pathExtension] length])]];
                        ////                DLog(@"%@", scanData.imagename);
                        //				scanData.index		= NULL;
                        //
                        //                //
                        //				// ファイルサイズ
                        //				//
                        //				NSString *doubleStr	= [NSString stringWithFormat:@"%@",[attr objectForKey:NSFileSize]];
                        //                NSString *byteStr = S_UNIT_BYTE;
                        //                float fSize = [doubleStr floatValue];
                        //                int    bytecnt = 0;
                        //                while (fSize > 1024) {
                        //                    fSize = fSize / 1024;
                        //                    bytecnt++;
                        //                }
                        //                switch (bytecnt) {
                        //                    case 0:
                        //                        break;
                        //                    case 1:
                        //                        byteStr = S_UNIT_KB;
                        //                        break;
                        //                    case 2:
                        //                        byteStr = S_UNIT_MB;
                        //                        break;
                        //                    default:
                        //                        byteStr = S_UNIT_GB;
                        //                        break;
                        //                }
                        //				scanData.filesize	= [NSString stringWithFormat:@"%.1f %@", fSize, byteStr];
                        //
                        //                //
                        //                // ディレクトリかファイルの判別
                        //                //
                        //                scanData.isDirectory = [CommonUtil directoryCheck:path name:fname];
                        //
                        //                //
                        //                // ファイルパスの保存
                        //                //
                        ////                scanData.fpath = tempDir;
                        //                scanData.fpath = [path stringByDeletingLastPathComponent];
                        //
                        //				//
                        //				// 登録処理
                        //				//
                        //				[self addScanData:scanDataList addScanData:scanData];
                        ////				LOG(@"scanData count[%d]", [scanData retainCount]);
                        //            }
                        if (isExtensionCheck)
                        {
                            // 位置変更
                            //
                            // ファイルやディレクトリの情報取得
                            //
                            NSString	 *path	= [tempDir stringByAppendingString:fname];
                            NSDictionary *attr	= [lFileManager attributesOfItemAtPath:path error:&err];
                            NSDate		 *date	= [attr objectForKey:NSFileModificationDate];
                            
#if 0
                            LOG(@"fname:%@", fname);
#endif
                            //
                            // scanData クラスにセット
                            //
                            ScanData *scanData	= [[ScanData alloc] init];
                            scanData.fname		= [NSString stringWithString:fileName];		// 表示名称
                            
                            //
                            // 作成日付をフォーマッタを取得して設定する
                            //
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
                            [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
                            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                            scanData.crdate			= [NSString stringWithString:[formatter stringFromDate:date]];
                            
                            [formatter setDateFormat:@"yyyyMM"];
                            scanData.crdate_yymm	= [NSString stringWithString:[formatter stringFromDate:date]];
                            
                            [formatter setDateFormat:@"yyyyMMdd"];
                            scanData.crdate_yymmdd	= [NSString stringWithString:[formatter stringFromDate:date]];
                            
                            scanData.imagename	= [NSString stringWithFormat:@"%@png", [fname substringToIndex: ([fname length] - [[fname pathExtension] length])]];
                            //                DLog(@"%@", scanData.imagename);
                            scanData.index		= NULL;
                            scanData.filesize	= [NSString stringWithFormat:@"%@",[attr objectForKey:NSFileSize]];
                            //
                            // ディレクトリかファイルの判別
                            //
                            scanData.isDirectory = [CommonUtil directoryCheck:path name:fname];
                            
                            //
                            // ファイルパスの保存
                            //
                            //                    scanData.fpath = tempDir;
                            scanData.fpath = [path stringByDeletingLastPathComponent];
                            //
                            // 登録処理
                            //
                            //                    [self addScanData:scanTempDataList addScanData:scanData];
                            [scanTempDataList addObject:scanData];
                            //				LOG(@"scanData count[%d]", [scanData retainCount]);
                        }
                        
                    }
                }
            }
            else  // not search view
            {
                //            NSMutableArray* checkList = [localFileManager contentsOfDirectoryAtPath:tempDir error:&err];
                for(fname in [localFileManager contentsOfDirectoryAtPath:tempDir error:&err])
                {
                    @autoreleasepool
                    {
                        
                        //
                        // ディレクトリ用の列挙子を取得する
                        //
                        NSFileManager *lFileManager	= [NSFileManager defaultManager];
                        NSString* fileName = nil;
                        fileName = [fname lastPathComponent];
                        
                        // ファイルやディレクトリのフルパス取得
                        NSString *directoryPath = [tempDir stringByAppendingPathComponent:fname];
                        
                        BOOL isExtensionCheck;
                        if (IsMoveView)
                        {
                            isExtensionCheck = [CommonUtil directoryCheck:directoryPath name:fileName];
                        }
                        else
                        {
                            //*TODO:Officeは対象外
                            isExtensionCheck = [CommonUtil tiffExtensionCheck:fname] ||
                            [CommonUtil jpegExtensionCheck:fname] ||
                            [CommonUtil pdfExtensionCheck:fname] ||
                            [CommonUtil pngExtensionCheck:fname] ||
                            [CommonUtil officeExtensionCheck:fname] ||
                            [CommonUtil directoryCheck:directoryPath name:fname];
                        }
                        
                        if (isExtensionCheck)
                        {
                            //
                            //                // 位置変更
                            //                //
                            //                // ファイルやディレクトリの情報取得
                            //                //
                            //                NSString	 *path	= [tempDir stringByAppendingString:fname];
                            //                NSDictionary *attr	= [lFileManager attributesOfItemAtPath:path error:&err];
                            //                NSDate		 *date	= [attr objectForKey:NSFileModificationDate];
                            //
                            //#if 0
                            //				LOG(@"fname:%@", fname);
                            //#endif
                            //				//
                            //				// scanData クラスにセット
                            //				//
                            //				ScanData *scanData	= [[ScanData alloc] init];
                            //				scanData.fname		= [NSString stringWithString:fileName];		// 表示名称
                            //
                            //				//
                            //				// 作成日付をフォーマッタを取得して設定する
                            //				//
                            //				NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
                            //
                            //				[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                            //				scanData.crdate			= [NSString stringWithString:[formatter stringFromDate:date]];
                            //
                            //				[formatter setDateFormat:@"yyyyMM"];
                            //				scanData.crdate_yymm	= [NSString stringWithString:[formatter stringFromDate:date]];
                            //
                            //                [formatter setDateFormat:@"yyyyMMdd"];
                            //				scanData.crdate_yymmdd	= [NSString stringWithString:[formatter stringFromDate:date]];
                            //
                            //				scanData.imagename	= [NSString stringWithFormat:@"%@png", [fname substringToIndex: ([fname length] - [[fname pathExtension] length])]];
                            ////                DLog(@"%@", scanData.imagename);
                            //				scanData.index		= NULL;
                            //
                            //                //
                            //				// ファイルサイズ
                            //				//
                            //				NSString *doubleStr	= [NSString stringWithFormat:@"%@",[attr objectForKey:NSFileSize]];
                            //                NSString *byteStr = S_UNIT_BYTE;
                            //                float fSize = [doubleStr floatValue];
                            //                int    bytecnt = 0;
                            //                while (fSize > 1024) {
                            //                    fSize = fSize / 1024;
                            //                    bytecnt++;
                            //                }
                            //                switch (bytecnt) {
                            //                    case 0:
                            //                        break;
                            //                    case 1:
                            //                        byteStr = S_UNIT_KB;
                            //                        break;
                            //                    case 2:
                            //                        byteStr = S_UNIT_MB;
                            //                        break;
                            //                    default:
                            //                        byteStr = S_UNIT_GB;
                            //                        break;
                            //                }
                            //				scanData.filesize	= [NSString stringWithFormat:@"%.1f %@", fSize, byteStr];
                            //
                            //                //
                            //                // ディレクトリかファイルの判別
                            //                //
                            //                scanData.isDirectory = [CommonUtil directoryCheck:path name:fname];
                            //
                            //                //
                            //                // ファイルパスの保存
                            //                //
                            //                //                scanData.fpath = tempDir;
                            //                scanData.fpath = [path stringByDeletingLastPathComponent];
                            //
                            //				//
                            //				// 登録処理
                            //				//
                            //				[self addScanData:scanDataList addScanData:scanData];
                            //                //				LOG(@"scanData count[%d]", [scanData retainCount]);
                            //            }
                            //			}
                            
                            // 位置変更
                            //
                            // ファイルやディレクトリの情報取得
                            //
                            NSString	 *path	= [tempDir stringByAppendingString:fname];
                            NSDictionary *attr	= [lFileManager attributesOfItemAtPath:path error:&err];
                            NSDate		 *date	= [attr objectForKey:NSFileModificationDate];
                            
#if 0
                            LOG(@"fname:%@", fname);
#endif
                            //
                            // scanData クラスにセット
                            //
                            ScanData *scanData	= [[ScanData alloc] init];
                            scanData.fname		= [NSString stringWithString:fname];		// 表示名称
                            
                            //
                            // 作成日付をフォーマッタを取得して設定する
                            //
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
                            [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
                            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                            scanData.crdate			= [NSString stringWithString:[formatter stringFromDate:date]];
                            
                            [formatter setDateFormat:@"yyyyMM"];
                            scanData.crdate_yymm	= [NSString stringWithString:[formatter stringFromDate:date]];
                            
                            [formatter setDateFormat:@"yyyyMMdd"];
                            scanData.crdate_yymmdd	= [NSString stringWithString:[formatter stringFromDate:date]];
                            
                            scanData.imagename	= [NSString stringWithFormat:@"%@png", [fname substringToIndex: ([fname length] - [[fname pathExtension] length])]];
                            //                DLog(@"%@", scanData.imagename);
                            scanData.index		= NULL;
                            scanData.filesize	= [NSString stringWithFormat:@"%@",[attr objectForKey:NSFileSize]];
                            //
                            // ディレクトリかファイルの判別
                            //
                            scanData.isDirectory = [CommonUtil directoryCheck:path name:fname];
                            
                            //
                            // ファイルパスの保存
                            //
                            scanData.fpath = tempDir;
                            
                            //
                            // 登録処理
                            //
                            //                    [self addScanData: scanTempDataList addScanData:scanData];
                            [scanTempDataList addObject:scanData];
                            //				LOG(@"scanData count[%d]", [scanData retainCount]);
                        }
                    }
                }
            }
            
            // 実ファイルが変更されている場合は、キャッシュを再作成しておく
            for (ScanData *scanData in scanTempDataList) {
                NSString *parentDirectory;
                if (scanData.fpath == nil) {
                    parentDirectory = [CommonUtil documentDir];
                } else {
                    parentDirectory = scanData.fpath;
                }
                NSString *targetFilePath = [parentDirectory stringByAppendingPathComponent:scanData.fname];
                
                // 実ファイルが変更されている場合は、キャッシュ再作成
                if (!scanData.isDirectory && [GeneralFileUtility isScanFilePath:targetFilePath]) {
                    ScanFile *pScanFile = [[ScanFile alloc] initWithScanFilePath:targetFilePath];
                    if ([ScanFileUtility cacheRecreateCheck:pScanFile]) {
                        [ScanFileUtility createRequiredAllImageFiles:pScanFile];
                    }
                }
            }
            //		//
            //		// index 作成
            //		//
            //		[self setIndexScanData:scanDataList];
            //
            //        // セクション番号の設定
            //		UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
            //		for (ScanData *theScanData in scanDataList)
            //		{
            //            NSInteger sectionNo = [theCollation sectionForObject:theScanData
            //                                         collationStringSelector:@selector(index)];
            //			theScanData.sectionNumber = sectionNo;
            //		}
            //
            //		NSInteger sectionCount = [[theCollation sectionTitles] count];
            //		for (int i=0; i<=sectionCount; i++)
            //		{
            //			NSMutableArray *sectionArray = [[NSMutableArray alloc] init]; // 1個作成
            //			[sectionArrays addObject:sectionArray];
            //		}
            //
            //		for (ScanData *theScanData in scanDataList)
            //		{
            //			[[sectionArrays objectAtIndex:theScanData.sectionNumber] addObject:theScanData];
            //        }
            //
            //        // ディレクトリセクションのソート
            //        // ディレクトリはあれば必ず先頭なのでIndex:0を参照する
            //        if(sectionArrays && sectionArrays.count){
            //            NSMutableArray* dirArray = [NSMutableArray arrayWithArray:[sectionArrays objectAtIndex:0]];
            //            if(dirArray && dirArray.count){
            //                // 先頭のデータがディレクトリかチェックする
            //                ScanData* sd = [dirArray objectAtIndex:0];
            //                if(sd && sd.isDirectory){
            //                    // 五十音順でソートする
            //                    dirArray = [NSMutableArray arrayWithArray:[dirArray sortedArrayUsingFunction:sortDirectry context:nil]];
            //                    [sectionArrays replaceObjectAtIndex:0 withObject:dirArray];
            //                }
            //            }
            //        }
            //
            //        //[[sectionArrays objectAtIndex:0] addObject:theScanData];
            //		return [sectionArrays retain];
            //
            //    }
            //    @finally
            //	{
            //        }
            //    }
            //    return nil; // will be never reached
            
            //
            // (3) index を作成する(フォルダーがある場合は最初に配置される)
            //
            [self setIndexScanData: scanTempDataList];
            
            ////
            // (4) ここから,セクション分け
            ////
            // 各scanDataにセクション番号を設定する
            for (ScanData *theScanData in scanTempDataList)
            {
                NSInteger sectionNo = [m_indexList indexOfObject:theScanData.index];
                if (sectionNo != NSNotFound) {
                    theScanData.sectionNumber = sectionNo;
                }
            }
            
            // セクションごとにscanDataの配列を作成する
            for (int i = 0; i <= m_indexList.count; i++)
            {
                NSMutableArray *sectionArray = [[NSMutableArray alloc] init]; // 1個作成
                [sectionArrays addObject:sectionArray];
            }
            
            // 各scanDataをセクションの配列に振り分ける
            for (ScanData *theScanData in scanTempDataList)
            {
                [[sectionArrays objectAtIndex:theScanData.sectionNumber] addObject:theScanData];
            }
            for (NSMutableArray* section in sectionArrays)
            {
                if([CommonUtil scanDataSortDirectionType] == SCANDATA_ASC)
                {
                    switch ([CommonUtil scanDataSortType]) {
                            //                    case SCANDATA_FILEDATE:
                            //                        [section sortUsingComparator: ^(ScanData *a, ScanData *b){return [b.crdate localizedCaseInsensitiveCompare: a.crdate];}];
                            //                        break;
                            //                    case SCANDATA_FILENAME:
                            //                        [section sortUsingComparator: ^(ScanData *a, ScanData *b){return [b.fname localizedCaseInsensitiveCompare: a.fname];}];
                            //                    break;
                            //                    case SCANDATA_FILESIZE:
                            //                        [section sortUsingComparator: ^(ScanData *a, ScanData *b){return [b.filesize intValue] > [a.filesize intValue];}];
                            //                    break;
                        case SCANDATA_FILETYPE: //sort by filename
                            [section sortUsingComparator: ^(ScanData *a, ScanData *b){return [a.fname localizedCaseInsensitiveCompare: b.fname];}];
                        default:
                            break;
                    }
                }
                else
                {
                    switch ([CommonUtil scanDataSortType]) {
                            //                    case SCANDATA_FILEDATE:
                            //                        [section sortUsingComparator: ^(ScanData *a, ScanData *b){return [a.crdate compare: b.crdate options:nil];}];
                            //                        break;
                            //                    case SCANDATA_FILENAME:
                            //                        [section sortUsingComparator: ^(ScanData *a, ScanData *b){return [a.fname compare: b.fname options:nil];}];
                            //                        break;
                            //                    case SCANDATA_FILESIZE:
                            //                        [section sortUsingComparator: ^(ScanData *a, ScanData *b){return [a.filesize intValue] > [b.filesize intValue];}];
                            //                        break;
                        case SCANDATA_FILETYPE: //sort by filename
                            [section sortUsingComparator: ^(ScanData *a, ScanData *b){return [b.fname localizedCaseInsensitiveCompare: a.fname];}];
                        default:
                            break;
                    }
                }
            }
            
            
            //[[sectionArrays objectAtIndex:0] addObject:theScanData];
            
            // (5) セクション分けされた配列を返す
            return sectionArrays;
            
        }
        @finally
        {
        }
    }
    return nil; // will be never reached
}
/*
 //
 // スキャンデータの読み込み
 //
 - (NSMutableArray *)getScanData
 {
 LOG_METHOD;
 
 @autoreleasepool
 {
 @try {
 //
 // ディレクトリ以下のファイルやディレクトリを順番に取得する
 //
 NSString *fullDirPath = self.fullPath;
 //        DLog(@"%@",fullDirPath);
 
 NSString		*tempDir;
 if(fullDirPath == nil)
 {
 tempDir		= [self.baseDir stringByAppendingString:@"/"];
 }
 else
 {
 tempDir		= [NSString stringWithFormat:@"%@/",fullDirPath];
 }
 NSError			*err			= nil;
 NSMutableArray	*sectionArrays	= [[NSMutableArray array] init];
 //        DLog(@"ディレクトリパス:%@¥n", tempDir );
 
 //
 // ディレクトリ用の列挙子を取得する
 //
 //		NSFileManager *localFileManager	= [[NSFileManager alloc] init];
 NSFileManager *localFileManager	= [NSFileManager defaultManager];
 
 // サブディレクトリを検索する為、コメントアウト
 //NSDirectoryEnumerator *dirEnum	= [localFileManager enumeratorAtPath:tempDir];
 
 NSString *fname;
 // サブディレクトリを検索する為、コメントアウト
 //while (fname = [dirEnum nextObject])
 //        for(fname in [localFileManager contentsOfDirectoryAtPath:tempDir error:&err])
 for(fname in [localFileManager subpathsOfDirectoryAtPath:tempDir error:&err])
 {
 @autoreleasepool
 {
 
 //
 // ディレクトリ用の列挙子を取得する
 //
 NSFileManager *lFileManager	= [NSFileManager defaultManager];
 //
 // .pdf ファイルの読み込み
 //
 DLog(@"fname = %@",fname);
 
 // ファイルやディレクトリのフルパス取得
 NSString *directoryPath = [tempDir stringByAppendingPathComponent:fname];
 
 BOOL isExtensionCheck;
 if (IsMoveView)
 {
 isExtensionCheck = [CommonUtil directoryCheck:directoryPath name:fname];
 }else
 {
 isExtensionCheck = [CommonUtil tiffExtensionCheck:fname] || [CommonUtil jpegExtensionCheck:fname] || [CommonUtil pdfExtensionCheck:fname] ||
 [CommonUtil directoryCheck:directoryPath name:fname];
 }
 
 if (isExtensionCheck)
 {
 
 // 位置変更
 //
 // ファイルやディレクトリの情報取得
 //
 NSString	 *path	= [tempDir stringByAppendingString:fname];
 NSDictionary *attr	= [lFileManager attributesOfItemAtPath:path error:&err];
 NSDate		 *date	= [attr objectForKey:NSFileModificationDate];
 
 #if 0
 LOG(@"fname:%@", fname);
 #endif
 //
 // scanData クラスにセット
 //
 ScanData *scanData	= [[ScanData alloc] init];
 scanData.fname		= [NSString stringWithString:fname];		// 表示名称
 
 //
 // 作成日付をフォーマッタを取得して設定する
 //
 NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
 
 [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
 scanData.crdate			= [NSString stringWithString:[formatter stringFromDate:date]];
 
 [formatter setDateFormat:@"yyyyMM"];
 scanData.crdate_yymm	= [NSString stringWithString:[formatter stringFromDate:date]];
 
 [formatter setDateFormat:@"yyyyMMdd"];
 scanData.crdate_yymmdd	= [NSString stringWithString:[formatter stringFromDate:date]];
 
 scanData.imagename	= [NSString stringWithFormat:@"%@png", [fname substringToIndex: ([fname length] - [[fname pathExtension] length])]];
 //                DLog(@"%@", scanData.imagename);
 scanData.index		= NULL;
 
 //
 // ファイルサイズ
 //
 NSString *doubleStr	= [NSString stringWithFormat:@"%@",[attr objectForKey:NSFileSize]];
 NSString *byteStr = S_UNIT_BYTE;
 float fSize = [doubleStr floatValue];
 int    bytecnt = 0;
 while (fSize > 1024) {
 fSize = fSize / 1024;
 bytecnt++;
 }
 switch (bytecnt) {
 case 0:
 break;
 case 1:
 byteStr = S_UNIT_KB;
 break;
 case 2:
 byteStr = S_UNIT_MB;
 break;
 default:
 byteStr = S_UNIT_GB;
 break;
 }
 scanData.filesize	= [NSString stringWithFormat:@"%.1f %@", fSize, byteStr];
 
 //
 // ディレクトリかファイルの判別
 //
 scanData.isDirectory = [CommonUtil directoryCheck:path name:fname];
 
 //
 // ファイルパスの保存
 //
 scanData.fpath = tempDir;
 
 //
 // 登録処理
 //
 [self addScanData:scanDataList addScanData:scanData];
 //				LOG(@"scanData count[%d]", [scanData retainCount]);
 }
 }
 }
 
 //
 // index 作成
 //
 [self setIndexScanData:scanDataList];
 
 // セクション番号の設定
 UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
 for (ScanData *theScanData in scanDataList)
 {
 NSInteger sectionNo = [theCollation sectionForObject:theScanData
 collationStringSelector:@selector(index)];
 theScanData.sectionNumber = sectionNo;
 }
 
 NSInteger sectionCount = [[theCollation sectionTitles] count];
 for (int i=0; i<=sectionCount; i++)
 {
 NSMutableArray *sectionArray = [[NSMutableArray alloc] init]; // 1個作成
 [sectionArrays addObject:sectionArray];
 }
 
 for (ScanData *theScanData in scanDataList)
 {
 [[sectionArrays objectAtIndex:theScanData.sectionNumber] addObject:theScanData];
 }
 
 // ディレクトリセクションのソート
 // ディレクトリはあれば必ず先頭なのでIndex:0を参照する
 if(sectionArrays && sectionArrays.count){
 NSMutableArray* dirArray = [NSMutableArray arrayWithArray:[sectionArrays objectAtIndex:0]];
 if(dirArray && dirArray.count){
 // 先頭のデータがディレクトリかチェックする
 ScanData* sd = [dirArray objectAtIndex:0];
 if(sd && sd.isDirectory){
 // 五十音順でソートする
 dirArray = [NSMutableArray arrayWithArray:[dirArray sortedArrayUsingFunction:sortDirectry context:nil]];
 [sectionArrays replaceObjectAtIndex:0 withObject:dirArray];
 }
 }
 }
 
 //[[sectionArrays objectAtIndex:0] addObject:theScanData];
 return [sectionArrays retain];
 
 }
 @finally
 {
 }
 }
 return nil; // will be never reached
 }
 */
// 指定したセクションの ScanDataクラスを取り出す
- (NSMutableArray *)loadScanDataAtSection:(NSUInteger)section
{
	//TRACE(@"section[%d]", section);
    
    return [ScanDataList objectAtIndex:section];
}

// 同じ名前のディレクトリ名があるかチェックする
- (BOOL)checkFolderData:(NSString*)dirName
{
    
    //    for (ScanData *theScanData in ScanDataList)
    for (ScanData *theScanData in scanTempDataList)
    {
        if([theScanData.fname isEqualToString:dirName])
        {
            return NO;
        }
    }
    
    return YES;
}

//
// ScanDataクラスの検索結果の数を戻す
//
- (NSUInteger)countOfSearchScanData
{
    //    [filteredList removeAllObjects];		// 削除
    //    for (ScanData *theScanData in scanTempDataList)
    //	{
    //        [filteredList addObject: theScanData];            
    //    }
    //    return [filteredList count];
    return [scanTempDataList count];
}

- (NSIndexPath*) indexOfScanDataWithFilePath: (NSString*)fileFullPath;
{
    NSArray* sDataList;
    ScanData* sData;
    
    DLog(@"in pfile %@", fileFullPath);
    
    for (int section=0; section < [ScanDataList count]; section++)
    {
        sDataList = [ScanDataList objectAtIndex: section];
        if(sDataList != nil)
        {
            for (int row=0; row < [sDataList count]; row++)
            {
                sData = [sDataList objectAtIndex:row];
                //                    DLog(@"at path %@", fileFullPath);
                //                    DLog(@"at path %@{%@}", sData.fpath, sData.fname);
                //                    DLog(@"session %d, row %d", section, row);
                if([[sData.fpath stringByAppendingPathComponent:sData.fname] isEqualToString: fileFullPath])
                {
                    return [NSIndexPath indexPathForRow:row inSection: section];
                }
            }
        }
    }
    DLog(@" index is nil");
    return nil;
}

- (NSString*) filePathAtIndexPath: (NSIndexPath *)indexPath;
{
    return [[[self loadScanDataAtIndexPath: indexPath] fpath] stringByAppendingPathComponent:[[self loadScanDataAtIndexPath: indexPath] fname]];
}


//#pragma mark Seasrch Manager
////
//// 指定した文字に一致する ScanDataクラスを取り出す
////
//- (void)loadFillterData:(NSString*)searchText
//{
//	//TRACE(@"indexPath[%@]", indexPath);
//    
//    [filteredList removeAllObjects];		// 削除
//    NSRange searchResult;
//	for (ScanData *theScanData in scanDataList)
//	{
//        searchResult = [theScanData.fname rangeOfString:searchText];
//        if(searchResult.location != NSNotFound)
//        {
//            [filteredList addObject:theScanData];            
//        }
//    }
//}
//
/* 未使用のためコメントアウト
 //
 //
 //
 - (void)filterDataForSearch:(NSString*)searchText scope:(NSString*)scope
 {
 LOG_METHOD;
 
 unsigned i = 0;
 NSComparisonResult	result = 0;
 
 [filteredList removeAllObjects];		// 削除
 for (ScanData *theScanData in scanDataList)
 {
 
 if ([scope isEqualToString:@"ファイル名"])
 {
 result = [theScanData.fname compare:searchText 
 options:(NSCaseInsensitiveSearch|NSWidthInsensitiveSearch)
 range:NSMakeRange(0, [searchText length])];
 
 }
 else if ([scope isEqualToString:@"年月日"])
 {
 result = [theScanData.crdate_yymmdd compare:searchText 
 options:(NSCaseInsensitiveSearch|NSWidthInsensitiveSearch)
 range:NSMakeRange(0, [searchText length])];
 
 }
 
 if (result == NSOrderedSame)
 {
 [filteredList addObject:theScanData];
 }
 i++;
 }
 }
 
 //
 // (検索用)指定したインデックスの ScanDataクラスを取り出す
 //
 - (ScanData *) loadfilterDataAtIndex: (NSUInteger)index
 {
 //TRACE(@"index[%d]", index);
 
 if (index < [filteredList count])
 {
 return [filteredList objectAtIndex: index];
 }
 
 return nil;
 }
 
 //
 // (検索用)指定したインデックスの ScanData クラスを置き換える
 //
 - (BOOL) replaceFilterDataAtIndex:(NSUInteger)index newObject:(ScanData *)newObject
 {
 //TRACE(@"index[%d]", index);
 
 if (index > [filteredList count])
 {
 return FALSE;
 }
 
 [filteredList replaceObjectAtIndex:index withObject:newObject];
 
 return TRUE;
 }
 
 //
 // (検索用)指定したインデックスの ScanDataクラスを削除
 //
 - (BOOL)removefilterAtIndex:(NSUInteger)index
 {
 //TRACE(@"index[%d]", index);
 
 @autoreleasepool
 {
 @try {
 //
 // ScanDataクラス配列(Filter) 削除
 //
 if (index > [filteredList count])
 {
 return FALSE;
 }
 
 NSString *strName	= [[filteredList objectAtIndex: index] fname];
 
 [filteredList removeObjectAtIndex:index];
 
 //
 // ScanDataクラス配列(temp)
 //
 for (int i = 0; i < [scanDataList count]; i++) 
 {
 ScanData *theScanData = [scanDataList objectAtIndex:i];
 
 NSComparisonResult res	= [strName compare:theScanData.fname];
 if (res == NSOrderedSame )
 {
 [scanDataList removeObjectAtIndex:i];
 break;
 }
 }
 
 //
 // ScanDataクラス配列
 //
 for (NSMutableArray *sectionArray in ScanDataList)
 {
 for (int i = 0; i < [sectionArray count]; i++) 
 {
 ScanData *theScanData = [sectionArray objectAtIndex:i];
 LOG(@"theScanData [%d][%@]", i, [theScanData fname]);
 
 NSComparisonResult res	= [strName compare:theScanData.fname];
 if (res == NSOrderedSame )
 {
 [sectionArray removeObjectAtIndex:(NSUInteger)i];
 break;
 }
 }
 }
 return TRUE;
 }
 @finally
 {
 }
 }
 }
 
 //
 // (検索用)filteredListクラスの要素数を戻す
 //
 - (NSUInteger)countOffilterData
 {
 return [filteredList count];
 }
 */
@end
