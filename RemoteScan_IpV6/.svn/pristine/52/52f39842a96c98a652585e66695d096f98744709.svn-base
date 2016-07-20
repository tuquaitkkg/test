
#import "RSHttpCommunicationManager.h"
#import "CommonUtil.h"

@implementation RSHttpCommunicationManager
@synthesize delegate, parserDelegate, isDownloading, isErr, errCode, errMessage;

-(id)initWithURL:(NSURL*)url
{
    self = [super init];
    if(self){
        baseUrl = url;
        isErr = NO;
    }
    return self;
}

-(BOOL)disconnect;
{
    BOOL ret = NO;
    
    if(urlConnection){
        [urlConnection cancel];
        urlConnection = nil;
        ret = YES;
    }
    
    self.isDownloading = NO;
    
    return ret;
}

-(BOOL)getRequest:(NSString*)request;
{
    BOOL ret = NO;
    isErr = NO;
    
    //
    // IP アドレスチェック
    //
    NSString* ip	= @"";
    ip	= [CommonUtil getIPAdder];
    unsigned int len = [[ip stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (len <= 0){
        if(parserDelegate){
            isErr = YES;
            errCode = @"WIFI_ERROR";
            errMessage = @"wifi error";
            [parserDelegate rsManagerDidFailWithError:self];
        }

    }else if(urlConnection){
        // 接続中
    
    }else{

        // request
        NSURL *url = [NSURL URLWithString:request relativeToURL:baseUrl];
        // タイムアウト値
        NSTimeInterval timeout = 30.0;
        NSURLRequest *urlrequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeout];
        urlConnection = [NSURLConnection connectionWithRequest:urlrequest delegate:self];

        if(urlConnection){
            self.isDownloading = YES;
            ret = YES;
        }
    }
    
    
    return ret;
}

-(BOOL)getRequestByPost:(NSString*)request HttpHeader:(NSDictionary*)httpHeader PostBody:(NSString*)postBody;
{
    BOOL ret = NO;
    isErr = NO;
    
    //
    // IP アドレスチェック
    //
    NSString* ip	= @"";
    ip	= [CommonUtil getIPAdder];
    unsigned int len = [[ip stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (len <= 0){
        if(parserDelegate){
            isErr = YES;
            errCode = @"WIFI_ERROR";
            errMessage = @"wifi error";
            [parserDelegate rsManagerDidFailWithError:self];
        }
        
    }else if(urlConnection){
        // 接続中
        
    }else{
        
        // request
        NSURL *url = [NSURL URLWithString:request relativeToURL:baseUrl];
        // タイムアウト値
        NSTimeInterval timeout = 30.0;
        NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeout];
        [urlrequest setHTTPMethod:@"POST"];

        // HttpHeaderの追加
        if(httpHeader != nil)
        {
            NSArray* keys = [httpHeader allKeys];
            for(int i = 0; i < [keys count]; i++)
            {
                [urlrequest setValue:[httpHeader objectForKey:keys[i]] forHTTPHeaderField:keys[i]];
            }
        }
        
        [urlrequest setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        urlConnection = [NSURLConnection connectionWithRequest:urlrequest delegate:self];
        
        if(urlConnection){
            self.isDownloading = YES;
            ret = YES;
        }
    }
    
    
    return ret;
}

// ダウンロード成功
-(void)compleatDownloadData
{    
    // ダウンロードデータのパース
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:downloadData];
    parser.delegate = self;
    [parser parse];
}

// 通信エラー(delegate未設定時)
-(void)didFailWithNetworkError
{
    
}

-(BOOL)string:(NSString*)a isEqualToString:(NSString*)b
{
    // 大文字小文字を区別せずに比較する
    return ([a compare:b options:NSCaseInsensitiveSearch] == NSOrderedSame);
}

#pragma mark - NSURLConnectionDelegate
// ヘッダー取得
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// データを初期化
    if(downloadData){
        downloadData = nil;
    }
	downloadData = [[NSMutableData alloc] initWithData:0];
}

// ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// データを追加する
	[downloadData appendData:data];
}

// エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(delegate){
        [delegate httpCommunicationManager:self error:error];
    }
    if(parserDelegate){
        isErr = YES;
        errCode = @"NETWORK_ERROR";
        errMessage = @"network error";
        [parserDelegate rsManagerDidFailWithError:self];
    }
    else
    {
        [self didFailWithNetworkError];
    }
    
    self.isDownloading = NO;
    urlConnection = nil;
}

// ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(delegate){
        [delegate httpCommunicationManager:self responseData:downloadData];
    }else{
        [self compleatDownloadData];
    }
    
    self.isDownloading = NO;
    urlConnection = nil;
}

#pragma mark - NSXMLParserDelegate
// 開始タグを検出
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//    DLog(@"%@, %@", elementName, attributeDict);
    
    if ([elementName isEqualToString:@"error"])
    {
        currentTag = @"error";
        isErr = YES;
    }
    else if ([elementName isEqualToString:@"code"])
    {
        currentTag = @"code";
    }
    else if ([elementName isEqualToString:@"message"])
    {
        currentTag = @"message";
    }

    if(!isErr)
    {
        [self didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];        
    }
}

// タグ以外の文字を検出
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    DLog(@"%@", string);
    
    // stringから空白、改行を除く
    NSString* tmpString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 空白だったら何もしない（仮）
    if([tmpString isEqualToString:@""])
    {
        return;
    }
    
    if([currentTag isEqualToString:@"code"])
    {
        errCode = [tmpString copy];
    }
    else if([currentTag isEqualToString:@"message"])
    {
        errMessage = [tmpString copy];
    }
    
    if(!isErr)
    {
        [self foundCharacters:tmpString];        
    }

}

// 終了タグを検出
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    DLog(@"%@", elementName);
    currentTag = @"";
    if(!isErr)
    {
        [self didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];        
    }

}

// ドキュメント終了
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(!isErr)
    {
        [self parserDidEndDocument];
        // 終了
        if(parserDelegate){
            [parserDelegate rsManagerDidFinishParsing:self]; //*** ここで落ちることがある
        }
    }
    else
    {
        if(self.parserDelegate)
        {
            [parserDelegate rsManagerDidFailWithError:self];
        }
    }    
}

// エラー
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
//    DLog(@"err:%@", parseError);
    
    if(parserDelegate){
        isErr = YES;
        errCode = @"XML_PARSE_ERROR";
        errMessage = @"xml parse error";
        [parserDelegate rsManagerDidFailWithError:self];
    }
    else
    {
        [self parseErrorOccurred:parseError];
    }
}

// 以下のメソッドはサブクラスで実装する
- (void) didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{}
- (void) foundCharacters:(NSString *)string{}
- (void) didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{}
- (void) parserDidEndDocument{}
- (void) parseErrorOccurred:(NSError *)parseError{}

@end
