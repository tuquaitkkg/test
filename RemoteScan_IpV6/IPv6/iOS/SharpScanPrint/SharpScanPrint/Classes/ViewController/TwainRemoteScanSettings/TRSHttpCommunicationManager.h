
#import <Foundation/Foundation.h>

@class TRSHttpCommunicationManager;

@protocol TRSHttpCommunicationManagerDelegate
@optional
-(void)httpCommunicationManager:(TRSHttpCommunicationManager*)manager responseData:(NSData*)data;
-(void)httpCommunicationManager:(TRSHttpCommunicationManager*)manager error:(NSError*)error;
@end

@protocol TRSManagerDelegate
@optional
-(void)rsManagerDidFinishParsing:(id)manager;
-(void)rsManagerDidFailWithError:(id)manager;
@end

@interface TRSHttpCommunicationManager : NSObject <NSURLConnectionDelegate, NSXMLParserDelegate>
{
    NSObject<TRSHttpCommunicationManagerDelegate>* __unsafe_unretained delegate;
    NSObject<TRSManagerDelegate>* __unsafe_unretained parserDelegate;
    
    NSString* ipAddress;
    int port;
    NSURL* baseUrl;
    NSURLConnection* urlConnection;
    NSMutableData* downloadData;
    
    BOOL isDownloading;
    
    BOOL isErr;
    NSString* errCode;
    NSString* errMessage;
    
    NSString* currentTag;
}

@property (nonatomic, unsafe_unretained) NSObject* delegate;
@property (nonatomic, unsafe_unretained) NSObject* parserDelegate;
@property (nonatomic) BOOL isDownloading;
@property (nonatomic) BOOL isErr;
@property (nonatomic) NSString* errCode;
@property (nonatomic) NSString* errMessage;

-(id)initWithURL:(NSURL*)url;
-(BOOL)disconnect;
-(BOOL)getRequest:(NSString*)request;
-(BOOL)getRequestByPost:(NSString*)request HttpHeader:(NSDictionary*)httpHeader PostBody:(NSString*)postBody;
-(BOOL)string:(NSString*)a isEqualToString:(NSString*)b;
-(void)compleatDownloadData;

// 以下のメソッドはサブクラスで実装する
- (void) didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void) foundCharacters:(NSString *)string;
- (void) didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void) parserDidEndDocument;
- (void) parseErrorOccurred:(NSError *)parseError;
@end
