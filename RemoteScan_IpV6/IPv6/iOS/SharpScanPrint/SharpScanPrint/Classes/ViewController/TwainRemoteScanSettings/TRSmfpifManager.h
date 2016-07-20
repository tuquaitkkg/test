
#import "TRSHttpCommunicationManager.h"
//#import "RSHttpCommunicationManager.h"

enum{
    TE_NEST_MFPIF_NONE,
    TE_NEST_MFPIF_VARIABLE,
    TE_NEST_MFPIF_NAME,
    TE_NEST_MFPIF_VALUE,
    TE_NEST_MFPIF_SERVICEURL,
};

@interface TRSmfpifManager : TRSHttpCommunicationManager
{
    int nNest;
    BOOL isCapableRemoteScan;
    NSString* serviceUrl;
    
    BOOL isVariableNode;
    NSString* tmpVariableName;
    NSString* tmpVariablevalue;
    
    BOOL isAddParse;
    BOOL isUpdateParse;
    BOOL isDeleteParse;
}

@property (nonatomic) BOOL isCapableRemoteScan;
@property (nonatomic, copy) NSString* serviceUrl;
@property (nonatomic, strong) NSMutableDictionary *addDic;
@property (nonatomic, strong) NSMutableDictionary *updateDic;
@property (nonatomic, strong) NSMutableDictionary *deleteDic;

// 情報取得開始
-(void)updateData;

@end
