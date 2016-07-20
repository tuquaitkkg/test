
#import <Foundation/Foundation.h>
#import "RSSettableElementsData.h"
#import "RSSVListTypeData.h"
#import "RSSVBoolTypeData.h"
#import "RSSVIntegerTypeData.h"
#import "RSSVDuplexData.h"
#import "RSCustomPaperSizeListData.h"
#import "RSSVFormatData.h"
#import "RSSVSpecialModeData.h"
#import "RSSVResolutionData.h"
#import "RSSVColorModeData.h"
#import "RSSVOriginalSizeData.h"
//#import "RSSEMultiCropData.h"
#import "RSSVMultiCropData.h"

@class RemoteScanData;

@interface RemoteScanSettingViewData : NSObject
{
    RSSVColorModeData *colorMode;
    RSSVOriginalSizeData *originalSize; /** 原稿サイズ*/
    RSSVListTypeData *sendSize;     /** 保存サイズ*/
    RSSVListTypeData *rotation;
    RSSVDuplexData *duplexData;

    RSSVResolutionData *resolution;
    RSSVListTypeData *exposureMode;
    RSSVIntegerTypeData *exposureLevel;
    RSSVSpecialModeData *specialMode;
    
    RSCustomPaperSizeListData *extraSizeListData;
    RSCustomPaperSizeListData *customSizeListData;
}

// 一旦全部プロパティ化　カスタマイズが必要なものは別途実装する
@property(nonatomic, strong) RSSVColorModeData *colorMode;
@property(nonatomic, strong) RSSVOriginalSizeData *originalSize; /** 原稿サイズ*/
@property(nonatomic, strong) RSSVListTypeData *sendSize;     /** 保存サイズ*/
@property(nonatomic, strong) RSSVListTypeData *rotation;
@property(nonatomic, strong) RSSVDuplexData *duplexData;
@property(nonatomic, strong) RSSVFormatData *formatData;
@property(nonatomic, strong) RSSVResolutionData *resolution;
@property(nonatomic, strong) RSSVListTypeData *exposureMode;
@property(nonatomic, strong) RSSVIntegerTypeData *exposureLevel;
@property(nonatomic, strong) RSSVSpecialModeData *specialMode;
@property(nonatomic, strong) RSCustomPaperSizeListData *extraSizeListData;
@property(nonatomic, strong) RSCustomPaperSizeListData *customSizeListData;

- (id)initWithRSSettableElementsData:(RSSettableElementsData *)data;

- (void)createExtraSize;
- (void)createCustomSize;

// カスタムサイズ情報の保存
- (BOOL)saveCustomData:(NSMutableArray *)rsCustomPaperSizeDataList;

// ExecuteJobのGetパラメータを返却
- (NSMutableDictionary *)getExecuteJobParameter;

// 現在の設定を保存する
- (BOOL)saveRemoteScanSettings;

// 現在保存されている設定値を読み込む
- (RemoteScanData *)loadRemoteScanSettings;

// カスタムサイズの設定を更新する
- (RSSVOriginalSizeData *)reloadOriginalSize:(RSSettableElementsData *)data ManuscriptSizeIndexRow:(NSInteger)row;

// マルチクロップON時の値設定
- (void)updateRssViewDataForMultiCropOn:(RSSEFileFormatData *)rsseFileFormatData;

// マルチクロップOFF時の値設定
- (void)updateRssViewDataForMultiCropOff;

// ファイル形式の値更新(制限なしにする)
- (void)updateRssViewDataForLongSizeDeselect;

// 長尺選択時の値設定
- (void)updateRssViewDataForLongSizeSelect:(RSSEFileFormatData *)rsseFileFormatData;

@end
