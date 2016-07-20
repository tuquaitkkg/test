#import "AlertMessageCheck.h"

@implementation AlertMessageCheck

NSArray* array;
int count;

- (instancetype)init
{
    self = [super init];
    if (self) {
        array = [[NSMutableArray alloc] initWithObjects:
                 @"MSG_BUTTON_OK",
                 @"MSG_BUTTON_CANCEL",
                 @"MSG_SCAN_REQ_ERR",
                 @"MSG_RECIEVE_ERR",
                 @"MSG_SAVE_ERR",
                 @"MSG_SCAN_CONFIRM",
                 @"MSG_REG_PROFILE",
                 @"MSG_REG_PROFILE_ERR",
                 @"MSG_DEL_PROFILE",
                 @"MSG_DEL_PROFILE_ERR",
                 @"MSG_WAIT_SCAN",
                 @"MSG_SCAN_CANCEL",
                 @"MSG_SCAN_DOING",
                 @"MSG_NO_SCAN_FILE",
                 @"MSG_DID_SCAN",
                 @"MSG_DID_SCAN_ERR",
                 @"MSG_REG_USER_PROFILE_ERR",
                 @"MSG_REG_PROFILE_CONFIRM",
                 @"MSG_NO_SCANNER",
                 @"MSG_NETWORK_ERR",
                 @"MSG_PRINT_REQ_ERR",
                 @"MSG_PRINT_ERR",
                 @"MSG_PRINT_CANCEL",
                 @"MSG_PRINT_CONNECT",
                 @"MSG_PRINT_DISCONNECT",
                 @"MSG_PRINT_FORWARD",
                 @"MSG_PRINT_FILE_ERR",
                 @"MSG_ALUBUM_ERR",
                 @"MSG_PRINT_CONFIRM",
                 @"MSG_PRINT_COMPLETE",
                 @"MSG_NO_PRINTER",
                 @"MSG_MAIL_START_ERR",
                 @"MSG_MAIL_ATTACH_CONFIRM",
                 @"MSG_NO_SEND_APP",
                 @"MSG_DEL_CONFIRM",
                 @"MSG_DEL_COMPLETE",
                 @"MSG_DEL_ERR",
                 @"MSG_SETTING_DEL_ERR",
                 @"MSG_SEARCH_DOING",
                 @"MSG_SEARCH_NOTHING",
                 @"MSG_SEARCH_COMPLETE",
                 @"MSG_SEARCH_COMPLETE_UPDATEONLY",
                 @"MSG_REQUIRED_ERR",
                 @"MSG_CHAR_TYPE_ERR",
                 @"MSG_FORMAT_ERR",
                 @"MSG_NUM_RANGE_ERR",
                 @"MSG_LENGTH_ERR",
                 @"SUBMSG_ERR",
                 @"SUBMSG_IPADDR_ERR",
                 @"SUBMSG_PORT_ERR",
                 @"SUBMSG_DEVICENAME_ERR",
                 @"SUBMSG_ONLY_HALFCHAR_NUMBER",
                 @"SUBMSG_IPADDR_FORMAT",
                 @"SUBMSG_PORTNO_RANGE",
                 @"SUBMSG_NAME_ERR",
                 @"SUBMSG_SEARCH_ERR",
                 @"SUBMSG_NAME_FORMAT",
                 @"SUBMSG_DEVICENAME_FORMAT",
                 @"SUBMSG_HOSTNAME_LEN_ERR",
                 @"SUBMSG_SEARCH_FORMAT",
                 @"MSG_PREVIEW_ERR",
                 @"MSG_IMAGE_PREVIEW_ERR",
                 @"MSG_IMAGE_PREVIEW_ERR_PDF",
                 @"MSG_NO_VIEW_FILE",
                 @"MSG_RECIEVE_ERR_PROCESSING",
                 @"MSG_RECIEVE_ERR_PRINT",
                 @"MSG_RECIEVE_ERR_SCAN",
                 @"MSG_RECIEVE_ERR_BUSY",
                 @"MSG_RECIEVE_ERR_SAVE",
                 @"MSG_SAME_DEVICE_ERR",
                 @"MSG_SAME_DEVICE_ERR_PRINTSERVER",
                 @"SUBMSG_DEVICEINPUTNAME_ERR",
                 @"SUBMSG_DEVICEPLACE_ERR",
                 @"MSG_DEL_FILE_FOLDER_CONFIRM",
                 @"MSG_SAME_NAME_ERR",
                 @"MSG_FILENAME_FORMAT",
                 @"MSG_CREATE_DIR_FAILED",
                 @"MSG_CHANGE_FAILED",
                 @"MSG_MOVE_SUCCESS",
                 @"MSG_MOVE_FAILED",
                 @"MSG_MOVE_PARENTCHILD",
                 @"MSG_MOVE_SAMEDIR",
                 @"MSG_MOVE_PATHEXISTS",
                 @"MSG_MOVE_SOMEFILES_AND_DIRECTORIES",
                 @"SUBMSG_FILENAME_FORMAT",
                 @"SUBMSG_FOLDERNAME_ERR",
                 @"SUBMSG_FILENAME_ERR",
                 @"SUBMSG_LOGINNAME_ERR",
                 @"SUBMSG_LOGINPASSWORD_ERR",
                 @"SUBMSG_LOGINNAME_FORMAT",
                 @"SUBMSG_LOGINPASSWORD_FORMAT",
                 @"SUBMSG_COMMUNITYSTRING_ERR",
                 @"SUBMSG_COMMUNITYSTRING_FORMAT",
                 @"SUBMSG_COMMUNITYSTRING_CHARTYPE",
                 @"SUBMSG_COMMUNITYSTRING_LENGTH",
                 @"MSG_MOVE_FILEDIRECTORYSAME",
                 @"MSG_MOVE_DIRECTORYFILESAME",
                 @"MSG_PRINTEROPTION_GET",
                 @"MSG_NO_PRINTOPTION_PCL",
                 @"MSG_NO_PRINTOPTION_PS",
                 @"MSG_LOCATION_INFORMATION_OFF",
                 @"MSG_PDF_ENCRYPTION_ERR",
                 @"MSG_PRINT_COMPLETE_PDF_ENCRYPTION",
                 @"MSG_DEL_PROFILE_ERR_SCANNER_PROCESSING",
                 @"MSG_OTHER_APP_CHECK",
                 @"MSG_SEND_APPLICATION",
                 @"MSG_SEND_APPLICATION_IPAD",
                 @"MSG_REG_PROFILE_ERR_SCANNER_PROCESSING",
                 @"SUBMSG_EMOJI",
                 @"S_LIBRARY_LICENSE",
                 @"SUBMSG_VERIFY_CODE_ERR",
                 @"SUBMSG_ONLY_HALFCHAR",
                 @"SUBMSG_VERIFY_CODE_RANGE",
                 @"MSG_REMOTESCAN_DOING",
                 @"MSG_REMOTESCAN_ERR",
                 @"MSG_REMOTESCAN_CANCELED",
                 @"MSG_REMOTESCAN_CANCELING",
                 @"MSG_REMOTESCAN_JAMED",
                 @"MSG_REMOTESCAN_JAMCLEAR",
                 @"MSG_REMOTESCAN_NOTSUPPORT",
                 @"MSG_REMOTESCAN_SCREENISNOTHOME",
                 @"MSG_REMOTESCAN_NOTAUTHENTICATED",
                 @"MSG_REMOTESCAN_ACCESSDENIED",
                 @"MSG_REMOTESCAN_ORIGINALNOTDETECTED",
                 @"MSG_REMOTESCAN_LIMITREACHED",
                 @"MSG_REMOTESCAN_ORIGINALNOTDETECTED_CONFIRM",
                 @"MSG_REMOTESCAN_SCANFAIL",
                 @"MSG_REMOTESCAN_CONFIRM",
                 @"MSG_REMOTESCAN_WAIT",
                 @"MSG_REMOTESCAN_CONFIRM_MULTICROP_ALERT",
                 @"MSG_WAIT",
                 @"MSG_REMOTESCAN_REMOVEDOCUMENT",
                 @"MSG_REMOTESCAN_USESTAND",
                 @"MSG_REMOTESCAN_USEFEEDER",
                 @"MSG_REMOTESCAN_NOTUSE",
                 @"SUBMSG_PDFPASSWORD_ERR",
                 @"SUBMSG_PDFPASSWORD_MAXLENGTH",
                 @"SUBMSG_PDFPASSWORD_FORMAT",
                 @"MSG_SETTING_DEVICE_REMOTE_RESET",
                 @"MSG_REMOTESCAN_NETWORK_ERROR_AND_EXIT",
                 @"MSG_REMOTESCAN_NETWORK_ERROR",
                 @"MSG_REMOTESCAN_ERROR_ALL_PAGE_BLANK",
                 @"MSG_REMOTESCAN_SESSIONID_GET_ERROR",
                 @"MSG_REMOTESCAN_SCREENISNOTLOGIN",
                 @"MSG_REMOTESCAN_FORBIDDEN",
                 @"MSG_REMOTESCAN_PAPER_SETTING_ERR",
                 @"MSG_REMOTESCAN_JAMMING_ERR",
                 @"MSG_REMOTESCAN_WIDTH_INCH",
                 @"MSG_REMOTESCAN_HEIGHT_INCH",
                 @"MSG_REMOTESCAN_WIDTH_MILLIMETER",
                 @"MSG_REMOTESCAN_HEIGHT_MILLIMETER",
                 @"MSG_PRINT_MEMORY_ERROR_PNG",
                 @"MSG_REMOTESCAN_SESSIONID_GET_ERROR",
                 @"MSG_CONFIRM_PRINT_WEB_PAGE",
                 @"SUBMSG_USERNO_ERR",
                 @"SUBMSG_USERNAME_ERR",
                 @"SUBMSG_JOBNAME_ERR",
                 @"SUBMSG_USERNO_FORMAT",
                 @"SUBMSG_USERNAME_FORMAT",
                 @"SUBMSG_JOBNAME_FORMAT",
                 @"MSG_CANNOT_PRINT_WEB_PAGE",
                 @"SUBMSG_ACCOUNTNAME_ERR",
                 @"SUBMSG_HOSTNAME_ERR",
                 @"MSG_EMAIL_CONNECT_ERROR",
                 @"MSG_EMAIL_ACCOUNT_ERROR",
                 @"SUBMSG_LOGINACCOUNT_ERR",
                 @"MSG_SETTING_DEVICE_GETMFP",
                 @"MSG_MAIL_NOTSUPPORT_ERR",
                 @"SUBMSG_PRINTNUMBER",
                 @"SUBMSG_PRINTNUMBER_FORMAT",
                 @"MSG_SCAN_CONFIRM_FREESIZE",
                 @"SUBMSG_RETENTION_FORMAT",
                 @"MSG_REMOTESCAN_ACCESSDENIED_MAIN",
                 @"MSG_ENCRYPTZIP_ERROR",
                 @"MSG_PRINT_COMPLETE_ATTACHMENT_MAIL",
                 @"MSG_BUTTON_YES",
                 @"MSG_BUTTON_NO",
                 @"MSG_PRINT_CONFIRM_NUP_DISABLE",
                 @"MSG_PRINT_MAILATTACHMENT_CONFIRM",
   
                 // 使われていない？
                 @"MSG_NOTPRINT_ALL",
                 @"MSG_NOTPRINT_PS",
                 @"MSG_NOTPRINT_NUP",
                 @"MSG_NOTPRINT_RETENTION",
                 @"MSG_NOTPRINT_CONFIRM",
//                 MSG_REMOTESCAN_NOTSCANNERMODE,
//                 MSG_REMOTESCAN_SPFISNOTBOTHSIZE,
                 @"MSG_OPENMANUAL_WITHEXTERNALAPP" ,
                 nil];
        count = 0;
    }
    return self;
}

- (void)showAlertView:(BOOL)showKey
{
    if(count == [array count] || count < 0)
    {
        return;
    }

    NSString *messageKey = [array objectAtIndex:count];
    NSString *message = NSLocalizedString(messageKey, nil);
    
    NSArray *arr = [message componentsSeparatedByString:@"%@"];
    NSUInteger pCount = [arr count]-1;
    NSRange searchResult;
    DLog(@"%@:%@",messageKey,message);

    switch (pCount) {
        case 1:
            message = [NSString stringWithFormat:message,@"11111"];
            break;
        case 2:
            message = [NSString stringWithFormat:message,@"11111",@"22222"];
            break;
        case 3:
            message = [NSString stringWithFormat:message,@"11111",@"22222",@"33333"];
            break;
        case 4:
            message = [NSString stringWithFormat:message,@"11111",@"22222",@"33333",@"44444"];
            break;
            
        default:
            searchResult = [message rangeOfString:@"%d"];
            if(searchResult.location != NSNotFound){
                message = [NSString stringWithFormat:message,11];
            }
            searchResult = [message rangeOfString:@"%.1f"];
            if(searchResult.location != NSNotFound){
                message = [NSString stringWithFormat:message,1.1f];
            }

            break;
    }
    
    DLog(@"%@:%@",messageKey,message);
    
    NSString *showMessage;
    if (showKey) {
        showMessage = messageKey;
    } else {
        showMessage = message;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:showMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // 「次」用のアクションを生成
    UIAlertAction *nextAction =
    [UIAlertAction actionWithTitle:@"次"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               DLog(@"「次」ボタン押下");
                               if (showKey) {
                                   [self showAlertView:NO];
                               } else {
                                   count++;
                                   [self showAlertView:YES];
                               }
                           }];
    
    // 「おわり」用のアクションを生成
    UIAlertAction *endAction =
    [UIAlertAction actionWithTitle:@"おわり"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               // ボタンタップ時の処理
                               DLog(@"「おわり」ボタン押下");
                           }];
    
    // コントローラにアクションを追加
    [alertController addAction:nextAction];
    [alertController addAction:endAction];
    // 親ViewControllerを検索
    UIViewController *baseVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (baseVC.presentedViewController != nil && !baseVC.presentedViewController.isBeingDismissed) {
        baseVC = baseVC.presentedViewController;
    }
    // アラート表示処理
    [baseVC presentViewController:alertController animated:YES completion:nil];

}

@end
