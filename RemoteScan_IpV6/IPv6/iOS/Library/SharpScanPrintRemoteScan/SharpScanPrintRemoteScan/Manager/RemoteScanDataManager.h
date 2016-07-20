
#import <Foundation/Foundation.h>
#import "RemoteScanData.h"
#import "RSCommonUtil.h"

@interface RemoteScanDataManager : NSObject
{
    RemoteScanData *data;
}

// インスタンスの取得
+ (RemoteScanDataManager *)sharedManager;

// 読み込み済みのデータを利用する
- (RemoteScanData *)sharedRemoteScanSettings;
// 現在保存されている設定値を読み込む
- (RemoteScanData *)loadRemoteScanSettings;
// 設定を保存する
- (BOOL)saveRemoteScanSettings:(NSDictionary *)dic;
// 設定の削除
- (BOOL)removeRemoteScanSettings;

@end
