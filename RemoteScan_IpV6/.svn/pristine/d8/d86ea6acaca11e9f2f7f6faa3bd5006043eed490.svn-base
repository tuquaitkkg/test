#import "ProfileDataManager.h"
#import "CommonUtil.h"
#import "Define.h"

//
// 静的変数（クラス変数）の定義
//

@implementation ProfileDataManager

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize		pProfileDataList;					// ProfileDataクラス配列
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
	
#if 0
	// debug出力
	DLog(@"ProfileDataList　count=%d", [pProfileDataList count]);
#endif
    
    return self;									// 初期化処理の終了した self を戻す
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//


#pragma mark -
#pragma mark ProfileData Manager

//
// プロパティリストを読み込んでProfileDataクラスを生成
//
- (NSMutableArray *)ReadProfileData
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
            NSString		*fileName		= [self.baseDir stringByAppendingString:PROFILEDATA_DAT];
            NSFileManager	*fileManager	= [NSFileManager defaultManager];
            
            // initWithCoder が call される
            obj = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
            NSMutableArray *tempDataList	= [[NSMutableArray alloc] initWithCapacity:1];
            
            //
            // ProfileData クラスを生成してコレクションに追加
            //
            ProfileData	 *profileData	= [[ProfileData alloc] init];
            
            BOOL isExists	= [fileManager fileExistsAtPath:fileName];
            if (isExists == YES)
            {
                profileData	= [obj objectAtIndex:0];				// 取得
            }
            [tempDataList addObject:profileData];					// 追加
            
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
- (BOOL)saveProfileData
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
            NSString *fileName	= [self.baseDir stringByAppendingString:PROFILEDATA_DAT];
            
            //
            // encodeWithCoder が call される
            //
            if (![NSKeyedArchiver archiveRootObject:pProfileDataList toFile:fileName]) {
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
- (NSUInteger)countOfProfileData
{
    return [pProfileDataList count];
}

//
// 指定したインデックスの ProfileDataクラスを取り出す
//
- (ProfileData *)loadProfileDataAtIndex:(NSUInteger)index
{
    if (pProfileDataList == nil) {
        //
        // データ取得
        //
        pProfileDataList		= [self ReadProfileData];
    }
    
    if (index < [pProfileDataList count])
	{
		ProfileData *profileData = [pProfileDataList objectAtIndex:index];
        
		// 表示名
		NSUInteger len = [profileData.profileName length];
		if (len <= 0)
		{
			// デフォルト値の設定：ユーザが名付けた端末名をセット
			UIDevice* device		= [UIDevice currentDevice];
            NSString* strProfileName = @"";
            int strCount = 0;
            for (int i = 0; i < [device.name length]; i++)
            {
                NSString *oneStr = [device.name substringWithRange:NSMakeRange(i,1)];
                // 文字は存在しているので１をカウント
                strCount++;
                // 全角だった場合はもう一つカウント
                if (![CommonUtil hasHalfChar:oneStr])
                {
                    strCount++;
                }
                
                if(strCount > 36)
                {
                    break;
                }
                strProfileName = [strProfileName stringByAppendingString:oneStr];
            }
			profileData.profileName	= strProfileName;
            
		}
        
		// 検索文字
		len = [profileData.serchString length];
		if (len <= 0)
		{
			profileData.serchString	= S_SEARCH_STRING;
		}
        
        return profileData;
    }
	return nil;
}

//
// 指定したインデックスに ProfileDataクラスを追加
//
- (BOOL)addProfileDataAtIndex:(NSUInteger)index newObject:(ProfileData *)newObject
{
    if (index > [pProfileDataList count])
	{
        return FALSE;
    }
    
	[pProfileDataList insertObject: newObject atIndex:index];
    
    return TRUE;
}

//
// 指定したインデックスの ProfileDataクラスを置き換える
//
- (BOOL)replaceProfileDataAtIndex:(NSUInteger)index newObject:(ProfileData *)newObject
{
    if (index > [pProfileDataList count])
	{
        return FALSE;
    }
    
	[pProfileDataList replaceObjectAtIndex:index withObject:newObject];
    
    return TRUE;
}

@end
