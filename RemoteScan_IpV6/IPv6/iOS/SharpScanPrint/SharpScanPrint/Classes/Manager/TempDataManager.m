//#import "CommonManager.h"
#import "TempDataManager.h"
#import "CommonUtil.h"
#import "GeneralFileUtility.h"

//
// 静的変数（クラス変数）の定義
//

@implementation TempDataManager

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
//@synthesize		TempDataList;						// TempDataクラス配列
//@synthesize		filteredList;						// TempDataクラス配列(Filter)
@synthesize		atempDataList;						// TempDataクラス配列(temp)
@synthesize		baseDir;							// ホームディレクトリ/Documments/
@synthesize		TempIndex;							// Index.plist のカレントIndex値
//@synthesize		tView;								// SecondViewController内のTableView
@synthesize     fullPath;
@synthesize     saveFileName;


#pragma mark -
#pragma mark class method


#pragma mark -
#pragma mark TempDataManager delegete

//
// イニシャライザ定義
//
- (id)init:(NSString*)directory
{
	LOG_METHOD;
	
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
	//
	// ホームディレクトリ/Documments の取得
	//
	self.baseDir = directory;
	//
	// スキャンデータの取得
	//
    //	filteredList	= [[NSMutableArray alloc] init];	// 初期化
	atempDataList	= [[NSMutableArray alloc] init];	// 初期化
	TempDataList	= [self getTempData];
    
    return self;
}
- (id)init
{
    return [self init:[CommonUtil tmpDir]];
}
//
// アプリケーションの終了直前に呼ばれるメソッド
//
- (void)dealloc
{
	LOG_METHOD;
    
    [TempDataList removeAllObjects];
    
    // 親クラスの解放処理を呼び出す
}


#pragma mark -
#pragma mark TempData Manager

//
// スキャンデータの再読み込み
//
- (void)reGetTempData
{
	[atempDataList removeAllObjects];
    //	[TempDataList removeAllObjects];
	
    TempDataList	= [self getTempData];
	
}

//
// 指定したインデックスの TempDataクラスを取り出す
//
- (TempData *)loadTempDataAtIndexPath:(NSIndexPath *)indexPath
{
	TRACE(@"indexPath[%@]", indexPath);
    DLog(@"TempDataList:%@",TempDataList);
    if (indexPath.row < [[TempDataList objectAtIndex: indexPath.section] count])
	{
        return [[TempDataList objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
    }
    
	return nil;
}

//
// 指定したインデックスの TempDataクラスを削除
//
- (BOOL)removeAtIndex:(NSIndexPath *)indexPath
{
	TRACE(@"indexPath[%@]", indexPath);
    
    if (indexPath.row > [[TempDataList objectAtIndex: indexPath.section] count])
	{
        return FALSE;
    }
	
	[[TempDataList objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
    
    return TRUE;
}

//
// 指定したファイルの削除
//
- (BOOL)removeFile
{
    
	BOOL ret = YES;
	
	NSFileManager	*fileManager	= [NSFileManager defaultManager];
	
    NSString* path	=[CommonUtil tmpDir];
    
	if ([fileManager removeItemAtPath:path error:NULL] != YES)
	{
		LOG(@"[common]removeFile:Error[%@]", path);
		ret = NO;
	}
    
	return ret;
}


//
// TempDataクラスの要素数を戻す
//
- (NSUInteger)countOfTempData
{
    return [TempDataList count];
}

//
// TempDataクラスの登録処理
//
- (BOOL)addTempData:(NSMutableArray *)collectionData addTempData:(TempData *)addTempData
{
	unsigned i;
    
	@autoreleasepool
    {
        
        if( [collectionData count] == 0)
        {
            [collectionData addObject:addTempData];
        }
        else
        {
            i = 0;
            for (TempData *theTempData in collectionData)
            {
                NSComparisonResult res= [theTempData.crdate compare:addTempData.crdate];
                if (res == NSOrderedSame )
                {
                    [collectionData insertObject:addTempData atIndex:i];		// 追加
                    break;
                }
                
                else if (res == NSOrderedAscending)
                {
                    [collectionData insertObject:addTempData atIndex:i];		// 追加
                    break;
                }
                
                else if (res== NSOrderedDescending)
                {
                    // theTempData.crdate > addTempData.crdate
                    
                }
                i++;
            }
            if (i >= [collectionData count])
            {
                [collectionData insertObject:addTempData atIndex:i];			// 追加
            }
        }
	}
    
	return YES;
}

//
// index設定処理
//
- (BOOL)setIndexTempData:(NSMutableArray *)tempDataLists
{
	@autoreleasepool
    {
        
        //NSString	*createDate	= [NSString stringWithString:@"000000000000"];
        NSUInteger	option	= 0;
        
        //
        // プロパティリストの読み込み
        //
        NSString *dataPath	= [[NSBundle mainBundle] pathForResource:@"Index" ofType:@"plist"];
        NSArray  *data;
        data				= [NSArray arrayWithContentsOfFile:dataPath];
        self.TempIndex			= 0;
        for (TempData *theTempData in tempDataLists)
        {
            // index値を返す(a ～ z)
            // (index用プロパティリストを読み込み、指定された option に従いindex値を返す)
            // option: 0:カレントのindex値 / 1:次のindex値
            if (self.TempIndex <= [data count])
            {
                self.TempIndex += option;
                id item = [[data objectAtIndex:TempIndex] substringToIndex:1];
                theTempData.index =  [NSString stringWithString:item];
            }
            else
            {
                theTempData.index = @"z";
            }
#if 0
            TRACE(@"[%@][%@][%@][%@]", theTempData.crdate_yymm, theTempData.crdate, theTempData.fname, theTempData.index );
#endif
        }
	}
    
	return YES;
}

//
// スキャンデータの読み込み
//
- (NSMutableArray *)getTempData
{
	LOG_METHOD;
	
    @autoreleasepool
    {
        @try {
            //
            // ディレクトリ以下のファイルやディレクトリを順番に取得する
            //
            NSString		*tempDir		= [self.baseDir stringByAppendingString:@"/"];
            NSError			*err			= nil;
            NSMutableArray	*sectionArrays	= [[NSMutableArray array] init];
            
            //
            // ディレクトリ用の列挙子を取得する
            //
            //
            NSFileManager *localFileManager	= [NSFileManager defaultManager];
            //		NSDirectoryEnumerator *dirEnum	= [localFileManager enumeratorAtPath:tempDir];
            
            
            
            //		NSString *fname;
            //		while (fname = [dirEnum nextObject])
            DLog(@"ファイルリスト:%@",[localFileManager contentsOfDirectoryAtPath:tempDir error:NULL]);
            for (NSString *fname in [localFileManager contentsOfDirectoryAtPath:tempDir error:NULL])
            {
                
                @autoreleasepool
                {
                    
                    //
                    // ディレクトリ用の列挙子を取得する
                    //
                    NSFileManager *lFileManager	= [NSFileManager defaultManager];
                    
                    //
                    // ファイルやディレクトリの情報取得
                    //
                    NSString	 *path	= [tempDir stringByAppendingString:fname];
                    NSDictionary *attr	= [lFileManager attributesOfItemAtPath:path error:&err];
                    NSDate		 *date	= [attr objectForKey:NSFileModificationDate];
                    
                    
                    //
                    // .pdf.jpg.tif.png/Office ファイルの読み込み
                    //
                    if ([CommonUtil tiffExtensionCheck:fname] || [CommonUtil jpegExtensionCheck:fname] || [CommonUtil pdfExtensionCheck:fname] || [CommonUtil pngExtensionCheck:fname] || [CommonUtil officeExtensionCheck:fname])
                    {
                        //
                        // scanData クラスにセット
                        //
                        TempData *scanData	= [[TempData alloc] init];
                        scanData.fname		= [NSString stringWithString:fname];		// 表示名称
                        
                        //
                        // 作成日付をフォーマッタを取得して設定する
                        //
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        
                        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                        scanData.crdate			= [NSString stringWithString:[formatter stringFromDate:date]];
                        
                        
                        scanData.imagename	= [NSString stringWithFormat:@"%@png", [fname substringToIndex: ([fname length] -[[fname pathExtension] length])]];
                        scanData.index		= NULL;
                        
                        //
                        // 登録処理
                        //
                        [self addTempData:atempDataList addTempData:scanData];
                    }
                }
            }
            
            
            //
            // index 作成
            //
            [self setIndexTempData:atempDataList];
            for (TempData *theScanData in atempDataList)
            {
                NSMutableArray *sectionArray = [[NSMutableArray alloc] init]; // 1個作成
                [sectionArrays addObject:sectionArray];
                
                [[sectionArrays objectAtIndex:theScanData.sectionNumber] addObject:theScanData];
            }
            
            //[[sectionArrays objectAtIndex:0] addObject:theScanData];
            return sectionArrays;
            
#if 0
            LOG(@"sectionArray count[%d]", [sectionArrays count]);
            
            for (NSUInteger index = 0; index < [sectionArrays count]; index++)
            {
                NSMutableArray *sectionArray = [sectionArrays objectAtIndex:index];
                if ([sectionArray count] == 0)
                {
                    [sectionArrays removeObjectAtIndex:(NSUInteger)index];
                }
                else
                {
                    LOG(@"sectionArray count[%d]", [sectionArray count]);
                    for (ScanData *theScanData in sectionArray)
                    {
                        TRACE(@"[%@]", [theScanData fname]);
                    }
                    LOG(@"======");
                }
                index++;
            }
#endif
            
#if 0
            //
            // クラスの削除ができないので独自にソートを実装
            // addScanData(登録処理時にソートして登録)
            //
            for (NSMutableArray *sectionArray in sectionArrays)
            {
                NSMutableArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray
                                                           collationStringSelector:@selector(crdate)];
                [DataLists addObject:sortedSection];
            }
            
            return DataLists;
#endif
        }
        @finally
        {
        }
    }
    return nil; // will be never reached
}

// 一時保存から保存フォルダへ移動
- (BOOL)moveTempData
{
    /*	@autoreleasepool
     {
     
     //
     // ディレクトリ以下のファイルやディレクトリを順番に取得する
     //
     NSString		*tempDir		= [self.baseDir stringByAppendingString:@"/"];
     NSString        *scanDir        = [[CommonUtil documentDir] stringByAppendingString:@"/"];
     BOOL            ret = TRUE;
     //
     // ディレクトリ用の列挙子を取得する
     //
     //
     for (TempData *theTempData in atempDataList)
     {
     NSString *fname = theTempData.fname;
     NSString *imageName = theTempData.imagename;
     //
     // ファイルやディレクトリの情報取得
     //
     NSString	 *filePath	= [tempDir stringByAppendingString:fname];
     NSString    *imagePath  = [[CommonUtil tmpDir] stringByAppendingPathComponent:[CommonUtil thumbnailPath:fname]];
     NSString     *targetFilePath =[scanDir stringByAppendingString:fname];
     NSString     *targetImagePath = [scanDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:fname]];
     
     // ファイル移動
     NSFileManager *fManager = [NSFileManager defaultManager];
     
     if([fManager fileExistsAtPath:targetFilePath])
     {
     
     ret = FALSE;
     break;
     }
     [fManager moveItemAtPath:filePath toPath:targetFilePath error:nil];
     [fManager moveItemAtPath:imagePath toPath:targetImagePath error:nil];
     
     }
     if(!ret)
     {
     // ロールバック処理
     for (TempData *theTempData in atempDataList)
     {
     NSString *fname = theTempData.fname;
     NSString *imageName = theTempData.imagename;
     //
     // ファイルやディレクトリの情報取得
     //
     NSString	 *filePath	= [scanDir stringByAppendingString:fname];
     NSString     *imagePath = [scanDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:fname]];
     NSString     *targetFilePath =[tempDir stringByAppendingString:fname];
     NSString     *targetImagePath = [[CommonUtil tmpDir] stringByAppendingPathComponent:[CommonUtil thumbnailPath:fname]];
     
     // ファイル移動
     NSFileManager *fManager = [NSFileManager defaultManager];
     [fManager moveItemAtPath:filePath toPath:targetFilePath error:nil];
     [fManager moveItemAtPath:imagePath toPath:targetImagePath error:nil];
     }
     return NO;
     }
     
     
     }
     
     return YES;
     */
    return [self controlTempData:YES];
}

// 一時保存から保存フォルダへコピー
- (BOOL)copyTempData
{
    return [self controlTempData:NO];
}

// 一時保存と保存フォルダ間のファイル操作
- (BOOL)controlTempData:(BOOL)isMove
{
	@autoreleasepool
    {
        
        //
        // ディレクトリ以下のファイルやディレクトリを順番に取得する
        //
        NSString		*tempDir		= [self.baseDir stringByAppendingString:@"/"];//Documents/TempFile/
        NSString        *scanDir;
        
        NSString *fullDirPath = self.fullPath;
        if (fullDirPath == nil || [fullDirPath isEqualToString:@""])
        {
            scanDir = [[CommonUtil documentDir] stringByAppendingString:@"/"];//Documents/ScanFile/
        }
        else
        {
//            [CommonUtil pngDir:fullDirPath];
            scanDir = [fullDirPath stringByAppendingString:@"/"];
        }
        
        // ファイル名でソートする
        [atempDataList sortUsingComparator:^NSComparisonResult(TempData* obj1, TempData* obj2) {
            return [obj1.fname compare:obj2.fname];
        }];
        
        int nSequence = 0;
        TempData* aData = [atempDataList objectAtIndex:0];
        
        // ファイル名変更の有無をチェック
        if(saveFileName){
            NSString* checkFname = [[saveFileName stringByDeletingPathExtension] stringByAppendingPathExtension:[aData.fname pathExtension]];
            if([checkFname isEqualToString:aData.fname]){
                // 変更なし
                nSequence = 0;
                saveFileName = nil;
            }
            else
            {
                // 連番判定
                NSArray* splits = [[aData.fname stringByDeletingPathExtension] componentsSeparatedByString:@"_"];
                // 最初のファイル名の最後が"_数字"になっているか
                if(atempDataList.count > 1 &&
                   splits.count > 1 &&
                   [[splits lastObject] intValue] > 0){
                    // "_001"か
                    if([[splits lastObject] isEqualToString:@"001"])
                    {
                        // 連番ファイル名と判定
                        nSequence = 1;
                    }
                }
            }
        }
        
        BOOL            ret = TRUE;
        //
        // ディレクトリ用の列挙子を取得する
        //
        //
        for (TempData *theTempData in atempDataList)
        {
            NSString *fname = theTempData.fname;
            NSString *imageName = theTempData.imagename;
            
            if(saveFileName){
                fname = [[saveFileName stringByDeletingPathExtension] stringByAppendingPathExtension:[theTempData.fname pathExtension]];
                imageName = [[saveFileName stringByDeletingPathExtension] stringByAppendingPathExtension:[theTempData.imagename pathExtension]];
                
            }else{
                if(nSequence){
                    // 連番部分を削除
                    NSString* ext = [fname pathExtension];
                    NSMutableArray* splitFname = [NSMutableArray arrayWithArray:[[fname stringByDeletingPathExtension] componentsSeparatedByString:@"_"]];
                    [splitFname removeLastObject];
                    fname = [splitFname objectAtIndex:0];
                    [splitFname removeObjectAtIndex:0];
                    for(NSString* p in splitFname){
                        fname = [NSString stringWithFormat:@"%@_%@", fname , p];
                    }
                    fname = [fname stringByAppendingPathExtension:ext];
                    
                    ext = [imageName pathExtension];
                    splitFname = [NSMutableArray arrayWithArray:[[imageName stringByDeletingPathExtension] componentsSeparatedByString:@"_"]];
                    [splitFname removeLastObject];
                    imageName = [splitFname objectAtIndex:0];
                    [splitFname removeObjectAtIndex:0];
                    for(NSString* p in splitFname){
                        imageName = [NSString stringWithFormat:@"%@_%@", imageName , p];
                    }
                    imageName = [imageName stringByAppendingPathExtension:ext];
                    
                }
            }
            
            // 連番を付与
            if (nSequence) {
                fname = [NSString stringWithFormat:@"%@_%03d.%@",
                         [fname stringByDeletingPathExtension],
                         nSequence,
                         [fname pathExtension]];
                imageName = [NSString stringWithFormat:@"%@_%03d.%@",
                             [imageName stringByDeletingPathExtension],
                             nSequence,
                             [imageName pathExtension]];
                nSequence++;
            }
            
            NSString *targetFilePath =[scanDir stringByAppendingString:fname];
            
            NSString *orgFname = fname;
            NSString *orgImageName = imageName;
            
            // ファイル移動
            NSFileManager *fManager = [NSFileManager defaultManager];
            
            // ファイル存在確認
            if([fManager fileExistsAtPath:targetFilePath])
            {
                ret = FALSE;
                
                // 連番でファイル名リネーム
                for (NSInteger iRenameIndex = 0; iRenameIndex < 10000; iRenameIndex++)
                {
                    fname = [NSString stringWithFormat:@"%@(%zd).%@",
                             [orgFname stringByDeletingPathExtension],
                             iRenameIndex + 1,
                             [orgFname pathExtension]];
                    if(fname.length > 200){
                        fname = [NSString stringWithFormat:@"%@(%zd).%@",
                                 [[orgFname stringByDeletingPathExtension] substringToIndex:195 - [orgFname pathExtension].length - 1],
                                 iRenameIndex + 1,
                                 [orgFname pathExtension]];
                    }
                    
                    imageName = [NSString stringWithFormat:@"%@(%zd).%@",
                                 [orgImageName stringByDeletingPathExtension],
                                 iRenameIndex + 1,
                                 [orgImageName pathExtension]];
                    if(imageName.length > 200){
                        // 静的解析で未使用と判断されたためコメントアウト
                        //                    imageName = [NSString stringWithFormat:@"%@(%d).%@",
                        //                                 [[orgImageName stringByDeletingPathExtension] substringToIndex:195 - [orgImageName pathExtension].length - 1],
                        //                                 iRenameIndex + 1,
                        //                                 [orgImageName pathExtension]];
                    }
                    
                    targetFilePath =[scanDir stringByAppendingString:fname];
                    
                    // ファイル存在確認
                    if(![fManager fileExistsAtPath:targetFilePath])
                    {
                        ret = TRUE;
                        break;
                    }
                }
                
                if (!ret)
                {
                    break;
                }
            }
            
            TempFile *tempFile = [[TempFile alloc] initWithFileName:theTempData.fname];
            ScanFile *scanFile = [[ScanFile alloc] initWithScanFilePath:targetFilePath];
            if(isMove)
            {
                [GeneralFileUtility move:tempFile Destination:scanFile];
            }
            else
            {
                [GeneralFileUtility copy:tempFile Destination:scanFile];
            }
        }
        if(!ret)
        {
            // ロールバック処理
            for (TempData *theTempData in atempDataList)
            {
                NSString *fname = theTempData.fname;
                //
                // ファイルやディレクトリの情報取得
                //
                NSString	 *filePath	= [scanDir stringByAppendingString:fname];
                NSString     *imagePath = [scanDir stringByAppendingPathComponent:[CommonUtil thumbnailPath:fname]];
                NSString     *targetFilePath =[tempDir stringByAppendingString:fname];
                NSString     *targetImagePath = [[CommonUtil tmpDir] stringByAppendingPathComponent:[CommonUtil thumbnailPath:fname]];
                
                NSFileManager *fManager = [NSFileManager defaultManager];
                if(isMove)
                {
                    // 保存フォルダから一時保存フォルダへ移動
                    [fManager moveItemAtPath:filePath toPath:targetFilePath error:nil];
                    [fManager moveItemAtPath:imagePath toPath:targetImagePath error:nil];
                }
                else
                {
                    // 保存フォルダから削除
                    [fManager removeItemAtPath:filePath error:nil];
                    [fManager removeItemAtPath:imagePath error:nil];
                }
            }
            return NO;
        }
        
        
    }
    
	return YES;
}

@end
