
#import <Foundation/Foundation.h>

@interface MailServerData : NSObject
{
    NSString* hostname;             // ホスト名
    NSString* imapPortNo;           // iMapサービスに割当てられたポートNo(default: 143)
    NSString* accountName;          // プリンタIPアドレス
    NSString* accountPassword;      // サービスに割当てられたポートNo
    BOOL      bSSL;                 // SSL flag
    NSString* getNumber;            // 取得件数
    NSNumber* filterSetting;        // フィルタ設定
}

@property (nonatomic, copy) NSString* hostname;
@property (nonatomic, copy) NSString* imapPortNo;
@property (nonatomic, copy) NSString* accountName;
@property (nonatomic, copy) NSString* accountPassword;
@property (nonatomic)       BOOL      bSSL;
@property (nonatomic, copy) NSString* getNumber;
@property (nonatomic, copy) NSNumber* filterSetting;

// 名称の取得
//- (NSString*)getPrinterName;

//- (BOOL)getAddStatus;

@end
