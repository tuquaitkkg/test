
#import "TRSmfpifManager.h"

@implementation TRSmfpifManager

@synthesize isCapableRemoteScan;
@synthesize serviceUrl;

-(id)initWithURL:(NSURL*)url
{
    self = [super init];
    if(self){
        baseUrl = url;
        isErr = NO;
        isAddParse = NO;
        isUpdateParse = NO;
        isDeleteParse = NO;
    }
    return self;
}

// 情報取得開始
-(void)updateData
{
    NSString* requestUrl = @"mfpif.xml";
    [self getRequest:requestUrl];
}

// ダウンロード成功
-(void)compleatDownloadData
{
    // フラグの初期化
    nNest = TE_NEST_MFPIF_NAME;
    isCapableRemoteScan = NO;
    
    isVariableNode = NO;
    tmpVariableName = @"";
    tmpVariablevalue = @"";
    
    [super compleatDownloadData];
}

// 開始タグを検出
- (void) didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"variable"]) 
    {
        nNest = TE_NEST_MFPIF_VARIABLE;
        isVariableNode = YES;
    } else if ([elementName isEqualToString:@"name"])
    {
        nNest = TE_NEST_MFPIF_NAME;
    } else if ([elementName isEqualToString:@"value"])
    {
        nNest = TE_NEST_MFPIF_VALUE;
    } else if ([elementName isEqualToString:@"serviceURL"])
    {
        nNest = TE_NEST_MFPIF_SERVICEURL;
    } else if ([elementName isEqualToString:@"ADD"])
    {
        isAddParse = YES;
        self.addDic = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
    } else if ([elementName isEqualToString:@"UPDATE"])
    {
        isUpdateParse = YES;
        self.updateDic = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
    } else if ([elementName isEqualToString:@"DELETE"])
    {
        isDeleteParse = YES;
        self.deleteDic = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
        
    } else if (isAddParse)
    {
        [self.addDic setObject:[attributeDict objectForKey:@"name"] forKey:elementName];
    } else if (isUpdateParse)
    {
        [self.updateDic setObject:[attributeDict objectForKey:@"name"] forKey:elementName];
    } else if (isDeleteParse)
    {
        [self.deleteDic setObject:[attributeDict objectForKey:@"name"] forKey:elementName];
    }
    
}

// タグ以外の文字を検出
- (void) foundCharacters:(NSString *)string
{
    if(isVariableNode)
    {
        switch (nNest) {
            case TE_NEST_MFPIF_NAME:
                if(string != nil)
                {
                    tmpVariableName = [string copy];
                }
                break;
            case TE_NEST_MFPIF_VALUE:
                if(string != nil)
                {
                    tmpVariablevalue = [string copy];
                }
            default:
                break;
        }
    } else if (nNest == TE_NEST_MFPIF_SERVICEURL)
    {
        serviceUrl = [string copy];
        nNest = TE_NEST_MFPIF_NONE;
    }
}

// 終了タグを検出
- (void) didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    DLog(@"\nelementName : %@  \nnamespaceURI : %@  \nqName : %@",elementName, namespaceURI, qName);
    
    if (isVariableNode &&[elementName isEqualToString:@"variable"])// && [tmpVariableName isEqualToString:@"mobile-if"])
    {
        if ([tmpVariableName isEqualToString:@"mobile-if"] && [tmpVariablevalue isEqualToString:@"2"])
        {
            isCapableRemoteScan = YES;
        }
        nNest = TE_NEST_MFPIF_NONE;
        isVariableNode = NO;
        tmpVariableName = @"";
        tmpVariablevalue = @"";
    } else if([elementName isEqualToString:@"name"] && nNest == TE_NEST_MFPIF_NAME)
    {
        nNest = TE_NEST_MFPIF_NONE;
    } else if([elementName isEqualToString:@"value"] && nNest == TE_NEST_MFPIF_VALUE)
    {
        nNest = TE_NEST_MFPIF_NONE;
    } else if([elementName isEqualToString:@"ADD"])
    {
        isAddParse = NO;
        DLog(@"addDic \n%@",[self.addDic description]);
    } else if([elementName isEqualToString:@"UPDATE"])
    {
        isUpdateParse = NO;
        DLog(@"updateDic \n%@",[self.updateDic description]);
    } else if([elementName isEqualToString:@"DELETE"])
    {
        isDeleteParse = NO;
        DLog(@"deleteDic \n%@",[self.deleteDic description]);
    }
}

@end
