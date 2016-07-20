#import "ProfileData.h"

@implementation ProfileData

//
// アクセサメソッドの自動合成(ゲッターとセッターの役割)
//
@synthesize		profileName;			// 表示名
@synthesize     serchString;
@synthesize		delMode;				// 消さない
@synthesize		modifyMode;				// 強制上書き
@synthesize		saveExSiteFileMode;		// 他アプリから受けたファイルを残す
@synthesize     autoSelectMode;         // このプリンター/スキャナーを選択
@synthesize     highQualityMode;        // 高品質で印刷する
@synthesize     useRawPrintMode;        // 印刷にRawプリントを使用する
@synthesize     deviceNameStyle;        // 自動検出デバイス名のスタイル
@synthesize     userAuthStyle;          // ユーザー認証のスタイル
@synthesize     loginName;              // ログイン名
@synthesize     loginPassword;          // パスワード
@synthesize     userNo;                 // ユーザー番号
@synthesize     userName;               // ユーザー名
@synthesize     jobName;                // ジョブ名
@synthesize     bUseLoginNameForUserName;
@synthesize     snmpSearchPublicMode;   // publicで検索する
@synthesize     snmpCommunityString;    // Community String

@synthesize     configScannerSetting;   // 端末側でスキャナーを設定する（リモートスキャンのON/OFF）
@synthesize     autoCreateVerifyCode;    // 確認コード自動生成フラグ
@synthesize     verifyCode;             // 確認コード

@synthesize     rsCustomSize0;          // リモートスキャン カスタムサイズ設定 0
@synthesize     rsCustomSize1;          // リモートスキャン カスタムサイズ設定 1
@synthesize     rsCustomSize2;          // リモートスキャン カスタムサイズ設定 2
@synthesize     rsCustomSize3;          // リモートスキャン カスタムサイズ設定 3
@synthesize     rsCustomSize4;          // リモートスキャン カスタムサイズ設定 4

@synthesize     jobTimeOut;              // ジョブ送信のタイムアウト(秒)

@synthesize     noPrint;               // 印刷せずにホールド
@synthesize     retentionAuth;         // 認証
@synthesize     retentionPassword;     // パスワード

#pragma mark -
#pragma mark ProfileData delegete

//
// イニシャライザ定義
//
- (id)init
{
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
    // 初期値
    bUseLoginNameForUserName = NO;

    return self;
}

//
// エンコーダーにデータを保存する処理
//
- (void)encodeWithCoder:(NSCoder *)coder
{
    // 文字列をキーで保存する
    [coder encodeObject:profileName		forKey:@"stringprofileName"];
    [coder encodeObject:serchString		forKey:@"stringserchString"];
    if (delMode) {
        [coder encodeObject:@"1"         forKey:@"stringdelMode"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringdelMode"];
    }
    if (modifyMode) {
        [coder encodeObject:@"1"         forKey:@"stringmodifyMode"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringmodifyMode"];
    }
    if(saveExSiteFileMode){
        [coder encodeObject:@"1"         forKey:@"stringsaveExSiteFileMode"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringsaveExSiteFileMode"];
    }
    if(autoSelectMode)
    {
        [coder encodeObject:@"1"         forKey:@"stringautoSelectMode"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringautoSelectMode"];
    }
    if(highQualityMode)
    {
        [coder encodeObject:@"1"         forKey:@"stringhighQualityMode"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringhighQualityMode"];
    }
    if(useRawPrintMode)
    {
        [coder encodeObject:@"1"         forKey:@"stringuseRawPrintMode"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringuseRawPrintMode"];        
    }
    [coder encodeObject:[NSString stringWithFormat:@"%zd", deviceNameStyle] forKey:@"stringdeviceNameStyle"];
    if(snmpSearchPublicMode)
    {
        [coder encodeObject:@"1"         forKey:@"stringsnmpSearchPublicMode"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringsnmpSearchPublicMode"];
    }
         
    [coder encodeObject:[NSString stringWithFormat:@"%zd", userAuthStyle] forKey:@"stringuserAuthStyle"];
    [coder encodeObject:loginName		forKey:@"stringloginName"];
    [coder encodeObject:loginPassword		forKey:@"stringloginPassword"];
    [coder encodeObject:userNo		forKey:@"stringuserNo"];
    [coder encodeObject:userName		forKey:@"stringuserName"];
    [coder encodeObject:jobName		forKey:@"stringjobName"];
    [coder encodeObject:[NSString stringWithFormat:@"%d", bUseLoginNameForUserName] forKey:@"stringUseLoginNameForUserName"];
    [coder encodeObject:snmpCommunityString  forKey:@"stringSnmpCommunityString"];

    if(configScannerSetting)
    {
        [coder encodeObject:@"1"         forKey:@"stringconfigScannerSetting"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringconfigScannerSetting"];
    }
    
    if(autoCreateVerifyCode)
    {
        [coder encodeObject:@"1"         forKey:@"stringautoCreateVerifyCode"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringautoCreateVerifyCode"];
    }
    
    [coder encodeObject:verifyCode  forKey:@"stringVerifyCode"];
    
    [coder encodeObject:rsCustomSize0  forKey:@"stringrsCustomSize0"];
    [coder encodeObject:rsCustomSize1  forKey:@"stringrsCustomSize1"];
    [coder encodeObject:rsCustomSize2  forKey:@"stringrsCustomSize2"];
    [coder encodeObject:rsCustomSize3  forKey:@"stringrsCustomSize3"];
    [coder encodeObject:rsCustomSize4  forKey:@"stringrsCustomSize4"];
    [coder encodeObject:jobTimeOut      forKey:@"stringjobTimeOut"];

    if (noPrint) {
        [coder encodeObject:@"1"         forKey:@"stringnoPrint"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringnoPrint"];
    }
    if (retentionAuth) {
        [coder encodeObject:@"1"         forKey:@"stringretentionAuth"];
    }
    else
    {
        [coder encodeObject:@"0"         forKey:@"stringretentionAuth"];
    }
    [coder encodeObject:retentionPassword		forKey:@"stringretentionPassword"];

}

//
// アーカイブから読み込む
//
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
	
    if (self)
	{
        profileName	= [coder decodeObjectForKey:@"stringprofileName"];
        serchString	= [coder decodeObjectForKey:@"stringserchString"];
        if ([[coder decodeObjectForKey:@"stringdelMode"] isEqualToString:@"1"] ) 
        {
            delMode = TRUE;
        }
        else
        {
            delMode = FALSE;
        }
        if ([[coder decodeObjectForKey:@"stringmodifyMode"] isEqualToString:@"1"]) 
        {
            modifyMode = TRUE;
        }
        else
        {
            modifyMode = FALSE;
        }
        if ([[coder decodeObjectForKey:@"stringsaveExSiteFileMode"] isEqualToString:@"1"]) 
        {
            saveExSiteFileMode = TRUE;
        }
        else
        {
            saveExSiteFileMode = FALSE;
        }
        if ([[coder decodeObjectForKey:@"stringautoSelectMode"] isEqualToString:@"1"]) 
        {
            autoSelectMode = TRUE;
        }
        else
        {
            autoSelectMode = FALSE;
        }
        if ([[coder decodeObjectForKey:@"stringhighQualityMode"] isEqualToString:@"1"]) 
        {
            highQualityMode = TRUE;
        }
        else
        {
            highQualityMode = FALSE;
        }
        if ([[coder decodeObjectForKey:@"stringuseRawPrintMode"] isEqualToString:@"1"])
        {
            useRawPrintMode = TRUE;
        }
        else
        {
            useRawPrintMode = FALSE;
        }
        deviceNameStyle = [[coder decodeObjectForKey:@"stringdeviceNameStyle"] intValue];
        userAuthStyle = [[coder decodeObjectForKey:@"stringuserAuthStyle"] intValue];
        loginName = [coder decodeObjectForKey:@"stringloginName"];
        loginPassword = [coder decodeObjectForKey:@"stringloginPassword"];
        userNo = [coder decodeObjectForKey:@"stringuserNo"];
        userName = [coder decodeObjectForKey:@"stringuserName"];
        jobName = [coder decodeObjectForKey:@"stringjobName"];
        if([coder decodeObjectForKey:@"stringUseLoginNameForUserName"])
        {
            bUseLoginNameForUserName      = [[coder decodeObjectForKey:@"stringUseLoginNameForUserName"] boolValue];
        }
        else
        {
            bUseLoginNameForUserName = NO;
        }
        if ([[coder decodeObjectForKey:@"stringsnmpSearchPublicMode"] isEqualToString:@"1"])
        {
            snmpSearchPublicMode = TRUE;
        }
        else
        {
            snmpSearchPublicMode = FALSE;
        }
        snmpCommunityString = [coder decodeObjectForKey:@"stringSnmpCommunityString"];
        
        if ([[coder decodeObjectForKey:@"stringconfigScannerSetting"] isEqualToString:@"1"]) 
        {
            configScannerSetting = TRUE;
        }
        else
        {
            configScannerSetting = FALSE;
        }
        
        if ([[coder decodeObjectForKey:@"stringautoCreateVerifyCode"] isEqualToString:@"1"]) 
        {
            autoCreateVerifyCode = TRUE;
        }
        else
        {
            autoCreateVerifyCode = FALSE;
        }
        
        verifyCode = [coder decodeObjectForKey:@"stringVerifyCode"];
        
        rsCustomSize0 = [coder decodeObjectForKey:@"stringrsCustomSize0"];
        rsCustomSize1 = [coder decodeObjectForKey:@"stringrsCustomSize1"];
        rsCustomSize2 = [coder decodeObjectForKey:@"stringrsCustomSize2"];
        rsCustomSize3 = [coder decodeObjectForKey:@"stringrsCustomSize3"];
        rsCustomSize4 = [coder decodeObjectForKey:@"stringrsCustomSize4"];
        
        jobTimeOut = [coder decodeObjectForKey:@"stringjobTimeOut"];
        if(jobTimeOut == nil)
        {
            jobTimeOut = N_NUM_DEFAULT_JOB_TIME_OUT;
        }

        if ([[coder decodeObjectForKey:@"stringnoPrint"] isEqualToString:@"1"] )
        {
            noPrint = TRUE;
        }
        else
        {
            noPrint = FALSE;
        }
        if ([[coder decodeObjectForKey:@"stringretentionAuth"] isEqualToString:@"1"] )
        {
            retentionAuth = TRUE;
        }
        else
        {
            retentionAuth = FALSE;
        }
        retentionPassword = [coder decodeObjectForKey:@"stringretentionPassword"];

    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"profileName[%@] serchString[%@] delMode[%d] modifyMode[%d] saveExSiteFileMode[%d] autoSelectMode[%d] highQualityMode[%d] useRawPrintMode[%d] deviceNameStyle[%zd] userAuthStyle[%zd] loginName[%@] loginPassword[%@] userNo[%@] userName[%@] jobName[%@] snmpSearchPublic[%d] configScannerSetting[%d] noPrint[%d] retentionAuth[%d] retentionPassword[%@] jobTimeOut[%@]"
			, profileName
            , serchString
			, delMode
			, modifyMode
            , saveExSiteFileMode
            , autoSelectMode
            , highQualityMode
            , useRawPrintMode
            , deviceNameStyle
            , userAuthStyle
            , loginName
            , loginPassword
            , userNo
            , userName
            , jobName
            , snmpSearchPublicMode
            , configScannerSetting
            , noPrint
            , retentionAuth
            , retentionPassword
            , jobTimeOut
            ];
}

//
// アプリケーションの終了直前に呼ばれるメソッド
//

@end
