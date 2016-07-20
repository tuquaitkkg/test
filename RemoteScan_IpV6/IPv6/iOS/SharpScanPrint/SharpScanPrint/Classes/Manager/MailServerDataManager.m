
#import "MailServerDataManager.h"
#import "CommonUtil.h"
#import "Define.h"

//
// 静的変数（クラス変数）の定義
//


@implementation MailServerDataManager
//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize		pMailServerDataList;					// ProfileDataクラス配列
@synthesize		baseDir;							// ホームディレクトリ/Documments/

#pragma mark -
#pragma mark class method

#pragma mark -
#pragma mark ProfileDataManager delegete

//
// イニシャライザ定義
//
- (id)init
{
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
	// 設定ファイル格納ディレクトリの取得
	self.baseDir		= CommonUtil.settingFileDir;
	
	//
	// データ取得
	//
    pMailServerDataList		= [self ReadMailServerData];
    
#if 0
	// debug出力
	DLog(@"MailServerDataList　count=%d", [pMailServerDataList count]);
#endif
    
    return self;									// 初期化処理の終了した self を戻す
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//


#pragma mark -
#pragma mark ProfileData Manager

//
// プロパティリストを読み込んでMailServerDataクラスを生成
//
- (NSMutableArray *)ReadMailServerData
{
	//
	// 自動解放プールの作成
	//
    @autoreleasepool
    {
        @try {
            //
            // 読み込む
            //
            id obj;
            NSString		*fileName		= [self.baseDir stringByAppendingString: MAILSERVERDATA_DAT];
            NSFileManager	*fileManager	= [NSFileManager defaultManager];
            
            // initWithCoder が call される
            obj = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
            NSMutableArray *tempDataList	= [[NSMutableArray alloc] initWithCapacity:1];
            
            //
            // MailServerData クラスを生成してコレクションに追加
            //
            MailServerData	 *mailServerData	= [[MailServerData alloc] init];
            
            BOOL isExists	= [fileManager fileExistsAtPath:fileName];
            if (isExists == YES)
            {
                mailServerData	= [obj objectAtIndex:0];				// 取得
            }
            [tempDataList addObject:mailServerData];					// 追加
            
            return tempDataList;
        }
        @finally {
        }
    }
    
    return nil; // will be never reached
}

//
// PROFILEの保存
//
- (BOOL)saveMailServerData
{
	//
	// 自動解放プールの作成
	//
    @autoreleasepool
    {
        @try {
            //
            // アーカイブする
            //
            NSString *fileName	= [self.baseDir stringByAppendingString: MAILSERVERDATA_DAT];
            
            //
            // encodeWithCoder が call される
            //
            if (![NSKeyedArchiver archiveRootObject:pMailServerDataList toFile:fileName]) {
                return FALSE;
            };
            
        }
        @finally
        {
        }
    }
    
    return TRUE;
}

//
// ProfileDataクラスの要素数を戻す
//
- (NSUInteger)countOfMailServerData
{
    return [pMailServerDataList count];
}

//
// 指定したインデックスの MailServerDataクラスを取り出す
//
- (MailServerData *)loadMailServerDataAtIndex:(NSUInteger)index
{
    if (index < [pMailServerDataList count])
	{
		MailServerData *mailServerData = [pMailServerDataList objectAtIndex:index];
        
//		// 表示名
//		unsigned int len = [mailServerData.hostname length];
//		if (len <= 0)
//		{
//			// デフォルト値の設定：ユーザが名付けた端末名をセット
//			UIDevice* device		= [UIDevice currentDevice];
//            NSString* strMailServerName = @"imap server";
//            int strCount = 0;
//            for (int i = 0; i < [device.name length]; i++)
//            {
//                NSString *oneStr = [device.name substringWithRange:NSMakeRange(i,1)];
//                // 文字は存在しているので１をカウント
//                strCount++;
//                // 全角だった場合はもう一つカウント
//                if (![CommonUtil hasHalfChar:oneStr])
//                {
//                    strCount++;
//                }
//                
//                if(strCount > 36) //  Max Length ???
//                {
//                    break;
//                }
//                strMailServerName = [strMailServerName stringByAppendingString:oneStr];
//            }
//			mailServerData.hostname	= strMailServerName;
//		}
        
//		// 検索文字
//		len = [mailServerData.serchString length];
//		if (len <= 0)
//		{
//			profileData.serchString	= S_SEARCH_STRING;
//		}
        
        return mailServerData;
    }
	return nil;
}

//
// 指定したインデックスに ProfileDataクラスを追加
//
- (BOOL)addMailServerDataAtIndex:(NSUInteger)index newObject:(MailServerData *)newObject
{
    if (index > [pMailServerDataList count])
	{
        return FALSE;
    }
    
	[pMailServerDataList insertObject: newObject atIndex:index];
    
    return TRUE;
}

//
// 指定したインデックスの ProfileDataクラスを置き換える
//
- (BOOL)replaceMailServerDataAtIndex:(NSUInteger)index newObject:(MailServerData *)newObject
{
    if (index > [pMailServerDataList count])
	{
        return FALSE;
    }
    
	[pMailServerDataList replaceObjectAtIndex:index withObject:newObject];
    
    return TRUE;
}

@end
