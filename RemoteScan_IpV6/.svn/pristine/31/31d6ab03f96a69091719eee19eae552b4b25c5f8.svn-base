
#import "PrinterDataManager.h"
#import "Define.h"
#import "ProfileDataManager.h"
#import "GeneralFileUtility.h"

@implementation PrinterDataManager

@synthesize PrinterDataList = m_parrPrinterData;
@synthesize BaseDir = m_pstrBaseDir;
@synthesize DefaultMFPIndex = m_nDefaultMfPIndex;

- (id)init
{
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
    // ホームディレクトリ/Library/PrivateDocuments の取得
    self.BaseDir = [GeneralFileUtility getPrivateDocuments];
    
	// プリンタ情報の取得
    m_parrPrinterData = [self ReadPrinterData];
    
    for (PrinterData *pd in m_parrPrinterData) {
        DLog(@"addDic:\n%@",[pd.addDic description]);
        DLog(@"updateDic:\n%@",[pd.updateDic description]);
        DLog(@"deleteDic:\n%@",[pd.deleteDic description]);
    }
    
    return self;
}


// プロパティリストを読み込んでPrinterDataクラスを生成
- (NSMutableArray *)ReadPrinterData
{
    // DATファイル読込み
    NSString *pstrFileName = [self.BaseDir stringByAppendingString:S_PRINTERDATA_DAT];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:pstrFileName];
    
    NSMutableArray *parrTempData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
    
    for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
    {
        // PrinterDataクラス
        PrinterData* printerData = nil;
        // プリンタ情報をDATファイルから取得
        printerData = [obj objectAtIndex:nIndex];
        // プリンタ情報をPrinterDataクラスに追加
        [parrTempData addObject:printerData];
    }
    return parrTempData;
}

// プロパティリストを読み込んでPrinterDataクラスを生成（除外されていないMFP）
- (NSMutableArray *)ReadPrinterDataInclude
{
    // DATファイル読込み
    NSString *pstrFileName = [self.BaseDir stringByAppendingString:S_PRINTERDATA_DAT];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:pstrFileName];
    
    NSMutableArray *parrTempData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
    
    for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
    {
        // PrinterDataクラス
        PrinterData* printerData = nil;
        // プリンタ情報をDATファイルから取得
        printerData = [obj objectAtIndex:nIndex];
        
        if(!printerData.ExclusionList)
        {
            // プリンタ情報をPrinterDataクラスに追加
            [parrTempData addObject:printerData];
        }
    }
    return parrTempData;
}

// プロパティリストを読み込んでPrinterDataクラスを生成（除外MFP）
- (NSMutableArray *)ReadPrinterDataExclude
{
    // DATファイル読込み
    NSString *pstrFileName = [self.BaseDir stringByAppendingString:S_PRINTERDATA_DAT];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:pstrFileName];
    
    NSMutableArray *parrTempData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
    
    for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
    {
        // PrinterDataクラス
        PrinterData* printerData = nil;
        // プリンタ情報をDATファイルから取得
        printerData = [obj objectAtIndex:nIndex];
        
        if(printerData.ExclusionList)
        {
            // プリンタ情報をPrinterDataクラスに追加
            [parrTempData addObject:printerData];
        }
    }
    return parrTempData;
}

// 除外されていないプリンタのリストとDATファイルのIndexをひも付ける
- (NSMutableArray*)GetIndexListInclude
{
    // DATファイル読込み
    NSString *pstrFileName = [self.BaseDir stringByAppendingString:S_PRINTERDATA_DAT];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:pstrFileName];
    
    NSMutableArray *parrTempData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
    
    for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
    {
        // PrinterDataクラス
        PrinterData* printerData = nil;
        // プリンタ情報をDATファイルから取得
        printerData = [obj objectAtIndex:nIndex];
        
        if(!printerData.ExclusionList)
        {
            // 除外されていないプリンタのリストのIndexがプリンタ情報の何番目のIndexであるか取得
            [parrTempData addObject:[NSNumber numberWithInteger:nIndex]];
            
        }
    }
    return parrTempData;
    
}

// 除外プリンタのリストとDATファイルのIndexをひも付ける
- (NSMutableArray*)GetIndexListExclude
{
    // DATファイル読込み
    NSString *pstrFileName = [self.BaseDir stringByAppendingString:S_PRINTERDATA_DAT];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:pstrFileName];
    
    NSMutableArray *parrTempData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
    
    for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
    {
        // PrinterDataクラス
        PrinterData* printerData = nil;
        // プリンタ情報をDATファイルから取得
        printerData = [obj objectAtIndex:nIndex];
        
        if(printerData.ExclusionList)
        {
            // 除外リストのIndexがプリンタ情報の何番目のIndexであるか取得
            [parrTempData addObject:[NSNumber numberWithInteger:nIndex]];
            
        }
    }
    return parrTempData;
    
}

// PrinterDataクラスの保存
- (BOOL)SavePrinterData
{
    for (PrinterData *pd in m_parrPrinterData) {
        DLog(@"addDic:\n%@",[pd.addDic description]);
        DLog(@"updateDic:\n%@",[pd.updateDic description]);
        DLog(@"deleteDic:\n%@",[pd.deleteDic description]);
    }

    NSString *pstrFileName	= [self.BaseDir stringByAppendingString:S_PRINTERDATA_DAT];
	if (![NSKeyedArchiver archiveRootObject:m_parrPrinterData toFile:pstrFileName])
    {
        return FALSE;
    }
    
    return TRUE;
}

// PrinterDataクラスの要素数返却
- (NSUInteger)CountOfPrinterData
{
    return [m_parrPrinterData count];
}

// PrinterDataクラスの要素数返却（除外されていないMFP）
- (NSUInteger)CountOfPrinterDataInclude
{
    return [self.ReadPrinterDataInclude count];
}

// PrinterDataクラスの要素数返却（除外MFP）
- (NSUInteger)CountOfPrinterDataExclude
{
    return [self.ReadPrinterDataExclude count];
}

// 指定したインデックスのPrinterDataクラスを取り出す
- (PrinterData*)LoadPrinterDataAtIndex:(NSIndexPath*)indexPath
{
    if (indexPath.row < [m_parrPrinterData count])
	{
        return [m_parrPrinterData objectAtIndex:indexPath.row];
    }
	return nil;
}

// 指定したインデックスのPrinterDataクラスを取り出す（除外されていないMFP）
- (PrinterData*)LoadPrinterDataAtIndexInclude:(NSIndexPath*)indexPath
{
    if (indexPath.row < self.CountOfPrinterDataInclude)
	{
        return [self.ReadPrinterDataInclude objectAtIndex:indexPath.row];
    }
	return nil;
}

// 指定したインデックスのPrinterDataクラスを取り出す（除外MFP）
- (PrinterData*)LoadPrinterDataAtIndexExclude:(NSIndexPath*)indexPath
{
    if (indexPath.row < self.CountOfPrinterDataExclude)
	{
        return [self.ReadPrinterDataExclude objectAtIndex:indexPath.row];
    }
	return nil;
}

// 指定したインデックスのPrinterDataクラスを取り出し、選択中MFPフラグを設定
- (PrinterData*)LoadPrinterDataAtIndexWithSetDefaultMFP:(NSIndexPath*)indexPath
{
    PrinterData* printerData = [self LoadPrinterDataAtIndex:indexPath];
    
    if (nil != printerData)
	{
        // 選択中のMFPかチェックするためのフラグを設定
        if(m_nDefaultMfPIndex == indexPath.row)
        {
            printerData.DefaultMFP = true;
        }
        else
        {
            printerData.DefaultMFP = false;
        }
    }
    return printerData;
}

// 指定したインデックスのPrinterDataクラスを取り出し、選択中MFPフラグを設定（除外されていないMFP）
- (PrinterData*)LoadPrinterDataAtIndexWithSetDefaultMFPInclude:(NSIndexPath*)indexPath
{
    PrinterData* printerData = [self LoadPrinterDataAtIndexInclude:indexPath];
    
    if (nil != printerData)
	{
        // 選択中のMFPかチェックするためのフラグを設定
        if(m_nDefaultMfPIndex == indexPath.row)
        {
            printerData.DefaultMFP = true;
        }
        else
        {
            printerData.DefaultMFP = false;
        }
    }
    return printerData;
}

- (PrinterData*)LoadPrinterDataAtIndex2:(NSUInteger)uIndex
{
    if (uIndex < [m_parrPrinterData count])
    {
        return [m_parrPrinterData objectAtIndex:uIndex];
    }
    return nil;
}

- (PrinterData*)LoadPrinterDataAtIndexInclude2:(NSUInteger)uIndex
{
    NSUInteger uPrinterDataIncludeIndex;
    if([self.GetIndexListInclude count] != 0)
    {
        uPrinterDataIncludeIndex = [[self.GetIndexListInclude objectAtIndex:uIndex] intValue];
        if (uPrinterDataIncludeIndex < [m_parrPrinterData count])
        {
            return [m_parrPrinterData objectAtIndex:uPrinterDataIncludeIndex];
        }
    }
    return nil;
}

- (PrinterData*)LoadPrinterDataAtIndexExclude2:(NSUInteger)uIndex
{
    
    NSUInteger uPrinterDataExcludeIndex;
    if([self.GetIndexListExclude objectAtIndex:uIndex])
    {
        uPrinterDataExcludeIndex = [[self.GetIndexListExclude objectAtIndex:uIndex] intValue];
    
        if (uPrinterDataExcludeIndex < [m_parrPrinterData count])
        {
            return [m_parrPrinterData objectAtIndex:uPrinterDataExcludeIndex];
        }
    }
    return nil;
}

// 指定したインデックスにPrinterDataクラスを追加
- (BOOL)AddPrinterDataAtIndex:(NSUInteger)uIndex
                    newObject:(PrinterData *)newData
{
    if (uIndex > [m_parrPrinterData count])
	{
        return FALSE;
    }
	[m_parrPrinterData insertObject: newData atIndex:uIndex];
    
    return TRUE;
}

// 指定したインデックスのPrinterDataクラスを置き換える
- (BOOL)ReplacePrinterDataAtIndex:(NSUInteger)uIndex 
                        newObject:(PrinterData *)newData
{
    if (uIndex > [m_parrPrinterData count])
	{
        return FALSE;
    }
	[m_parrPrinterData replaceObjectAtIndex:uIndex withObject:newData];
    
    return TRUE;
}

// 指定したインデックスのPrinterDataクラスを移動
- (BOOL)MoveFromIndex:(NSUInteger)uFromIndex
              toIndex:(NSUInteger)uToIndex
{
    PrinterData* moveData = [m_parrPrinterData objectAtIndex:uFromIndex];
    
    if (uFromIndex < uToIndex)
	{
        [m_parrPrinterData insertObject:moveData atIndex:uToIndex+1];
        [m_parrPrinterData removeObjectAtIndex:uFromIndex];
    }
    else if(uFromIndex > uToIndex)
	{
        [m_parrPrinterData insertObject:moveData atIndex:uToIndex];
        [m_parrPrinterData removeObjectAtIndex:uFromIndex+1];
    }
    else
	{
        return FALSE;
    }
    return TRUE;
}

// 指定したインデックスのPrinterDataクラスを削除
- (BOOL)RemoveAtIndex:(NSUInteger)uIndex
{
    if (uIndex > [m_parrPrinterData count])
	{
        return FALSE;
    }
    [m_parrPrinterData removeObjectAtIndex:uIndex];
    
    return TRUE;
}

// 指定したキーに一致するPrinterDataクラスのインデックスを返却
- (NSInteger)GetPrinterIndexForKey:(NSString*)pstrKey
{
    for (NSInteger nIndex = 0; nIndex < [m_parrPrinterData count]; nIndex++)
    {
        PrinterData* tempData = [m_parrPrinterData objectAtIndex:nIndex];
        if ([tempData.PrimaryKey isEqualToString:pstrKey])
        {
            return nIndex;
        }
    }
    // 見つからなかった場合
    return -1;
}

// 指定したキーに一致するPrinterDataクラスのインデックスを返却
- (NSInteger)GetPrinterIndexForKeyInclude:(NSString*)pstrKey
{
    //    for (NSInteger nIndex = 0; nIndex < [m_parrPrinterData count]; nIndex++)
    NSArray* m_parrPrinterDataArray = self.ReadPrinterDataInclude;
    for (NSInteger nIndex = 0; nIndex < [m_parrPrinterDataArray count]; nIndex++)
    {
        //        PrinterData* tempData = [m_parrPrinterData objectAtIndex:nIndex];
        PrinterData* tempData = [m_parrPrinterDataArray objectAtIndex:nIndex];
        if ([tempData.PrimaryKey isEqualToString:pstrKey])
        {
            return nIndex;
        }
    }
    // 見つからなかった場合
    return -1;
}

// FTPポート番号更新
- (void)SetPortNo:(NSUInteger)uIndex
           portNo:(NSString*)pstrPortNo
{
    // PrinterDataクラスを取得
    PrinterData* newData = [m_parrPrinterData objectAtIndex:uIndex];
    
    // ポート番号更新
    newData.PortNo = pstrPortNo;    
    [m_parrPrinterData replaceObjectAtIndex:uIndex withObject:newData];
    
    // DATファイルに保存
    [self SavePrinterData];
}

// FTPポート番号取得
- (NSString*)GetPortNo:(NSUInteger)uIndex
{
    // PrinterDataクラスを取得
    PrinterData* newData = [m_parrPrinterData objectAtIndex:uIndex];
    
    return newData.PortNo;
}

// 選択中MFPのIndex保持
- (void)SetDefaultMFPIndex:(NSString*) pstrKey PrimaryKeyForCurrrentWifi:(NSString*) pstrKeyForCurrentWiFi
{
    // PROFILE情報の取得
    ProfileDataManager* profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    BOOL bAutoSelect= profileData.autoSelectMode;
    
    // プリンター/スキャナー自動切替ON
    if(bAutoSelect)
    {
        // 接続先WiFiの最新プリンタ情報取得
        m_nDefaultMfPIndex = [self GetPrinterIndexForKey:pstrKeyForCurrentWiFi];
        if (m_nDefaultMfPIndex == -1)
        {
            // 接続先WiFiの最新印刷情報が取得できない場合は最新印刷情報取得
//            m_nDefaultMfPIndex = [self GetPrinterIndexForKey:pstrKey];
            m_nDefaultMfPIndex = [self GetPrinterIndexForKeyInclude:pstrKey];
            
            // 最新印刷情報がない場合は最初に表示するプリンタをデフォルト設定とする
            if (m_nDefaultMfPIndex == -1)
            {
                m_nDefaultMfPIndex = 0;
            }
        }
    }
    else
    {
        // 最新プリンタ名取得
//        m_nDefaultMfPIndex = [self GetPrinterIndexForKey:pstrKey];
        m_nDefaultMfPIndex = [self GetPrinterIndexForKeyInclude:pstrKey];
        // 最新印刷情報がない場合は最初に表示するプリンタをデフォルト設定とする
        if (m_nDefaultMfPIndex == -1)
        {
            m_nDefaultMfPIndex = 0;
        }
    }
}

// リモートスキャン対応スキャナーの数を返却する
- (int) countRemoteScanCapableScanner
{
    int cnt = 0;
    
    NSMutableArray* scannerArray = [self ReadPrinterDataInclude];
    for (PrinterData* pData in scannerArray) {
        if ([pData IsCapableRemoteScan]) {
            cnt++;
        }
    }
    
    return cnt;
}

@end
