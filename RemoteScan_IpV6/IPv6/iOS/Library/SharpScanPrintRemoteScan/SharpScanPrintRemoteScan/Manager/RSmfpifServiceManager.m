#import "RSmfpifServiceManager.h"

@implementation RSmfpifServiceManager

@synthesize portNo;
@synthesize enabledDataReceive;
@synthesize location;
@synthesize modelName;

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        baseUrl = url;
        isErr = NO;
        
        self.setOsaHttpPortGetFlag = NO;
        self.setPrintReleaseDataReceiveGetFlag = NO;
    }
    return self;
}

// 情報取得開始
- (void)updateData:(NSString *)serviceUrl
{
    NSString *postBody = @"<soap:Envelope xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><get_information xmlns='urn:schemas-sharp-jp:service:mfp-1-1'><requests>";
    if(self.setOsaHttpPortGetFlag) {
        postBody = [postBody stringByAppendingString:@"<request>/system-setting/network/security/service-control/osa-http</request>"];
        postBody = [postBody stringByAppendingString:@"<request>/system-setting/network/security/service-control/osa-http-port</request>"];
        postBody = [postBody stringByAppendingString:@"<request>/system-setting/network/security/service-control/osa-https</request>"];
        postBody = [postBody stringByAppendingString:@"<request>/system-setting/network/security/service-control/osa-https-port</request>"];
    }
    if(self.setPrintReleaseDataReceiveGetFlag) {
        postBody = [postBody stringByAppendingString:@"<request>/system-setting/admin-setting/print/printrelease/data-receive</request>"];
    }
    if(self.setLocationGetFlag) {
        postBody = [postBody stringByAppendingString:@"<request>/system-status/device/machine-config/location</request>"];
    }
    if(self.setModelNameGetFlag) {
        postBody = [postBody stringByAppendingString:@"<request>/system-status/device/machine-config/modelName</request>"];
    }
    postBody = [postBody stringByAppendingString:@"</requests></get_information></soap:Body></soap:Envelope>"];

    NSMutableDictionary *postHeader = [[NSMutableDictionary alloc] init];
    [postHeader setObject:@"POST" forKey:@"SOAPAction"];
    [self getRequestByPost:serviceUrl HttpHeader:postHeader PostBody:postBody];
}

// ダウンロード成功
- (void)compleatDownloadData
{
    // フラグの初期化
    nNest = E_NEST_MFPIFSERVICE_NONE;
    portNo = @"";

    [super compleatDownloadData];
}

// 開始タグを検出
- (void)didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"osa-http-port"])
    {
        nNest = E_NEST_MFPIFSERVICE_OSAHTTPPORT;
    } else if ([elementName isEqualToString:@"data-receive"])
    {
        nNest = E_NEST_MFPIFSERVICE_PRINTRELEASE_DATARECEIVE;
    } else if ([elementName isEqualToString:@"address"])
    {
        nNest = E_NEST_MFPIFSERVICE_LOCATION;
    } else if ([elementName isEqualToString:@"modelName"])
    {
        nNest = E_NEST_MFPIFSERVICE_MODELNAME;
    }
}

// タグ以外の文字を検出
- (void)foundCharacters:(NSString *)string
{
    if (nNest == E_NEST_MFPIFSERVICE_OSAHTTPPORT)
    {
        portNo = [string copy];
        nNest = E_NEST_MFPIFSERVICE_NONE;
    } else if (nNest == E_NEST_MFPIFSERVICE_PRINTRELEASE_DATARECEIVE)
    {
        if([string isEqual:@"enable"]) {
            enabledDataReceive = YES;
        }
        nNest = E_NEST_MFPIFSERVICE_NONE;
    } else if (nNest == E_NEST_MFPIFSERVICE_LOCATION)
    {
        location = [string copy];
    } else if (nNest == E_NEST_MFPIFSERVICE_MODELNAME)
    {
        modelName = [string copy];
    }
}

// 終了タグを検出
- (void)didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (nNest == E_NEST_MFPIFSERVICE_OSAHTTPPORT ||
        nNest == E_NEST_MFPIFSERVICE_PRINTRELEASE_DATARECEIVE ||
        nNest == E_NEST_MFPIFSERVICE_LOCATION ||
        nNest == E_NEST_MFPIFSERVICE_MODELNAME)
    {
        nNest = E_NEST_MFPIFSERVICE_NONE;
    }
}

@end
