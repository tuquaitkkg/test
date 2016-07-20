#import "RSHttpCommunicationManager.h"

enum
{
    E_NEST_MFPIFSERVICE_NONE,
    E_NEST_MFPIFSERVICE_OSAHTTPPORT,
    E_NEST_MFPIFSERVICE_PRINTRELEASE_DATARECEIVE,
    E_NEST_MFPIFSERVICE_LOCATION,
    E_NEST_MFPIFSERVICE_MODELNAME,
};

@interface RSmfpifServiceManager : RSHttpCommunicationManager
{
    int nNest;
    NSString *portNo;
    BOOL enabledDataReceive;
    NSString* location;
    NSString* modelName;
}

@property(nonatomic, copy) NSString *portNo;
@property(nonatomic) BOOL enabledDataReceive;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *modelName;

@property(nonatomic) BOOL setOsaHttpPortGetFlag;
@property(nonatomic) BOOL setPrintReleaseDataReceiveGetFlag;
@property(nonatomic) BOOL setLocationGetFlag;
@property(nonatomic) BOOL setModelNameGetFlag;

- (void)updateData:(NSString *)serviceUrl;

@end
