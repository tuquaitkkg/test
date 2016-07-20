
#import "RemoteScanDataManager.h"

@implementation RemoteScanDataManager

static RemoteScanDataManager *remoteScanDataManager = nil;

+ (RemoteScanDataManager *)sharedManager
{
    @synchronized(self)
    {
        if (remoteScanDataManager == nil)
        {
            remoteScanDataManager = [[self alloc] init];
        }
    }
    return remoteScanDataManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (remoteScanDataManager == nil)
        {
            remoteScanDataManager = [super allocWithZone:zone];
            return remoteScanDataManager;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//- (id)retain {
//    DLog(@"!!! このクラスはシングルトンパターンを採用しています。reainしないでください。");
//    return self;
//}
//
//- (unsigned)retainCount {
//    return UINT_MAX;
//}
//
//- (oneway void)release {
//    DLog(@"!!! このクラスはシングルトンパターンを採用しています。releaseしないでください。");
//}
//
//- (id)autorelease {
//    DLog(@"!!! このクラスはシングルトンパターンを採用しています。autoreleaseしないでください。");
//    return self;
//}

// 読み込み済みのデータを利用する
- (RemoteScanData *)sharedRemoteScanSettings
{
    if (!data)
    {
        // 読み込まれていない場合は読み込む
        [self loadRemoteScanSettings];
    }
    return data;
}

// 現在保存されている設定値を読み込む
- (RemoteScanData *)loadRemoteScanSettings
{
    // 自動解放プールの作成
    @autoreleasepool
    {
        @try
        {
            // 読み込む
            NSString *fileName = [RSCommonUtil.settingFileDir stringByAppendingString:S_REMOTESCANSETTING_DAT];

            // initWithCoder が call される
            data = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
            //        DLog(@"data:%@", data);
            if (!data)
            {
                data = [[RemoteScanData alloc] init];
            }
        }
        @finally
        {
        }
    }

    return data;
}

// 設定を保存する
- (BOOL)saveRemoteScanSettings:(NSDictionary *)dic
{
    BOOL ret = YES;
    // 自動解放プールの作成
    @autoreleasepool
    {
        @try
        {
            RemoteScanData *rsd = [[RemoteScanData alloc] init];

            // 値を格納
            rsd.colorMode = [dic objectForKey:@"ColorMode"];
            rsd.originalSize = [dic objectForKey:@"OriginalSize"];
            rsd.ManualSizeX = [dic objectForKey:@"ManualSizeX"];
            rsd.ManualSizeY = [dic objectForKey:@"ManualSizeY"];
            rsd.ManualSizeName = [dic objectForKey:@"ManualSizeName"];
            rsd.sendSize = [dic objectForKey:@"SendSize"];
            rsd.rotation = [dic objectForKey:@"Rotation"];
            rsd.duplexMode = [dic objectForKey:@"DuplexMode"];
            rsd.duplexDir = [dic objectForKey:@"DuplexDir"];
            rsd.fileFormat = [dic objectForKey:@"FileFormat"];
            rsd.compression = [dic objectForKey:@"Compression"];
            rsd.compressionRatio = [dic objectForKey:@"CompressionRatio"];
            rsd.pagesPerFile = [dic objectForKey:@"PagesPerFile"];
            rsd.pdfPassword = [dic objectForKey:@"PdfPassword"];
            rsd.resolution = [dic objectForKey:@"Resolution"];
            rsd.exposureMode = [dic objectForKey:@"ExposureMode"];
            rsd.exposureLevel = [dic objectForKey:@"ExposureLevel"];
            rsd.specialMode = [dic objectForKey:@"SpecialMode"];
            rsd.selectColorMode = [dic objectForKey:@"SelectColorMode"];
            rsd.useOCR = [dic objectForKey:@"UseOCR"];
            rsd.ocrLanguage = [dic objectForKey:@"OCRLanguage"];
            rsd.ocrOutputFont = [dic objectForKey:@"OCROutputFont"];
            rsd.correctImageRotation = [dic objectForKey:@"CorrectImageRotation"];
            rsd.extractFileName = [dic objectForKey:@"ExtractFileName"];
            rsd.ocrAccuracy = [dic objectForKey:@"OCRAccuracy"];

            // リモートスキャン設定値の保存
            NSString *fileName = [RSCommonUtil.settingFileDir stringByAppendingString:S_REMOTESCANSETTING_DAT];

            // encodeWithCoder が call される
            if (![NSKeyedArchiver archiveRootObject:rsd toFile:fileName])
            {
                ret = NO;
            }
            else
            {
                // データを更新する
                [self loadRemoteScanSettings];
            }
        }
        @finally
        {
        }
    }

    return ret;
}

// 設定の削除
- (BOOL)removeRemoteScanSettings
{
    BOOL ret = YES;
    NSString *fileName = [RSCommonUtil.settingFileDir stringByAppendingString:S_REMOTESCANSETTING_DAT];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err = nil;
    if ([fm fileExistsAtPath:fileName])
    {
        [fm removeItemAtPath:fileName error:&err];
        if (err)
        {
            DLog(@"ERR:%@", err);
            ret = NO;
        }
        else
        {
            if (data)
            {
                data = nil;
            }
        }
    }
    return ret;
}

@end
