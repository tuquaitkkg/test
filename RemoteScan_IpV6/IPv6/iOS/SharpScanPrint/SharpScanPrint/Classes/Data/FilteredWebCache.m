
#import "FilteredWebCache.h"

@implementation FilteredWebCache
@synthesize bImageOff;

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    
    if(bImageOff){
        NSURL *URL = [request URL];
        
        NSURLResponse *response = [[NSURLResponse alloc]initWithURL:URL
                                                           MIMEType:@"text/plain"
                                              expectedContentLength:1
                                                   textEncodingName:nil];
        
        NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc]initWithResponse:response data:[NSData dataWithBytes:"" length:1]];
        
        [super storeCachedResponse:cachedResponse forRequest:request];
        
        
    }
    return [super cachedResponseForRequest:request];
}
@end
