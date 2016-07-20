
#import "PJLDataManager.h"
#import "CommonUtil.h"
#import "Define.h"
#import "PrintRangeSettingViewController.h"

@implementation PJLDataManager

@synthesize BaseDir = m_pstrBaseDir;

- (id)init
{
    if ((self = [super init]) == nil)
	{
        return nil;
    }
    
	// ホームディレクトリ/Documments の取得
	self.BaseDir = [CommonUtil tmpDir];
    
    return self;
}


// PJLData作成
- (NSString*)CreatePJLData:(NSInteger)nNumOfSets     // 部数
                      Side:(NSInteger)nSide          // 片面/両面
                 ColorMode:(NSInteger)nColormode     // カラーモード
                 PaperSize:(NSString*)pstrPapersize     // 用紙サイズ
                 PaperType:(NSString*)pstrPapertype     // 用紙タイプ
               Orientation:(NSInteger)nOrientation           // 印刷の向き(未使用)
            PrintRangeInfo:(PrintRangeSettingViewController*)printRangeInfo   // 印刷範囲情報
               PrintTarget:(NSInteger)printTarget           // 印刷対象
             RetentionHold:(BOOL)bRetentionHold                 // リテンション(ホールドする/しない)
             RetentionAuth:(BOOL)bRetentionAuth                 // リテンション(認証 あり/なし)
         RetentionPassword:(NSString*)pstrRetentionPassword     // リテンション(パスワード)
                 Finishing:(STAPLE)staple               // 仕上げ(ステープル対応/非対応)
                ClosingRow:(NSInteger)nClosingRow       // とじ位置(左とじ/右とじ/上とじ)
                    Staple:(NSString*)pstrStaple        // ステープル(なし/1箇所とじ/2箇所とじ/針なしステープル)
                  CanPunch:(PunchData*)punchData        // パンチ可否
                     Punch:(NSString*)pstrPunch         // パンチ(2穴/3穴/4穴/4穴(幅広))
                    NupRow:(NSInteger)nNupRow        // N-Up(1-Up/2-Up/4-Up)
                    SeqRow:(NSInteger)nSeqRow        // 順序
                IsVertical:(BOOL)isVertical          // 縦/横フラグ
                  FilePath:(NSString*)pstrFilePath   // 送信ファイルパス
                   JobName:(NSString*)pstrJobName   // ジョブ名
              PrintRelease:(NSInteger)printRelease; // プリントリリース

{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSString* uuid = [[CommonUtil CreatUUID] copy];
    //NSString* uuid = @"PJLDATA";
    
    //uuidをPJLファイルのファイル名とし、フルパス生成
    NSString* pjlFilepath = [self.BaseDir stringByAppendingFormat:@"/%@", uuid];
    
    // PJLファイルが存在する場合は削除
    if ([fileMgr fileExistsAtPath:pjlFilepath isDirectory:NO] == YES)
    {
        // ToDo:エラーはとるようにする
        [fileMgr removeItemAtPath:pjlFilepath error:nil];
    }
    
    // PJLファイル新規作成
    [fileMgr createFileAtPath:pjlFilepath contents:nil attributes:nil];
    
    NSFileHandle* outFileHandle = [NSFileHandle fileHandleForWritingAtPath:pjlFilepath];
    
    // PJL書込み情報作成
    NSInteger asccEsc = N_PJL_ESC;
    NSString *strEsc = [NSString stringWithFormat:@"%c",(char)asccEsc];
    NSData* escData = [strEsc dataUsingEncoding:NSUTF8StringEncoding];
    
    // ジョブ名(元ファイル名)
    NSString* pstrJobFileName = [pstrJobName lastPathComponent];
//    NSString* pstrJobFileName = [pstrFilePath lastPathComponent];
    
    // ファイル名
    NSString* pstrFileName = [pstrFilePath lastPathComponent];
    
    // 送信ファイル
    NSFileHandle* fhdlSend = [NSFileHandle fileHandleForReadingAtPath:pstrFilePath];
    
    // Sharp MFPからのスキャンデータ確認
    NSData* pdfHeader = nil;
    if([CommonUtil pdfExtensionCheck:pstrFilePath])
    {
        [fhdlSend seekToFileOffset:0L];
        @try
        {
            NSData* sharpPdfHeader = [S_PDF_SHARP_SCANHEADER dataUsingEncoding:NSUTF8StringEncoding];
            
            pdfHeader = [fhdlSend readDataOfLength:[sharpPdfHeader length]];
            if ([pdfHeader isEqualToData:sharpPdfHeader]) 
            {
                //pdfHeader = [S_PDF_SHARP_SCANHEADER_DUMMY dataUsingEncoding:NSUTF8StringEncoding];
            }
            else
            {
                pdfHeader = nil;
            }
        }
        @catch(id error)
        {
            pdfHeader = nil;
        }
        
        if (nil ==pdfHeader)
        {
            [fhdlSend seekToFileOffset:0L];
        }
    }
    
//    // 確認用
//    DLog(@"--- PJL中身確認START: ---\n");
//    DLog(@"\n%@",[self CreatePJLHeaderStart]);
//    DLog(@"\n%@",[self CreatePJLHeader:pstrJobFileName]);
//    DLog(@"\n%@",[self CreatePJLHeaderUtf8:pstrJobFileName]);
//    DLog(@"\n%@",[self CreatePJLSpoolTime]);
//    DLog(@"\n%@",[self CreatePJLUserName]);
//    DLog(@"\n%@",[self CreatePJLHeader:pstrFileName
//                           NumOfSets:nNumOfSets
//                                Side:nSide
//                           ColorMode:nColormode
//                           PaperSize:pstrPapersize
//                         Orientation:nOrientation
//                      PrintRangeInfo:printRangeInfo
//                       RetentionHold:bRetentionHold
//                       RetentionAuth:bRetentionAuth
//                   RetentionPassword:pstrRetentionPassword
//                              NupRow:nNupRow
//                              SeqRow:nSeqRow
//                          IsVertical:isVertical
//                        pstrFilePath:pstrFilePath]);
//    DLog(@"--- PJL中身確認END: ---\n");
    // PJLヘッダ
    NSData* headerData1 = [[self CreatePJLHeaderStart]dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* headerData2 = [[self CreatePJLHeader:pstrJobFileName]dataUsingEncoding:[CommonUtil getStringEncodingById:S_LANG]];
    
    NSData* headerData3 = [[self CreatePJLHeaderUtf8:pstrJobFileName]dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* headerData4 = [[self CreatePJLSpoolTime]dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* headerData5 = [[self CreatePJLUserName]dataUsingEncoding:[CommonUtil getStringEncodingById:S_LANG]];
    
    NSData* headerData6 = [[self CreatePJLHeader:pstrFileName 
                                       NumOfSets:nNumOfSets 
                                            Side:nSide
                                       ColorMode:nColormode
                                       PaperSize:pstrPapersize
                                       PaperType:pstrPapertype
                                     Orientation:nOrientation
                                  PrintRangeInfo:printRangeInfo
                                     PrintTarget:printTarget
                                   RetentionHold:bRetentionHold
                                   RetentionAuth:bRetentionAuth
                               RetentionPassword:pstrRetentionPassword
                                       Finishing:staple
                                      ClosingRow:nClosingRow
                                          Staple:pstrStaple
                                        CanPunch:punchData
                                           Punch:pstrPunch
                                          NupRow:nNupRow
                                          SeqRow:nSeqRow
                                      IsVertical:isVertical
                                    pstrFilePath:pstrFilePath
                            PrintRelease:printRelease]
                           dataUsingEncoding:NSUTF8StringEncoding];
    
    // PJLフッタ
    NSData* footerData = [[self CreatePJLFooter:pstrFileName] dataUsingEncoding:[CommonUtil getStringEncodingById:S_LANG]];
    
    // PJL終端
    NSString* pstrEnd = S_PJL_JOB;
    NSData* endData = [pstrEnd dataUsingEncoding:NSUTF8StringEncoding];
    
    // PJLファイル書込み
    [outFileHandle writeData:escData];      // エスケープシーケンス
    [outFileHandle writeData:headerData1];   // ヘッダ
    [outFileHandle writeData:headerData2];   // ヘッダ
    [outFileHandle writeData:headerData3];   // ヘッダ
    [outFileHandle writeData:headerData4];   // ヘッダ
    [outFileHandle writeData:headerData5];   // ヘッダ
    [outFileHandle writeData:headerData6];   // ヘッダ
    if (nil != pdfHeader)
    {
        [outFileHandle writeData:pdfHeader]; // 送信ファイル(PDFヘッダ)
    }
    
    // 送信ファイル
    // 100MB越えの大きなファイル対応の為に分割して書き込む
    UInt64 offset = 0;
    [fhdlSend seekToFileOffset:offset];

    UInt32 chunkSize = 1024000;     //Read 1MB chunks.
    bool sizeCheck;

    do {
        sizeCheck = NO;
        @autoreleasepool
        {
            NSData *sendData = [fhdlSend readDataOfLength:chunkSize];
            
            if ([sendData length] > 0) {
                // 取得したデータを書き込む
                [outFileHandle writeData:sendData];
                sizeCheck = YES;
            }
            
            
            offset += [sendData length];
            
            DLog(@"offset:%llu",offset);
            [fhdlSend seekToFileOffset:offset];
        }
        
    } while (sizeCheck);
    
    [outFileHandle writeData:escData];      // エスケープシーケンス
    [outFileHandle writeData:footerData];   // フッタ
    [outFileHandle writeData:escData];      // エスケープシーケンス
    [outFileHandle writeData:endData];      // 終端
    
    // FileHandle Close
    [fhdlSend closeFile];
    [outFileHandle closeFile];
    
    return pjlFilepath;
}

//データ→文字列
- (NSString*)data2str:(NSData*)data {
    return [[NSString alloc] initWithData:data 
                                  encoding:NSUTF8StringEncoding];
}

// PJLヘッダー作成
- (NSString*)CreatePJLHeaderStart
{
    // PJLの決まり事
    NSString* pstrHeader = S_PJL_JOB;
    return pstrHeader;
}

// PJLヘッダー作成
- (NSString*)CreatePJLHeader:(NSString*)pstrFileName   // ファイル名
{
    // ログインデータの取得
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    NSString* pstrHeader;
    NSString* pstrJobAddr;
    
    //長いファイル名(80バイト超えるとき）は80バイトに切り捨てる
    NSString* pstrFileName80orLess = [CommonUtil trimString:pstrFileName halfCharNumber:80];
    
    
    // @PJL JOB NAME
    if([profileData.jobName length] > 0)
    {
        pstrJobAddr = [[NSString alloc]initWithFormat:S_PJL_JOB_NAME_ADDR, profileData.jobName];
    }else
    {
        pstrJobAddr = [[NSString alloc]initWithFormat:S_PJL_JOB_NAME_ADDR, pstrFileName80orLess];
    }
    
    pstrHeader = [[NSString alloc]initWithFormat:S_PJL_JOB_NAME, pstrJobAddr];
    
    // @PJL SET JOB NAME(ジョブ名称)
    if([profileData.jobName length] > 0)
    {
        pstrHeader = [pstrHeader stringByAppendingFormat:S_PJL_SET_JOB_NAME, profileData.jobName];
    }else
    {
        pstrHeader = [pstrHeader stringByAppendingFormat:S_PJL_SET_JOB_NAME, pstrFileName80orLess];
    }
    
    return pstrHeader;
}

// PJLヘッダー作成
- (NSString*)CreatePJLHeaderUtf8:(NSString*)pstrFileName   // ファイル名
{
    // ログインデータの取得
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    NSString* pstrHeader;
    
    
    //長いファイル名(80バイト超えるとき）は80バイトに切り捨てる
    NSString* pstrFileName80orLess = [CommonUtil trimString:pstrFileName halfCharNumber:80];
    
    
    // @PJL SET JOB NAME(ジョブ名称)
    if([profileData.jobName length] > 0)
    {
        pstrSpoolKey = [self GetSpoolTime];
        pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_JOB_NAMEW, profileData.jobName];
    }else
    {
        pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_JOB_NAMEW, pstrFileName80orLess];
    }
    
    return pstrHeader;
}

// PJLヘッダー作成
- (NSString*)CreatePJLSpoolTime
{
    // プロファイルデータの取得
    profileDataManager = [[ProfileDataManager alloc] init];
//    ProfileData *profileData = [profileDataManager loadProfileDataAtIndex:0];
//    DLog(@"%@",profileData);
    NSString* pstrHeader;
    // @PJL SET SPOOLTIME(SpoolTime)
    NSString* pstrSpooltime = [self GetSpoolTime];
    pstrSpoolKey = pstrSpooltime;
    pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_SPOOLTIME, pstrSpooltime];
    
    return pstrHeader;
}
// PJLヘッダー作成
- (NSString*)CreatePJLUserName  // ファイル名
{
    // プロファイルデータの取得
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    NSString* pstrHeader;
    
    if (!profileData.bUseLoginNameForUserName) {
        // ユーザー名にログイン名を指定するがオフ
        if ([profileData.userName length] > 0) {
            // ユーザー名をそのままセット
            // @PJL SET USER NAME (ユーザー名称にログイン名を設定)
            pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_USER_NAME, profileData.userName];
        } else {
            // @PJL SET USER NAME(ユーザー名称)
            pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_USER_NAME, S_PJL_SET_USER_NAME_DEFAULT];
        }
    } else {
        // ユーザー名にログイン名を指定するがオン
        if ([profileData.loginName length] > 0) {
            // ログイン名の頭32
            NSString *decryptLoginName = [CommonUtil decryptString:[CommonUtil base64Decoding:profileData.loginName] withKey:S_KEY_PJL];
            DLog(@"decryptLoginName: %@", decryptLoginName);
            if([decryptLoginName length] > 32) {
                decryptLoginName = [decryptLoginName substringToIndex:32];
            }
            pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_USER_NAME, decryptLoginName];
            DLog(@"pstrHeader: %@", pstrHeader);
        } else {
            // @PJL SET USER NAME(ユーザー名称)
            pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_USER_NAME, S_PJL_SET_USER_NAME_DEFAULT];
        }
        
    }
    
    return pstrHeader;
}

// PJLヘッダ作成
- (NSString*)CreatePJLHeader:(NSString*)pstrFileName   // ファイル名
                   NumOfSets:(NSInteger)nNumOfSets     // 部数
                        Side:(NSInteger)nSide          // 片面/両面
                   ColorMode:(NSInteger)nColormode     // カラーモード
                   PaperSize:(NSString*)pstrPapersize     // 用紙サイズ
                   PaperType:(NSString*)pstrPapertype     // 用紙タイプ
                 Orientation:(NSInteger)nOrientation           // N-Up
              PrintRangeInfo:(PrintRangeSettingViewController*)printRangeInfo   // 印刷範囲情報
                 PrintTarget:(NSInteger)printTarget         // 印刷対象
               RetentionHold:(BOOL)bRetentionHold                 // リテンション(ホールドする/しない)
               RetentionAuth:(BOOL)bRetentionAuth                 // リテンション(認証 あり/なし)
           RetentionPassword:(NSString*)pstrRetentionPassword     // リテンション(パスワード)
                   Finishing:(STAPLE)staple               // 仕上げ(ステープル対応/非対応)
                  ClosingRow:(NSInteger)nClosingRow       // とじ位置(左とじ/右とじ/上とじ)
                    Staple:(NSString*)pstrStaple        // ステープル(なし/1箇所とじ/2箇所とじ/針なしステープル)
                    CanPunch:(PunchData*)punchData      // パンチ可否
                       Punch:(NSString*)pstrPunch       // パンチ(2穴/3穴/4穴/4穴(幅広))
                      NupRow:(NSInteger)nNupRow        // N-Up(1-Up/2-Up/4-Up)
                      SeqRow:(NSInteger)nSeqRow        // 順序
                  IsVertical:(BOOL)isVertical          // 縦/横フラグ
                pstrFilePath:(NSString*)pstrFilePath   // ファイルパス
                PrintRelease:(NSInteger)printRelease   // プリントリリース
{
    // プロファイルデータの取得
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = nil;
    profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    NSString* pstrHeader;
    
    if (!profileData.bUseLoginNameForUserName) {
        // ユーザー名にログイン名を指定するがオフ
        if ([profileData.userName length] > 0) {
            // ユーザー名をそのままセット
            // @PJL SET USER NAME (ユーザー名称にログイン名を設定)
            pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_USER_NAMEW, profileData.userName];
        } else {
            // @PJL SET USER NAME(ユーザー名称)
            pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_USER_NAMEW, S_PJL_SET_USER_NAME_DEFAULT];
        }
    } else {
        // ユーザー名にログイン名を指定するがオン
        if ([profileData.loginName length] > 0) {
            // ログイン名の頭32
            NSString *decryptLoginName = [CommonUtil decryptString:[CommonUtil base64Decoding:profileData.loginName] withKey:S_KEY_PJL];
            DLog(@"decryptLoginName: %@", decryptLoginName);
            pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_USER_NAMEW, [CommonUtil trimString:decryptLoginName halfCharNumber:32]];
            DLog(@"pstrHeader: %@", pstrHeader);
        } else {
            // @PJL SET USER NAME(ユーザー名称)
            pstrHeader = [[NSString alloc]initWithFormat:S_PJL_SET_USER_NAMEW, S_PJL_SET_USER_NAME_DEFAULT];
        }
        
    }
    
    // @PJL SET OUTBIN(出力ビン)
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_OUTBIN, S_PJL_SET_OUTBIN_AUTO]];

    // N-upの指定
    NSString *pageImageInfo = nil;
    NSString *pageNupOrderInfo = nil;
    if(nNupRow == 1){
        // 2-UP
        pageImageInfo = S_PJL_SET_PAGEIMAGEINFO_TWOUP;
        if(isVertical) {
            if(nSeqRow == 1){
                pageNupOrderInfo = S_PJL_SET_PAGENUPORDERINFO_RIGHT_TO_LEFT;
            } else{
                // nSeqRow == 0
                pageNupOrderInfo = S_PJL_SET_PAGENUPORDERINFO_LEFT_TO_RIGHT;
            }
        }else{
            pageNupOrderInfo = S_PJL_SET_PAGENUPORDERINFO_TOP_TO_BOTTOM;
        }
    } else if(nNupRow == 2){
        // 4-UP
        pageImageInfo = S_PJL_SET_PAGEIMAGEINFO_FOURUP;
        if(nSeqRow == 1){
            pageNupOrderInfo = S_PJL_SET_PAGENUPORDERINFO_UPPERLEFT_TO_BOTTOM;
        } else if(nSeqRow == 2){
            pageNupOrderInfo = S_PJL_SET_PAGENUPORDERINFO_UPPERRIGHT_TO_LEFT;
        } else if(nSeqRow == 3){
            pageNupOrderInfo = S_PJL_SET_PAGENUPORDERINFO_UPPERRIGHT_TO_BOTTOM;
        } else{
            // nSeqRow == 0
            pageNupOrderInfo = S_PJL_SET_PAGENUPORDERINFO_UPPERLEFT_TO_RIGHT;
        }
    } else{
        // 1-UP
        pageImageInfo = S_PJL_SET_PAGEIMAGEINFO_ONEUP;
        pageNupOrderInfo = S_PJL_SET_PAGENUPORDERINFO_OFF;
    }
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PAGEIMAGEINFO, pageImageInfo]];
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PAGENUPORDERINFO, pageNupOrderInfo]];
    
    // 印刷範囲(暗号化PDFまたは一般PDFで、「直接指定」選択時のみPJLを設定する)
    if (printRangeInfo != nil && printRangeInfo.noRangeDesignation && printRangeInfo.m_PrintRangeStyle == 2) {
        // @PJL SET PRINTPAGES(印刷範囲)
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PRINTPAGES, [self GetPrintRangeSetting:printRangeInfo]]];
        // 印刷範囲確認用
        DLog(@"印刷範囲確認:%@",[[NSString alloc]initWithFormat:S_PJL_SET_PRINTPAGES, [self GetPrintRangeSetting:printRangeInfo]]);
    }
    
    // @PJL SET ALLSHEETS(印刷対象)
    switch (printTarget) {
        case PRINT_TARGET_ALL_SHEETS_OFF:
            pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PRINT_TARGET, S_PJL_SET_PRINT_TARGET_OFF]];
            break;
        case PRINT_TARGET_ALL_SHEETS_ON:
            pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PRINT_TARGET, S_PJL_SET_PRINT_TARGET_ON]];
            break;
        case PRINT_TARGET_NOT_AVAILABLE:
        default:
            break;
    }
    
    // @PJL SET RETENTION(リテンション)
    if(bRetentionHold)
    {
        // 印刷せずにホールドする
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_FILING, S_PJL_SET_FILING_PERMANENCE]];
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_FILINGFOLDERPATHW, S_PJL_SET_FILINGFOLDERPATH_STANDARD]];
        
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_FILINGFOLDERPATH, S_PJL_SET_FILINGFOLDERPATH_STANDARD]];
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_HOLD, S_PJL_SET_HOLD_STORE]];
        
        if(bRetentionAuth)
        {
            // 認証あり
            pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", S_PJL_SET_HOLDTYPE_PRIVATE];
            NSString *pstrEncRetentionPassword = [CommonUtil getRetentionPassword:pstrRetentionPassword SpoolTime:pstrSpoolKey];
            pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_HOLDKEY, pstrEncRetentionPassword]];
        }
    }
    else
    {
        // ホールドしない
        // 印刷せずにホールドする
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_FILING, S_PJL_SET_FILING_OFF]];
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_HOLD, S_PJL_SET_HOLD_OFF]];
        
    }
    // @PJL SET QTY(部数)
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_QTY, nNumOfSets]];
    
    // @PJL SET DUPLEX(片面/両面)
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_DUPLEX, [self GetDuplexSetting:nSide]]];

    // @PJL SET BINDING(とじ位置 in 仕上げ)
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_BINDING, [self GetBindingSetting:nSide ClosingRow:nClosingRow]]];
    
    // @PJL SET JOBSTAPLE(ステープル in 仕上げ) / @PJL SET STAPLEOPTION(針なしステープル in 仕上げ)
    // ステープル対応プリンターの場合のみ設定する
    if (staple != STAPLE_NONE && pstrStaple != nil) {
        pstrHeader = [pstrHeader stringByAppendingString:[self GetStapleSetting:pstrStaple]];
    }
    
    // @PJL SET PUNCH(パンチ)
    if (punchData == nil || punchData.canPunch == NO) {
        // パンチ未対応のため処理なし
    } else if (pstrPunch == nil) {
        // パンチ対応で「なし」の場合
        // @PJL SET PUNCH=OFF
        pstrHeader = [pstrHeader stringByAppendingString:[self GetPunchSetting:NO]];
    } else {
        // パンチありの場合
        // @PJL SET PUNCH=ON
        pstrHeader = [pstrHeader stringByAppendingString:[self GetPunchSetting:YES]];
        // @PJL SET PUNCH-NUMBER=TWO/THREE/FOUR/FOURWIDE
        pstrHeader = [pstrHeader stringByAppendingString:[self GetPunchNumberSetting:pstrPunch]];
    }
    
    // @PJL SET PAPER(用紙サイズ)
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PAPER, pstrPapersize]];
//    if ([pstrPapersize isEqualToString:S_PJL_PAPERSIZE_JPOST]) {
//        pstrHeader = [pstrHeader stringByAppendingFormat:S_PJL_SET_MEDIATYPE_POSTCARD];
//    } else if ([pstrPapersize isEqualToString:S_PJL_PAPERSIZE_DL] ||
//               [pstrPapersize isEqualToString:S_PJL_PAPERSIZE_C5] ||
//               [pstrPapersize isEqualToString:S_PJL_PAPERSIZE_COM10] ||
//               [pstrPapersize isEqualToString:S_PJL_PAPERSIZE_MONARCH] ||
//               [pstrPapersize isEqualToString:S_PJL_PAPERSIZE_KAKUGATA2] ||
//               [pstrPapersize isEqualToString:S_PJL_PAPERSIZE_CHOKEI3] ||
//               [pstrPapersize isEqualToString:S_PJL_PAPERSIZE_YOKEI2] ||
//               [pstrPapersize isEqualToString:S_PJL_PAPERSIZE_YOKEI4]) {
//        pstrHeader = [pstrHeader stringByAppendingFormat:S_PJL_SET_MEDIATYPE_ENVELOPE];
//    }
    
    // @PJL SET MEDIATYPE(用紙タイプ)
    pstrHeader = [pstrHeader stringByAppendingFormat:S_PJL_SET_MEDIATYPE, pstrPapertype];
    
    // ユーザー番号が指定されている場合は設定する
    if([profileData.userNo length] > 0)
    {
        // @PJL SET ACCOUNTNUMBER(ユーザー番号)
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_ACCOUNTNUMBER, profileData.userNo]];
        
    }
    
    if ([profileData.loginName length] > 0)
    {        
        NSString *decryptLoginName = [CommonUtil decryptString:[CommonUtil base64Decoding:profileData.loginName] withKey:S_KEY_PJL];

        
        // @PJL SET ACCOUNTLOGIN(ログイン名)
        NSString *loginName = [CommonUtil getAccountLogin:decryptLoginName SpoolTime:pstrSpoolKey encoding:[CommonUtil getStringEncodingById:S_LANG]];
        
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_ACCOUNTLOGIN, loginName]];   
        
        // @PJL SET ACCOUNTLOGINW(ログイン名)
        NSString *loginNameW = [CommonUtil getAccountLoginw:decryptLoginName SpoolTime:pstrSpoolKey encoding:[CommonUtil getStringEncodingById:S_LANG]];
        
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_ACCOUNTLOGINW, loginNameW]];   
        
        if([profileData.loginPassword length] > 0)
        {
            NSString *decryptLoginPassword = [CommonUtil decryptString:[CommonUtil base64Decoding:profileData.loginPassword] withKey:S_KEY_PJL];

            
            // @PJL SET ACCOUNTPASSWORD(パスワード)
            NSString *loginPassword = [CommonUtil getAccountPassword:decryptLoginPassword SpoolTime:pstrSpoolKey encoding:[CommonUtil getStringEncodingById:S_LANG]];
            
            pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_ACCOUNTPASSWORD, loginPassword]];   
            
            // @PJL SET ACCOUNTPASSWORDW(パスワード)
            NSString *loginPasswordW = [CommonUtil getAccountPasswordw:decryptLoginPassword SpoolTime:pstrSpoolKey encoding:[CommonUtil getStringEncodingById:S_LANG]];
            
            pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_ACCOUNTPASSWORDW, loginPasswordW]];  
        }
    }
    
    // @PJL SET COLORMODE(カラーモード)
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_COLORMODE, [self GetColormodeSetting:nColormode]]];
    
    // @PJL SET RESOLUTION(高品質)
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", S_PJL_SET_RESOLUTION];
    
    // @PJL SET RENDERMODEL(高品質)
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_RENDERMODEL, [self GetRendermodeSetting:nColormode HighQuarityMode:profileData.highQualityMode]]];
    
    // @PJL SET PRINTAGENT
    NSString *idiomType = nil;
    NSString *strBundle = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        idiomType = S_PJL_SET_PRINTAGENT_IPAD;
    }else
    {
        idiomType = S_PJL_SET_PRINTAGENT_IPHONE;
    }
    if ([S_LANG isEqualToString:S_LANG_JA])
    {
        strBundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }else
    {
        strBundle = [[NSString alloc]initWithFormat:@"%@%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], @"A"];
    }
    pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PRINTAGENT, idiomType, strBundle]];

    // プリントリリース
    switch (printRelease) {
        case PRINT_RELEASE_DISABLED:
            pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PRINTRELEASE, S_PJL_SET_PRINTRELEASE_OFF]];
            break;
        case PRINT_RELEASE_ENABLED:
            pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_SET_PRINTRELEASE, S_PJL_SET_PRINTRELEASE_ON]];
            break;
        case PRINT_RELEASE_NOT_SUPPORTED:
        default:
            break;
    }
    
    // @PJL ENTER LANGUAGE
    if([CommonUtil pdfExtensionCheck:pstrFilePath])
    {
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_LANGUAGE, S_PJL_LANGUAGE_AUTO]];
    }else if([CommonUtil tiffExtensionCheck:pstrFilePath])
    {
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_LANGUAGE, S_PJL_LANGUAGE_AUTO]];
    }
    else if([CommonUtil jpegExtensionCheck:pstrFilePath])
    {
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_LANGUAGE, S_PJL_LANGUAGE_AUTO]];
    }
    else
    {
        pstrHeader = [pstrHeader stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_LANGUAGE, S_PJL_LANGUAGE_AUTO]];
    }
    
    return pstrHeader;
}

// PJLフッタ作成
- (NSString*)CreatePJLFooter:(NSString*)pstrFileName
{
    // ログインデータの取得
    profileDataManager = [[ProfileDataManager alloc] init];
    ProfileData *profileData = [profileDataManager loadProfileDataAtIndex:0];
    
    //長いファイル名(80バイト超えるとき）は80バイトに切り捨てる
    NSString* pstrFileName80orLess = [CommonUtil trimString:pstrFileName halfCharNumber:80];
    
    
    // PJLの決まり事
    NSString* pstrFooter = S_PJL_JOB;
    //pstrFooter = [pstrFooter stringByAppendingString:@"\r\n"];
    
    // @PJL EOJ NAME
    if([profileData.jobName length] > 0)
    {
        pstrFooter = [pstrFooter stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_EOJ_NAME, [[NSString alloc]initWithFormat:S_PJL_JOB_NAME_ADDR, profileData.jobName]]];
    }else
    {
        pstrFooter = [pstrFooter stringByAppendingFormat:@"%@", [[NSString alloc]initWithFormat:S_PJL_EOJ_NAME, [[NSString alloc]initWithFormat:S_PJL_JOB_NAME_ADDR, pstrFileName80orLess]]];
    }
    
    return pstrFooter;
}

// 片面/両面設定取得
- (NSString*)GetDuplexSetting:(NSInteger)nSide   // 片面/両面
{
    // 両面
    NSString* pstrDuplex = S_PJL_DUPLEX_ON;
    
    if (nSide == E_ONE_SIDE)
    {
        // 片面
        pstrDuplex = S_PJL_DUPLEX_OFF;
    }
    return pstrDuplex;
}

// とじ位置の取得
- (NSString*)GetBindingSetting:(NSInteger)nSide   // 片面/両面
                    ClosingRow:(NSInteger)nClosingRow   // とじ位置(左とじ/右とじ/上とじ)
{
    // とじ位置
    NSString *binding = nil;

    // 「片面印刷」の場合
    if (nSide == E_ONE_SIDE) {
        
        // 「左とじ」の場合
        if (nClosingRow == 0) {
            binding = S_PJL_SET_BINDING_LEFTEDGE;
            
        // 「右とじ」の場合
        } else if (nClosingRow == 1) {
            binding = S_PJL_SET_BINDING_RIGHTEDGE;
            
        // 「上とじ」の場合
        } else if (nClosingRow == 2) {
            binding = S_PJL_SET_BINDING_UPPEREDGE;
        }
        
    // 「両面印刷よことじ」の場合
    } else if (nSide == E_DUPLEX_SIDE_LONG) {
        
        // 「左とじ」の場合
        if (nClosingRow == 0) {
            binding = S_PJL_SET_BINDING_LEFTEDGE;
            
        // 「右とじ」の場合
        } else if (nClosingRow == 1) {
            binding = S_PJL_SET_BINDING_RIGHTEDGE;
            
        // 「上とじ」の場合
        } else if (nClosingRow == 2) {
            binding = S_PJL_SET_BINDING_LEFTEDGE;
        }
        
    // 「両面印刷たてとじ」の場合
    } else if (nSide == E_DUPLEX_SIDE_SHORT) {
        
        // 「左とじ」の場合
        if (nClosingRow == 0) {
            binding = S_PJL_SET_BINDING_UPPEREDGE;
            
        // 「右とじ」の場合
        } else if (nClosingRow == 1) {
            binding = S_PJL_SET_BINDING_UPPEREDGE;
            
        // 「上とじ」の場合
        } else if (nClosingRow == 2) {
            binding = S_PJL_SET_BINDING_UPPEREDGE;
        }
    }
    return binding;
}

/**
 @brief ステープルの設定
 */
- (NSString*)GetStapleSetting:(NSString*)pstrStaple {
    
    if ([pstrStaple isEqualToString:S_PJL_SET_STAPLEOPTION_STAPLELESS]) {
        return [[NSString alloc]initWithFormat:S_PJL_SET_STAPLEOPTION, pstrStaple];
    }
    
    return [[NSString alloc]initWithFormat:S_PJL_SET_JOBSTAPLE, pstrStaple];
}

/**
 @brief パンチ有無
 */
- (NSString*)GetPunchSetting:(BOOL)canPunch {
    
    // パンチなし
    NSString *value = S_PJL_SET_PUNCH_OFF;
    if (canPunch) {
        // パンチあり
        value = S_PJL_SET_PUNCH_ON;
    }
    return [[NSString alloc]initWithFormat:S_PJL_SET_PUNCH, value];
}

/**
 @brief パンチ設定値
 */
- (NSString*)GetPunchNumberSetting:(NSString*)pstrPunch {
    return [[NSString alloc]initWithFormat:S_PJL_SET_PUNCH_NUMBER, pstrPunch];
}

// カラーモード取得
- (NSString*)GetColormodeSetting:(NSInteger)nColormode // カラーモード
{
    NSString* pstrColormode = S_PJL_COLORMODE_AUTO;
    
    switch (nColormode) {
        case E_COLORMODE_COLOR:
            pstrColormode = S_PJL_COLORMODE_COLOR;
            break;
        case E_COLORMODE_BW:
            pstrColormode = S_PJL_COLORMODE_BW;
            break;
        default:
            break;
    }
    return pstrColormode;
}

- (NSString*)GetRendermodeSetting:(NSInteger)nColormode // レンダーモード
                 HighQuarityMode:(BOOL)bHighQuarityMode // 高品質印刷
{
    NSString* pstrRendermode = S_PJL_RENDERMODEL_ON;
    
    switch (nColormode) {
        case E_COLORMODE_AUTO:
        case E_COLORMODE_COLOR:
            if(!bHighQuarityMode)
            {
                pstrRendermode = S_PJL_RENDERMODEL_ON;
            }
            else
            {
                pstrRendermode = S_PJL_RENDERMODEL_OFF;    
            }
            break;
        case E_COLORMODE_BW:
            if(!bHighQuarityMode)
            {
                pstrRendermode = S_PJL_RENDERMODEL_BW_ON;
            }
            else
            {
                pstrRendermode = S_PJL_RENDERMODEL_BW_OFF;  
            }
            
            break;
        default:
            break;
    }
    return  pstrRendermode;
}

// 印刷範囲取得
- (NSString*)GetPrintRangeSetting:(PrintRangeSettingViewController*)printRangeInfo // 印刷範囲情報
{
    NSString* pstrPrintRange;
    
    switch (printRangeInfo.m_PrintRangeStyle) {
        case 2:
            pstrPrintRange = printRangeInfo.m_PageDirect;
            break;
            
        default:
            pstrPrintRange = @"";
            break;
    }
    // スペースは空白に置換して返却
    return [pstrPrintRange stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)GetSpoolTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //spoolTime用に変換
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    return dateString;
}

@end
