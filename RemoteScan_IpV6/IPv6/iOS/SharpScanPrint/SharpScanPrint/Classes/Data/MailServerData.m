
#import "MailServerData.h"

@implementation MailServerData
@synthesize hostname;             // ホスト名
@synthesize imapPortNo;           // iMapサービスに割当てられたポートNo(default: 143)
@synthesize accountName;          // プリンタIPアドレス
@synthesize accountPassword;      // サービスに割当てられたポートNo
@synthesize bSSL;                 // SSL flag
@synthesize getNumber;            // 取得件数
@synthesize filterSetting;         // フィルタ設定

- (id)init
{
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
    //デフォルト設定
    bSSL          = YES;   // ssl設定
    getNumber     = @"10"; //取得件数
    filterSetting = @(0);  //フィルター設定
    
    return self;
}

// エンコーダーにデータを保存する処理
- (void)encodeWithCoder:(NSCoder*)coder
{
    // 文字列をキーで保存する
    [coder encodeObject:hostname        forKey:@"mailServerHostname"];
    [coder encodeObject:imapPortNo      forKey:@"mailServerImapPortNo"];
    [coder encodeObject:accountName     forKey:@"mailServerAccountName"];
    [coder encodeObject:accountPassword forKey:@"mailServerAccountPassword"];
    
    [coder encodeObject:[NSString stringWithFormat:@"%d", bSSL] forKey:@"mailServerSSL"];
    [coder encodeObject:getNumber forKey:@"mailServerGetNumber"];
    [coder encodeObject:filterSetting forKey:@"mailServerFilterSetting"];
}

// アーカイブから読み込む
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
	
    if (self)
	{
        hostname        = [coder decodeObjectForKey:@"mailServerHostname"];
        imapPortNo      = [coder decodeObjectForKey:@"mailServerImapPortNo"];
        accountName     = [coder decodeObjectForKey:@"mailServerAccountName"];
        accountPassword = [coder decodeObjectForKey:@"mailServerAccountPassword"];
        getNumber       = [coder decodeObjectForKey:@"mailServerGetNumber"];
        filterSetting   = [coder decodeObjectForKey:@"mailServerFilterSetting"];
        
        if(hostname == nil)
        {
            hostname = @"";
        }
        if(imapPortNo == nil)
        {
            imapPortNo = @"143";
        }
        if(accountName == nil)
        {
            accountName = @"";
        }
        if(accountPassword == nil)
        {
            accountPassword = @"";
        }
        if([coder decodeObjectForKey:@"mailServerSSL"])
        {
            bSSL      = [[coder decodeObjectForKey:@"mailServerSSL"] boolValue];
        }
        else
        {
            bSSL = YES;
        }
        if (getNumber == nil) {
            getNumber = @"10";
        }
        if (filterSetting == nil) {
            filterSetting = @(0);
        }
    }
    return self;
}

// ログ出力
- (NSString*)description
{
    return [NSString stringWithFormat:
            @"hostname[%@] imapPortNo[%@] accountName[%@] AccountPassword[%@] SSL[%d] getNumber[%@] filterSetting[%@]"
            , hostname
            , imapPortNo
            , accountName
            , accountPassword
            , bSSL
            , getNumber
            , filterSetting];
}


@end
