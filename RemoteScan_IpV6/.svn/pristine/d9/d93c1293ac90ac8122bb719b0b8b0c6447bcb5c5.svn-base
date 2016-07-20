
#import "RSHttpCommunicationManager.h"

enum
{
    E_NEST_MFPIF_NONE,
    E_NEST_MFPIF_VARIABLE,
    E_NEST_MFPIF_NAME,
    E_NEST_MFPIF_VALUE,
    E_NEST_MFPIF_SERVICEURL,
};

@interface RSmfpifManager : RSHttpCommunicationManager <RSManagerDelegate>
{
    int nNest;
    BOOL isCapableRemoteScan;
    BOOL isCapableNetScan;
    BOOL isCapableNovaLight;
    BOOL isCapableOfficePrint;
    BOOL isCapablePrintRelease;
    NSString *ooxmlPrintVersion;
    NSString *serviceUrl;

    BOOL isVariableNode;
    NSString *tmpVariableName;
    NSString *tmpVariablevalue;

    BOOL isAddParse;
    BOOL isUpdateParse;
    BOOL isDeleteParse;
}

@property(nonatomic) BOOL isCapableRemoteScan;
@property(nonatomic) BOOL isCapableNetScan;
@property(nonatomic) BOOL isCapableNovaLight;
@property(nonatomic) BOOL isCapableOfficePrint;
@property(nonatomic) BOOL isCapablePrintRelease;
@property(nonatomic, copy) NSString *ooxmlPrintVersion;
@property(nonatomic, copy) NSString *serviceUrl;
@property(nonatomic, strong) NSMutableDictionary *addDic;
@property(nonatomic, strong) NSMutableDictionary *updateDic;
@property(nonatomic, strong) NSMutableDictionary *deleteDic;

// 情報取得開始
- (BOOL)updateData;

// 情報取得開始（同期処理　通信が終わるまで待ちます）
- (RSmfpifManager*)updateDataForSync;
@end
