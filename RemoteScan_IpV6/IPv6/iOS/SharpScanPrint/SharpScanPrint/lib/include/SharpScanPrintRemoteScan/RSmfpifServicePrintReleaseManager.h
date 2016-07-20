#import "RSHttpCommunicationManager.h"

enum
{
    E_NEST_MFPIFSERVICE_PRINTRELEASE_NONE,
    E_NEST_MFPIFSERVICE_PRINTRELEASE_DATARECEIVE,
};

@interface RSmfpifServicePrintReleaseManager : RSHttpCommunicationManager
{
    int nNest;
    BOOL enabledDataReceive;
}

@property(nonatomic) BOOL enabledDataReceive;


- (void)updateData:(NSString *)serviceUrl;


@end
