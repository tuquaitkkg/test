
#import <Foundation/Foundation.h>

@interface NSStream (MyAdditions)

+ (void)getStreamsToHostNamed:(NSString *)hostName 
                         port:(NSInteger)port 
                  inputStream:(NSInputStream **)inputStreamPtr 
                 outputStream:(NSOutputStream **)outputStreamPtr;

@end
