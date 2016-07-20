
#import "ExcludePrinterDataManager.h"
#import "Define.h"
#import "GeneralFileUtility.h"

@implementation ExcludePrinterDataManager

@synthesize ExcludePrinterData = m_parrPrinterData;
//@synthesize bFirst = m_bFirst;

- (id)init
{
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
    // ホームディレクトリ/Library/PrivateDocuments の取得
    m_pstrBaseDir = [GeneralFileUtility getPrivateDocuments];

	// 除外プリンタ情報の取得
    [self GetExcludePrinterData];
    
    return self;
}

// 除外プリンタ情報取得
- (void)GetExcludePrinterData
{
    // DATファイル読込み
    NSString *pstrFileName = [m_pstrBaseDir stringByAppendingString:S_EXCLUDEPRINTERDATA_DAT];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:pstrFileName];
 /*
    if(0 < [obj count])
    {
        m_parrPrinterData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
        for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
        {
            // 除外プリンタ情報をDATファイルから取得して追加
            [m_parrPrinterData addObject:[obj objectAtIndex:nIndex]];
        }
    }    
    // DATファイルから取得できなかった場合
    else
    {
        // デフォルトの除外リスト読み込み
        NSString* path = [[NSBundle mainBundle] pathForResource:@"excludeDevice" ofType:@"plist"];
        m_parrPrinterData = [NSMutableArray arrayWithContentsOfFile:path];
        [m_parrPrinterData retain];
    }
*/    
/*
    NSUserDefaults* pud = [NSUserDefaults standardUserDefaults]; 
    BOOL isFirst = [pud boolForKey:@"First"];
    
    if(isFirst)
    {
        m_parrPrinterData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
        for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
        {
            // 除外プリンタ情報をDATファイルから取得して追加
            [m_parrPrinterData addObject:[obj objectAtIndex:nIndex]];
        }
    }
    else
    {
        // デフォルトの除外リスト読み込み
        NSString* path = [[NSBundle mainBundle] pathForResource:@"excludeDevice" ofType:@"plist"];
        m_parrPrinterData = [NSMutableArray arrayWithContentsOfFile:path];
        [m_parrPrinterData retain];
        
        [pud setBool:TRUE forKey:@"First"];
        [pud synchronize];
    }
*/
    if(obj != nil)
    {
        m_parrPrinterData = [[NSMutableArray alloc] initWithCapacity:[obj count]];
        for (NSInteger nIndex = 0; nIndex < [obj count]; nIndex++)
        {
            // 除外プリンタ情報をDATファイルから取得して追加
            [m_parrPrinterData addObject:[obj objectAtIndex:nIndex]];
        }
    }    
    // DATファイルから取得できなかった場合
    else
    {
        // デフォルトの除外リスト読み込み
        NSString* path = [[NSBundle mainBundle] pathForResource:@"excludeDevice" ofType:@"plist"];
        m_parrPrinterData = [NSMutableArray arrayWithContentsOfFile:path];
    }
    
    // 製品名の昇順でソート
    [m_parrPrinterData sortUsingComparator:^(id obj1, id obj2)
    {
        return [obj1 compare:obj2]; 
    }];
    
}

// 除外プリンタ情報保存
- (BOOL)SaveExcludePrinterData
{
    NSString *pstrFileName	= [m_pstrBaseDir stringByAppendingString:S_EXCLUDEPRINTERDATA_DAT];
	if (![NSKeyedArchiver archiveRootObject:m_parrPrinterData toFile:pstrFileName])
    {
        return FALSE;
    }
    
    return TRUE;
}

// 最後尾にデータを追加して除外プリンタ情報保存
- (BOOL)SaveExcludePrinterData:(NSString*)pAddExcludePrinterName
{
    // 最後尾にデータを追加
    [self AddExcludePrinterDataAtIndex:pAddExcludePrinterName];
    // 保存
    return [self SaveExcludePrinterData];
}

// PrinterDataクラスの要素数返却
- (NSUInteger)CountOfExcludePrinterData
{
    return [m_parrPrinterData count];
}

// 指定したインデックスの除外プリンタ情報返却
- (NSString*)LoadExcludePrinterDataAtIndex:(NSUInteger)uIndex
{
    if (uIndex < [m_parrPrinterData count])
	{
        return [m_parrPrinterData objectAtIndex:uIndex];
    }
	return nil;
}

// 指定したインデックスにPrinterDataクラスを追加
- (BOOL)AddExcludePrinterDataAtIndex:(NSString*)pAddPrinterName
{
	[m_parrPrinterData addObject:pAddPrinterName];
    
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

// 除外リスト初期化
- (void)InitExcludePrinterData
{
    // デフォルトの除外リスト読み込み
    [m_parrPrinterData removeAllObjects];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"excludeDevice" ofType:@"plist"];
    m_parrPrinterData = [NSMutableArray arrayWithContentsOfFile:path];
    // 保存
    [self SaveExcludePrinterData];
}

// 除外リスト一致チェック
- (BOOL)IsExcludePrinterData:(NSString*)pPrinterName
{    
    BOOL isExclude = false;
    for(int i = 0;i < [m_parrPrinterData count];i++)
    {
        if([pPrinterName caseInsensitiveCompare:[m_parrPrinterData objectAtIndex:i]] == NSOrderedSame)
        {
            isExclude = true;
            break;
        }
    }
    return isExclude;
}


@end
