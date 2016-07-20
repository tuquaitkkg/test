
#import "RSHttpCommunicationManager.h"
#import "RSCommonUtil.h"

@interface RSSetDeviceContextManager : RSHttpCommunicationManager
{
}

// 情報取得開始
- (void)updateData:(BOOL)enableRemoteScan remoteScanHost:(NSString *)host remoteScanCode:(NSString *)code remoteScanTimeOut:(NSInteger)timeout vkey:(NSString *)vkey;
@end
