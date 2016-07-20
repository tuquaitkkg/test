
#import "RSGetDeviceStatusManager.h"

enum
{
    E_SYSNAME_SIZE,
    E_SYSNAME_SOURCE,
    E_SYSNAME_DETECTABLEMINWIDTH,
    E_SYSNAME_DETECTABLEMINHEIGHT,
    E_SYSNAME_CURRENTMODE,
};

@implementation RSGetDeviceStatusManager

@synthesize feederSize;
@synthesize platenSize;
@synthesize currentMode;
@synthesize detectableMinWidth;
@synthesize detectableMinHeight;

// 情報取得開始
- (void)updateData
{
    feederSize = @"";
    platenSize = @"";
    currentMode = @"";
    tmpSize = nil;
    tmpSource = nil;
    ;
    NSString *requestUrl = @"mfpcommon/GetDeviceStatus/v1?res=xml";
    [self getRequest:requestUrl];
}

// ダウンロード成功
- (void)compleatDownloadData
{
    [super compleatDownloadData];
}

// 開始タグを検出
- (void)didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"original"])
    {
        //
    }
    else if ([elementName isEqualToString:@"scanInfo"])
    {
        //
    }
    else if ([elementName isEqualToString:@"property"])
    {
        NSString *sysname = [attributeDict objectForKey:@"sys-name"];
        if (sysname != nil && [sysname isEqualToString:@"Size"])
        {
            nSysName = E_SYSNAME_SIZE;
        }
        else if (sysname != nil && [sysname isEqualToString:@"Source"])
        {
            nSysName = E_SYSNAME_SOURCE;
        }
        else if (sysname != nil && [sysname isEqualToString:@"CurrentMode"])
        {
            nSysName = E_SYSNAME_CURRENTMODE;
        }
        else if (sysname != nil && [sysname isEqualToString:@"DetectableMinWidth"])
        {
            nSysName = E_SYSNAME_DETECTABLEMINWIDTH;
        }
        else if (sysname != nil && [sysname isEqualToString:@"DetectableMinHeight"])
        {
            nSysName = E_SYSNAME_DETECTABLEMINHEIGHT;
        }
    }
}

// タグ以外の文字を検出
- (void)foundCharacters:(NSString *)string
{
    if (nSysName == E_SYSNAME_SIZE)
    {
        tmpSize = [string copy];
    }
    else if (nSysName == E_SYSNAME_SOURCE)
    {
        tmpSource = [string copy];
    }
    else if (nSysName == E_SYSNAME_CURRENTMODE)
    {
        currentMode = [string copy];
    }
    else if (nSysName == E_SYSNAME_DETECTABLEMINWIDTH)
    {
        detectableMinWidth = [string copy];
    }
    else if (nSysName == E_SYSNAME_DETECTABLEMINHEIGHT)
    {
        detectableMinHeight = [string copy];
    }

    if (tmpSize != nil && tmpSource != nil)
    {
        if ([tmpSource isEqualToString:@"feeder"])
        {
            feederSize = [tmpSize copy];
        }
        else
        {
            platenSize = [tmpSize copy];
        }

        tmpSize = nil;
        tmpSource = nil;
    }
}

// 終了タグを検出
- (void)didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

@end
