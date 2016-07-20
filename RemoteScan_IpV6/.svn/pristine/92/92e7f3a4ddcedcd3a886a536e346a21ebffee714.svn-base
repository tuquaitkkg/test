
#import "RSmfpifManager.h"

@implementation RSmfpifManager
{
    BOOL isFinishSyncingTask;
}

@synthesize isCapableRemoteScan;
@synthesize isCapableNovaLight;
@synthesize isCapableNetScan;
@synthesize isCapableOfficePrint;
@synthesize isCapablePrintRelease;
@synthesize ooxmlPrintVersion;
@synthesize serviceUrl;

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        baseUrl = url;
        isErr = NO;
        isAddParse = NO;
        isUpdateParse = NO;
        isDeleteParse = NO;
    }
    return self;
}

// 情報取得開始
- (BOOL)updateData
{
    NSString *requestUrl = @"mfpif.xml";
    return [self getRequest:requestUrl];
}

- (RSmfpifManager*)updateDataForSync
{
    parserDelegate = self;
    isFinishSyncingTask = NO;
    
    NSString *requestUrl = @"mfpif.xml";
    BOOL ret = [self getRequest:requestUrl];
    if(!ret) {
        return self;
    }
    
    while (isFinishSyncingTask == NO) {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
    }
    
    return self;
}

// ダウンロード成功
- (void)compleatDownloadData
{
    // フラグの初期化
    nNest = E_NEST_MFPIF_NAME;
    isCapableRemoteScan = NO;
    isCapableNetScan = NO;
    isCapableNovaLight = NO;
    isCapableOfficePrint = NO;
    isCapablePrintRelease = NO;
    ooxmlPrintVersion = @"";
    isVariableNode = NO;
    tmpVariableName = @"";
    tmpVariablevalue = @"";

    [super compleatDownloadData];
}

// 開始タグを検出
- (void)didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"variable"])
    {
        nNest = E_NEST_MFPIF_VARIABLE;
        isVariableNode = YES;
    }
    else if ([elementName isEqualToString:@"name"])
    {
        nNest = E_NEST_MFPIF_NAME;
    }
    else if ([elementName isEqualToString:@"value"])
    {
        nNest = E_NEST_MFPIF_VALUE;
    }
    else if ([elementName isEqualToString:@"serviceURL"])
    {
        nNest = E_NEST_MFPIF_SERVICEURL;
    }
    else if ([elementName isEqualToString:@"ADD"])
    {
        isAddParse = YES;
        self.addDic = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
    }
    else if ([elementName isEqualToString:@"UPDATE"])
    {
        isUpdateParse = YES;
        self.updateDic = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
    }
    else if ([elementName isEqualToString:@"DELETE"])
    {
        isDeleteParse = YES;
        self.deleteDic = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
    }
    else if (isAddParse)
    {
        [self.addDic setObject:[attributeDict objectForKey:@"name"] forKey:elementName];
    }
    else if (isUpdateParse)
    {
        [self.updateDic setObject:[attributeDict objectForKey:@"name"] forKey:elementName];
    }
    else if (isDeleteParse)
    {
        [self.deleteDic setObject:[attributeDict objectForKey:@"name"] forKey:elementName];
    }
}

// タグ以外の文字を検出
- (void)foundCharacters:(NSString *)string
{
    if (isVariableNode)
    {
        switch (nNest)
        {
        case E_NEST_MFPIF_NAME:
            if (string != nil)
            {
                tmpVariableName = [string copy];
            }
            break;
        case E_NEST_MFPIF_VALUE:
            if (string != nil)
            {
                tmpVariablevalue = [string copy];
            }
        default:
            break;
        }
    }
    else if (nNest == E_NEST_MFPIF_SERVICEURL)
    {
        serviceUrl = [string copy];
        nNest = E_NEST_MFPIF_NONE;
    }
}

// 終了タグを検出
- (void)didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    DLog(@"\nelementName : %@  \nnamespaceURI : %@  \nqName : %@", elementName, namespaceURI, qName);

    if (isVariableNode && [elementName isEqualToString:@"variable"]) // && [tmpVariableName isEqualToString:@"mobile-if"])
    {
        if ([tmpVariableName isEqualToString:@"mobile-if"] && [tmpVariablevalue isEqualToString:@"2"])
        {
            isCapableRemoteScan = YES;
        }
        nNest = E_NEST_MFPIF_NONE;

        if ([tmpVariableName isEqualToString:@"mobile-if"] && [tmpVariablevalue isEqualToString:@"3"])
        {
            isCapableNovaLight = YES;
        }
        if ([tmpVariableName isEqualToString:@"netscan"] && [tmpVariablevalue isEqualToString:@"true"])
        {
            isCapableNetScan = YES;
        }
        if ([tmpVariableName isEqualToString:@"ooxml-print"] && [tmpVariablevalue isEqualToString:@"true"])
        {
            isCapableOfficePrint = YES;
        }
        if ([tmpVariableName isEqualToString:@"ooxml-print-version"])
        {
            ooxmlPrintVersion = [tmpVariablevalue copy];
        }
        if ([tmpVariableName isEqualToString:@"printrelease"] && [tmpVariablevalue isEqualToString:@"true"])
        {
            isCapablePrintRelease = YES;
        }
    }
    else if ([elementName isEqualToString:@"name"] && nNest == E_NEST_MFPIF_NAME)
    {
        nNest = E_NEST_MFPIF_NONE;
    }
    else if ([elementName isEqualToString:@"value"] && nNest == E_NEST_MFPIF_VALUE)
    {
        nNest = E_NEST_MFPIF_NONE;
    }
    else if ([elementName isEqualToString:@"ADD"])
    {
        isAddParse = NO;
        DLog(@"addDic \n%@", [self.addDic description]);
    }
    else if ([elementName isEqualToString:@"UPDATE"])
    {
        isUpdateParse = NO;
        DLog(@"updateDic \n%@", [self.updateDic description]);
    }
    else if ([elementName isEqualToString:@"DELETE"])
    {
        isDeleteParse = NO;
        DLog(@"deleteDic \n%@", [self.deleteDic description]);
    }

    if ([elementName isEqualToString:@"variable"])
    {
        isVariableNode = NO;
    }
}

#pragma mark - parserDelegate
- (void)rsManagerDidFinishParsing:(id)manager
{
    isFinishSyncingTask = YES;
}
- (void)rsManagerDidFailWithError:(id)manager
{
    isFinishSyncingTask = YES;
}

@end
