#import "AttachmentDataManager.h"
#import "CommonUtil.h"
#import "CommonManager.h"
#import "Define.h"


@implementation AttachmentDataManager

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize		baseDir;							// ホームディレクトリ/Documments/
//@synthesize		tView;                              // ファイル選択画面のTableView
@synthesize     fullPath = m_fullPath;
@synthesize     IsMoveView;                         // 移動する画面

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
    
	self.baseDir = [CommonUtil tmpAttachmentDir];
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
- (AttachmentData *)loadScanDataAtIndexPath:(NSIndexPath *)indexPath
{
	TRACE(@"indexPath[%@]", indexPath);
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
	TRACE(@"indexPath[%@]", indexPath);
    
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
- (BOOL)addScanData:(NSMutableArray *)collectionData addScanData:(AttachmentData *)addScanData
{
	unsigned i;
    
    @autoreleasepool
    {
        
        if( [collectionData count] == 0)
        {
            TRACE(@"fnam[%@]crdate[%@]crdate_yymm[%@]", addScanData.fname, addScanData.crdate, addScanData.crdate_yymm);
            [collectionData addObject:addScanData];
        }
        else
        {
            i = 0;
            for (AttachmentData *theScanData in collectionData)
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
            TRACE(@"fnam[%@]crdate[%@]crdate_yymm[%@] (%d)", addScanData.fname, addScanData.crdate, addScanData.crdate_yymm,i);
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
        for (AttachmentData *theScanData in scanDataLists)
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
                [dirLists sortUsingComparator: ^(AttachmentData *a, AttachmentData *b){return [a.fname localizedCaseInsensitiveCompare: b.fname];}];
            }
            else
            {
                [dirLists sortUsingComparator: ^(AttachmentData *a, AttachmentData *b){return [b.fname localizedCaseInsensitiveCompare: a.fname];}];
            }
        }
        
        // (3) ディレクトリー以外を名前順でデータをソートする
        [dataLists sortUsingComparator: ^(AttachmentData *a, AttachmentData *b){return [a.fname localizedCaseInsensitiveCompare: b.fname];}];
        
        // (4) ディレクトリーのインデクスを設定し、名前順で並べ替える
        if(directoryExists)
        {
            for (AttachmentData *theScanData in dirLists)
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
        for (AttachmentData *theScanData in dataLists)
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
            TRACE(@"[%@][%@][%@][%@]", theScanData.crdate_yymm, theScanData.crdate, theScanData.fname, theScanData.index );
#endif
            
        }
        // (6)ディレクトリーをマージする
        [scanDataLists removeAllObjects];
        if (directoryExists) {
            [scanDataLists addObjectsFromArray:dirLists];
            //numberOfSecition++;
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
    @try {
        @autoreleasepool
        {
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
            
            NSString *fname;
            
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
                        isExtensionCheck = [CommonUtil tiffExtensionCheck:fname] ||
                        [CommonUtil jpegExtensionCheck:fname] ||
                        [CommonUtil pdfExtensionCheck:fname] ||
                        [CommonUtil pngExtensionCheck:fname] ||
                        [CommonUtil officeExtensionCheck:fileName]||
                        [CommonUtil directoryCheck:directoryPath name:fname] ||
                        [fname hasSuffix:@".zip"];
                    }
                    
                    if (isExtensionCheck) {
                        // 除外フォルダチェック(Cache-フォルダやDIRZIP-フォルダーは除外対象)
                        if ([CommonUtil exclusionDirectoryCheck:directoryPath name:fname]) {
                            isExtensionCheck = NO;
                        }
                    }
                    
                    if (isExtensionCheck)
                    {
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
                        // AttachmentData クラスにセット
                        //
                        AttachmentData *scanData	= [[AttachmentData alloc] init];
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
                        
                        if ([fname hasSuffix:@".zip"]) {
                            scanData.isDirectory = YES;
                        }
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
            
            //
            // (3) index を作成する(フォルダーがある場合は最初に配置される)
            //
            [self setIndexScanData: scanTempDataList];
            
            ////
            // (4) ここから,セクション分け
            ////
            // 各scanDataにセクション番号を設定する
            for (AttachmentData *theScanData in scanTempDataList)
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
            for (AttachmentData *theScanData in scanTempDataList)
            {
                [[sectionArrays objectAtIndex:theScanData.sectionNumber] addObject:theScanData];
            }
            
            // (5) セクション分けされた配列を返す
            return sectionArrays;
            
        }
    }
    @finally
	{
    }
    return nil; // will be never reached
}

// 指定したセクションの ScanDataクラスを取り出す
- (NSMutableArray *)loadScanDataAtSection:(NSUInteger)section
{
	TRACE(@"section[%zd]", section);
    
    return [ScanDataList objectAtIndex:section];
}

// 同じ名前のディレクトリ名があるかチェックする
- (BOOL)checkFolderData:(NSString*)dirName
{
    
    //    for (ScanData *theScanData in ScanDataList)
    for (AttachmentData *theScanData in scanTempDataList)
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
    AttachmentData* sData;
    
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

@end
