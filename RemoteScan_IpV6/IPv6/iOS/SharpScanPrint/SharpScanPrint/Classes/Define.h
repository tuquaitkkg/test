
#import "RSDefine.h"

// バージョン情報末尾番号（）内の番号
#define MAINTENANCE_NUMBER  @"1"

// iOSのバージョンが7以降かどうかを判定するマクロ
#define isIOS7Later             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
// iOSのバージョンが7.1以降かどうかを判定するマクロ
#define isIOS7_1Later             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.1 ? YES : NO)

// iOSのバージョンが8以降かどうかを判定するマクロ
#define isIOS8Later             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
// iOSのバージョンが8.1以降かどうかを判定するマクロ
#define isIOS8_1Later             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.1 ? YES : NO)

// iOSのバージョンが9以降かどうかを判定するマクロ
#define isIOS9Later             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)

// IPv6対応するかどうか(対応しない場合はコメントアウト)
#define IPV6_VALID

// 複数印刷対応
#define ST_CLOSE_BUTTON_PUSHED @"stCloseButtonPushed" // 印刷設定の閉じるボタン

#define NK_CLOSE_BUTTON_PUSHED @"kCloseButtonPushed"
#define NK_ENTER_BUTTON_PUSHED @"kEnterButtonPushed"
#define NK_ENTER_BUTTON_PUSHED2 @"kEnterButtonPushed2"//添付ファイル
#define NK_BACK_BUTTON_PUSHED @"kBackButtonPushed"
#define NK_PICT_ENTER_BUTTON_PUSHED @"kPictEnterButtonPushed"
#define NK_PICT_EDIT_ACTION @"kPictEditAction"

#define WP_ENTER_BUTTON_PUSHED1 @"kWebPrintEnterButtonPushed1"
#define WP_ENTER_BUTTON_PUSHED2 @"kWebPrintEnterButtonPushed2"

#define MP_ENTER_BUTTON_PUSHED1 @"kMailPrintEnterButtonPushed1"
#define MP_ENTER_BUTTON_PUSHED2 @"kMailPrintEnterButtonPushed2"
#define MP_ATTACHMENT_BUTTON_PUSHED1 @"kAttachmentPrintEnterButtonPushed1"
#define MP_ATTACHMENT_BUTTON_PUSHED2 @"kAttachmentPrintEnterButtonPushed2"
#define MP_SHOW_ATTACHMENT_BUTTON_PUSHED @"kShowAttachmentPrintEnterButtonPushed"

// ログイン画面　フラグキー
#define S_LOGIN             @"login"
#define S_KEYWORD0          @"MX-"
#define S_KEYWORD1          @"DX-"

// IPAddress Dictionary Key
#define S_MY_IPADDRESS_DIC_KEY  @"myIPAddress"
#define S_TARGET_IPADDRESS_DIC_KEY  @"targetIPAddress"

// トップ画面 テーブルビューセル名
#define S_TOP_PRINT         NSLocalizedString(@"S_TOP_PRINT", @"印刷する")
#define S_TOP_SENDMAIL      NSLocalizedString(@"S_TOP_SENDMAIL", @"メールに添付する")
#define S_TOP_SEND_OUTSIDE  NSLocalizedString(@"S_TOP_SEND_OUTSIDE", @"アプリケーションに送る")
#define S_TOP_SCAN          NSLocalizedString(@"S_TOP_SCAN", @"取り込む")
#define S_TOP_ARRANGE       NSLocalizedString(@"S_TOP_ARRANGE", @"ファイルを管理する")
#define S_TOP_SUB_SETTING   NSLocalizedString(@"S_TOP_SUB_SETTING", @"設定")
#define S_TOP_SUB_VERSION   NSLocalizedString(@"S_TOP_SUB_VERSION", @"バージョン情報")
//トップ画面ヘルプ文言
#define MSG_OPENMANUAL_WITHEXTERNALAPP NSLocalizedString(@"MSG_OPENMANUAL_WITHEXTERNALAPP", @"外部アプリを起動して操作マニュアルを開きます。")
//ヘルプPDFのURL（iPhone）
#define S_HELPPDF_URL         NSLocalizedString(@"S_HELPPDF_URL", @"ヘルプPDFのURL")
//ヘルプPDFのURL（iPad）
#define S_HELPPDF_URL_IPAD         NSLocalizedString(@"S_HELPPDF_URL_IPAD", @"ヘルプPDFのURL")
//ヘルプPDFのファイル名
#define S_HELPPDF_NAME         NSLocalizedString(@"S_HELPPDF_NAME", @"ヘルプPDFの ファイル名")
//ヘルプPDFのファイル名(iPad)
#define S_HELPPDF_NAME_IPAD         NSLocalizedString(@"S_HELPPDF_NAME_IPAD", @"ヘルプPDFの ファイル名(iPad)")

// トップ画面 テーブルビュー設定
#define N_NUM_SECTION_TOP       2   // セクション数
#define N_NUM_ROW_TOP_SEC1      5   // セクション１の行数
#define N_NUM_ROW_TOP_SEC2      2   // セクション２の行数
#define N_HEIGHT_TOP_SEC1       58  // セクション１の縦幅
#define N_HEIGHT_TOP_SEC2       40  // セクション２の縦幅

// 印刷-ファイル分類選択画面 テーブルビューセル名
#define S_PRINT_SEL_FILE    NSLocalizedString(@"S_PRINT_SEL_FILE", @"ファイルを選択する")
#define S_PRINT_SEL_PICTURE NSLocalizedString(@"S_PRINT_SEL_PICTURE", @"写真を選択する")
#define S_PRINT_SEL_WEBPAGE NSLocalizedString(@"S_PRINT_SEL_WEBPAGE", @"Webページを印刷する")
#define S_PRINT_SEL_EMAIL NSLocalizedString(@"S_PRINT_SEL_EMAIL", @"メールを印刷する")

// 印刷-ファイル分類選択画面 テーブルビュー設定
#define N_NUM_SECTION_PRINT_SEL     2   // セクション数
#define N_NUM_ROW_PRINT_SEL_SEC1    2   // セクション１の行数
#define N_NUM_ROW_PRINT_SEL_SEC1_IPAD    2   // iPad版のセクション１の行数
#define N_HEIGHT_PRINT_SEL_SEC1     58  // セクション１の縦幅
#define N_NUM_ROW_PRINT_SEL_SEC2    2   // セクション2の行数
#define N_HEIGHT_PRINT_SEL_SEC2     58  // セクション2の縦幅

// フォルダー作成画面
#define S_TITLE_CREATE_FOLDER_NAME NSLocalizedString(@"S_TITLE_CREATE_FOLDER_NAME", @"フォルダー名")

// 名称変更画面
#define S_TITLE_FILE_NAME        NSLocalizedString(@"S_TITLE_FILE_NAME", @"ファイル名")
#define S_TITLE_FOLDER_NAME        NSLocalizedString(@"S_TITLE_FOLDER_NAME", @"フォルダー名")

// 設定-設定情報選択画面 テーブルビュー設定
#define N_NUM_SECTION_SETTING       1   // セクション数
#define N_NUM_ROW_SETTING_SEL_SEC1  6   // セクション１の行数
#define N_HEIGHT_SETTING_SEL_SEC1   58  // セクション１の縦幅

// 設定-設定情報選択画面 テーブルビューセル名
#define S_SETTING_DEVICE    NSLocalizedString(@"S_SETTING_DEVICE", @"プリンター/スキャナーを設定")
//#define S_SETTING_SERVER    NSLocalizedString(@"S_SETTING_SERVER", @"プリントサーバーを設定") //*** 仮
#define S_SETTING_EXCLCLUDE_DEVICE NSLocalizedString(@"S_SETTING_EXCLCLUDE_DEVICE", @"プリンター/スキャナーの除外設定")
#define S_SETTING_EXCLUDE_MFP NSLocalizedString(@"S_SETTING_EXCLUDE_MFP", @"除外プリンター/スキャナーを設定")
#define S_SETTING_USERINFO  NSLocalizedString(@"S_SETTING_USERINFO", @"ユーザー情報を設定")
#define S_SETTING_MAIL_SERVERINFO NSLocalizedString(@"S_SETTING_MAIL_SERVERINFO", @"メールを設定")
#define S_SETTING_APPLICATION NSLocalizedString(@"S_SETTING_APPLICATION", @"アプリケーションの動作を設定")

// 設定-プリンター/スキャナー設定画面 テーブルビュー設定
#define N_NUM_SECTION_SETTING_MFP   1   // セクション数
#define N_HEIGHT_SETTING_MFP_SEC    58  // セクションの縦幅
#define S_SETTING_DEVICE_NAME NSLocalizedString(@"S_SETTING_DEVICE_NAME", @"名称：")
#define S_SETTING_DEVICE_DEVICENAME NSLocalizedString(@"S_SETTING_DEVICE_DEVICENAME", @"製品名：")
#define S_SETTING_DEVICE_IP_ADDRESS NSLocalizedString(@"S_SETTING_DEVICE_IP_ADDRESS", @"IPアドレス：")
#define S_SETTING_DEVICE_HOSTNAME NSLocalizedString(@"S_SETTING_DEVICE_HOSTNAME", @"ホスト名：")
#define S_SETTING_DEVICE_PORT NSLocalizedString(@"S_SETTING_DEVICE_PORT", @"ポート番号：")
#define S_SETTING_DEVICE_PLACE NSLocalizedString(@"S_SETTING_DEVICE_PLACE", @"設置場所：")
#define S_SETTING_DEVICE_DEFAULT_MFP NSLocalizedString(@"S_SETTING_DEVICE_DEFAULT_MFP", @"このプリンター/スキャナーを選択")
#define S_SETTING_DEVICE_ADD_EXCLUTIONLIST NSLocalizedString(@"S_SETTING_DEVICE_ADD_EXCLUTIONLIST", @"除外リストに追加")

// 設定-プリンター/スキャナー情報表示画面 テーブルビュー設定
#define N_NUM_SECTION_SETTING_SHOW_INFO     4   // セクション数
#define N_NUM_ROW_SETTING_SHOW_INFO_SEC1    5   // セクション１の行数
#define N_NUM_ROW_SETTING_SHOW_INFO_SEC2    2   // セクション２の行数
#define N_NUM_ROW_SETTING_SHOW_INFO_SEC3    4   // セクション３の行数
#define S_TITLE_SETTING_SHOW_INFO_SEC1  NSLocalizedString(@"S_TITLE_SETTING_SHOW_INFO_SEC1", @"プリンター/スキャナー情報")    // セクション１のタイトル

#define N_NUM_FTP_PORT_NO                   @"21"  // FTPポートNo
#define N_NUM_RAWPRINT_PORT_NO              @"9100"// RawプリントポートNo

// 設定-プリンター/スキャナー除外リスト追加画面
#define S_SETTING_EXCLCLUDE_DEVICE_ADD NSLocalizedString(@"S_SETTING_EXCLCLUDE_DEVICE_ADD", @"除外リストに追加する")    // セクション１のタイトル
#define S_TITLE_SETTING_ADD_EXCLCLUDE_DEVICENAME NSLocalizedString(@"S_TITLE_SETTING_ADD_EXCLCLUDE_DEVICENAME", @"製品名を入力")

// 設定-ユーザー情報設定
#define S_TITLE_SETTING_USER_INFO NSLocalizedString(@"S_TITLE_SETTING_USER_INFO", @"プロファイル情報")
#define S_TITLE_SETTING_USER_AUTH NSLocalizedString(@"S_TITLE_SETTING_USER_AUTH", @"ユーザー認証")
#define S_TITLE_SETTING_ACTION NSLocalizedString(@"S_TITLE_SETTING_ACTION", @"動作設定")
#define S_TITLE_SETTING_REMOTE_SCAN NSLocalizedString(@"S_TITLE_SETTING_REMOTE_SCAN", @"スキャナーの動作設定")
#define S_TITLE_SETTING_DEVICENAME_STYLE NSLocalizedString(@"S_TITLE_SETTING_DEVICENAME_STYLE", @"名称設定方法")
#define S_TITLE_SETTING_DEVICENAME_STYLE_LOCATION NSLocalizedString(@"S_TITLE_SETTING_DEVICENAME_STYLE_LOCATION", @"機種名(設置場所)")
#define S_TITLE_SETTING_DEVICENAME_STYLE_IP_ADDRESS NSLocalizedString(@"S_TITLE_SETTING_DEVICENAME_STYLE_IP_ADDRESS", @"機種名(IPアドレス)")
#define S_TITLE_SETTING_DEVICENAME_STYLE_HOSTNAME NSLocalizedString(@"S_TITLE_SETTING_DEVICENAME_STYLE_HOSTNAME", @"機種名(ホスト名)")
#define S_TITLE_SETTING_RETENTION NSLocalizedString(@"S_TITLE_SETTING_RETENTION", @"リテンション設定")
#define S_TITLE_SETTING_SCAN NSLocalizedString(@"S_TITLE_SETTING_SCAN", @"取り込みの設定")
#define S_TITLE_SETTING_PRINT NSLocalizedString(@"S_TITLE_SETTING_PRINT", @"印刷の設定")
#define S_TITLE_SETTING_COMMON NSLocalizedString(@"S_TITLE_SETTING_COMMON", @"共通設定")
#define S_TITLE_SETTING_SNMP NSLocalizedString(@"S_TITLE_SETTING_SNMP", @"SNMP設定")
#define S_SETTING_USERINFO_NAME NSLocalizedString(@"S_SETTING_USERINFO_NAME", @"表示名")
#define S_SETTING_USERINFO_SEARCH NSLocalizedString(@"S_SETTING_USERINFO_SEARCH", @"検索文字")
#define S_SETTING_USERINFO_IP_ADDRESS NSLocalizedString(@"S_SETTING_USERINFO_IP_ADDRESS", @"IPアドレス")
#define S_SETTING_USERINFO_LOGINNAME NSLocalizedString(@"S_SETTING_USERINFO_LOGINNAME", @"ログイン名")
#define S_SETTING_USERINFO_LOGINPASSWORD NSLocalizedString(@"S_SETTING_USERINFO_LOGINPASSWORD", @"パスワード")
#define S_SETTING_USERINFO_DELETE_MODE NSLocalizedString(@"S_SETTING_USERINFO_DELETE_MODE", @"プロファイルの自動削除")
#define S_SETTING_USERINFO_MODIFY_MODE NSLocalizedString(@"S_SETTING_USERINFO_MODIFY_MODE", @"プロファイルの強制上書き")
#define S_SETTING_USERINFO_SAVE_OUTSIDE NSLocalizedString(@"S_SETTING_USERINFO_SAVE_OUTSIDE", @"他アプリから受けたファイルを残す")
#define S_SETTING_USERINFO_AUTOSELECT NSLocalizedString(@"S_SETTING_USERINFO_AUTOSELECT", @"プリンター/スキャナー自動選択")
#define S_SETTING_USERINFO_HIGH_QUALITY NSLocalizedString(@"S_SETTING_USERINFO_HIGH_QUALITY", @"高品質で印刷する")
#define S_SETTING_USERINFO_UPDATE_SELECT NSLocalizedString(@"S_SETTING_USERINFO_UPDATE_SELECT", @"選択プリンター/スキャナーの更新")
#define S_SETTING_USERINFO_USE_RAWPRINT NSLocalizedString(@"S_SETTING_USERINFO_USE_RAWPRINT", @"印刷にRawプリントを使用する")

#define S_SETTING_APPLICATION_JOB_TIMEOUT NSLocalizedString(@"S_SETTING_APPLICATION_JOB_TIMEOUT", @"ジョブ送信のタイムアウト(秒)")
#define S_SETTING_APPLICATION_SNMP_SEARCH_PUBLIC  NSLocalizedString(@"S_SETTING_APPLICATION_SNMP_SEARCH_PUBLIC", @"publicで検索する")
#define S_SETTING_APPLICATION_SNMP_COMMUNITY_STRING  NSLocalizedString(@"S_SETTING_APPLICATION_SNMP_COMMUNITY_STRING", @"Community String\n（改行区切りで入力してください）")
#define S_SETTING_APPLICATION_SNMP_COMMUNITY_STRING_DEFAULT  NSLocalizedString(@"S_SETTING_APPLICATION_SNMP_COMMUNITY_STRING_DEFAULT", @"SNMP Community String")

#define S_SEARCH_STRING NSLocalizedString(@"S_SEARCH_STRING", @"あ")
// 設定-ユーザー情報設定 テーブルビュー設定
#define N_NUM_SECTION_USERINFO  5   // セクション数
#define N_NUM_ROW_USERINFO_SEC1 3   // セクション１の行数
#define N_NUM_ROW_USERINFO_SEC2 2   // セクション２の行数
#define N_NUM_ROW_USERINFO_SEC3 2   // セクション３の行数
#define N_NUM_ROW_USERINFO_SEC4 1   // セクション４の行数
#define N_NUM_ROW_USERINFO_SEC5 3   // セクション５の行数

// 設定-アプリケーションの動作を設定 テーブルビュー設定
#define N_NUM_DEFAULT_JOB_TIME_OUT  @"60"   // ジョブ送信のタイムアウト(秒)の初期値

enum
{
    SCAN_SECTION_APPLICATION,       // セクション(取り込みの設定)
    PRINT_SECTION_APPLICATION,      // セクション(印刷の設定)
    COMMON_SECTION_APPLICATION,     // セクション(共通設定)
    SNMP_SECTION_APPLICATION,       // セクション(SNMP設定)
    
    N_NUM_SECTION_APPLICATION,      // セクション数
};
enum
{
    SCAN_SECTION_PROFILE_AUTO_DELETE,       // プロファイルの自動削除
    SCAN_SECTION_PROFILE_OVERWRITE,         // プロファイルの強制上書き
    
    N_NUM_ROW_APPLICATION_SCAN_SECTION,     // セクション(取り込みの設定)の行数
};
enum
{
    PRINT_SECTION_HIGH_QUALITY,             // 高品質で印刷する
    PRINT_SECTION_RAW_PRINT,                // 印刷にRawプリントを使用する
    PRINT_SECTION_SAVE_INPUT_FILE,          // 他アプリから受けたファイルを残す
    PRINT_SECTION_JOB_TIME_OUT,             // ジョブ送信のタイムアウト(秒)
    PRINT_SECTION_RETENTION_INFO,           // リテンション
    
    N_NUM_ROW_APPLICATION_PRINT_SECTION,    // セクション(印刷の設定)の行数
};
enum
{
    COMMON_SECTION_MFP_AUTO_SWITCH,         // プリンタ／スキャナー自動切替
    COMMON_SECTION_MFP_NAME,                // プリンター／スキャナーの名称
    
    N_NUM_ROW_APPLICATION_COMMON_SECTION,   // セクション(共通設定)の行数
};
enum
{
    SNMP_SECTION_SEARCH_PUBLIC,             // publicで検索する
    SNMP_SECTION_COMMUNITY_STRING,          // Community String
    
    N_NUM_ROW_APPLICATION_SNMP_SECTION,     // セクション(SNMP設定)の行数
};
enum
{
    RETENTION_INFO_SECTION_NO_PRINT_HOLD,   // 印刷せずにホールド
    RETENTION_INFO_SECTION_AUTH_ON,         // パスワードを指定
    RETENTION_INFO_SECTION_PASSWORD,        // パスワード
    
    N_NUM_ROW_RETENTION_INFO_SECTION,       // セクション(リテンション情報設定)の最大行数
};

enum
{
    SETTING_DEVICENAME_STYLE_LOCATION,
    SETTING_DEVICENAME_STYLE_IP_ADDRESS,

    N_NUM_ROW_APPLICATION_SEC2,    // セクション(自動追加プリンター/スキャナーの名称設定)の行数
};

// バージョン情報
#define S_TRADEMARK         NSLocalizedString(@"S_TRADEMARK", @"Sharpdesk Mobile はシャープ株式会社の登録商標です。")
#define S_APPLICATIONNAME   NSLocalizedString(@"S_APPLICATIONNAME", @"Sharpdesk Mobile")
#define S_APPLICATIONNAME2  NSLocalizedString(@"S_APPLICATIONNAME2", @"")
#define S_VERSION           NSLocalizedString(@"S_VERSION", @"Version %@ (%@)")
#define S_COPYRIGHT         NSLocalizedString(@"S_COPYRIGHT", @"Copyright (c) 2012-2015 SHARP CORPORATION;")
#define S_BUTTON_SPECIALMODE        NSLocalizedString(@"S_BUTTON_SPECIALMODE", @"特別モード実行中")
#define S_BUTTON_PRINT_RANGE_EXPANSION  NSLocalizedString(@"S_BUTTON_PRINT_RANGE_EXPANSION", @"印刷範囲拡張有効")
#define S_LIBRARY_LICENSE   NSLocalizedString(@"S_LIBRARY_LICENSE", @"本ソフトウェアは以下の著作物を含んでいます。")
#define S_LIBRARY_SNMPPLUS          @"SNMP++"

//ライセンスファイル名
#define S_LIBRARY_LICENSE_SNMPPLUS  @"License_SNMPplus"
#define S_LIBRARY_LICENSE_MAILCORE  @"License_MailCore"
#define S_LIBRARY_LICENSE_LIBETPAN  @"License_libEtPan"
#define S_LIBRARY_LICENSE_IOSPORTS  @"License_iOSPorts"
#define S_LIBRARY_LICENSE_CYRUSSASL @"License_CyrusSASL"
#define S_LIBRARY_LICENSE_OPENSSL   @"License_OpenSSL"
#define S_LIBRARY_LICENSE_ELCIMAGE  @"License_ELCImagePickerController"
#define S_LIBRARY_LICENSE_MINIZIP   @"License_MiniZip"

//特別モードフラグキー
#define S_SPECIALMODE_FLAG   @"specialModeFlag"
//PDF印刷範囲拡張有効フラグキー
#define S_PDF_PRINT_RANGE_EXPANSION_FLAG   @"pdfPrintRangeExpansionFlag"
//保存する画面のフォルダ階層パスのキー
#define S_KEY_SAVE_PATH      @"S_KEY_SAVE_PATH"
// ログイン名、パスワード暗号化キー
#define S_KEY_PJL            @"Sharpdesk Mobile"

// 共通-ファイル選択画面
#define N_HEIGHT_SEL_FILE   66  // セクションの縦幅
#define N_HEIGHT_SEL_DEFAULT   44  // セクションの縦幅

// 共通−バックグラウンドカラー
#define BACKGROUND_COLOR_IPHONE     [UIColor groupTableViewBackgroundColor]
#define BACKGROUND_COLOR_IPAD1      [UIColor colorWithRed:0.831 green:0.839 blue:0.863 alpha:1]
#define BACKGROUND_COLOR_IPAD2      [UIColor colorWithRed:0.937 green:0.937 blue:0.956 alpha:1]
#define BACKGROUND_COLOR_IPAD       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?BACKGROUND_COLOR_IPAD2:BACKGROUND_COLOR_IPAD1)
#define BACKGROUND_COLOR            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?BACKGROUND_COLOR_IPAD:BACKGROUND_COLOR_IPHONE)

// 共通-無効テキストカラー
#define UNABLE_TEXT_COLOR           [UIColor grayColor]

// 共通-テーブルヘッダーフッター高さ設定
#define TABLE_HEADER_HEIGHT_1   10
#define TABLE_HEADER_HEIGHT_2   30
#define TABLE_FOOTER_HEIGHT_1   10
#define TABLE_FOOTER_HEIGHT_2   32

// 共通-ナビゲーションバースタイル
#define NAVIGATION_BARSTYLE         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?UIBarStyleDefault:UIBarStyleBlackOpaque)

// 共通-ツールバースタイル
#define TOOLBAR_BARSTYLE            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?UIBarStyleDefault:UIBarStyleBlack)

// 共通-ナビゲーションタイトルカラー
#define NAVIGATION_TITLE_COLOR      ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?[UIColor blackColor] :[UIColor whiteColor])

// 共通-テーブルセルアクセサリー
#define TABLE_CELL_ACCESSORY        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?UITableViewCellAccessoryDisclosureIndicator :UITableViewCellAccessoryDetailDisclosureButton)

// iPad用
#define N_BUTTON_FONT_SIZE_DEFAULT 15 // ボタンタイトルのフォントサイズ(標準)
#define N_BUTTON_FONT_SIZE_LITTLE 12  // ボタンタイトルのフォントサイズ(小)
#define N_TABLE_FONT_SIZE_HEADER 14  // テーブルのヘッダーのフォントサイズ(標準)
// iPad用

// SNMP設定
#define N_SNMP_PORT             161
#define S_SNMP_COMMUNITY_STRING_DEFAULT @"public"
#define S_SNMP_OID_PLACE        @"1.3.6.1.2.1.1.6.0"            // 設置場所
#define S_SNMP_OID_FTPPORT      @"1.3.6.1.4.1.2385.2.1.3.2.1.3.10701.14.1" // FTPポート
#define S_SNMP_OID_LANG_INDEX   @"1.3.6.1.2.1.43.5.1.1.10.1"    // MFPの表示言語インデックス
#define S_SNMP_OID_LANG_        @"1.3.6.1.2.1.43.7.1.1.4.1."    // MFPの表示言語（末尾に上記表示言語インデックスで取得した値を追加
#define S_SNMP_OID_PRINTEROPTIONS @"1.3.6.1.2.1.43.15.1.1.2"    // MFPの追加オプション
#define S_SNMP_OID_FINISHER @"1.3.6.1.2.1.43.33.1.1.3"          // MFPのフィニッシャー情報
#define S_SNMP_OID_STAPLELESS_STAPLE    @"1.3.6.1.2.1.43.30.1.1.10" // MFPの針なしステープル情報

#define S_SNMP_OID_LANG_JA      @"2024"
#define S_SNMP_OID_LANG_CH      @"2025"
#define S_SNMP_OID_LANG_CH_TW   @"2026"
#define S_SNMP_OID_LANG_2003   @"2003"
#define S_SNMP_OID_LANG_2001   @"2001"
#define S_SNMP_OID_LANG_2002   @"2002"
#define S_SNMP_OID_LANG_2251   @"2251"
#define S_SNMP_OID_LANG_2253   @"2253"
#define S_SNMP_OID_LANG_2255   @"2255"
#define S_SNMP_OID_LANG_2257   @"2257"

#define S_SNMP_OID_PRINTEROPTION_PCL_1 @"3"     // PCL
#define S_SNMP_OID_PRINTEROPTION_PCL_2 @"47"    // PCL
#define S_SNMP_OID_PRINTEROPTION_PS_1  @"6"     // PS

#define S_SNMP_OID_FINISHER_STITCHING_TYPE @"30"    // stitchingType
#define S_SNMP_OID_FINISHER_STAPLE_TOP_LEFT @"4"    // stapleTopLeft
#define S_SNMP_OID_FINISHER_STAPLE_TOP_RIGHT @"6"   // stapleTopRight
#define S_SNMP_OID_FINISHER_STAPLE_DUAL @"10"       // stapleDual

// 針なしステープル
#define S_SNMP_OID_FINISHER_STAPLELESS_STAPLE @"Stapleless Staple"    // Stapleless Staple

// パンチ
#define S_SNMP_OID_FINISHER_PUNCH_SWITCHING_TYPE @"83" // punch switchingType
#define S_SNMP_OID_FINISHER_PUNCH_3HOLES @"5"       // threeHoleUS(3穴)
#define S_SNMP_OID_FINISHER_PUNCH_2HOLES @"6"       // twoHoleDIN(2穴)
#define S_SNMP_OID_FINISHER_PUNCH_4HOLES @"7"       // fourHoleDIN(4穴)
#define S_SNMP_OID_FINISHER_PUNCH_4HOLESWIDE @"11"  // swedish4Hole(4穴(幅広))

// アイコン名称
// トップ画面
#define S_ICON_TOP_PRINT        @"Top_Print"            // 印刷する
#define S_ICON_TOP_SENDMAIL     @"Top_SendMail"         // メールで送信する
#define S_ICON_TOP_SEND_EX_SITE @"Top_SendExternalSite" // 外部サイトへ送る
#define S_ICON_TOP_SCAN         @"Top_Scan"             // 取り込む
#define S_ICON_TOP_ARRANGE      @"Top_PictureArrange"   // 整理する
#define S_ICON_TOP_SETTINGS     @"Top_Settings"         // 設定
#define S_ICON_TOP_VERSION      @"Top_VersionInfo"      // バージョン情報
#define S_EXTENSION_PNG         @".png"                 // アイコン拡張子(png)

// 印刷画面
#define S_ICON_PRINT_PRINTOUT       @"Print"            // 印刷ボタン
#define S_ICON_PRINT_PRINTER        @"Scanner"          // プリンター選択ボタン
#define S_ICON_PRINT_NUMBER_OF_SETS @"NumberOfSets"     // 部数選択ボタン
#define S_ICON_PRINT_BOTH_ONESIDES  @"Both_OneSides"    // 両面/片面設定ボタン
#define S_ICON_PRINT_SEL_FILE       @"FileSelect"       // ファイル選択ボタン
#define S_ICON_PRINT_SEL_PICTURE    @"PictureSelect"    // 写真選択ボタン
#define S_ICON_PRINT_WEBPAGE        @"WebPageSelect"    // Webページ印刷ボタン
#define S_ICON_PRINT_EMAIL          @"EmailSelect"      // メール印刷ボタン

// 取り込む画面
#define S_ICON_SCAN_SCAN       @"Scan"            // 印刷ボタン
#define S_ICON_SCAN_SCANNER    @"Scanner"         // プリンター選択ボタン
#define S_ICON_SCAN_SAVE       @"PictureSave"
#define N_NUM_PDF_1PAGE_MAXSIZE             1.2f            // PDFファイルの1ページあたりの最大サイズ
#define N_NUM_PDF_ACTIVEMEMORY_MAXSIZE      0.7f            // 空き容量サイズ（掛率）

// メールを送信する画面
#define S_ICON_SENDMAIL_SEND    @"AttachesMail"     // メールに添付するボタンへ変更する

// 外部アプリへ送る画面
#define S_ICON_SEND_SEND        @"SendExternalSite" // 外部アプリへ送るボタンへ変更する

// 整理する画面
#define S_ICON_ARRANGE_DEL      @"PictureDelete"    // 削除ボタン

// 設定画面
#define S_ICON_SETTING_DEVICE           @"Printer_ScannerSetting"       // プリンター/スキャナを設定
#define S_ICON_SETTING_SERVER           @"PrintServerSetting"           // プリントサーバーを設定
#define S_ICON_SETTING_EXCLUDE_MFP      @"Not_Supported"                // 除外プリンター/スキャナを設定
#define S_ICON_SETTING_USERINFO         @"UserInformationSetting"       // ユーザ情報を設定
#define S_ICON_SETTING_MFPLIST          @"Printer_Scanner"              // プリンタ一覧のセル
#define S_ICON_SETTING_UPDATE           @"ListUpdate"                   // 自動更新ボタン
#define S_ICON_SETTING_ADD              @"ManualAdd"                    // 手動追加ボタン
#define S_ICON_SETTING_CLEAR            @"Clear_machine_name_list"   //リストを初期化する
#define S_ICON_SETTING_DEFAULT          @"Selected"                     // 印刷／取り込み画面で選択中のプリンター/スキャナー
#define S_ICON_SETTING_DEFAULT_MANUALY  @"Selected_Manually"            // 印刷／取り込み画面で選択中のプリンター/スキャナー(手動追加)
#define S_ICON_SETTING_MFPLIST_MANUALY  @"Printer_Scanner_Manually"     // プリンタ一覧のプリンター/スキャナー(手動追加)
#define S_ICON_SETTING_DEFAULT_SERVER   @"PrintServer"                  // 印刷／取り込み画面で選択中のプリントサーバー(手動追加)
#define S_ICON_SETTING_MFPLIST_SERVER   @"Selected_PrintServer"         // プリンタ一覧のプリントサーバー(手動追加)


// ボタン矢印ファイル
#define S_IMAGE_PICKER  @"pickerArrow"
#define S_IMAGE_BUTTON_GRAY_PICKER  @"Button_Gray_Arrow"

// サムネイル規定ファイル
#define S_THUMBNAIL_BROKEN  @"Broken"
#define S_ICON_PDF  @"pdf"
#define S_ICON_JPG  @"jpg"
#define S_ICON_TIFF @"tiff"
#define S_ICON_PNG @"png"
#define S_ICON_WORD @"docx"
#define S_ICON_EXCEL @"xlsx"
#define S_ICON_POWERPOINT @"pptx"

// ver1.2 追加アイコン
#define S_ICON_SELECTFILE       @"SelectFile_Select"
#define S_ICON_NON_SELECTFILE   @"SelectFile_NonSelect"
#define S_ICON_DIR              @"Dir"
#define S_ICON_FILE_MOVE        @"FileMove"
#define S_ICON_FILE_DELETE      @"FileDelete"
#define S_ICON_FILE_RENAME      @"FileRename"
#define S_ICON_CREATE_FOLDER    @"CreateFolder"

#define S_ICON_COLORMODE        @"ColorMode"
#define S_ICON_PAPERSIZE        @"PaperSize"
#define S_ICON_ORIENTATION        @"PaperDirection"

#define S_ICON_SETTING_APPLICATION  @"ApplicationSetting"
#define S_ICON_PREVIEWROTATE        @"PreviewRotate"

// ver2.0 追加アイコン
#define S_ICON_SETTING_MAIL_SERVERINFO  @"MailSetting"

// ver2.2 追加アイコン
#define S_ICON_PRINTRELEASE      @"PrintRelease"
#define S_ICON_PAPERTYPE         @"PrintType"


// ボタンの背景画像
#define S_IMAGE_BUTTON_BLUE @"Button_Blue"
#define S_IMAGE_BUTTON_GRAY @"Button_Gray"
#define S_IMAGE_BUTTON_OKCANCEL @"OkCancel_button"

// 言語名
#define S_LANG NSLocalizedString(@"S_LANG", @"JA")
#define S_LANG_JA @"JA"
#define S_LANG_EN @"EN"
#define S_LANG_ZN_CH @"ZN_CH"
#define S_LANG_DE @"DE"
#define S_LANG_ES @"ES"
#define S_LANG_FR @"FR"
#define S_LANG_IT @"IT"
#define S_LANG_NL @"NL"
#define S_LANG_SV @"SV"
#define S_LANG_ZN_TW @"ZN_TW"
#define S_LANG_FI @"FI"
#define S_LANG_DA @"DA"
#define S_LANG_NB @"NB"
#define S_LANG_PT @"PT"
#define S_LANG_HU @"HU"
#define S_LANG_PL @"PL"
#define S_LANG_CS @"CS"
#define S_LANG_SK @"SK"
#define S_LANG_RU @"RU"
#define S_LANG_TR @"TR"
#define S_LANG_EL @"EL"


// Locale
#define S_LOCALE_US @"US"
#define S_LOCALE_CA @"CA"

// ヘルプファイル名
#define S_HELP NSLocalizedString(@"S_HELP", @"help_Jp")
// ライセンスファイル名
#define S_LICENSE NSLocalizedString(@"S_LICENSE", @"License_Jp")
// 特別モードヘルプファイル名
#define S_HELP_SPECIAL_MODE NSLocalizedString(@"S_HELP_SPECIAL_MODE", @"special_Jpn")

// 画面タイトル
#define S_TITLE_TOP             NSLocalizedString(@"S_TITLE_TOP", @"Sharpdesk Mobile")         // トップ画面
#define S_TITLE_PRINT           NSLocalizedString(@"S_TITLE_PRINT", @"印刷する")                  // 印刷画面
#define S_TITLE_SCAN            NSLocalizedString(@"S_TITLE_SCAN", @"取り込む")                  // 取り込む画面
#define S_TITLE_SENDMAIL		NSLocalizedString(@"S_TITLE_SENDMAIL", @"メールに添付する")            // メールを送信する画面
#define S_TITLE_SEND			NSLocalizedString(@"S_TITLE_SEND", @"アプリケーションに送る")       // 外部サイトへ送る画面
#define S_TITLE_ARRANGE         NSLocalizedString(@"S_TITLE_ARRANGE", @"ファイルを管理する")                  // 整理する画面
#define S_TITLE_MOVE            NSLocalizedString(@"S_TITLE_MOVE", @"移動する")                  // 移動する画面
#define S_TITLE_SAVE            NSLocalizedString(@"S_TITLE_SAVE", @"保存する")                  // 保存する画面
#define S_TITLE_CREATE_FOLDER   NSLocalizedString(@"S_TITLE_CREATE_FOLDER", @"フォルダーを作成する")                  // フォルダー作成画面
#define S_TITLE_CHANGE_FILENAME NSLocalizedString(@"S_TITLE_CHANGE_FILENAME", @"ファイル名を変更する")                  // 名称変更画面(ファイル名)
#define S_TITLE_CHANGE_FOLDERNAME NSLocalizedString(@"S_TITLE_CHANGE_FOLDERNAME", @"フォルダー名を変更する")                  // 名称変更画面(フォルダー名)
#define S_TITLE_SETTING         NSLocalizedString(@"S_TITLE_SETTING", @"設定")                     // 設定画面
#define S_TITLE_SETTING_USER    NSLocalizedString(@"S_TITLE_SETTING_USER", @"ユーザー情報を設定")          // 設定-ユーザー情報を設定
#define S_TITLE_SETTING_APPLICATION NSLocalizedString(@"S_TITLE_SETTING_APPLICATION", @"アプリケーションの動作を設定")          // 設定-アプリケーションの動作を設定
#define S_TITLE_SETTING_ADD		NSLocalizedString(@"S_TITLE_SETTING_ADD", @"手動で追加する")				// 設定-手動で追加する
#define S_TITLE_VERSION_INFO    NSLocalizedString(@"S_TITLE_VERSION_INFO", @"バージョン情報")             // 設定-バージョン情報
#define S_SETTING_EMAIL_GET_NUMBER  NSLocalizedString(@"S_SETTING_EMAIL_GET_NUMBER", @"取得件数")             // 取得件数
#define S_SETTING_EMAIL_FILTER_SETTING  NSLocalizedString(@"S_SETTING_EMAIL_FILTER_SETTING", @"フィルタリング設定")             // フィルタリング設定

// ボタン名称
// 共通
#define S_BUTTON_BACK           NSLocalizedString(@"S_BUTTON_BACK", @"戻る")                   // ナビゲーションバー 戻るボタン
#define S_BUTTON_SETTING        NSLocalizedString(@"S_BUTTON_SETTING", @"設定")                   // ナビゲーションバー 設定ボタン
#define S_BUTTON_DECIDE         NSLocalizedString(@"S_BUTTON_DECIDE", @"決定")                   // メニュー 決定ボタン
#define S_BUTTON_FIX            NSLocalizedString(@"S_BUTTON_FIX", @"確定")                   // ナビゲーションバー 確定ボタン
#define S_BUTTON_CANCEL         NSLocalizedString(@"S_BUTTON_CANCEL", @"キャンセル")              // ナビゲーションバー キャンセルボタン
#define S_BUTTON_SAVEVAL        NSLocalizedString(@"S_BUTTON_SAVEVAL", @"保存")                   // ナビゲーションバー 保存ボタン
#define S_BUTTON_MENU           NSLocalizedString(@"S_BUTTON_MENU", @"Menu")             // ナビゲーションバー 縦表示時のメニューボタン
#define S_BUTTON_FILE_LIST      NSLocalizedString(@"S_BUTTON_FILE_LIST", @"ファイル一覧")             // ナビゲーションバー 縦表示時のメニューボタン
#define S_BUTTON_HELP           NSLocalizedString(@"S_BUTTON_HELP", @"ヘルプ")             // ナビゲーションバー ヘルプボタン
#define S_BUTTON_CLOSE          NSLocalizedString(@"S_BUTTON_CLOSE", @"閉じる")             // ナビゲーションバー 閉じるボタン

// ライセンス表示
#define S_BUTTON_AGREE          NSLocalizedString(@"S_BUTTON_AGREE", @"同意する")             // 同意するボタン

// 印刷画面
#define S_BUTTON_PRINTOUT       NSLocalizedString(@"S_BUTTON_PRINTOUT", @"\"%@\"で印刷する")    // 印刷ボタン
#define S_BUTTON_PRINTER        NSLocalizedString(@"S_BUTTON_PRINTER", @"プリンター：\"%@\"")  // プリンター選択ボタン
#define S_BUTTON_NUMBER_OF_SETS NSLocalizedString(@"S_BUTTON_NUMBER_OF_SETS", @"部数：%@部")         // 部数選択ボタン
#define S_BUTTON_SIDE           NSLocalizedString(@"S_BUTTON_SIDE", @"両面/片面：%@")      // 両面/片面設定ボタン
#define S_BUTTON_PAPERSIZE      NSLocalizedString(@"S_BUTTON_PAPERSIZE", @"用紙サイズ：%@")      // 用紙サイズ設定ボタン
#define S_BUTTON_PAPERTYPE      NSLocalizedString(@"S_BUTTON_PAPERTYPE", @"用紙タイプ：%@")      // 用紙タイプ設定ボタン
#define S_BUTTON_COLORMODE      NSLocalizedString(@"S_BUTTON_COLORMODE", @"カラーモード：%@")      // カラーモード設定ボタン
#define S_BUTTON_ORIENTATION    NSLocalizedString(@"S_BUTTON_ORIENTATION", @"印刷の向き：%@")      // 印刷の向き設定ボタン
#define S_BUTTON_NO_PRINTER     NSLocalizedString(@"S_BUTTON_NO_PRINTER", @"利用できるプリンターがありません")

// 取り込む画面
#define S_BUTTON_SCAN       NSLocalizedString(@"S_BUTTON_SCAN", @"\"%@\"から取り込む")  // 印刷ボタン
#define S_BUTTON_SCANNER    NSLocalizedString(@"S_BUTTON_SCANNER", @"スキャナー：\"%@\"")  // プリンター選択ボタン
#define S_BUTTON_SAVE       NSLocalizedString(@"S_BUTTON_SAVE", @"画像を保存する")      // プリンター選択ボタン
#define S_BUTTON_NO_SCANNER NSLocalizedString(@"S_BUTTON_NO_SCANNER", @"利用できるスキャナーがありません")
#define S_LABEL_NO_IMAGE         NSLocalizedString(@"S_LABEL_NO_IMAGE",@"No Image") // No Image

// メールを送信する画面
#define S_BUTTON_SENDMAIL	NSLocalizedString(@"S_BUTTON_SENDMAIL", @"メールに添付する")    // メールを送信するボタン

// 外部アプリへ送る画面
#define S_BUTTON_SEND		NSLocalizedString(@"S_BUTTON_SEND", @"アプリケーションに送る")  // 外部アプリへ送るボタン
#define S_BUTTON_MOVE		NSLocalizedString(@"S_BUTTON_MOVE", @"ここに移動")  // ここに移動ボタン
#define S_BUTTON_SAVE_HERE		NSLocalizedString(@"S_BUTTON_SAVE_HERE", @"ここに保存")  // ここに保存ボタン

// iPad用
// 印刷画面
#define S_BUTTON_PRINTOUT_IPAD       NSLocalizedString(@"S_BUTTON_PRINTOUT_IPAD", @"印刷する")    // 印刷ボタン
#define S_BUTTON_NUMBER_OF_SETS_IPAD NSLocalizedString(@"S_BUTTON_NUMBER_OF_SETS_IPAD", @"%@部")           // 部数選択ボタン
#define S_LABEL_PRINTER_IPAD         NSLocalizedString(@"S_LABEL_PRINTER_IPAD", @"プリンター")      // プリンター
#define S_LABEL_NUMBER_OF_SETS_IPAD  NSLocalizedString(@"S_LABEL_NUMBER_OF_SETS_IPAD", @"部数")           // 部数
#define S_LABEL_SIDE_IPAD            NSLocalizedString(@"S_LABEL_SIDE_IPAD", @"両面/片面")       // 両面/片面設定
#define S_LABEL_PAPERSIZE_IPAD      NSLocalizedString(@"S_LABEL_PAPERSIZE_IPAD", @"用紙サイズ")      // 用紙サイズ設定ボタン
#define S_LABEL_PAPERTYPE_IPAD      NSLocalizedString(@"S_LABEL_PAPERTYPE_IPAD", @"用紙タイプ")      // 用紙タイプ設定ボタン

#define S_LABEL_COLORMODE_IPAD      NSLocalizedString(@"S_LABEL_COLORMODE_IPAD", @"カラーモード")      // カラーモード設定ボタン
#define S_LABEL_ORIENTATION_IPAD    NSLocalizedString(@"S_LABEL_ORIENTATION_IPAD", @"印刷の向き")      // 印刷の向き設定ボタン

// 取り込む画面
#define S_BUTTON_SCAN_IPAD       NSLocalizedString(@"S_BUTTON_SCAN_IPAD", @"取り込む")  // 印刷ボタン
#define S_LABEL_SCANER_IPAD      NSLocalizedString(@"S_LABEL_SCANER_IPAD", @"スキャナー")    // スキャナー

// メールを送信する画面
#define S_BUTTON_SENDMAIL_IPAD	NSLocalizedString(@"S_BUTTON_SENDMAIL_IPAD", @"添付する")    // メールを送信するボタン

// 外部アプリへ送る画面
#define S_BUTTON_SEND_IPAD		NSLocalizedString(@"S_BUTTON_SEND_IPAD", @"送る")  // 外部アプリへ送るボタン
// iPad用

// 整理する画面
#define S_BUTTON_DEL        NSLocalizedString(@"S_BUTTON_DEL", @"ファイルを削除する")    // ファイルを削除するボタン


// ファイル一覧共通
#define S_LABEL_FOLDER      NSLocalizedString(@"S_LABEL_FOLDER", @"フォルダー")      // フォルダー
#define S_LABEL_FILE        NSLocalizedString(@"S_LABEL_FILE", @"ファイル")       // ファイル
// iPad用
#define S_KEY_SELECT_INDEX_SECTION  @"S_KEY_SELECT_INDEX_SECTION"   // 選択ファイルのインデックスを保存
#define S_KEY_SELECT_INDEX_ROW      @"S_KEY_SELECT_INDEX_ROW"       // 選択ファイルのインデックスを保存
#define S_KEY_SELECT_DIR            @"S_KEY_SELECT_DIR"                     // 選択ファイルのディレクトリを保存
#define S_KEY_SELECT_FPATH          @"S_KEY_SELECT_FPATH"                 // 選択ファイルのをパスを保存
// iPad用

// 検索キー
#define S_SEARCH_KEY      @"searchKeyString"

//ソート（昇順/降順)キー
#define S_SCANDATA_DIR    @"scanDataSortDirectionType"

//ソート（項目)キー
#define S_SCANDATA_TYPE   @"ScanDataSortType"

//　ファイルのソートキー
enum ScanDataSortDirectionType
{
    SCANDATA_ASC = 0,
    SCANDATA_DES
};

enum ScanDataSortType
{
    SCANDATA_FILEDATE = 0,
    SCANDATA_FILENAME,
    SCANDATA_FILESIZE,
    SCANDATA_FILETYPE
};

// フィニッシャー対応有無
typedef enum {
    STAPLE_ERR = -1,
    STAPLE_NONE,
    STAPLE_ONE,
    STAPLE_TWO,
    STAPLE_NONE_STAPLELESS,
    STAPLE_ONE_STAPLELESS,
    STAPLE_TWO_STAPLELESS
} STAPLE;

// ソート用パネル(iPhone:modal, iPad:popover) タイトル
#define S_SORT_TITLE            NSLocalizedString(@"S_SORT_TITLE", @"並べ替え")

// ソート用パネル(iPhone:modal, iPad:popover) ソートキー　cell名
#define S_SORT_BUTTON_DATE      NSLocalizedString(@"S_SORT_BUTTON_DATE", @"タイムスタンプ")
#define S_SORT_BUTTON_NAME      NSLocalizedString(@"S_SORT_BUTTON_NAME", @"ファイル名")
#define S_SORT_BUTTON_SIZE      NSLocalizedString(@"S_SORT_BUTTON_SIZE", @"ファイルサイズ")
#define S_SORT_BUTTON_TYPE      NSLocalizedString(@"S_SORT_BUTTON_TYPE", @"ファイルの種類")

// 設定-プリンター/スキャナを設定画面
#define S_BUTTON_AUTO_UPDATE    NSLocalizedString(@"S_BUTTON_AUTO_UPDATE", @"リストを自動で更新する")
#define S_BUTTON_MANUAL_ADD     NSLocalizedString(@"S_BUTTON_MANUAL_ADD", @"手動で追加する")

// 設定-プリンター/スキャナ除外設定画面
#define S_BUTTON_EXCLUDE_DEVICE_ADD    NSLocalizedString(@"S_BUTTON_EXCLUDE_DEVICE_ADD", @"追加する")
#define S_BUTTON_EXCLUDE_DEVICE_INITIALIZE     NSLocalizedString(@"S_BUTTON_EXCLUDE_DEVICE_INITIALIZE", @"リストを初期化する")
#define MSG_EXCLUDE_DEVICE_INITIALIZE NSLocalizedString(@"MSG_EXCLUDE_DEVICE_INITIALIZE", @"リストを初期化します")

// プレビュー画面共通メニューID
enum PreviewMenuID
{
    PrvMenuIDNone = 0,
    PrvMenuIDFirst,
    PrvMenuIDSecond,//プリントorスキャナー選択ボタン
    PrvMenuIDThird,
    PrvMenuIDFourth,
    PrvMenuIDFifth,
    PrvMenuIDSixth,
    PrvMenuIDSeventh,
    PrvMenuIDEighth,
    PrvMenuIDNinth,
    PrvMenuIDTenth,
    PrvMenuIDEleventh,
    PrvMenuIDTwelveth,
    PrvMenuIDThirteenth,
    PrvMenuIDFourteenth,
    PrvMenuIDMax
};

// 印刷画面 FTP送信バッファサイズ
enum
{
    //kSendBufferSize = 32768
    kSendBufferSize = 1572864
};

// 印刷画面 FTP送信エラーコード
enum ERRCODE_SENDFTP
{
    SUCCESS = 0,
    ERR_INVALID_FILEPATH,
    ERR_INVALID_URL,
    ERR_FAILED_SET_SENDPRM,
    ERR_FAILED_SENDFTP,
    ERR_INVALID_HOSTNAME
};

// 入力チェックエラーコード
enum ERRCODE_INPUT_CHECK
{
	ERR_SUCCESS = 0,		// 成功
	ERR_NO_INPUT,			// 未入力
	ERR_INVALID_FORMAT,		// 入力形式不正
	ERR_INVALID_CHAR_TYPE,	// 文字種不正
	ERR_OVER_NUM_RANGE,		// 数値範囲外
    ERR_INPUT_DUPULICATE,    // 重複
    ERR_OVER_INPUT          // 文字数超過
};

// ファイルチェックエラーコード
enum ERRCODE_FILE_INPUT_CHECK
{
	FILE_ERR_SUCCESS = 0,		// 成功
	FILE_ERR_NO_INPUT,			// 未入力
	FILE_ERR_INVALID_FORMAT,	// 入力形式不正
	FILE_ERR_INVALID_CHAR_TYPE,	// 文字種不正
    FILE_ERR_RESERVED_WORD,	    // 予約語
	FILE_ERR_OVER_NUM_RANGE,	// 数値範囲外
    FILE_ERR_NO_CHANGE,         // ファイル名変更なし
    FILE_ERR_EXISTS_SAME,       // 同じファイル名が存在
    FILE_ERR_MOVE_SAMEDIR,      // 同じフォルダーに移動
    FILE_ERR_MOVE_PARENTCHILD,  // 移動元フォルダーのサブフォルダーに移動
    FILE_ERR_MOVE_FILEDIRECTORYSAME,    // 移動先に指定したファイル名と同じ名前のフォルダーが存在
    FILE_ERR_MOVE_DIRECTORYFILESAME,    // 移動先に指定したフォルダー名と同じ名前のファイルが存在
    FILE_ERR_MOVE_FAILED,       // 移動処理に失敗
    FILE_ERR_FAILED             // 変更に失敗
};

// 移動チェックコード
enum MOVE_CHECK
{
	EXISTS_OVERWRITEFILE_OK = 0,		// 成功
	EXISTS_OVERWRITEFILE_OVERWRITE,     // 上書き
    EXISTS_OVERWRITEFILE_FILEDIRECTORYSAME,			// 移動先に指定したファイル名と同じ名前のフォルダーが存在
    EXISTS_OVERWRITEFILE_DIRECTORYFILESAME          // 移動先に指定したフォルダー名と同じ名前のファイルが存在
};

// ファイル選択画面の遷移元画面ID
enum PrevViewID
{
    PV_PRINT_SELECT_FILE_CELL = 1,
    PV_PRINT_SELECT_PICTURE_CELL,
    PV_PRINT_WEBPAGE_CELL,
    PV_PRINT_MAIL_CELL,
    SendMailSelectTypeView,
    SendExSiteSelectTypeView,
    ArrangeSelectTypeView,
    // iPad用
    SettingMenu,
    ScanTempDataView,
    // iPad用
    SearchResultTypeView,
    AdvancedSearchResultTypeView,
    SelectMailView
};

// 印刷プレビュー画面の遷移元ID
typedef enum PrintPictViewID
{
    PPV_OTHER = 0,
    PPV_PRINT_SELECT_FILE_CELL,
    PPV_PRINT_SELECT_PICTURE_CELL,
    PPV_PRINT_WEBPAGE_CELL,
    PPV_PRINT_MAIL_CELL,
    WEB_PRINT_VIEW,
    EMAIL_PRINT_VIEW,
    PPV_PRINT_MAIL_ATTACHMENT_CELL,
    PPV_PRINT_MULTI_FILE_PREVIEW,
} PrintPictViewID;

// PDFファイル読み込みエラーコード
enum CHECKCODE_PDF_VIEW
{
    CHK_PDF_VIEW_OK = 0,               // 表示可能
    CHK_PDF_NO_VIEW_FILE,              // 非対応ファイル(ファイルが読み込めない、暗号化PDF)
    CHK_PDF_OVER_1PAGE_MAXSIZE,        // 1ページあたりのファイルサイズが規定値以上
    CHK_PDF_OVER_ACTIVEMEMORY_MAXSIZE,  // ファイルサイズが残メモリの規定値以上
    CHK_PDF_ENCRYPTED_FILE             // 暗号化PDF
};

// メール印刷オプション
enum MAIL_OPTION_TYPE
{
    MAIL_OPTION_TYPE_DEFAULT = -1,
    MAIL_OPTION_TYPE_1 = 1,
    MAIL_OPTION_TYPE_2 = 2,
};

// プリントリリース選択状態
enum PRINT_RELEASE_VALUE
{
    PRINT_RELEASE_NOT_SUPPORTED = -1,
    PRINT_RELEASE_DISABLED = 1,
    PRINT_RELEASE_ENABLED = 2,
};

// 印刷対象
enum PRINT_TARGET_VALUE
{
    PRINT_TARGET_NOT_AVAILABLE = -1,
    PRINT_TARGET_ALL_SHEETS_OFF = 1,
    PRINT_TARGET_ALL_SHEETS_ON = 2,
};

// Tempファイル名称
//#define S_TEMP_PRINT_JPG    @"temp_print.jpg"   // PhotoLibraryのイメージファイル名(jpg)
//#define S_TEMP_PRINT_PNG    @"temp_print.png"   // PhotoLibraryのイメージファイル名(png)
//#define S_TEMP_PRINT_TIF    @"temp_print.tif"   // PhotoLibraryのイメージファイル名(tif)

// Bonjour関連
#define S_WEB_SERVICE_TYPE  @"_pdl-datastream._tcp" // 検索サービスタイプ
#define S_INIT_DOMAIN       @"local"                // 検索ドメイン名

// DATファイル情報
#define S_PRINTERDATA_DAT @"/PrinterData.dat"   // プリンタ情報DATファイル
#define S_EXCLUDEPRINTERDATA_DAT @"/ExcludePrinterData.dat"   // 除外プリンタ情報DATファイル
#define S_CUSTOMSIZEDATA_DAT @"/CustomSizeData.dat" // カスタムサイズDATファイル
#define S_REMOTESCANSETTING_DAT @"/RemoteScanSettingData.dat" // リモートスキャン設定DATファイル

#define S_PRINTSERVERDATA_DAT @"/PrintServerData.dat"   // プリントサーバー情報DATファイル

// 取り込み時のFTP情報
#define S_FTP_USER @"SharpSPUser"    //ftpユーザ
#define S_FTP_PORT @"4687"                       // ポート番号
#define N_FTP_PORT 4687                      // ポート番号

// 取り込み時のFTPパスワード(特別モード時)
#define S_FTP_SPECIAL_PASSWORD @"SharpdeskM"

// PrinterDataCell用のセル位置
#define MFP_SETTING_IMAGE_X 4
#define MFP_SETTING_IMAGE_Y 4
#define MFP_SETTING_IMAGE_W 50
#define MFP_SETTING_IMAGE_H 50

#define MFP_SETTING_NAME_X 60
#define MFP_SETTING_NAME_Y 10
#define MFP_SETTING_NAME_W 250
#define MFP_SETTING_NAME_H 20

#define MFP_SETTING_IPADDRESS_X 60
#define MFP_SETTING_IPADDRESS_Y 30
#define MFP_SETTING_IPADDRESS_W 250
#define MFP_SETTING_IPADDRESS_H 20


// PrinterDetailDataCell用のセル位置
#define MFP_SETTING_DETAIL_TITLE_X 10
#define MFP_SETTING_DETAIL_TITLE_Y 5
#define MFP_SETTING_DETAIL_TITLE_W 80
#define MFP_SETTING_DETAIL_TITLE_H 30

#define MFP_SETTING_DETAIL_VAL_X 110
#define MFP_SETTING_DETAIL_VAL_Y 5
#define MFP_SETTING_DETAIL_VAL_W 150
#define MFP_SETTING_DETAIL_VAL_H 30

#define MFP_SETTING_DETAIL_TITLE_X_IPAD 20
#define MFP_SETTING_DETAIL_TITLE_W_IPAD 110
#define MFP_SETTING_DETAIL_VAL_X_IPAD 140
#define MFP_SETTING_DETAIL_VAL_W_IPAD 100


#define DISTANCE_1 10
#define DISTANCE_2 20

// 内部メモリキー情報
// 最新印刷情報
#define S_KEY_LATEST_PRIMARY_KEY        @"KEY_LATEST_PRIMARYKEY"        // プライマリキー (プリンター)
#define S_KEY_LATEST_PRIMARY_KEY2       @"KEY_LATEST_PRIMARYKEY2"       // プライマリキー (プリントサーバー)
#define S_KEY_LATEST_IDX_NUM_OF_SETS    @"KEY_LATEST_IDX_NUM_OF_SETS"   // 部数index
#define S_KEY_LATEST_NUM_OF_SETS        @"KEY_LATEST_NUM_OF_SETS"       // 部数
#define S_KEY_LATEST_IDX_SIDE           @"KEY_LATEST_IDX_SIDE"          // 両面/片面index
#define S_KEY_LATEST_SIDE               @"KEY_LATEST_SIDE"              // 両面/片面
#define S_KEY_LATEST_PRINT_TYPE         @"KEY_LATEST_PRINT_TYPE"      // プリンター/スキャナー or プリントサーバー

// 印刷画面 ログイン情報
#define S_PRINT_LOGIN_ID        @"anonymous"    // ログインID
#define S_PRINT_LOGIN_PASSWORD  @""             // パスワード

// 印刷画面 PJL情報
#define N_PJL_ESC               27
#define S_PJL_JOB               @"%-12345X"
#define S_PJL_JOB_NAME          @"@PJL JOB NAME=%@\r\n"
#define S_PJL_SET_SPOOLTIME     @"@PJL SET SPOOLTIME=\"%@\"\r\n"
#define S_PJL_EOJ_NAME          @"@PJL EOJ NAME=%@\r\n"
#define S_PJL_SET_JOB_NAME_DEFAULT      @"SharpdeskMobile Job"
#define S_PJL_SET_JOB_NAME      @"@PJL SET JOBNAME=\"%@\"\r\n"
#define S_PJL_SET_JOB_NAMEW     @"@PJL SET JOBNAMEW=\"%@\"\r\n"
#define S_PJL_SET_USER_NAME_DEFAULT    @"SharpdeskM User"
#define S_PJL_SET_USER_NAME     @"@PJL SET USERNAME=\"%@\"\r\n"
#define S_PJL_SET_USER_NAMEW    @"@PJL SET USERNAMEW=\"%@\"\r\n"
#define S_PJL_SET_QTY           @"@PJL SET QTY=%zd\r\n"
#define S_PJL_SET_DUPLEX        @"@PJL SET DUPLEX=%@\r\n"
#define S_PJL_SET_BINDING       @"@PJL SET BINDING=%@\r\n"
#define S_PJL_SET_JOBSTAPLE     @"@PJL SET JOBSTAPLE=%@\r\n"
#define S_PJL_SET_STAPLEOPTION     @"@PJL SET STAPLEOPTION=%@\r\n"
#define S_PJL_SET_PUNCH         @"@PJL SET PUNCH=%@\r\n"
#define S_PJL_SET_PUNCH_NUMBER  @"@PJL SET PUNCH-NUMBER=%@\r\n"
#define S_PJL_SET_ACCOUNTNUMBER @"@PJL SET ACCOUNTNUMBER=\"%@\"\r\n"
#define S_PJL_LANGUAGE          @"@PJL ENTER LANGUAGE=%@\r\n"
#define S_PJL_XL                @") HP-PCL XL;3;0;\r\n"
#define S_PJL_SET_RESOLUTION    @"@PJL SET RESOLUTION=600\r\n"
#define S_PJL_SET_RENDERMODEL   @"@PJL SET RENDERMODEL=%@\r\n"
#define S_PJL_SET_PRINTAGENT   @"@PJL SET PRINTAGENT=\"Sharpdesk Mobile (%@) V%@\"\r\n"
#define S_PJL_SET_PRINTAGENT_IPAD   @"iPad"
#define S_PJL_SET_PRINTAGENT_IPHONE   @"iPhone"
#define S_PJL_SET_PRINTRELEASE @"@PJL SET PRINTRELEASE=%@\r\n"
#define S_PJL_SET_PRINTRELEASE_ON @"ON"
#define S_PJL_SET_PRINTRELEASE_OFF @"OFF"
#define S_PJL_SET_ACCOUNTLOGIN  @"@PJL SET ACCOUNTLOGIN=\"%@\"\r\n"
#define S_PJL_SET_ACCOUNTLOGINW @"@PJL SET ACCOUNTLOGINW=\"%@\"\r\n"
#define S_PJL_SET_ACCOUNTPASSWORD  @"@PJL SET ACCOUNTPASSWORD=\"%@\"\r\n"
#define S_PJL_SET_ACCOUNTPASSWORDW @"@PJL SET ACCOUNTPASSWORDW=\"%@\"\r\n"
#define S_PJL_SET_COLORMODE     @"@PJL SET COLORMODE=%@\r\n"
#define S_PJL_SET_PAPER         @"@PJL SET PAPER=%@\r\n"
#define S_PJL_SET_FILING_OFF                    @"OFF"
#define S_PJL_SET_FILING_PERMANENCE             @"PERMANENCE"
#define S_PJL_SET_FILING                        @"@PJL SET FILING=%@\r\n"
#define S_PJL_SET_FILINGFOLDERPATH_STANDARD     @"*standard"
#define S_PJL_SET_FILINGFOLDERPATH              @"@PJL SET FILINGFOLDERPATH=\"%@\"\r\n"
#define S_PJL_SET_FILINGFOLDERPATHW             @"@PJL SET FILINGFOLDERPATHW=\"%@\"\r\n"
#define S_PJL_SET_PRINTPAGES           @"@PJL SET PRINTPAGES=\"%@\"\r\n"
#define S_PJL_SET_HOLD_OFF                      @"OFF"
#define S_PJL_SET_HOLD_STORE                    @"STORE"
#define S_PJL_SET_HOLD                          @"@PJL SET HOLD=%@\r\n"
#define S_PJL_SET_HOLDTYPE_PRIVATE              @"@PJL SET HOLDTYPE=PRIVATE\r\n"
#define S_PJL_SET_HOLDKEY                       @"@PJL SET HOLDKEY=\"%@\"\r\n"
#define S_PJL_SET_PAGEIMAGEINFO_ONEUP   @"ONEUP"
#define S_PJL_SET_PAGEIMAGEINFO_TWOUP   @"TWOUP"
#define S_PJL_SET_PAGEIMAGEINFO_FOURUP  @"FOURUP"
#define S_PJL_SET_PAGEIMAGEINFO         @"@PJL SET PAGEIMAGEINFO=%@\r\n"
#define S_PJL_SET_PAGENUPORDERINFO_OFF                   @"OFF"
#define S_PJL_SET_PAGENUPORDERINFO_LEFT_TO_RIGHT         @"LTOR"
#define S_PJL_SET_PAGENUPORDERINFO_RIGHT_TO_LEFT         @"RTOL"
#define S_PJL_SET_PAGENUPORDERINFO_TOP_TO_BOTTOM         @"TTOB"
#define S_PJL_SET_PAGENUPORDERINFO_UPPERLEFT_TO_RIGHT    @"RANDD"
#define S_PJL_SET_PAGENUPORDERINFO_UPPERLEFT_TO_BOTTOM   @"DANDR"
#define S_PJL_SET_PAGENUPORDERINFO_UPPERRIGHT_TO_LEFT    @"LANDD"
#define S_PJL_SET_PAGENUPORDERINFO_UPPERRIGHT_TO_BOTTOM  @"DANDL"
#define S_PJL_SET_PAGENUPORDERINFO                       @"@PJL SET PAGENUPORDERINFO=%@\r\n"
#define S_PJL_SET_MEDIATYPE         @"@PJL SET MEDIATYPE=%@\r\n"
#define S_PJL_SET_PRINT_TARGET @"@PJL SET ALLSHEETS=%@\r\n"
#define S_PJL_SET_PRINT_TARGET_OFF @"OFF"
#define S_PJL_SET_PRINT_TARGET_ON @"ON"
#define S_PJL_SET_OUTBIN        @"@PJL SET OUTBIN=%@\r\n"
#define S_PJL_SET_OUTBIN_AUTO   @"AUTO"

#define S_PJL_JOB_NAME_ADDR     @"\"%@\""
#define S_PJL_DUPLEX_ON         @"ON"
#define S_PJL_DUPLEX_OFF        @"OFF"
#define S_PJL_SET_BINDING_LEFTEDGE       @"LEFTEDGE"
#define S_PJL_SET_BINDING_RIGHTEDGE      @"RIGHTEDGE"
#define S_PJL_SET_BINDING_UPPEREDGE      @"UPPEREDGE"
#define S_PJL_SET_JOBSTAPLE_STAPLENO     @"STAPLENO"
#define S_PJL_SET_JOBSTAPLE_STAPLELEFT   @"STAPLELEFT"
#define S_PJL_SET_JOBSTAPLE_STAPLEBOTH   @"STAPLEBOTH"
#define S_PJL_SET_STAPLEOPTION_STAPLELESS   @"STAPLELESS"
#define S_PJL_SET_PUNCH_ON               @"ON"
#define S_PJL_SET_PUNCH_OFF              @"OFF"
#define S_PJL_SET_PUNCH_NUMBER_TWO       @"TWO"
#define S_PJL_SET_PUNCH_NUMBER_THREE     @"THREE"
#define S_PJL_SET_PUNCH_NUMBER_FOUR      @"FOUR"
#define S_PJL_SET_PUNCH_NUMBER_FOURWIDE  @"FOURWIDE"

#define S_PJL_LANGUAGE_PDF      @"PDF"
#define S_PJL_LANGUAGE_TIFF     @"TIFF"
#define S_PJL_LANGUAGE_JPEG     @"JPEG"
#define S_PJL_LANGUAGE_AUTO     @"SHARPAUTO"
#define S_PJL_RENDERMODEL_ON    @"CMYK4B"
#define S_PJL_RENDERMODEL_OFF   @"CMYK1B"
#define S_PJL_RENDERMODEL_BW_ON    @"G4"
#define S_PJL_RENDERMODEL_BW_OFF   @"G1"
#define S_PJL_COLORMODE_AUTO    @"AUTO"
#define S_PJL_COLORMODE_COLOR   @"COLOR"
#define S_PJL_COLORMODE_BW    @"BW"

#define S_PJL_PAPERSIZE_LETTER      @"LETTER"
#define S_PJL_PAPERSIZE_LEGAL       @"LEGAL"
#define S_PJL_PAPERSIZE_A4          @"A4"
#define S_PJL_PAPERSIZE_A4WIDE      @"A4WIDE(12x9)"
#define S_PJL_PAPERSIZE_LEDGER      @"LEDGER"
#define S_PJL_PAPERSIZE_LEDGERWIDE  @"LEDGER WIDE"
#define S_PJL_PAPERSIZE_A3          @"A3"
#define S_PJL_PAPERSIZE_A3WIDE      @"A3WIDE"
#define S_PJL_PAPERSIZE_JISB4       @"JISB4"
#define S_PJL_PAPERSIZE_JISB5       @"JISB5"
#define S_PJL_PAPERSIZE_EXECUTIVE   @"EXECUTIVE"
#define S_PJL_PAPERSIZE_COM10       @"COM10"
#define S_PJL_PAPERSIZE_MONARCH     @"MONARCH"
#define S_PJL_PAPERSIZE_C5          @"C5"
#define S_PJL_PAPERSIZE_DL          @"DL"
#define S_PJL_PAPERSIZE_B4          @"B4"
#define S_PJL_PAPERSIZE_B5          @"B5"
#define S_PJL_PAPERSIZE_ISOB5       @"ISOB5"
#define S_PJL_PAPERSIZE_CUSTOM      @"CUSTOM"
#define S_PJL_PAPERSIZE_JPOST       @"JPOST"
#define S_PJL_PAPERSIZE_JPOSTD      @"JPOSTD"
#define S_PJL_PAPERSIZE_ENVL3       @"ENVL3"
#define S_PJL_PAPERSIZE_CHOKEI3     @"CHOKEI3"
#define S_PJL_PAPERSIZE_CHOKEI4     @"CHOKEI4"
#define S_PJL_PAPERSIZE_YOKEI2      @"YOKEI2"
#define S_PJL_PAPERSIZE_YOKEI4      @"YOKEI4"
#define S_PJL_PAPERSIZE_KAKUGATA2   @"KAKUGATA2"
#define S_PJL_PAPERSIZE_KAKUGATA3   @"KAKUGATA3"
#define S_PJL_PAPERSIZE_A5          @"A5"
#define S_PJL_PAPERSIZE_A6R         @"A6R"
#define S_PJL_PAPERSIZE_FOLIO       @"FOLIO"
#define S_PJL_PAPERSIZE_INVOICE     @"INVOICE"
#define S_PJL_PAPERSIZE_FOOLSCAP    @"FOOLSCAP"
#define S_PJL_PAPERSIZE_STAMP       @"STAMP"
#define S_PJL_PAPERSIZE_B6R         @"B6R"
#define S_PJL_PAPERSIZE_CHINESE8K   @"CHINESE8K"
#define S_PJL_PAPERSIZE_CHINESE16K  @"CHINESE16K"
#define S_PJL_PAPERSIZE_SRA3        @"SRA3"
#define S_PJL_PAPERSIZE_SRA4        @"SRA4"
#define S_PJL_PAPERSIZE_KX4         @"KX4"
#define S_PJL_PAPERSIZE_KX8         @"KX8"
#define S_PJL_PAPERSIZE_AX4         @"AX4"
#define S_PJL_PAPERSIZE_AX8         @"AX8"
#define S_PJL_PAPERSIZE_MXLEGAL     @"MXLEGAL"
#define S_PJL_PAPERSIZE_ASIANLEGAL  @"ASIANLEGAL"

// 用紙タイプ
#define S_PJL_PAPERTYPE_AUTOSELECT      @"DEFAULTMEDIATYPE"
#define S_PJL_PAPERTYPE_PLAIN           @"PLAIN"
#define S_PJL_PAPERTYPE_LETTERHEAD      @"LETTERHEAD"
#define S_PJL_PAPERTYPE_PREPRINTED      @"PREPRINTED"
#define S_PJL_PAPERTYPE_PREPUNCHED      @"PREPUNCHED"
#define S_PJL_PAPERTYPE_RECYCLED        @"RECYCLED"
#define S_PJL_PAPERTYPE_COLOR           @"COLOR"
#define S_PJL_PAPERTYPE_LABELS          @"LABELS"
#define S_PJL_PAPERTYPE_HEAVYPAPER      @"BOND"
#define S_PJL_PAPERTYPE_TRANSPARENCY    @"TRANSPARENCY"
#define S_PJL_PAPERTYPE_ENVELOPE        @"ENVELOPE"
#define S_PJL_PAPERTYPE_POSTCARD        @"POSTCARD"

//PDF1.4対応用
#define S_PDF_SHARP_SCANHEADER_CREATOR @"Creator";
//#define S_PDF_SHARP_SCANHEADER_SEARCH_BYTE  84
#define S_PDF_SHARP_SCANHEADER_SEARCH_BYTE  1000000
#define S_PDF_SHARP_SCANHEADER_SHARP_CAPITAL  @"Sharp"
#define S_PDF_SHARP_RAWPRINT_THRESHOLD  4000  //PDFの書き出しのデータ上限

#define S_PDF_SHARP_SCANHEADER  @"%PDF-1.4 Sharp Scanned ImagePDF"
#define S_PDF_SHARP_SCANHEADER_DUMMY  @"%PDF-1.4 Sharr Scanned ImagePDF"
#define S_PDFA_SHARP_SCANHEADER_PREFIX  @"%PDF-1.4\n%"
#define S_PDFA_SHARP_SCANHEADER_SUFIX  @"\n%Sharp Scanned ImagePDF"
#define S_PDF_SHARP_SCANHEADER_SHARP  @"sharp"
#define S_PDF_SHARP_SCANHEADER_SCANNED  @"scanned"
#define S_PDF_SHARP_SCANHEADER_COMPACT  @"compact"
#define S_PDF_SHARP_SCANHEADER_COMPACT_CREATOR @"/Creator.*Sharp"


#define N_COMPACT_PDF_A3_SIZE   540000

// 印刷画面 片面/両面設定
#define S_ONE_SIDE          NSLocalizedString(@"S_ONE_SIDE", @"片面印刷")
#define S_DUPLEX_SIDE_SHORT NSLocalizedString(@"S_DUPLEX_SIDE_SHORT", @"両面印刷 たてとじ")
#define S_DUPLEX_SIDE_LONG  NSLocalizedString(@"S_DUPLEX_SIDE_LONG", @"両面印刷 よことじ")

enum PrintSideEnum
{
    E_ONE_SIDE = 0,         // 片面
    E_DUPLEX_SIDE_LONG,     // 両面横綴じ
    E_DUPLEX_SIDE_SHORT     // 両面縦綴じ
};

#define S_PRINT_COLORMODE_AUTO   NSLocalizedString(@"S_PRINT_COLORMODE_AUTO", @"自動")
#define S_PRINT_COLORMODE_COLOR   NSLocalizedString(@"S_PRINT_COLORMODE_COLOR", @"カラー")
#define S_PRINT_COLORMODE_BW   NSLocalizedString(@"S_PRINT_COLORMODE_BW", @"グレースケール")

enum PrintColormodeEnum
{
    E_COLORMODE_AUTO = 0,   // 自動
    E_COLORMODE_COLOR,      // カラー
    E_COLORMODE_BW          // グレースケール
};


#define S_PRINT_PAPERSIZE_LETTER NSLocalizedString(@"S_PRINT_PAPERSIZE_LETTER", @"S_PRINT_PAPERSIZE_LETTER")
#define S_PRINT_PAPERSIZE_LEGAL NSLocalizedString(@"S_PRINT_PAPERSIZE_LEGAL", @"S_PRINT_PAPERSIZE_LEGAL")
#define S_PRINT_PAPERSIZE_A4 NSLocalizedString(@"S_PRINT_PAPERSIZE_A4", @"S_PRINT_PAPERSIZE_A4")
#define S_PRINT_PAPERSIZE_A4WIDE NSLocalizedString(@"S_PRINT_PAPERSIZE_A4WIDE", @"S_PRINT_PAPERSIZE_A4WIDE")
#define S_PRINT_PAPERSIZE_LEDGER NSLocalizedString(@"S_PRINT_PAPERSIZE_LEDGER", @"S_PRINT_PAPERSIZE_LEDGER")
#define S_PRINT_PAPERSIZE_LEDGERWIDE NSLocalizedString(@"S_PRINT_PAPERSIZE_LEDGERWIDE", @"S_PRINT_PAPERSIZE_LEDGER WIDE")
#define S_PRINT_PAPERSIZE_A3 NSLocalizedString(@"S_PRINT_PAPERSIZE_A3", @"S_PRINT_PAPERSIZE_A3")
#define S_PRINT_PAPERSIZE_A3WIDE NSLocalizedString(@"S_PRINT_PAPERSIZE_A3WIDE", @"S_PRINT_PAPERSIZE_A3WIDE")
#define S_PRINT_PAPERSIZE_JISB4 NSLocalizedString(@"S_PRINT_PAPERSIZE_JISB4", @"S_PRINT_PAPERSIZE_JISB4")
#define S_PRINT_PAPERSIZE_JISB5 NSLocalizedString(@"S_PRINT_PAPERSIZE_JISB5", @"S_PRINT_PAPERSIZE_JISB5")
#define S_PRINT_PAPERSIZE_EXECUTIVE NSLocalizedString(@"S_PRINT_PAPERSIZE_EXECUTIVE", @"S_PRINT_PAPERSIZE_EXECUTIVE")
#define S_PRINT_PAPERSIZE_COM10 NSLocalizedString(@"S_PRINT_PAPERSIZE_COM10", @"S_PRINT_PAPERSIZE_COM10")
#define S_PRINT_PAPERSIZE_MONARCH NSLocalizedString(@"S_PRINT_PAPERSIZE_MONARCH", @"S_PRINT_PAPERSIZE_MONARCH")
#define S_PRINT_PAPERSIZE_C5 NSLocalizedString(@"S_PRINT_PAPERSIZE_C5", @"S_PRINT_PAPERSIZE_C5")
#define S_PRINT_PAPERSIZE_DL NSLocalizedString(@"S_PRINT_PAPERSIZE_DL", @"S_PRINT_PAPERSIZE_DL")
#define S_PRINT_PAPERSIZE_B4 NSLocalizedString(@"S_PRINT_PAPERSIZE_B4", @"S_PRINT_PAPERSIZE_B4")
#define S_PRINT_PAPERSIZE_B5 NSLocalizedString(@"S_PRINT_PAPERSIZE_B5", @"S_PRINT_PAPERSIZE_B5")
#define S_PRINT_PAPERSIZE_ISOB5 NSLocalizedString(@"S_PRINT_PAPERSIZE_ISOB5", @"S_PRINT_PAPERSIZE_ISOB5")
#define S_PRINT_PAPERSIZE_CUSTOM NSLocalizedString(@"S_PRINT_PAPERSIZE_CUSTOM", @"S_PRINT_PAPERSIZE_CUSTOM")
#define S_PRINT_PAPERSIZE_JPOST NSLocalizedString(@"S_PRINT_PAPERSIZE_JPOST", @"S_PRINT_PAPERSIZE_JPOST")
#define S_PRINT_PAPERSIZE_JPOSTD NSLocalizedString(@"S_PRINT_PAPERSIZE_JPOSTD", @"S_PRINT_PAPERSIZE_JPOSTD")
#define S_PRINT_PAPERSIZE_ENVL3 NSLocalizedString(@"S_PRINT_PAPERSIZE_ENVL3", @"S_PRINT_PAPERSIZE_ENVL3")
#define S_PRINT_PAPERSIZE_CHOKEI3 NSLocalizedString(@"S_PRINT_PAPERSIZE_CHOKEI3", @"S_PRINT_PAPERSIZE_CHOKEI3")
#define S_PRINT_PAPERSIZE_CHOKEI4 NSLocalizedString(@"S_PRINT_PAPERSIZE_CHOKEI4", @"S_PRINT_PAPERSIZE_CHOKEI4")
#define S_PRINT_PAPERSIZE_YOKEI2 NSLocalizedString(@"S_PRINT_PAPERSIZE_YOKEI2", @"S_PRINT_PAPERSIZE_YOKEI2")
#define S_PRINT_PAPERSIZE_YOKEI4 NSLocalizedString(@"S_PRINT_PAPERSIZE_YOKEI4", @"S_PRINT_PAPERSIZE_YOKEI4")
#define S_PRINT_PAPERSIZE_KAKUGATA2 NSLocalizedString(@"S_PRINT_PAPERSIZE_KAKUGATA2", @"S_PRINT_PAPERSIZE_KAKUGATA2")
#define S_PRINT_PAPERSIZE_KAKUGATA3 NSLocalizedString(@"S_PRINT_PAPERSIZE_KAKUGATA3", @"S_PRINT_PAPERSIZE_KAKUGATA3")
#define S_PRINT_PAPERSIZE_A5 NSLocalizedString(@"S_PRINT_PAPERSIZE_A5", @"S_PRINT_PAPERSIZE_A5")
#define S_PRINT_PAPERSIZE_A6R NSLocalizedString(@"S_PRINT_PAPERSIZE_A6R", @"S_PRINT_PAPERSIZE_A6R")
#define S_PRINT_PAPERSIZE_FOLIO NSLocalizedString(@"S_PRINT_PAPERSIZE_FOLIO", @"S_PRINT_PAPERSIZE_FOLIO")
#define S_PRINT_PAPERSIZE_INVOICE NSLocalizedString(@"S_PRINT_PAPERSIZE_INVOICE", @"S_PRINT_PAPERSIZE_INVOICE")
#define S_PRINT_PAPERSIZE_FOOLSCAP NSLocalizedString(@"S_PRINT_PAPERSIZE_FOOLSCAP", @"S_PRINT_PAPERSIZE_FOOLSCAP")
#define S_PRINT_PAPERSIZE_STAMP NSLocalizedString(@"S_PRINT_PAPERSIZE_STAMP", @"S_PRINT_PAPERSIZE_STAMP")
#define S_PRINT_PAPERSIZE_B6R NSLocalizedString(@"S_PRINT_PAPERSIZE_B6R", @"S_PRINT_PAPERSIZE_B6R")
#define S_PRINT_PAPERSIZE_CHINESE8K NSLocalizedString(@"S_PRINT_PAPERSIZE_CHINESE8K", @"S_PRINT_PAPERSIZE_CHINESE8K")
#define S_PRINT_PAPERSIZE_CHINESE16K NSLocalizedString(@"S_PRINT_PAPERSIZE_CHINESE16K", @"S_PRINT_PAPERSIZE_CHINESE16K")
#define S_PRINT_PAPERSIZE_SRA3 NSLocalizedString(@"S_PRINT_PAPERSIZE_SRA3", @"S_PRINT_PAPERSIZE_SRA3")
#define S_PRINT_PAPERSIZE_SRA4 NSLocalizedString(@"S_PRINT_PAPERSIZE_SRA4", @"S_PRINT_PAPERSIZE_SRA4")
#define S_PRINT_PAPERSIZE_KX4 NSLocalizedString(@"S_PRINT_PAPERSIZE_KX4", @"S_PRINT_PAPERSIZE_KX4")
#define S_PRINT_PAPERSIZE_KX8 NSLocalizedString(@"S_PRINT_PAPERSIZE_KX8", @"S_PRINT_PAPERSIZE_KX8")
#define S_PRINT_PAPERSIZE_AX4 NSLocalizedString(@"S_PRINT_PAPERSIZE_AX4", @"S_PRINT_PAPERSIZE_AX4")
#define S_PRINT_PAPERSIZE_AX8 NSLocalizedString(@"S_PRINT_PAPERSIZE_AX8", @"S_PRINT_PAPERSIZE_AX8")
#define S_PRINT_PAPERSIZE_MXLEGAL NSLocalizedString(@"S_PRINT_PAPERSIZE_MXLEGAL", @"S_PRINT_PAPERSIZE_MXLEGAL")
#define S_PRINT_PAPERSIZE_ASIANLEGAL NSLocalizedString(@"S_PRINT_PAPERSIZE_ASIANLEGAL", @"S_PRINT_PAPERSIZE_ASIANLEGAL")

enum PrintPapersizeEnum
{
	E_PAPERSIZE_LETTER = 0,
	E_PAPERSIZE_LEGAL,
	E_PAPERSIZE_A4,
	E_PAPERSIZE_A4WIDE,
	E_PAPERSIZE_LEDGER,
	E_PAPERSIZE_LEDGERWIDE,
	E_PAPERSIZE_A3,
	E_PAPERSIZE_A3WIDE,
	E_PAPERSIZE_JISB4,
	E_PAPERSIZE_JISB5,
	E_PAPERSIZE_EXECUTIVE,
	E_PAPERSIZE_COM10,
	E_PAPERSIZE_MONARCH,
	E_PAPERSIZE_C5,
	E_PAPERSIZE_DL,
	E_PAPERSIZE_B4,
	E_PAPERSIZE_B5,
	E_PAPERSIZE_ISOB5,
	E_PAPERSIZE_CUSTOM,
	E_PAPERSIZE_JPOST,
	E_PAPERSIZE_JPOSTD,
	E_PAPERSIZE_ENVL3,
	E_PAPERSIZE_CHOKEI3,
	E_PAPERSIZE_CHOKEI4,
	E_PAPERSIZE_YOKEI2,
	E_PAPERSIZE_YOKEI4,
	E_PAPERSIZE_KAKUGATA2,
	E_PAPERSIZE_KAKUGATA3,
	E_PAPERSIZE_A5,
	E_PAPERSIZE_A6R,
	E_PAPERSIZE_FOLIO,
	E_PAPERSIZE_INVOICE,
	E_PAPERSIZE_FOOLSCAP,
	E_PAPERSIZE_STAMP,
	E_PAPERSIZE_B6R,
	E_PAPERSIZE_CHINESE8K,
	E_PAPERSIZE_CHINESE16K,
	E_PAPERSIZE_SRA3,
	E_PAPERSIZE_SRA4,
	E_PAPERSIZE_KX4,
	E_PAPERSIZE_KX8,
	E_PAPERSIZE_AX4,
	E_PAPERSIZE_AX8,
	E_PAPERSIZE_MXLEGAL,
	E_PAPERSIZE_ASIANLEGAL
};

// 用紙タイプ
#define S_PRINT_PAPERTYPE_AUTOSELECT NSLocalizedString(@"S_PRINT_PAPERTYPE_AUTOSELECT", @"S_PRINT_PAPERTYPE_AUTOSELECT")
#define S_PRINT_PAPERTYPE_PLAIN NSLocalizedString(@"S_PRINT_PAPERTYPE_PLAIN", @"S_PRINT_PAPERTYPE_PLAIN")
#define S_PRINT_PAPERTYPE_LETTERHEAD NSLocalizedString(@"S_PRINT_PAPERTYPE_LETTERHEAD", @"S_PRINT_PAPERTYPE_LETTERHEAD")
#define S_PRINT_PAPERTYPE_PREPRINTED NSLocalizedString(@"S_PRINT_PAPERTYPE_PREPRINTED", @"S_PRINT_PAPERTYPE_PREPRINTED")
#define S_PRINT_PAPERTYPE_PREPUNCHED NSLocalizedString(@"S_PRINT_PAPERTYPE_PREPUNCHED", @"S_PRINT_PAPERTYPE_PREPUNCHED")
#define S_PRINT_PAPERTYPE_RECYCLED NSLocalizedString(@"S_PRINT_PAPERTYPE_RECYCLED", @"S_PRINT_PAPERTYPE_RECYCLED")
#define S_PRINT_PAPERTYPE_COLOR NSLocalizedString(@"S_PRINT_PAPERTYPE_COLOR", @"S_PRINT_PAPERTYPE_COLOR")
#define S_PRINT_PAPERTYPE_LABELS NSLocalizedString(@"S_PRINT_PAPERTYPE_LABELS", @"S_PRINT_PAPERTYPE_LABELS")
#define S_PRINT_PAPERTYPE_HEAVYPAPER NSLocalizedString(@"S_PRINT_PAPERTYPE_HEAVYPAPER", @"S_PRINT_PAPERTYPE_HEAVYPAPER")
#define S_PRINT_PAPERTYPE_TRANSPARENCY NSLocalizedString(@"S_PRINT_PAPERTYPE_TRANSPARENCY", @"S_PRINT_PAPERTYPE_TRANSPARENCY")
#define S_PRINT_PAPERTYPE_ENVELOPE NSLocalizedString(@"S_PRINT_PAPERTYPE_ENVELOPE", @"S_PRINT_PAPERTYPE_ENVELOPE")
#define S_PRINT_PAPERTYPE_POSTCARD NSLocalizedString(@"S_PRINT_PAPERTYPE_POSTCARD", @"S_PRINT_PAPERTYPE_POSTCARD")

#define N_PRINT_PAPERTYPE_ADVANCED_INDEX 10

enum PrintPapertypeEnum
{
    E_PAPERTYPE_AUTOSELECT = 0,
    E_PAPERTYPE_PLAIN,
    E_PAPERTYPE_LETTERHEAD,
    E_PAPERTYPE_PREPRINTED,
    E_PAPERTYPE_PREPUNCHED,
    E_PAPERTYPE_RECYCLED,
    E_PAPERTYPE_COLOR,
    E_PAPERTYPE_LABELS,
    E_PAPERTYPE_HEAVYPAPER,
    E_PAPERTYPE_TRANSPARENCY,
    E_PAPERTYPE_ENVELOPE,
    E_PAPERTYPE_POSTCARD
};


#define S_PRINT_ORIENTATION_PORTRAIT    NSLocalizedString(@"S_PRINT_ORIENTATION_PORTRAIT", @"縦")
#define S_PRINT_ORIENTATION_LANDSCAPE    NSLocalizedString(@"S_PRINT_ORIENTATION_LANDSCAPE", @"横")

enum PrintOrientationEnum
{
    E_ORIENTATION_PORTRAIT = 0, //縦
    E_ORIENTATION_LANDSCAPE     //横
};

// 原稿画面設定
#define RSS_MANUSCRIPT_IMAGE_X 60
#define RSS_MANUSCRIPT_IMAGE_Y 10
#define RSS_MANUSCRIPT_IMAGE_W 128
#define RSS_MANUSCRIPT_IMAGE_H 128
#define N_HEIGHT_RSS_MANUSCRIPT_SEC_ORIENTATION       128  // 画像セットのセクションの縦幅
#define N_HEIGHT_RSS_MANUSCRIPT_SEC_OTHER             40  // その他のセクションの縦幅
// イメージ
#define S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_H @"RemoteScanOrientationH"
#define S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_H2 @"RemoteScanOrientationH_for7"
#define S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_V @"RemoteScanOrientationV"
#define S_IMAGE_RSS_MANUSCRIPT_ORIENTATION_V2 @"RemoteScanOrientationV_for7"

// はがき
#define JAPANESE_POSTCARD_A6_WIDTH 100
#define JAPANESE_POSTCARD_A6_HEIGHT 148

// メッセージ
#define MSG_LOGIN NSLocalizedString(@"MSG_LOGIN", @"アプリケーションを起動するためのキーワードを入れてください。キーワードは販売店にご確認ください。\r\n\r\n")
#define MSG_LOGIN_ERR NSLocalizedString(@"MSG_LOGIN_ERR", @"キーワードが間違っています。\r\nもう一度試してください。\r\n\r\n\r\n")
#define MSG_BUTTON_OK NSLocalizedString(@"MSG_BUTTON_OK", @"OK")
#define MSG_BUTTON_CANCEL NSLocalizedString(@"MSG_BUTTON_CANCEL", @"キャンセル")
#define MSG_PRINT_REQ_ERR   NSLocalizedString(@"MSG_PRINT_REQ_ERR", @"使用可能なプリンターが\r\nありません。")
#define MSG_PRINT_ERR   NSLocalizedString(@"MSG_PRINT_ERR", @"接続がタイムアウトしました。ネットワーク接続、またはプリンターの状態を確認してください。")
#define MSG_SCAN_REQ_ERR   NSLocalizedString(@"MSG_SCAN_REQ_ERR", @"使用可能なスキャナーが\r\nありません。")
#define MSG_RECIEVE_ERR   NSLocalizedString(@"MSG_RECIEVE_ERR", @"呼び出しに失敗しました。")
#define MSG_PRINT_CANCEL   NSLocalizedString(@"MSG_PRINT_CANCEL", @"印刷を中断しました。")
#define MSG_NETWORK_ERR  NSLocalizedString(@"MSG_NETWORK_ERR", @"ネットワークの接続を\r\n確認してください。")
#define MSG_SETTING_DEL_ERR   NSLocalizedString(@"MSG_SETTING_DEL_ERR", @"削除に失敗しました。")
#define MSG_DEL_CONFIRM   NSLocalizedString(@"MSG_DEL_CONFIRM", @"ファイルを削除します。")
#define MSG_DEL_FILE_FOLDER_CONFIRM   NSLocalizedString(@"MSG_DEL_FILE_FOLDER_CONFIRM", @"ファイル/フォルダーを削除します。")
#define MSG_DEL_COMPLETE   NSLocalizedString(@"MSG_DEL_COMPLETE", @"削除しました。")
#define MSG_DEL_ERR   NSLocalizedString(@"MSG_DEL_ERR", @"削除に失敗しました。")
#define MSG_PRINT_CONNECT   NSLocalizedString(@"MSG_PRINT_CONNECT", @"接続中です。")
#define MSG_PRINT_DISCONNECT   NSLocalizedString(@"MSG_PRINT_DISCONNECT", @"切断中です。")
#define MSG_PRINT_FORWARD   NSLocalizedString(@"MSG_PRINT_FORWARD", @"転送中です。\r\n転送中は、この画面を閉じないでください。")
#define MSG_NO_SEND_APP   NSLocalizedString(@"MSG_NO_SEND_APP", @"対応するアプリケーションが\r\nひとつもありません。")
#define MSG_PREVIEW_ERR   NSLocalizedString(@"MSG_PREVIEW_ERR", @"ファイルの読込みに\r\n失敗しました。")
#define MSG_PRINT_FILE_ERR   NSLocalizedString(@"MSG_PRINT_FILE_ERR", @"印刷に失敗しました。\r\n(送信ファイル不正)")
#define MSG_ALUBUM_ERR   NSLocalizedString(@"MSG_ALUBUM_ERR", @"写真アルバムが使用できません。")
#define MSG_SAVE   NSLocalizedString(@"MSG_SAVE", @"画像を保存しました。")
#define MSG_SAVE_ERR   NSLocalizedString(@"MSG_SAVE_ERR", @"保存に失敗しました。")
#define MSG_SCAN_CONFIRM   NSLocalizedString(@"MSG_SCAN_CONFIRM", @"取り込みを行います。")
#define MSG_REG_PROFILE   NSLocalizedString(@"MSG_REG_PROFILE", @"プロファイル登録中です。")
#define MSG_REG_PROFILE_ERR   NSLocalizedString(@"MSG_REG_PROFILE_ERR", @"プロファイル登録に失敗しました。")
#define MSG_DEL_PROFILE   NSLocalizedString(@"MSG_DEL_PROFILE", @"プロファイル削除中です。")
#define MSG_DEL_PROFILE_ERR   NSLocalizedString(@"MSG_DEL_PROFILE_ERR", @"プロファイル削除に失敗しました。")
#define MSG_WAIT_SCAN   NSLocalizedString(@"MSG_WAIT_SCAN", @"取り込み待ちです。\"FTP/Desktop\"または\"ファクス/イメージ送信\"からアドレス帳を開き、送り先を選択してスキャンしてください。")
#define MSG_WAIT_SCAN_NOVA_L   NSLocalizedString(@"MSG_WAIT_SCAN_NOVA_L", @"取り込み待ちです。スキャナモードキーを押下し、\nワンタッチ送信キー6を押下した後、\nスタートキーを押してスキャンしてください。")
#define MSG_SCAN_CANCEL   NSLocalizedString(@"MSG_SCAN_CANCEL", @"取り込みを中断しました。")
#define MSG_SCAN_DOING   NSLocalizedString(@"MSG_SCAN_DOING", @"受信中です。")
#define MSG_NO_SCAN_FILE   NSLocalizedString(@"MSG_NO_SCAN_FILE", @"取り込まれたファイルの形式は本アプリケーションで利用できません。")
#define MSG_DID_SCAN   NSLocalizedString(@"MSG_DID_SCAN", @"受信完了です。")
#define MSG_SCAN_COMPLETE   NSLocalizedString(@"MSG_SCAN_COMPLETE", @"取り込みが完了しました。")
#define MSG_DID_SCAN_ERR   NSLocalizedString(@"MSG_DID_SCAN_ERR", @"受信に失敗しました。")
#define MSG_SEARCH_DOING   NSLocalizedString(@"MSG_SEARCH_DOING", @"検索中です。")
#define MSG_REQUIRED_ERR   NSLocalizedString(@"MSG_REQUIRED_ERR", @"%@が未入力です。")
#define MSG_CHAR_TYPE_ERR   NSLocalizedString(@"MSG_CHAR_TYPE_ERR", @"%@の入力文字種が不正です。(%@)")
#define MSG_LENGTH_ERR   NSLocalizedString(@"MSG_LENGTH_ERR", @"%@の入力可能な文字数を超えています。\r\n(%@)")
#define MSG_FORMAT_ERR   NSLocalizedString(@"MSG_FORMAT_ERR", @"%@の入力形式が不正です。\r\n%@")
#define MSG_REG_USER_PROFILE_ERR   NSLocalizedString(@"MSG_REG_USER_PROFILE_ERR", @"プロファイル情報の登録に\r\n失敗しました。")
#define MSG_PRINT_CONFIRM   NSLocalizedString(@"MSG_PRINT_CONFIRM", @"印刷を行います。")
#define MSG_NOTPRINT_CONFIRM  NSLocalizedString(@"MSG_NOTPRINT_CONFIRM" , @"以下の理由により印刷できないファイルがあります。\r\n印刷できないファイルを除いて印刷を続行しますか？")
#define MSG_NOTPRINT_PS   NSLocalizedString(@"MSG_NOTPRINT_PS", @"・PS拡張キットが無いため、PDFの印刷は出来ません。")
#define MSG_NOTPRINT_NUP   NSLocalizedString(@"MSG_NOTPRINT_NUP", @"・ページ集約に対応していないファイルが含まれています。")
#define MSG_NOTPRINT_RETENTION  NSLocalizedString(@"MSG_NOTPRINT_RETENTION", @"・暗号化PDFはリテンションが出来ません。")
#define MSG_NOTPRINT_OFFICE  NSLocalizedString(@"MSG_NOTPRINT_OFFICE", @"・ダイレクトプリント拡張キットが無いため、OOXMLファイルの印刷は出来ません。")

#define MSG_NOTPRINT_ALL   NSLocalizedString(@"MSG_NOTPRINT_ALL", @"以下の理由により印刷できるファイルがありません。")
#define MSG_PRINT_COMPLETE   NSLocalizedString(@"MSG_PRINT_COMPLETE", @"転送が完了しました。")
#define MSG_REG_PROFILE_CONFIRM   NSLocalizedString(@"MSG_REG_PROFILE_CONFIRM", @"プロファイル情報が重複しています。上書きして処理を継続しますか？")
#define MSG_MAIL_ATTACH_ERR NSLocalizedString(@"MSG_MAIL_ATTACH_ERR", @"メールの添付に失敗しました。")
#define MSG_MAIL_START_ERR NSLocalizedString(@"MSG_MAIL_START_ERR", @"メールが起動出来ません。\r\nこの機能はメール設定後に使用可能です。")

#define MSG_NUM_RANGE_ERR			NSLocalizedString(@"MSG_NUM_RANGE_ERR", @"%@の数値が範囲外です。\r\n(%@)")
#define MSG_SEARCH_NOTHING          NSLocalizedString(@"MSG_SEARCH_NOTHING", @"機器が見つかりませんでした。機器が接続されていることを確認して再度実施してください。")
#define MSG_SEARCH_COMPLETE         NSLocalizedString(@"MSG_SEARCH_COMPLETE", @"%d台の機器が追加されました。")
#define MSG_SEARCH_COMPLETE_UPDATEONLY  NSLocalizedString(@"MSG_SEARCH_COMPLETE_UPDATEONLY", @"新たな機器は見つかりませんでした。")
#define MSG_IMAGE_PREVIEW_ERR       NSLocalizedString(@"MSG_IMAGE_PREVIEW_ERR", @"メモリーが不足しているため\r\n画像を表示できません。")
#define MSG_IMAGE_PREVIEW_ERR_PDF   NSLocalizedString(@"MSG_IMAGE_PREVIEW_ERR_PDF", @"PDFファイルの1ページあたりのファイルサイズが%.1fMBを超えているため、画像を表示できません。")
#define MSG_MAIL_ATTACH_CONFIRM NSLocalizedString(@"MSG_MAIL_ATTACH_CONFIRM", @"ファイルサイズが1MBを超えているため、メールを送信できない可能性があります。処理を継続しますか？")
#define MSG_NO_SCANNER NSLocalizedString(@"MSG_NO_SCANNER", @"利用できるスキャナーがありません。\"設定\"ボタンを押してスキャナーを追加してください。")
#define MSG_NO_PRINTER NSLocalizedString(@"MSG_NO_PRINTER", @"利用できるプリンターがありません。\"設定\"ボタンを押してプリンターを追加してください。")
#define MSG_NO_VIEW_FILE NSLocalizedString(@"MSG_NO_VIEW_FILE", @"選択したファイルの形式は本アプリケーションで利用できません。")
#define MSG_RECIEVE_ERR_PROCESSING   NSLocalizedString(@"MSG_RECIEVE_ERR_PROCESSING", @"%@のため、ファイルを受信できません。SharpdeskMobileを終了してから再度実行してください。")
#define MSG_RECIEVE_ERR_PRINT    NSLocalizedString(@"MSG_RECIEVE_ERR_PRINT", @"印刷中または印刷画面にて操作中")
#define MSG_RECIEVE_ERR_SCAN    NSLocalizedString(@"MSG_RECIEVE_ERR_SCAN", @"取り込み中または取り込み画面にて操作中")
#define MSG_RECIEVE_ERR_BUSY   NSLocalizedString(@"MSG_RECIEVE_ERR_BUSY", @"他処理実行中")
#define MSG_RECIEVE_ERR_SAVE   NSLocalizedString(@"MSG_RECIEVE_ERR_SAVE", @"保存中")
#define MSG_SAME_DEVICE_ERR   NSLocalizedString(@"MSG_SAME_DEVICE_ERR", @"同じ %@を持つプリンター/スキャナーがすでに存在します。")
#define MSG_SAME_DEVICE_ERR_PRINTSERVER   NSLocalizedString(@"MSG_SAME_DEVICE_ERR_PRINTSERVER", @"同じ %@を持つプリントサーバーがすでに存在します。")
#define MSG_EXCLUDE_DEVICE   NSLocalizedString(@"MSG_EXCLUDE_DEVICE", @"このリストに記載されているプリンター/スキャナーは「プリンター/スキャナーを設定」画面で自動検出されません")
#define MSG_SAME_NAME_ERR   NSLocalizedString(@"MSG_SAME_NAME_ERR", @"同じ %@がすでに存在します。")
#define MSG_FILENAME_FORMAT      NSLocalizedString(@"MSG_FILENAME_FORMAT", @"%@には次の文字は使えません。\r\n<>:*?\"/|\\¥絵文字")
#define MSG_FILE_NO_CHANGE  NSLocalizedString(@"MSG_FILE_NO_CHANGE", @"ファイル名が変更されていません。")
#define MSG_CREATE_DIR_FAILED  NSLocalizedString(@"MSG_CREATE_DIR_FAILED", @"フォルダーの作成に失敗しました。")
#define MSG_CHANGE_FAILED  NSLocalizedString(@"MSG_CHANGE_FAILED", @"%@変更に失敗しました。")
#define MSG_MOVE_SUCCESS    NSLocalizedString(@"MSG_MOVE_SUCCESS", @"移動しました。")
#define MSG_MOVE_FAILED    NSLocalizedString(@"MSG_MOVE_FAILED", @"フォルダー/ファイルの移動に失敗しました。")
#define MSG_MOVE_PARENTCHILD    NSLocalizedString(@"MSG_MOVE_PARENTCHILD", @"移動元フォルダーのサブフォルダーに移動することはできません。")
#define MSG_MOVE_SAMEDIR    NSLocalizedString(@"MSG_MOVE_SAMEDIR", @"同じフォルダーには移動できません。")
#define MSG_MOVE_FILEDIRECTORYSAME    NSLocalizedString(@"MSG_MOVE_FILEDIRECTORYSAME", @"指定されたファイル名と同じ名前のフォルダーが既に存在するため移動することができません。")
#define MSG_MOVE_DIRECTORYFILESAME   NSLocalizedString(@"MSG_MOVE_DIRECTORYFILESAME", @"指定されたフォルダー名と同じ名前のファイルが既に存在するため移動することができません。")
#define MSG_MOVE_PATHEXISTS    NSLocalizedString(@"MSG_MOVE_PATHEXISTS", @"移動先に同じ名前のファイルが存在します。同じ名前のファイルは上書きされます。")
#define MSG_MOVE_SOMEFILES_AND_DIRECTORIES    NSLocalizedString(@"MSG_MOVE_SOMEFILES_AND_DIRECTORIES", @"一部のファイル/フォルダーが移動できませんでした。")
#define MSG_PRINTEROPTION_GET   NSLocalizedString(@"MSG_PRINTEROPTION_GET", @"プリンター/スキャナー情報の取得中です。")
#define MSG_PRINTSERBEROPTION_GET   NSLocalizedString(@"MSG_PRINTSERBEROPTION_GET", @"プリントサーバー情報の取得中です。")

#define MSG_PRINTEROPTION_GET_NETWORK_ERR   NSLocalizedString(@"MSG_PRINTEROPTION_GET_NETWORK_ERR", @"ネットワークに接続していないため、プリンター/スキャナー情報の取得を行うことができません。プリンター/スキャナーを登録しますか？")
#define MSG_PRINTEROPTION_GET_ERROR   NSLocalizedString(@"MSG_PRINTEROPTION_GET_ERROR", @"プリンター/スキャナー情報の取得に失敗しました。プリンター/スキャナーを登録しますか？")
#define MSG_NO_PRINTOPTION_PCL  NSLocalizedString(@"MSG_NO_PRINTOPTION_PCL", @"プリンター拡張キットが装着されていないため、印刷する事ができません。")
#define MSG_NO_PRINTOPTION_PS  NSLocalizedString(@"MSG_NO_PRINTOPTION_PS", @"PS拡張キットが装着されていないため、PDF形式のファイルは印刷することができません。")
#define MSG_NO_PRINTOPTION_OFFICE  NSLocalizedString(@"MSG_NO_PRINTOPTION_OFFICE", @"ダイレクトプリント拡張キットが無いため、OOXMLファイルの印刷は出来ません。")

#define SUBMSG_ERR                  NSLocalizedString(@"SUBMSG_ERR", @"%@、%@のいずれか")
#define SUBMSG_NAME_ERR             NSLocalizedString(@"SUBMSG_NAME_ERR", @"表示名")
#define SUBMSG_SEARCH_ERR			NSLocalizedString(@"SUBMSG_SEARCH_ERR", @"検索文字")
#define SUBMSG_IPADDR_ERR			NSLocalizedString(@"SUBMSG_IPADDR_ERR", @"IPアドレス")
#define SUBMSG_PORT_ERR				NSLocalizedString(@"SUBMSG_PORT_ERR", @"ポート番号")
#define SUBMSG_LOGINNAME_ERR        NSLocalizedString(@"SUBMSG_LOGINNAME_ERR", @"ログイン名")
#define SUBMSG_LOGINPASSWORD_ERR    NSLocalizedString(@"SUBMSG_LOGINPASSWORD_ERR", @"パスワード")
#define SUBMSG_ONLY_HALFCHAR_NUMBER	NSLocalizedString(@"SUBMSG_ONLY_HALFCHAR_NUMBER", @"半角数字のみ")
#define SUBMSG_IPADDR_FORMAT		NSLocalizedString(@"SUBMSG_IPADDR_FORMAT", @"xxx.xxx.xxx.xxx(xxx=0〜255)")
#define SUBMSG_PORTNO_RANGE			NSLocalizedString(@"SUBMSG_PORTNO_RANGE", @"0〜65535")
#define SUBMSG_NAME_FORMAT          NSLocalizedString(@"SUBMSG_NAME_FORMAT", @"半角36文字、全角18文字以内")
#define SUBMSG_SEARCH_FORMAT        NSLocalizedString(@"SUBMSG_SEARCH_FORMAT", @"全角/半角10文字以内")
#define SUBMSG_LOGINNAME_FORMAT     NSLocalizedString(@"SUBMSG_LOGINNAME_FORMAT", @"半角255文字、全角127文字以内")
#define SUBMSG_LOGINPASSWORD_FORMAT NSLocalizedString(@"SUBMSG_LOGINPASSWORD_FORMAT", @"半角32文字以内")
#define SUBMSG_DEVICENAME_ERR       NSLocalizedString(@"SUBMSG_DEVICENAME_ERR", @"名称")
#define SUBMSG_DEVICENAME_FORMAT    NSLocalizedString(@"SUBMSG_DEVICENAME_FORMAT", @"半角120文字、全角60文字以内")
#define SUBMSG_HOSTNAME_LEN_ERR     NSLocalizedString(@"SUBMSG_HOSTNAME_LEN_ERR", @"半角英数字記号255文字以内")
#define SUBMSG_FILENAME_FORMAT    NSLocalizedString(@"SUBMSG_FILENAME_FORMAT", @"全角/半角200文字以内")
#define SUBMSG_EMOJI                NSLocalizedString(@"SUBMSG_EMOJI", @"絵文字は入力出来ません。")
#define SUBMSG_EMOJI_ERR            NSLocalizedString(@"SUBMSG_EMOJI_ERR", @"絵文字")
#define SUBMSG_JOBTIMEOUT_ERR		NSLocalizedString(@"SUBMSG_JOBTIMEOUT_ERR", @"ジョブ送信のタイムアウト(秒)")
#define SUBMSG_JOBTIMEOUT_RANGE		NSLocalizedString(@"SUBMSG_JOBTIMEOUT_RANGE", @"60〜300")


#define SUBMSG_DEVICEINPUTNAME_ERR		NSLocalizedString(@"SUBMSG_DEVICEINPUTNAME_ERR", @"製品名")
#define SUBMSG_DEVICEPLACE_ERR      NSLocalizedString(@"SUBMSG_DEVICEPLACE_ERR", @"設置場所")
#define SUBMSG_FOLDERNAME_ERR		NSLocalizedString(@"SUBMSG_FOLDERNAME_ERR", @"フォルダー名")
#define SUBMSG_FILENAME_ERR         NSLocalizedString(@"SUBMSG_FILENAME_ERR", @"ファイル名")
#define SUBMSG_COMMUNITYSTRING_ERR             NSLocalizedString(@"SUBMSG_COMMUNITYSTRING_ERR", @"Community String")
#define SUBMSG_COMMUNITYSTRING_FORMAT             NSLocalizedString(@"SUBMSG_COMMUNITYSTRING_FORMAT", @"10行以内")
#define SUBMSG_COMMUNITYSTRING_CHARTYPE             NSLocalizedString(@"SUBMSG_COMMUNITYSTRING_CHARTYPE", @"半角15文字以内")
#define SUBMSG_COMMUNITYSTRING_LENGTH             NSLocalizedString(@"SUBMSG_COMMUNITYSTRING_LENGTH", @"半角15文字以内")

#define S_UNIT_BYTE NSLocalizedString(@"S_UNIT_BYTE", @"Byte")
#define S_UNIT_KB   NSLocalizedString(@"S_UNIT_KB", @"KB")
#define S_UNIT_MB   NSLocalizedString(@"S_UNIT_MB", @"MB")
#define S_UNIT_GB   NSLocalizedString(@"S_UNIT_GB", @"GB")

#define MSG_LOCATION_INFORMATION_OFF    NSLocalizedString(@"MSG_LOCATION_INFORMATION_OFF", @"位置情報サービスがオフになっているため、ファイルが読込めませんでした。")
#define MSG_PDF_ENCRYPTION_ERR    NSLocalizedString(@"MSG_PDF_ENCRYPTION_ERR", @"暗号化PDFはプレビュー表示できません。")
#define MSG_PREVIEW_INCOMPATIBLE_ERR    NSLocalizedString(@"MSG_PREVIEW_INCOMPATIBLE_ERR", @"このファイルはプレビュー表示に対応していません。内容を確認する場合は[%@]をタップしてください。")

#define S_ALERT_SEARCH          NSLocalizedString(@"S_ALERT_SEARCH", @"検索文字:%@")
#define S_ALERT_NAME            NSLocalizedString(@"S_ALERT_NAME", @"表示名:%@")

#define MSG_PRINT_COMPLETE_PDF_ENCRYPTION   NSLocalizedString(@"MSG_PRINT_COMPLETE_PDF_ENCRYPTION", @"暗号化PDFの転送が完了しました。プリンター本体の画面でパスワードを入力して印刷してください。")
#define S_SETTING_USERINFO_SAVE_PRINT_SETTING NSLocalizedString(@"S_SETTING_USERINFO_SAVE_PRINT_SETTING", @"印刷設定を記憶する")
#define MSG_DEL_PROFILE_ERR_SCANNER_PROCESSING     NSLocalizedString(@"MSG_DEL_PROFILE_ERR_SCANNER_PROCESSING", @"スキャナーが処理中のため、プロファイルの削除が出来ませんでした。");

#define S_BUTTON_OTHER_APP		NSLocalizedString(@"S_BUTTON_OTHER_APP", @"他アプリで確認")  // 他アプリで確認ボタン
#define MSG_OTHER_APP_CHECK		NSLocalizedString(@"MSG_OTHER_APP_CHECK", @"他アプリで確認")
#define MSG_SEND_APPLICATION	NSLocalizedString(@"MSG_SEND_APPLICATION", @"アプリケーションに送る")
#define MSG_SEND_APPLICATION_IPAD		NSLocalizedString(@"MSG_SEND_APPLICATION_IPAD", @"送る")

#define MSG_REG_PROFILE_ERR_SCANNER_PROCESSING     NSLocalizedString(@"MSG_REG_PROFILE_ERR_SCANNER_PROCESSING", @"スキャナーが処理中のため、プロファイルの登録が出来ませんでした。");
#define MSG_SETTING_DEVICE_GETMFP NSLocalizedString(@"MSG_SETTING_DEVICE_GETMFP", @"プリンター/スキャナー情報の取得中です。")

#define S_RS_XML_AUTO								NSLocalizedString(@"S_RS_XML_AUTO", @"自動")
//#define S_RS_XML_MONOCHROME							NSLocalizedString(@"S_RS_XML_MONOCHROME", @"モノクロ")
//#define S_RS_XML_GRAYSCALE							NSLocalizedString(@"S_RS_XML_GRAYSCALE", @"グレースケール")
//#define S_RS_XML_FULLCOLOR							NSLocalizedString(@"S_RS_XML_FULLCOLOR", @"フルカラー")
//#define S_RS_XML_LONG								NSLocalizedString(@"S_RS_XML_LONG", @"long")
//#define S_RS_XML_INVOICE							NSLocalizedString(@"S_RS_XML_INVOICE", @"invoice")
//#define S_RS_XML_INVOICE_R							NSLocalizedString(@"S_RS_XML_INVOICE_R", @"invoice_r")
//#define S_RS_XML_LETTER								NSLocalizedString(@"S_RS_XML_LETTER", @"letter")
//#define S_RS_XML_LETTER_R							NSLocalizedString(@"S_RS_XML_LETTER_R", @"letter_r")
//#define S_RS_XML_FOOLSCAP							NSLocalizedString(@"S_RS_XML_FOOLSCAP", @"foolscap")
//#define S_RS_XML_LEGAL								NSLocalizedString(@"S_RS_XML_LEGAL", @"legal")
//#define S_RS_XML_LEDGER								NSLocalizedString(@"S_RS_XML_LEDGER", @"ledger")
//#define S_RS_XML_A5									NSLocalizedString(@"S_RS_XML_A5", @"a5")
//#define S_RS_XML_A5_R								NSLocalizedString(@"S_RS_XML_A5_R", @"a5_r")
//#define S_RS_XML_B5									NSLocalizedString(@"S_RS_XML_B5", @"b5")
//#define S_RS_XML_B5_R								NSLocalizedString(@"S_RS_XML_B5_R", @"b5_r")
//#define S_RS_XML_A4									NSLocalizedString(@"S_RS_XML_A4", @"a4")
//#define S_RS_XML_A4_R								NSLocalizedString(@"S_RS_XML_A4_R", @"a4_r")
//#define S_RS_XML_B4									NSLocalizedString(@"S_RS_XML_B4", @"b4")
//#define S_RS_XML_A3									NSLocalizedString(@"S_RS_XML_A3", @"a3")
//#define S_RS_XML_8K									NSLocalizedString(@"S_RS_XML_8K", @"8k")
//#define S_RS_XML_16K								NSLocalizedString(@"S_RS_XML_16K", @"16k")
//#define S_RS_XML_16K_R								NSLocalizedString(@"S_RS_XML_16K_R", @"16k_r")
//#define S_RS_XML_8_1_2X13_2_5						NSLocalizedString(@"S_RS_XML_8_1_2X13_2_5", @"8_1_2x13_2_5")
//#define S_RS_XML_8_1_2X13_1_2						NSLocalizedString(@"S_RS_XML_8_1_2X13_1_2", @"8_1_2x13_1_2")
//#define S_RS_XML_MANUAL								NSLocalizedString(@"S_RS_XML_MANUAL", @"manual")
//#define S_RS_XML_100								NSLocalizedString(@"S_RS_XML_100", @"100")
//#define S_RS_XML_150								NSLocalizedString(@"S_RS_XML_150", @"150")
//#define S_RS_XML_200								NSLocalizedString(@"S_RS_XML_200", @"200")
//#define S_RS_XML_300								NSLocalizedString(@"S_RS_XML_300", @"300")
//#define S_RS_XML_400								NSLocalizedString(@"S_RS_XML_400", @"400")
//#define S_RS_XML_600								NSLocalizedString(@"S_RS_XML_600", @"600")
//#define S_RS_XML_TEXT								NSLocalizedString(@"S_RS_XML_TEXT", @"text")
//#define S_RS_XML_TEXT_PRINT_PHOTO					NSLocalizedString(@"S_RS_XML_TEXT_PRINT_PHOTO", @"text_print_photo")
//#define S_RS_XML_PRINT_PHOTO						NSLocalizedString(@"S_RS_XML_PRINT_PHOTO", @"print_photo")
//#define S_RS_XML_TEXT_PHOTO							NSLocalizedString(@"S_RS_XML_TEXT_PHOTO", @"text_photo")
//#define S_RS_XML_PHOTO								NSLocalizedString(@"S_RS_XML_PHOTO", @"photo")
//#define S_RS_XML_MAP								NSLocalizedString(@"S_RS_XML_MAP", @"map")
//#define S_RS_XML_SIMPLEX							NSLocalizedString(@"S_RS_XML_SIMPLEX", @"simplex")
//#define S_RS_XML_DUPLEX								NSLocalizedString(@"S_RS_XML_DUPLEX", @"duplex")
//#define S_RS_XML_BOOK								NSLocalizedString(@"S_RS_XML_BOOK", @"book")
//#define S_RS_XML_TABLET								NSLocalizedString(@"S_RS_XML_TABLET", @"tablet")
#define S_RS_XML_NONE								NSLocalizedString(@"S_RS_XML_NONE", @"none")
//#define S_RS_XML_MH									NSLocalizedString(@"S_RS_XML_MH", @"mh")
//#define S_RS_XML_MMR								NSLocalizedString(@"S_RS_XML_MMR", @"mmr")
//#define S_RS_XML_JPEG								NSLocalizedString(@"S_RS_XML_JPEG", @"jpeg")
//#define S_RS_XML_LOW								NSLocalizedString(@"S_RS_XML_LOW", @"low")
//#define S_RS_XML_MIDDLE								NSLocalizedString(@"S_RS_XML_MIDDLE", @"middle")
//#define S_RS_XML_HIGH								NSLocalizedString(@"S_RS_XML_HIGH", @"high")
//#define S_RS_XML_ROT_OFF							NSLocalizedString(@"S_RS_XML_ROT_OFF", @"rot_off")
//#define S_RS_XML_ROT_90								NSLocalizedString(@"S_RS_XML_ROT_90", @"rot_90")
//#define S_RS_XML_PDF								NSLocalizedString(@"S_RS_XML_PDF", @"pdf")
//#define S_RS_XML_PDFA								NSLocalizedString(@"S_RS_XML_PDFA", @"pdfa")
//#define S_RS_XML_ENCRYPT_PDF						NSLocalizedString(@"S_RS_XML_ENCRYPT_PDF", @"encrypt_pdf")
//#define S_RS_XML_TIFF								NSLocalizedString(@"S_RS_XML_TIFF", @"tiff")
//#define S_RS_XML_XPS								NSLocalizedString(@"S_RS_XML_XPS", @"xps")
//#define S_RS_XML_COMPACT_PDF						NSLocalizedString(@"S_RS_XML_COMPACT_PDF", @"compact_pdf")
//#define S_RS_XML_COMPACT_PDF_ULTRA_FINE				NSLocalizedString(@"S_RS_XML_COMPACT_PDF_ULTRA_FINE", @"compact_pdf_ultra_fine")
//#define S_RS_XML_COMPACT_PDFA						NSLocalizedString(@"S_RS_XML_COMPACT_PDFA", @"compact_pdfa")
//#define S_RS_XML_COMPACT_PDFA_ULTRA_FINE			NSLocalizedString(@"S_RS_XML_COMPACT_PDFA_ULTRA_FINE", @"compact_pdfa_ultra_fine")
//#define S_RS_XML_ENCRYPT_COMPACT_PDF				NSLocalizedString(@"S_RS_XML_ENCRYPT_COMPACT_PDF", @"encrypt_compact_pdf")
//#define S_RS_XML_ENCRYPT_COMPACT_PDF_ULTRA_FINE		NSLocalizedString(@"S_RS_XML_ENCRYPT_COMPACT_PDF_ULTRA_FINE", @"encrypt_compact_pdf_ultra_fine")
//#define S_RS_XML_PRIORITY_BLACK_PDF					NSLocalizedString(@"S_RS_XML_PRIORITY_BLACK_PDF", @"priority_black_pdf")
//#define S_RS_XML_PRIORITY_BLACK_PDFA				NSLocalizedString(@"S_RS_XML_PRIORITY_BLACK_PDFA", @"priority_black_pdfa")
//#define S_RS_XML_ENCRYPT_PRIORITY_BLACK_PDF			NSLocalizedString(@"S_RS_XML_ENCRYPT_PRIORITY_BLACK_PDF", @"encrypt_priority_black_pdf")
//#define S_RS_XML_JOB_BUILD							NSLocalizedString(@"S_RS_XML_JOB_BUILD", @"job_build")
//#define S_RS_XML_JOB_BUILD_MIXED_SOURCE				NSLocalizedString(@"S_RS_XML_JOB_BUILD_MIXED_SOURCE", @"job_build_mixed_source")
//#define S_RS_XML_BLANK_PAGE_SKIP					NSLocalizedString(@"S_RS_XML_BLANK_PAGE_SKIP", @"blank_page_skip")
//#define S_RS_XML_BLANK_AND_BACK_SHADOW_SKIP			NSLocalizedString(@"S_RS_XML_BLANK_AND_BACK_SHADOW_SKIP", @"blank_and_back_shadow_skip")

#define S_RS_XML_COLORMODE_AUTO                     NSLocalizedString(@"S_RS_XML_COLORMODE_AUTO", @"自動")
#define S_RS_XML_COLORMODE_FULLCOLOR                NSLocalizedString(@"S_RS_XML_COLORMODE_FULLCOLOR", @"フルカラー")
#define S_RS_XML_COLORMODE_GRAYSCALE                NSLocalizedString(@"S_RS_XML_COLORMODE_GRAYSCALE", @"グレースケール")
#define S_RS_XML_COLORMODE_MONOCHROME               NSLocalizedString(@"S_RS_XML_COLORMODE_MONOCHROME", @"白黒2値")
#define S_RS_XML_COMPRESSION_NONE                   NSLocalizedString(@"S_RS_XML_COMPRESSION_NONE", @"圧縮なし")
#define S_RS_XML_COMPRESSION_MH                     NSLocalizedString(@"S_RS_XML_COMPRESSION_MH", @"G3 fax")
#define S_RS_XML_COMPRESSION_MMR                    NSLocalizedString(@"S_RS_XML_COMPRESSION_MMR", @"G4 fax")
#define S_RS_XML_COMPRESSION_JPEG                   NSLocalizedString(@"S_RS_XML_COMPRESSION_JPEG", @"非可逆圧縮(カラー画像用)")
#define S_RS_XML_COMPRESSION_RATIO_LOW              NSLocalizedString(@"S_RS_XML_COMPRESSION_RATIO_LOW", @"低")
#define S_RS_XML_COMPRESSION_RATIO_MIDDLE           NSLocalizedString(@"S_RS_XML_COMPRESSION_RATIO_MIDDLE", @"中")
#define S_RS_XML_COMPRESSION_RATIO_HIGH             NSLocalizedString(@"S_RS_XML_COMPRESSION_RATIO_HIGH", @"高")
#define S_RS_XML_DUPLEX_MODE_SIMPLEX                NSLocalizedString(@"S_RS_XML_DUPLEX_MODE_SIMPLEX", @"片面")
#define S_RS_XML_DUPLEX_MODE_DUPLEX                 NSLocalizedString(@"S_RS_XML_DUPLEX_MODE_DUPLEX", @"両面")
#define S_RS_XML_EXPOSURE_MODE_TEXT                 NSLocalizedString(@"S_RS_XML_EXPOSURE_MODE_TEXT", @"文字")
#define S_RS_XML_EXPOSURE_MODE_TEXT_PRINT_PHOTO     NSLocalizedString(@"S_RS_XML_EXPOSURE_MODE_TEXT_PRINT_PHOTO", @"文字/印刷写真")
#define S_RS_XML_EXPOSURE_MODE_PRINT_PHOTO          NSLocalizedString(@"S_RS_XML_EXPOSURE_MODE_PRINT_PHOTO", @"印刷写真")
#define S_RS_XML_EXPOSURE_MODE_TEXT_PHOTO           NSLocalizedString(@"S_RS_XML_EXPOSURE_MODE_TEXT_PHOTO", @"文字/印画紙写真")
#define S_RS_XML_EXPOSURE_MODE_PHOTO                NSLocalizedString(@"S_RS_XML_EXPOSURE_MODE_PHOTO", @"印画紙写真")
#define S_RS_XML_EXPOSURE_MODE_MAP                  NSLocalizedString(@"S_RS_XML_EXPOSURE_MODE_MAP", @"地図")
#define S_RS_XML_FILE_FORMAT_PDF                    NSLocalizedString(@"S_RS_XML_FILE_FORMAT_PDF", @"PDF")
#define S_RS_XML_FILE_FORMAT_TIFF                   NSLocalizedString(@"S_RS_XML_FILE_FORMAT_TIFF", @"TIFF")
#define S_RS_XML_FILE_FORMAT_JPEG                   NSLocalizedString(@"S_RS_XML_FILE_FORMAT_JPEG", @"JPEG")
#define S_RS_XML_FILE_FORMAT_COMPACT_PDF            NSLocalizedString(@"S_RS_XML_FILE_FORMAT_COMPACT_PDF", @"高圧縮")
#define S_RS_XML_FILE_FORMAT_COMPACT_PDF_ULTRA_FINE    NSLocalizedString(@"S_RS_XML_FILE_FORMAT_COMPACT_PDF_ULTRA_FINE", @"高圧縮高精細")
#define S_RS_XML_FILE_FORMAT_COMPACT_PDFA           NSLocalizedString(@"S_RS_XML_FILE_FORMAT_COMPACT_PDFA", @"高圧縮")
#define S_RS_XML_FILE_FORMAT_COMPACT_PDFA_ULTRA_FINE    NSLocalizedString(@"S_RS_XML_FILE_FORMAT_COMPACT_PDFA_ULTRA_FINE", @"高圧縮高精細")
#define S_RS_XML_FILE_FORMAT_ENCRYPT_COMPACT_PDF    NSLocalizedString(@"S_RS_XML_FILE_FORMAT_ENCRYPT_COMPACT_PDF", @"高圧縮")
#define S_RS_XML_FILE_FORMAT_ENCRYPT_COMPACT_PDF_ULTRA_FINE        NSLocalizedString(@"S_RS_XML_FILE_FORMAT_ENCRYPT_COMPACT_PDF_ULTRA_FINE", @"高圧縮高精細")
#define S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDF     NSLocalizedString(@"S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDF", @"黒文字重視")
#define S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDFA    NSLocalizedString(@"S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDFA", @"黒文字重視")
#define S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDFA_1A    NSLocalizedString(@"S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDFA_1A", @"黒文字重視")
#define S_RS_XML_FILE_FORMAT_ENCRYPT_PRIORITY_BLACK_PDF            NSLocalizedString(@"S_RS_XML_FILE_FORMAT_ENCRYPT_PRIORITY_BLACK_PDF", @"黒文字重視")
#define S_RS_XML_ORIGINAL_SIZE_AUTO                 NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_AUTO", @"自動")
#define S_RS_XML_ORIGINAL_SIZE_LONG                 NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_LONG", @"長尺")
#define S_RS_XML_ORIGINAL_SIZE_INVOICE              NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_INVOICE", @"インボイス")
#define S_RS_XML_ORIGINAL_SIZE_INVOICE_R            NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_INVOICE_R", @"インボイスR")
#define S_RS_XML_ORIGINAL_SIZE_LETTER               NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_LETTER", @"レター")
#define S_RS_XML_ORIGINAL_SIZE_LETTER_R             NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_LETTER_R", @"レターR")
#define S_RS_XML_ORIGINAL_SIZE_FOOLSCAP             NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_FOOLSCAP", @"フルスキャップ")
#define S_RS_XML_ORIGINAL_SIZE_LEGAL                NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_LEGAL", @"リーガル")
#define S_RS_XML_ORIGINAL_SIZE_LEDGER               NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_LEDGER", @"レジャー")
#define S_RS_XML_ORIGINAL_SIZE_A5                   NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_A5", @"A5")
#define S_RS_XML_ORIGINAL_SIZE_A5_R                 NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_A5_R", @"A5R")
#define S_RS_XML_ORIGINAL_SIZE_B5                   NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_B5", @"B5")
#define S_RS_XML_ORIGINAL_SIZE_B5_R                 NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_B5_R", @"B5R")
#define S_RS_XML_ORIGINAL_SIZE_A4                   NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_A4", @"A4")
#define S_RS_XML_ORIGINAL_SIZE_A4_R                 NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_A4_R", @"A4R")
#define S_RS_XML_ORIGINAL_SIZE_B4                   NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_B4", @"B4")
#define S_RS_XML_ORIGINAL_SIZE_A3                   NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_A3", @"A3")
#define S_RS_XML_ORIGINAL_SIZE_8K                   NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_8K", @"8K")
#define S_RS_XML_ORIGINAL_SIZE_16K                  NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_16K", @"16K")
#define S_RS_XML_ORIGINAL_SIZE_16KR                 NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_16KR", @"16KR")
#define S_RS_XML_ORIGINAL_SIZE_8_1_2X13_2_5         NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_8_1_2X13_2_5", @"8.5x 13.4")
#define S_RS_XML_ORIGINAL_SIZE_8_1_2X13_1_2         NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_8_1_2X13_1_2", @"216x 343")
#define S_RS_XML_ORIGINAL_SIZE_JAPANESE_POSTCARD_A6         NSLocalizedString(@"S_RS_XML_ORIGINAL_SIZE_JAPANESE_POSTCARD_A6", @"はがき")
#define S_RS_XML_RESOLUTION_100                   NSLocalizedString(@"S_RS_XML_RESOLUTION_100", @"100dpi")
#define S_RS_XML_RESOLUTION_150                   NSLocalizedString(@"S_RS_XML_RESOLUTION_150", @"150dpi")
#define S_RS_XML_RESOLUTION_200                   NSLocalizedString(@"S_RS_XML_RESOLUTION_200", @"200dpi")
#define S_RS_XML_RESOLUTION_300                   NSLocalizedString(@"S_RS_XML_RESOLUTION_300", @"300dpi")
#define S_RS_XML_RESOLUTION_400                   NSLocalizedString(@"S_RS_XML_RESOLUTION_400", @"400dpi")
#define S_RS_XML_RESOLUTION_600                   NSLocalizedString(@"S_RS_XML_RESOLUTION_600", @"600dpi")
#define S_RS_XML_SEND_SIZE_AUTO                   NSLocalizedString(@"S_RS_XML_SEND_SIZE_AUTO", @"自動")
#define S_RS_XML_SEND_SIZE_INVOICE                NSLocalizedString(@"S_RS_XML_SEND_SIZE_INVOICE", @"インボイス")
#define S_RS_XML_SEND_SIZE_INVOICE_R              NSLocalizedString(@"S_RS_XML_SEND_SIZE_INVOICE_R", @"インボイスR")
#define S_RS_XML_SEND_SIZE_LETTER                 NSLocalizedString(@"S_RS_XML_SEND_SIZE_LETTER", @"レター")
#define S_RS_XML_SEND_SIZE_LETTER_R               NSLocalizedString(@"S_RS_XML_SEND_SIZE_LETTER_R", @"レターR")
#define S_RS_XML_SEND_SIZE_FOOLSCAP               NSLocalizedString(@"S_RS_XML_SEND_SIZE_FOOLSCAP", @"フルスキャップ")
#define S_RS_XML_SEND_SIZE_LEGAL                  NSLocalizedString(@"S_RS_XML_SEND_SIZE_LEGAL", @"リーガル")
#define S_RS_XML_SEND_SIZE_LEDGER                 NSLocalizedString(@"S_RS_XML_SEND_SIZE_LEDGER", @"レジャー")
#define S_RS_XML_SEND_SIZE_A5                     NSLocalizedString(@"S_RS_XML_SEND_SIZE_A5", @"A5")
#define S_RS_XML_SEND_SIZE_A5_R                   NSLocalizedString(@"S_RS_XML_SEND_SIZE_A5_R", @"A5R")
#define S_RS_XML_SEND_SIZE_B5                     NSLocalizedString(@"S_RS_XML_SEND_SIZE_B5", @"B5")
#define S_RS_XML_SEND_SIZE_B5_R                   NSLocalizedString(@"S_RS_XML_SEND_SIZE_B5_R", @"B5R")
#define S_RS_XML_SEND_SIZE_A4                     NSLocalizedString(@"S_RS_XML_SEND_SIZE_A4", @"A4")
#define S_RS_XML_SEND_SIZE_A4_R                   NSLocalizedString(@"S_RS_XML_SEND_SIZE_A4_R", @"A4R")
#define S_RS_XML_SEND_SIZE_B4                     NSLocalizedString(@"S_RS_XML_SEND_SIZE_B4", @"B4")
#define S_RS_XML_SEND_SIZE_A3                     NSLocalizedString(@"S_RS_XML_SEND_SIZE_A3", @"A3")
#define S_RS_XML_SEND_SIZE_8K                     NSLocalizedString(@"S_RS_XML_SEND_SIZE_8K", @"8K")
#define S_RS_XML_SEND_SIZE_16K                    NSLocalizedString(@"S_RS_XML_SEND_SIZE_16K", @"16K")
#define S_RS_XML_SEND_SIZE_16KR                   NSLocalizedString(@"S_RS_XML_SEND_SIZE_16KR", @"16KR")
#define S_RS_XML_SEND_SIZE_8_1_2X13_2_5           NSLocalizedString(@"S_RS_XML_SEND_SIZE_8_1_2X13_2_5", @"8.5x 13.4")
#define S_RS_XML_SEND_SIZE_8_1_2X13_1_2           NSLocalizedString(@"S_RS_XML_SEND_SIZE_8_1_2X13_1_2", @"216x 343")
#define S_RS_XML_SPECIAL_MODE_NONE                NSLocalizedString(@"S_RS_XML_SPECIAL_MODE_NONE", @"Off")
#define S_RS_XML_SPECIAL_MODE_BLANK_PAGE_SKIP     NSLocalizedString(@"S_RS_XML_SPECIAL_MODE_BLANK_PAGE_SKIP", @"白紙を飛ばす")
#define S_RS_XML_SPECIAL_MODE_BLANK_AND_BACK_SHADOW_SKIP      NSLocalizedString(@"S_RS_XML_SPECIAL_MODE_BLANK_AND_BACK_SHADOW_SKIP", @"白紙と裏写り原稿を飛ばす")
#define S_RS_XML_SPECIAL_MODE_MULTI_CROP          NSLocalizedString(@"S_RS_XML_SPECIAL_MODE_MULTI_CROP", @"マルチクロップ")
#define S_RS_XML_OCRLANGUAGE_DEFAULT NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_DEFAULT", @"default")
#define S_RS_XML_OCRLANGUAGE_JA      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_JA", @"ja")
#define S_RS_XML_OCRLANGUAGE_EN      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_EN", @"en")
#define S_RS_XML_OCRLANGUAGE_DE      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_DE", @"de")
#define S_RS_XML_OCRLANGUAGE_FR      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_FR", @"fr")
#define S_RS_XML_OCRLANGUAGE_ES      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_ES", @"es")
#define S_RS_XML_OCRLANGUAGE_IT      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_IT", @"it")
#define S_RS_XML_OCRLANGUAGE_NL      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_NL", @"nl")
#define S_RS_XML_OCRLANGUAGE_CA_ES   NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_CA_ES", @"ca_es")
#define S_RS_XML_OCRLANGUAGE_SV      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_SV", @"sv")
#define S_RS_XML_OCRLANGUAGE_NO      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_NO", @"no")
#define S_RS_XML_OCRLANGUAGE_FI      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_FI", @"fi")
#define S_RS_XML_OCRLANGUAGE_DA      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_DA", @"da")
#define S_RS_XML_OCRLANGUAGE_CS      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_CS", @"cs")
#define S_RS_XML_OCRLANGUAGE_PL      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_PL", @"pl")
#define S_RS_XML_OCRLANGUAGE_HU      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_HU", @"hu")
#define S_RS_XML_OCRLANGUAGE_EL      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_EL", @"el")
#define S_RS_XML_OCRLANGUAGE_RU      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_RU", @"ru")
#define S_RS_XML_OCRLANGUAGE_PT      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_PT", @"pt")
#define S_RS_XML_OCRLANGUAGE_TR      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_TR", @"tr")
#define S_RS_XML_OCRLANGUAGE_SK      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_SK", @"sk")
#define S_RS_XML_OCRLANGUAGE_ZH_CN   NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_ZH_CN", @"zh_cn")
#define S_RS_XML_OCRLANGUAGE_ZH_TW   NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_ZH_TW", @"zh_tw")
#define S_RS_XML_OCRLANGUAGE_KO      NSLocalizedString(@"S_RS_XML_OCRLANGUAGE_KO", @"ko")

#define S_RS_XML_OCROUTPUTFONT_DEFAULT          NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_DEFAULT", @"DEFAULT")
#define S_RS_XML_OCROUTPUTFONT_MS_GOTHIC        NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_MS_GOTHIC", @"MS_GOTHIC")
#define S_RS_XML_OCROUTPUTFONT_MS_MINCHO        NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_MS_MINCHO", @"MS_MINCHO")
#define S_RS_XML_OCROUTPUTFONT_MS_PGOTHIC       NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_MS_PGOTHIC", @"MS_PGOTHIC")
#define S_RS_XML_OCROUTPUTFONT_MS_PMINCHO       NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_MS_PMINCHO", @"MS_PMINCHO")
#define S_RS_XML_OCROUTPUTFONT_SIMSUN           NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_SIMSUN", @"SIMSUN")
#define S_RS_XML_OCROUTPUTFONT_SIMHEI           NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_SIMHEI", @"SIMHEI")
#define S_RS_XML_OCROUTPUTFONT_MINGLIU          NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_MINGLIU", @"MINGLIU")
#define S_RS_XML_OCROUTPUTFONT_PMINGLIU         NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_PMINGLIU", @"PMINGLIU")
#define S_RS_XML_OCROUTPUTFONT_DOTUM            NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_DOTUM", @"DOTUM")
#define S_RS_XML_OCROUTPUTFONT_BATANG           NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_BATANG", @"BATANG")
#define S_RS_XML_OCROUTPUTFONT_MALGUN_GOTHIC    NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_MALGUN_GOTHIC", @"MALGUN_GOTHIC")
#define S_RS_XML_OCROUTPUTFONT_ARIAL            NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_ARIAL", @"ARIAL")
#define S_RS_XML_OCROUTPUTFONT_TIMES_NEW_ROMAN  NSLocalizedString(@"S_RS_XML_OCROUTPUTFONT_TIMES_NEW_ROMAN", @"TIMES_NEW_ROMANO")

#define S_RS_SPECIAL_MODE_DETAIL_NONE             NSLocalizedString(@"S_RS_SPECIAL_MODE_DETAIL_NONE", @"白紙のページを含めて取り込みます。")
#define S_RS_SPECIAL_MODE_DETAIL_BLANK_PAGE_SKIP  NSLocalizedString(@"S_RS_SPECIAL_MODE_DETAIL_BLANK_PAGE_SKIP", @"白紙のページをスキップして取り込みます。")
#define S_RS_SPECIAL_MODE_DETAIL_BLANK_AND_BACK_SHADOW_SKIP   NSLocalizedString(@"S_RS_SPECIAL_MODE_DETAIL_BLANK_AND_BACK_SHADOW_SKIP", @"白紙と裏写りのページをスキップして取り込みます。")
#define S_RS_MULTICROP_DETAIL_OPEN_PLATEN       NSLocalizedString(@"S_RS_MULTICROP_DETAIL_OPEN_PLATEN", @"原稿台のカバーを開いた状態でスキャンして下さい。")

#define S_ICON_RS_COLORMODE     @"RSColor";
#define S_ICON_RS_MANUSCRIPT    @"RSManuscript";
#define S_ICON_RS_BOTHSIDES     @"RSBothsides";
#define S_ICON_RS_FORMAT        @"RSFormat";
#define S_ICON_RS_PPI           @"RSPpi";
#define S_ICON_RS_OTHERSETTING  @"RSOthersetting";
#define S_ICON_RS_SCANREADY  @"RemoteScanReady";

#define SUBMSG_VERIFY_CODE_ERR      NSLocalizedString(@"SUBMSG_VERIFY_CODE_ERR", @"確認コード")
#define SUBMSG_VERIFY_CODE_RANGE    NSLocalizedString(@"SUBMSG_VERIFY_CODE_RANGE", @"半角数字8文字以内")

#define S_TITLE_RENAME_FILENAME NSLocalizedString(@"S_TITLE_RENAME_FILENAME", @"ファイル名を指定する")                  // 名称指定画面(取り込み後プレビュー画面からの遷移)
#define MSG_REMOTESCAN_DOING   NSLocalizedString(@"MSG_REMOTESCAN_DOING", @"取り込み中です。")

#define MSG_REMOTESCAN_CANCELED   NSLocalizedString(@"MSG_REMOTESCAN_CANCELED", @"キャンセルされました。")
#define MSG_REMOTESCAN_CANCELING   NSLocalizedString(@"MSG_REMOTESCAN_CANCELING", @"キャンセルしました。")
#define MSG_REMOTESCAN_JAMED   NSLocalizedString(@"MSG_REMOTESCAN_JAMED", @"紙づまりが発生しました。紙づまりを解消し、%@枚戻してから、端末に表示される取り込みボタンを押してください。")
#define MSG_REMOTESCAN_JAMCLEAR   NSLocalizedString(@"MSG_REMOTESCAN_JAMCLEAR", @"JAMが解消しましたので、再度取り込みボタンを押してください。")
#define MSG_REMOTESCAN_NOTSUPPORT   NSLocalizedString(@"MSG_REMOTESCAN_NOTSUPPORT", @"スキャナーがリモートスキャンに対応していません。通常の取り込みを行ってください。")
#define MSG_NETSCAN_NOTSUPPORT   NSLocalizedString(@"MSG_NETSCAN_NOTSUPPORT", @"入力された機器はネットワークスキャナ―機能がありません。")
#define MSG_REMOTESCAN_SCREENISNOTHOME   NSLocalizedString(@"MSG_REMOTESCAN_SCREENISNOTHOME", @"接続先の画面をホーム画面にしてください。")
#define MSG_REMOTESCAN_NOTAUTHENTICATED   NSLocalizedString(@"MSG_REMOTESCAN_NOTAUTHENTICATED", @"接続先のスキャナーにログインしてから再度行ってください。")
#define MSG_REMOTESCAN_ACCESSDENIED   NSLocalizedString(@"MSG_REMOTESCAN_ACCESSDENIED", @"スキャナーがリモートスキャンモードでなくなりました。取り込み処理を中止します。")
#define MSG_REMOTESCAN_ORIGINALNOTDETECTED   NSLocalizedString(@"MSG_REMOTESCAN_ORIGINALNOTDETECTED", @"用紙が未検知です。用紙をセットし、再度「取り込む」ボタンを押してください。")
#define MSG_REMOTESCAN_LIMITREACHED   NSLocalizedString(@"MSG_REMOTESCAN_LIMITREACHED", @"出力可能枚数が上限に到達しました。")
#define MSG_REMOTESCAN_ORIGINALNOTDETECTED_CONFIRM   NSLocalizedString(@"MSG_REMOTESCAN_ORIGINALNOTDETECTED_CONFIRM", @"用紙が未検知です。用紙をセットし、再度取り込みボタンを押してください。")
#define MSG_REMOTESCAN_SCANFAIL   NSLocalizedString(@"MSG_REMOTESCAN_SCANFAIL", @"取り込みが失敗しました。")
#define MSG_REMOTESCAN_CONFIRM   NSLocalizedString(@"MSG_REMOTESCAN_CONFIRM", @"取り込みを行います。\n表示名:%@\n確認コード:%@")
#define MSG_REMOTESCAN_WAIT   NSLocalizedString(@"MSG_REMOTESCAN_WAIT", @"原稿をセットしてください。\n表示名:%@\n確認コード:%@")
#define MSG_REMOTESCAN_CONFIRM_MULTICROP_ALERT    NSLocalizedString(@"MSG_REMOTESCAN_CONFIRM_MULTICROP_ALERT", @"原稿台のカバーを開いた状態でスキャンして下さい。")
#define MSG_WAIT   NSLocalizedString(@"MSG_WAIT", @"しばらくお待ちください。")


#define S_TITLE_COLORMODE   NSLocalizedString(@"S_TITLE_COLORMODE", @"カラーモード")
#define S_TITLE_MANUSCRIPT   NSLocalizedString(@"S_TITLE_MANUSCRIPT", @"原稿")
#define S_TITLE_BOTH   NSLocalizedString(@"S_TITLE_BOTH", @"両面")
#define S_TITLE_FORMAT   NSLocalizedString(@"S_TITLE_FORMAT", @"フォーマット")
#define S_TITLE_RESOLUTION   NSLocalizedString(@"S_TITLE_RESOLUTION", @"解像度")
#define S_TITLE_OTHER   NSLocalizedString(@"S_TITLE_OTHER", @"その他の設定")
#define S_TITLE_CUSTOMSIZE   NSLocalizedString(@"S_TITLE_CUSTOMSIZE", @"カスタムサイズ")
#define S_TITLE_CUSTOMSIZE_REGISTER   NSLocalizedString(@"S_TITLE_CUSTOMSIZE_REGISTER", @"カスタムサイズの登録")
#define S_BUTTON_REMOTESCAN_READY   NSLocalizedString(@"S_BUTTON_REMOTESCAN_READY", @"取り込む")
#define S_BUTTON_REMOTESCAN   NSLocalizedString(@"S_BUTTON_REMOTESCAN", @"\"%@\"から取り込む")
#define S_BUTTON_REMOTE_COLORMODE   NSLocalizedString(@"S_BUTTON_REMOTE_COLORMODE", @"カラーモード：%@")
#define S_BUTTON_MANUSCRIPT   NSLocalizedString(@"S_BUTTON_MANUSCRIPT", @"原稿：%@")
#define S_BUTTON_BOTH   NSLocalizedString(@"S_BUTTON_BOTH", @"両面：%@")
#define S_BUTTON_FORMAT   NSLocalizedString(@"S_BUTTON_FORMAT", @"フォーマット：%@")
#define S_BUTTON_RESOLUTION   NSLocalizedString(@"S_BUTTON_RESOLUTION", @"解像度：%@")
#define S_BUTTON_OTHER   NSLocalizedString(@"S_BUTTON_OTHER", @"その他の設定")
#define S_LABEL_REMOTESWITCH   NSLocalizedString(@"S_LABEL_REMOTESWITCH", @"端末側からスキャナーの設定を行う")
#define S_TITLE_MANUSCRIPT_SIZE   NSLocalizedString(@"S_TITLE_MANUSCRIPT_SIZE", @"原稿サイズ")
#define S_TITLE_MANUSCRIPT_CURRENT_SIZE   NSLocalizedString(@"S_TITLE_MANUSCRIPT_CURRENT_SIZE", @"現在の検知サイズ")
#define S_TITLE_MANUSCRIPT_SAVE_SIZE   NSLocalizedString(@"S_TITLE_MANUSCRIPT_SAVE_SIZE", @"保存サイズ")
#define S_TITLE_MANUSCRIPT_SET   NSLocalizedString(@"S_TITLE_MANUSCRIPT_SET", @"画像セットの方向")
#define S_FOOTER_MANUSCRIPT_SAVE_SIZE   NSLocalizedString(@"S_FOOTER_MANUSCRIPT_SAVE_SIZE", @"原稿サイズと異なるサイズを指定すると、\r\n自動的に画像を拡大/縮小します。")
#define S_MANUSCRIPT_CUSTOMSIZE_REGISTER   NSLocalizedString(@"S_MANUSCRIPT_CUSTOMSIZE_REGISTER", @"カスタムサイズの登録")
#define S_BUTTON_FORMAT_COLOR   NSLocalizedString(@"S_BUTTON_FORMAT_COLOR", @"カラー/グレースケール")
#define S_BUTTON_FORMAT_MONOCHROME   NSLocalizedString(@"S_BUTTON_FORMAT_MONOCHROME", @"白黒")
#define S_TITLE_FORMAT_FILE_FORMAT   NSLocalizedString(@"S_TITLE_FORMAT_FILE_FORMAT", @"ファイル形式")
#define S_TITLE_FORMAT_COMPACT_PDF   NSLocalizedString(@"S_TITLE_FORMAT_COMPACT_PDF", @"高圧縮PDFのタイプ")
#define S_TITLE_FORMAT_COLOR_COMPRESSION   NSLocalizedString(@"S_TITLE_FORMAT_COLOR_COMPRESSION", @"圧縮率")
#define S_TITLE_FORMAT_MONOCHROME_COMPRESSION   NSLocalizedString(@"S_TITLE_FORMAT_MONOCHROME_COMPRESSION", @"圧縮形式")
#define S_TITLE_FORMAT_OCR_LANGUAGE   NSLocalizedString(@"S_TITLE_FORMAT_OCR_LANGUAGE", @"言語設定")
#define S_TITLE_FORMAT_OCR_OUTPUT_FONT   NSLocalizedString(@"S_TITLE_FORMAT_OCR_OUTPUT_FONT", @"フォント")
#define S_TITLE_FORMAT_OCR_ACCURACY     NSLocalizedString(@"S_TITLE_FORMAT_OCR_ACCURACY", @"OCR精度")
#define S_FORMAT_PAGE_PER_FILE   NSLocalizedString(@"S_FORMAT_PAGE_PER_FILE", @"ページ毎にファイル化")
#define S_FORMAT_PAGENUM   NSLocalizedString(@"S_FORMAT_PAGENUM", @"ページ数")
#define S_FORMAT_PAGE   NSLocalizedString(@"S_FORMAT_PAGE", @"ページ")
#define S_FORMAT_PDF_PASSWORD   NSLocalizedString(@"S_FORMAT_PDF_PASSWORD", @"暗号化")
#define S_FORMAT_PASSWORD   NSLocalizedString(@"S_FORMAT_PASSWORD", @"パスワード")
#define S_FORMAT_OCR   NSLocalizedString(@"S_FORMAT_OCR", @"OCR(文字認識)")
#define S_FORMAT_CORRECT_IMAGE_ROTATION   NSLocalizedString(@"S_FORMAT_CORRECT_IMAGE_ROTATION", @"画像の向き検知")
#define S_FORMAT_EXTRACT_FILE_NAME   NSLocalizedString(@"S_FORMAT_EXTRACT_FILE_NAME", @"ファイル名自動抽出")
#define S_TITLE_OTHER_EXPOSURE_MODE   NSLocalizedString(@"S_TITLE_OTHER_EXPOSURE_MODE", @"濃度")
#define S_TITLE_OTHER_BLANK   NSLocalizedString(@"S_TITLE_OTHER_BLANK", @"白紙飛ばし")
#define S_TITLE_OTHER_EXPOSURE_LEVEL   NSLocalizedString(@"S_TITLE_OTHER_EXPOSURE_LEVEL", @"濃度レベル")
// マルチクロップはS_RS_XML_SPECIAL_MODE_MULTI_CROP
#define S_OTHER_LIGHT   NSLocalizedString(@"S_OTHER_LIGHT", @"うすい")
#define S_OTHER_DEEP   NSLocalizedString(@"S_OTHER_DEEP", @"こい")
#define S_CUSTOMSIZE_NEWADD   NSLocalizedString(@"S_CUSTOMSIZE_NEWADD", @"新規追加")
#define S_CUSTOMSIZE_REGISTER_NAME   NSLocalizedString(@"S_CUSTOMSIZE_REGISTER_NAME", @"名称")
#define S_CUSTOMSIZE_REGISTER_SIZE   NSLocalizedString(@"S_CUSTOMSIZE_REGISTER_SIZE", @"サイズ")
#define S_CUSTOMSIZE_REGISTER_MILLIMETER   NSLocalizedString(@"S_CUSTOMSIZE_REGISTER_MILLIMETER", @"ミリ")
#define S_CUSTOMSIZE_REGISTER_INCH   NSLocalizedString(@"S_CUSTOMSIZE_REGISTER_INCH", @"インチ")
#define S_BUTTON_CUSTOMSIZE_REGISTER_MILLIMETER   NSLocalizedString(@"S_BUTTON_CUSTOMSIZE_REGISTER_MILLIMETER", @"ミリ")
#define S_BUTTON_CUSTOMSIZE_REGISTER_INCH   NSLocalizedString(@"S_BUTTON_CUSTOMSIZE_REGISTER_INCH", @"インチ")
#define S_CUSTOMSIZE_REGISTER_WIDTH   NSLocalizedString(@"S_CUSTOMSIZE_REGISTER_WIDTH", @"横")
#define S_CUSTOMSIZE_REGISTER_HEIGHT   NSLocalizedString(@"S_CUSTOMSIZE_REGISTER_HEIGHT", @"縦")
#define MSG_REMOTESCAN_REMOVEDOCUMENT  NSLocalizedString(@"MSG_REMOTESCAN_REMOVEDOCUMENT", @"原稿送り装置から原稿を取り除いてください。")
#define MSG_REMOTESCAN_USESTAND  NSLocalizedString(@"MSG_REMOTESCAN_USESTAND", @"原稿台を使用してください。")
#define MSG_REMOTESCAN_USEFEEDER  NSLocalizedString(@"MSG_REMOTESCAN_USEFEEDER", @"原稿送り装置を使用してください。")
#define MSG_REMOTESCAN_NOTUSE  NSLocalizedString(@"MSG_REMOTESCAN_NOTUSE", @"この組み合わせは設定できません。")
#define SUBMSG_PDFPASSWORD_ERR  NSLocalizedString(@"SUBMSG_PDFPASSWORD_ERR", @"パスワード")
#define SUBMSG_PDFPASSWORD_MAXLENGTH  NSLocalizedString(@"SUBMSG_PDFPASSWORD_MAXLENGTH", @"半角32文字以内")
#define SUBMSG_PDFPASSWORD_FORMAT  NSLocalizedString(@"SUBMSG_PDFPASSWORD_FORMAT", @"半角英数字のみ")
#define S_SETTING_DEVICE_REMOTE_SCAN NSLocalizedString(@"S_SETTING_DEVICE_REMOTE_SCAN", @"端末側からスキャナーの設定を行う")
#define S_SETTING_DEVICE_REMOTE_CODEAUTO NSLocalizedString(@"S_SETTING_DEVICE_REMOTE_CODEAUTO", @"確認コードを自動で生成")
#define S_SETTING_DEVICE_REMOTE_CODE NSLocalizedString(@"S_SETTING_DEVICE_REMOTE_CODE", @"確認コード")
#define S_SETTING_DEVICE_REMOTE_RESET_HEADER NSLocalizedString(@"S_SETTING_DEVICE_REMOTE_RESET_HEADER", @"リセット")
#define S_SETTING_DEVICE_REMOTE_RESET NSLocalizedString(@"S_SETTING_DEVICE_REMOTE_RESET", @"設定をリセットする")
#define MSG_SETTING_DEVICE_REMOTE_RESET NSLocalizedString(@"MSG_SETTING_DEVICE_REMOTE_RESET", @"設定をリセットしますか？")
#define MSG_REMOTESCAN_NETWORK_ERROR_AND_EXIT NSLocalizedString(@"MSG_REMOTESCAN_NETWORK_ERROR_AND_EXIT", @"スキャナーとの通信に失敗しました。ネットワークとスキャナーの設定を確認し、「端末側からスキャナーの設定を行う」スイッチをオンにして再度実施してください。")
#define MSG_REMOTESCAN_NETWORK_ERROR NSLocalizedString(@"MSG_REMOTESCAN_NETWORK_ERROR", @"スキャナーとの通信に失敗しました。")
#define MSG_REMOTESCAN_ERROR_ALL_PAGE_BLANK NSLocalizedString(@"MSG_REMOTESCAN_ERROR_ALL_PAGE_BLANK", @"全て白紙と認識されました。原稿を確認してください。")
#define MSG_REMOTESCAN_SESSIONID_GET_ERROR NSLocalizedString(@"MSG_REMOTESCAN_SESSIONID_GET_ERROR", @"スキャナーが使用中です。しばらく待ってから再度実施してください。")

#define MSG_REMOTESCAN_SCREENISNOTLOGIN NSLocalizedString(@"MSG_REMOTESCAN_SCREENISNOTLOGIN", @"接続先の画面をログイン画面にしてください。")
#define MSG_REMOTESCAN_FORBIDDEN NSLocalizedString(@"MSG_REMOTESCAN_FORBIDDEN", @"接続先のスキャナーは、使用を禁止されているため利用できません。")
#define MSG_REMOTESCAN_PAPER_SETTING_ERR NSLocalizedString(@"MSG_REMOTESCAN_PAPER_SETTING_ERR", @"この組み合わせは設定できません。")
#define MSG_REMOTESCAN_JAMMING_ERR NSLocalizedString(@"MSG_REMOTESCAN_JAMMING_ERR", @"本体の紙詰まりを解消してください。")

#define MSG_REMOTESCAN_WIDTH_INCH NSLocalizedString(@"MSG_REMOTESCAN_WIDTH_INCH", @"横は1 ~ 17 インチの範囲内で設定可能です。 ")
#define MSG_REMOTESCAN_HEIGHT_INCH NSLocalizedString(@"MSG_REMOTESCAN_HEIGHT_INCH", @"縦は1 ~ 11 5/8 インチの範囲内で設定可能です。")
#define MSG_REMOTESCAN_WIDTH_MILLIMETER NSLocalizedString(@"MSG_REMOTESCAN_WIDTH_MILLIMETER", @"横は25 ~ 432 ミリの範囲内で設定可能です。 ")
#define MSG_REMOTESCAN_HEIGHT_MILLIMETER NSLocalizedString(@"MSG_REMOTESCAN_HEIGHT_MILLIMETER", @"縦は25 ~ 297 ミリの範囲内で設定可能です。 ")
#define S_RS_SCAN   NSLocalizedString(@"S_RS_SCAN", @"取り込み")
#define S_RS_UNKNOWN   NSLocalizedString(@"S_RS_UNKNOWN", @"未検知")
#define S_RS_XML_SEND_SIZE_BUSINESSCARD   NSLocalizedString(@"S_RS_XML_SEND_SIZE_BUSINESSCARD", @"名刺")
#define S_RS_XML_SEND_SIZE_LTYPE   NSLocalizedString(@"S_RS_XML_SEND_SIZE_LTYPE", @"L判")
#define S_RS_XML_SEND_SIZE_2LTYPE   NSLocalizedString(@"S_RS_XML_SEND_SIZE_2LTYPE", @"2L判")
#define S_RS_XML_SEND_SIZE_CARD   NSLocalizedString(@"S_RS_XML_SEND_SIZE_CARD", @"カード")
#define S_RS_CUSTOMSIZE_MILLIMETER   NSLocalizedString(@"S_RS_CUSTOMSIZE_MILLIMETER", @"ミリ")
#define S_RS_CUSTOMSIZE_INCH   NSLocalizedString(@"S_RS_CUSTOMSIZE_INCH", @"インチ")
#define S_RS_CUSTOMSIZE_50LETTER   NSLocalizedString(@"S_RS_CUSTOMSIZE_50LETTER", @"全角/半角50文字以内")
#define MSG_PRINT_MEMORY_ERROR_PNG NSLocalizedString(@"MSG_PRINT_MEMORY_ERROR_PNG", @"メモリ不足のため、印刷用ファイルの作成に失敗しました。")
#define MSG_CANNOT_PRINT_WEB_PAGE NSLocalizedString(@"MSG_CANNOT_PRINT_WEB_PAGE", @"このページは印刷出来ません。")
#define MSG_CONFIRM_PRINT_WEB_PAGE NSLocalizedString(@"MSG_CONFIRM_PRINT_WEB_PAGE", @"ページの読み込みが完了していないため、正常に印刷されない可能性があります。\n印刷しますか？")

#define S_SEARCH_PLACEHOLDER NSLocalizedString(@"S_SEARCH_PLACEHOLDER", @"検索ワードを入力してください")
#define S_BUTTON_SEARCH NSLocalizedString(@"S_BUTTON_SEARCH", @"検索")
#define S_TITLE_SEARCHRESULT NSLocalizedString(@"S_TITLE_SEARCHRESULT", @"検索結果(%d件)")
#define S_TITLE_ADVANCEDSEARCH NSLocalizedString(@"S_TITLE_ADVANCEDSEARCH", @"詳細検索")
#define S_LABEL_SEARCH_SCOPE NSLocalizedString(@"S_LABEL_SEARCH_SCOPE", @"検索範囲")
#define S_LABEL_SEARCH_TARGET NSLocalizedString(@"S_LABEL_SEARCH_TARGET", @"検索対象")
#define S_LABEL_INCLUDE_SUBFOLDERS NSLocalizedString(@"S_LABEL_INCLUDE_SUBFOLDERS", @"サブフォルダーを含める")
#define S_LABEL_FILTER_FOLDER NSLocalizedString(@"S_LABEL_FILTER_FOLDER", @"フォルダー")
#define S_LABEL_FILTER_PDF NSLocalizedString(@"S_LABEL_FILTER_PDF", @"PDF")
#define S_LABEL_FILTER_TIFF NSLocalizedString(@"S_LABEL_FILTER_TIFF", @"TIFF")
#define S_LABEL_FILTER_IMAGE NSLocalizedString(@"S_LABEL_FILTER_IMAGE", @"画像ファイル(JPEG、PNG)")
#define S_LABEL_FILTER_OFFICE NSLocalizedString(@"S_LABEL_FILTER_OFFICE", @"OOXMLファイル(DOCX、XLSX、PPTX)")

#define SORTBUTTON_WIDTH 44
#define ADVANCEDSEARCHBUTTON_WIDTH 44
#define SEARCHBAR_HEIGHT 44

#define S_SETTING_USERINFO_STYLE_LOFIN NSLocalizedString(@"S_SETTING_USERINFO_STYLE_LOFIN", @"認証にログイン名を使用する")
#define S_SETTING_USERINFO_STYLE_USER NSLocalizedString(@"S_SETTING_USERINFO_STYLE_USER", @"認証にユーザー番号を使用する")
#define S_SETTING_USERINFO_USERNO NSLocalizedString(@"S_SETTING_USERINFO_USERNO", @"ユーザー番号")
#define S_TITLE_SETTING_USER_JOB NSLocalizedString(@"S_TITLE_SETTING_USER_JOB", @"デフォルトジョブID")
#define S_SETTING_USERINFO_USERNAME NSLocalizedString(@"S_SETTING_USERINFO_USERNAME", @"ユーザー名")
#define S_SETTING_USERINFO_JOBNAME NSLocalizedString(@"S_SETTING_USERINFO_JOBNAME", @"ジョブ名")
#define S_SETTING_USERINFO_USE_LOGINNAME_FOR_USERNAME NSLocalizedString(@"S_SETTING_USERINFO_USE_LOGINNAME_FOR_USERNAME", @"ユーザー名にログイン名を使用する")
#define SUBMSG_USERNO_ERR     NSLocalizedString(@"SUBMSG_USERNO_ERR", @"ユーザー番号")
#define SUBMSG_USERNAME_ERR     NSLocalizedString(@"SUBMSG_USERNAME_ERR", @"ユーザー名")
#define SUBMSG_JOBNAME_ERR     NSLocalizedString(@"SUBMSG_JOBNAME_ERR", @"ジョブ名")
#define SUBMSG_USERNO_FORMAT     NSLocalizedString(@"SUBMSG_USERNO_FORMAT", @"半角数値5〜8桁")
#define SUBMSG_USERNAME_FORMAT     NSLocalizedString(@"SUBMSG_USERNAME_FORMAT", @"半角32文字、全角16文字以内")
#define SUBMSG_JOBNAME_FORMAT     NSLocalizedString(@"SUBMSG_JOBNAME_FORMAT", @"半角80文字、全角40文字以内")
/* E-mail Print */
#define N_NUM_SECTION_N_NUM_ROW_MAILSERVERINFO 5
#define N_NUM_ROW_MAILSERVERINFO_SEC1 2
#define N_NUM_ROW_MAILSERVERINFO_SEC2 3
#define N_NUM_ROW_MAILSERVERINFO_SEC3 1
#define N_NUM_ROW_MAILSERVERINFO_SEC4 2

#define S_TITLE_SETTING_MAILSERVER NSLocalizedString(@"S_TITLE_SETTING_MAILSERVER", @"メールを設定")
#define S_TITLE_SETTING_MAILSERVER_ACCOUNT NSLocalizedString(@"S_TITLE_SETTING_EMAIL_ACCOUNT", @"メールアカウント")
#define S_TITLE_SETTING_MAILSERVER_SETTING NSLocalizedString(@"S_TITLE_SETTING_EMAIL_SERVER_SETTING", @"メールサーバー設定")
#define S_TITLE_SETTING_MAILSERVER_DISPLAY NSLocalizedString(@"S_TITLE_SETTING_EMAIL_DISPLAY_SETTING", @"メール表示設定")

#define MAIL_SETTING_DISPLAY_TEN NSLocalizedString(@"MAIL_SETTING_DISPLAY_TEN", @"10")
#define MAIL_SETTING_DISPLAY_THIRTY NSLocalizedString(@"MAIL_SETTING_DISPLAY_THIRTY", @"30")
#define MAIL_SETTING_DISPLAY_FIFTY NSLocalizedString(@"MAIL_SETTING_DISPLAY_FIFTY", @"50")
#define MAIL_SETTING_DISPLAY_HUNDRED NSLocalizedString(@"MAIL_SETTING_DISPLAY_HUNDRED", @"100")

#define S_TITLE_SETTING_MAILSERVER_FILTER_0 NSLocalizedString(@"S_TITLE_SETTING_MAILSERVER_FILTER_0", @"全て")
#define S_TITLE_SETTING_MAILSERVER_FILTER_1 NSLocalizedString(@"S_TITLE_SETTING_MAILSERVER_FILTER_1", @"未読のみ")
#define S_TITLE_SETTING_MAILSERVER_FILTER_2 NSLocalizedString(@"S_TITLE_SETTING_MAILSERVER_FILTER_2", @"今日のメール")
#define S_TITLE_SETTING_MAILSERVER_FILTER_3 NSLocalizedString(@"S_TITLE_SETTING_MAILSERVER_FILTER_3", @"30日以内のメール")

#define S_SETTING_MAILSERVER_ACCOUNT_NAME NSLocalizedString(@"S_SETTING_EMAIL_ACCOUNT_NAME", @"アカウント名")
#define S_SETTING_MAILSERVER_PASSWORD NSLocalizedString(@"S_SETTING_EMAIL_PASSWORD", @"パスワード")
#define S_SETTING_MAILSERVER_HOST_NAME NSLocalizedString(@"S_SETTING_EMAIL_HOST_NAME", @"ホスト名")
#define S_SETTING_MAILSERVER_PORT_NUMBER NSLocalizedString(@"S_SETTING_EMAIL_PORT_NUMBER", @"ポート番号")
#define S_SETTING_MAILSERVER_SSL NSLocalizedString(@"S_SETTING_EMAIL_SSL", @"SSL")
#define S_SETTING_MAILSERVER_GET_NUMBER NSLocalizedString(@"S_SETTING_EMAIL_GET_NUMBER", @"取得件数")
#define S_SETTING_MAILSERVER_FILTER_SETTING NSLocalizedString(@"S_SETTING_EMAIL_FILTER_SETTING", @"フィルタリング設定")

#define S_EMAIL_HEADER_FROM NSLocalizedString(@"S_EMAIL_HEADER_FROM", @"From")
#define S_EMAIL_HEADER_SUBJECT NSLocalizedString(@"S_EMAIL_HEADER_SUBJECT", @"件名")
#define S_EMAIL_HEADER_DATE NSLocalizedString(@"S_EMAIL_HEADER_DATE", @"日付")
#define S_EMAIL_HEADER_TO NSLocalizedString(@"S_EMAIL_HEADER_TO", @"To")
#define S_EMAIL_INBOX_PREVIOUS NSLocalizedString(@"S_EMAIL_INBOX_PREVIOUS", @"前の%d件を取得")
#define S_EMAIL_INBOX_NEXT NSLocalizedString(@"S_EMAIL_INBOX_NEXT", @"次の%d件を取得")

#define S_TITLE_EMAIL_PRINT NSLocalizedString(@"S_TITLE_EMAIL_PRINT", @"E-mailを印刷する")

#define MSG_EMAIL_ACCOUNT_ERROR NSLocalizedString(@"MSG_EMAIL_ACCOUNT_ERROR", @"メールサーバの%@が未設定です。")
#define SUBMSG_LOGINACCOUNT_ERR NSLocalizedString(@"SUBMSG_LOGINACCOUNT_ERR", @"ログインアカウント")
#define SUBMSG_ACCOUNTNAME_ERR        NSLocalizedString(@"SUBMSG_ACCOUNTNAME_ERR", @"アカウント名")
#define MSG_EMAIL_CONNECT_ERROR NSLocalizedString(@"MSG_EMAIL_CONNECT_ERROR", @"サーバー接続に失敗しました。")
#define SUBMSG_HOSTNAME_ERR				NSLocalizedString(@"SUBMSG_HOSTNAME_ERR", @"ホスト名")

#define S_RS_COMPACT_PDF_TYPE_NONE   NSLocalizedString(@"S_RS_COMPACT_PDF_TYPE_NONE", @"なし")

#define S_ICON_PRINTRANGE        @"PrintRange"
#define S_ICON_PRINTTARGET       @"PrintWhat"
#define S_ICON_RETENTION         @"Retention"
#define S_ICON_STAPLE            @"Staple"
#define S_ICON_NUP               @"Nup"
#define S_ICON_MAILUPDATE        @"MailUpdate"
#define S_ICON_PREVIOUS          @"Previous"
#define S_ICON_NEXT              @"Next"
#define S_ICON_SEARCHFINE        @"SearchFine"
#define S_ICON_SORTTIMEASC       @"SortTimeAsc"
#define S_ICON_SORTTIMEDES       @"SortTimeDes"
#define S_ICON_SORTFILEASC       @"SortFileAsc"
#define S_ICON_SORTFILEDES       @"SortFileDes"
#define S_ICON_SORTSIZEASC       @"SortSizeAsc"
#define S_ICON_SORTSIZEDES       @"SortSizeDes"
#define S_ICON_SORTTYPEASC       @"SortTypeAsc"
#define S_ICON_SORTTYPEDES       @"SortTypeDes"
#define S_ICON_ADDPAGE           @"AddPage"
#define S_ICON_DELPAGE           @"DelPage"
#define S_ICON_MAIL              @"Mail"
#define S_ICON_EDIT              @"PrintEdit"
#define S_ICON_EDIT_FINISH       @"PrintEditFinish"
#define S_ICON_MULTIPLE          @"PrintMultiple selection"
#define S_ICON_PRINT_CANCEL      @"PrintCancel"
#define S_ICON_PRINT_SELECT      @"PrintSelect"
#define S_ICON_PRINTER           @"select_printer"
#define S_ICON_PRINTSERVER       @"select_printserver"
#define S_ICON_GET_MAIL_COUNT    @"getmailcount"
#define S_ICON_MAIL_FILTER       @"mailfiltersetting"
#define S_ICON_PRINT_START       @"PrintStart"
#define S_ICON_PRINT_ATTACHED    @"PrintAttached"
#define S_ICON_PRINT_DECIDE      @"PrintDecide"
#define S_ICON_EDIT2             @"PrintEdit2"
#define S_ICON_PRINT_SAVE        @"PrintSave"
#define S_ICON_PRINT_FINISH      @"PrintFinish"
#define S_ICON_PRINT_ACQUIRE     @"AcquirePictureFile"

#define S_TITLE_WIFI_CONNECT   NSLocalizedString(@"S_TITLE_WIFI_CONNECT", @"接続先:%@")
#define S_TITLE_WIFI_UNCONNECT   NSLocalizedString(@"S_TITLE_WIFI_UNCONNECT", @"Wi-Fi未接続")

#define MSG_MAIL_NOTSUPPORT_ERR    NSLocalizedString(@"MSG_MAIL_NOTSUPPORT_ERR", @"このメールはサポートされていない形式のため表示できません。")
#define S_IMAGE_FILE_SELECT   NSLocalizedString(@"S_IMAGE_FILE_SELECT", @"選択")


//#define S_SAVE_WEB_FILENAME_FOR_PRINT_PDF        @"WebPage.pdf"                 // 印刷用に保存するファイル名
//#define S_SAVE_MAIL_FILENAME_FOR_PRINT_PDF        @"MailPage.pdf"                 // 印刷用に保存するファイル名
#define S_PRINT_DATA_FILENAME_FOR_PRINT_PDF        @"PrintData.pdf"                 // 印刷用に保存するファイル名
#define S_PRINT_DATA_FILENAME_FOR_PRINT_TIFF        @"PrintData.tiff"                 // 印刷用に保存するファイル名

#define SUBMSG_PRINTNUMBER NSLocalizedString(@"SUBMSG_PRINTNUMBER", @"数値、ハイフン、スペース、カンマが入力可能です")
#define SUBMSG_PRINTNUMBER_FORMAT NSLocalizedString(@"SUBMSG_PRINTNUMBER_FORMAT", @"1, 2, 4-5 の形式で指定してください。")

#define S_TITLE_SETTING_DEVICENAME_STYLE NSLocalizedString(@"S_TITLE_SETTING_DEVICENAME_STYLE", @"名称設定方法")

#define S_TITLE_RETENTION NSLocalizedString(@"S_TITLE_RETENTION", @"リテンション")
#define S_RETENTION_HOLDOFF   NSLocalizedString(@"S_RETENTION_HOLDOFF", @"ホールドしない")
#define S_RETENTION_HOLDON   NSLocalizedString(@"S_RETENTION_HOLDON", @"ホールドする")
#define S_RETENTION_NOPRINT NSLocalizedString(@"S_RETENTION_NOPRINT", @"印刷せずにホールド")
#define S_RETENTION_AUTHENTICATE NSLocalizedString(@"S_RETENTION_AUTHENTICATE", @"パスワードを指定")
#define S_RETENTION_PASSWORD NSLocalizedString(@"S_RETENTION_PASSWORD", @"パスワード")
#define S_TITLE_PRINT_RANGE NSLocalizedString(@"S_TITLE_PRINT_RANGE", @"印刷範囲")
#define S_PRINT_RANGE_ALL NSLocalizedString(@"S_PRINT_RANGE_ALL", @"全てのページ")
#define S_PRINT_RANGE_RANGE NSLocalizedString(@"S_PRINT_RANGE_RANGE", @"範囲指定")
#define S_PRINT_RANGE_DIRECT NSLocalizedString(@"S_PRINT_RANGE_DIRECT", @"直接指定")
#define S_PRINT_WHAT_SELECTED NSLocalizedString(@"S_PRINT_WHAT_SELECTED", @"選択されたシート")
#define S_PRINT_WHAT_ALL NSLocalizedString(@"S_PRINT_WHAT_ALL", @"ブック全体")

#define S_TITLE_N_UP NSLocalizedString(@"S_TITLE_N_UP", @"ページ集約")
#define S_N_UP_ORDER NSLocalizedString(@"S_N_UP_ORDER", @"順序")
#define S_TITLE_PRINTRELEASE NSLocalizedString(@"S_TITLE_PRINTRELEASE", @"プリントリリース")

#define S_PRINTRELEASE_ENABLE NSLocalizedString(@"S_PRINTRELEASE_ENABLE", @"有効")
#define S_PRINTRELEASE_DISABLE NSLocalizedString(@"S_PRINTRELEASE_DISABLE", @"無効")
#define S_TITLE_FINISHING NSLocalizedString(@"S_TITLE_FINISHING", @"仕上げ")

// iPhone用
// 印刷画面
#define S_BUTTON_FINISHING       NSLocalizedString(@"S_BUTTON_FINISHING", @"仕上げ：%@")        // 仕上げ
#define S_BUTTON_N_UP       NSLocalizedString(@"S_BUTTON_N_UP", @"ページ集約：%@")  // ページ集約ボタン
#define S_BUTTON_PRINT_RANGE       NSLocalizedString(@"S_BUTTON_PRINT_RANGE", @"印刷範囲：%@")  // 印刷範囲ボタン
#define S_BUTTON_PRINT_WHAT   NSLocalizedString(@"S_BUTTON_PRINT_WHAT", @"印刷対象：%@")  // 印刷対象ボタン
#define S_BUTTON_RETENTION       NSLocalizedString(@"S_BUTTON_RETENTION", @"リテンション：%@")  // リテンションボタン
#define S_BUTTON_PRINTRELEASE       NSLocalizedString(@"S_BUTTON_PRINTRELEASE", @"プリントリリース：%@")  // プリントリリース


// iPad用
// 印刷画面
#define S_BUTTON_FINISHING_IPAD      NSLocalizedString(@"S_BUTTON_FINISHING_IPAD", @"仕上げ")      // 仕上げ設定ボタン
#define S_BUTTON_N_UP_IPAD       NSLocalizedString(@"S_BUTTON_N_UP_IPAD", @"ページ集約")  // ページ集約ボタン
#define S_BUTTON_PRINT_RANGE_IPAD       NSLocalizedString(@"S_BUTTON_PRINT_RANGE_IPAD", @"印刷範囲")  // 印刷範囲ボタン
#define S_BUTTON_PRINT_WHAT_IPAD       NSLocalizedString(@"S_BUTTON_PRINT_WHAT_IPAD", @"印刷対象")  // 印刷対象ボタン
#define S_BUTTON_RETENTION_IPAD       NSLocalizedString(@"S_BUTTON_RETENTION_IPAD", @"リテンション")  // リテンションボタン
#define S_BUTTON_PRINTRELEASE_IPAD       NSLocalizedString(@"S_BUTTON_PRINTRELEASE_IPAD", @"プリントリリース")  // プリントリリース

#define S_FINISHING_BINDINGEDGE     NSLocalizedString(@"S_FINISHING_BINDINGEDGE", @"とじ位置")
#define S_PRINT_BINDINGEDGE_LEFT     NSLocalizedString(@"S_PRINT_BINDINGEDGE_LEFT", @"左とじ")
#define S_PRINT_BINDINGEDGE_RIGHT     NSLocalizedString(@"S_PRINT_BINDINGEDGE_RIGHT", @"右とじ")
#define S_PRINT_BINDINGEDGE_TOP     NSLocalizedString(@"S_PRINT_BINDINGEDGE_TOP", @"上とじ")

#define S_FINISHING_STAPLE     NSLocalizedString(@"S_FINISHING_STAPLE", @"ステープル")
#define S_PRINT_STAPLE_NONE     NSLocalizedString(@"S_PRINT_STAPLE_NONE", @"なし")
#define S_PRINT_STAPLE_1STAPLE     NSLocalizedString(@"S_PRINT_STAPLE_1STAPLE", @"1箇所とじ")
#define S_PRINT_STAPLE_2STAPLES     NSLocalizedString(@"S_PRINT_STAPLE_2STAPLES", @"2箇所とじ")
#define S_PRINT_STAPLE_STAPLELESS     NSLocalizedString(@"S_PRINT_STAPLE_STAPLELESS", @"針なしステープル")
#define S_PRINT_STAPLE_ENABLED     NSLocalizedString(@"S_PRINT_STAPLE_ENABLED", @"ステープル")
#define S_PRINT_FINISHING_DISABLED     NSLocalizedString(@"S_PRINT_FINISHING_DISABLED", @"なし")

#define S_FINISHING_PUNCH     NSLocalizedString(@"S_FINISHING_PUNCH", @"パンチ")
#define S_PRINT_PUNCH_NONE     NSLocalizedString(@"S_PRINT_PUNCH_NONE", @"なし")
#define S_PRINT_PUNCH_2HOLES     NSLocalizedString(@"S_PRINT_PUNCH_2HOLES", @"2穴")
#define S_PRINT_PUNCH_3HOLES     NSLocalizedString(@"S_PRINT_PUNCH_3HOLES", @"3穴")
#define S_PRINT_PUNCH_4HOLES     NSLocalizedString(@"S_PRINT_PUNCH_4HOLES", @"4穴")
#define S_PRINT_PUNCH_4HOLESWIDE     NSLocalizedString(@"S_PRINT_PUNCH_4HOLESWIDE", @"4穴(幅広)")
#define S_PRINT_PUNCH_ENABLED     NSLocalizedString(@"S_PRINT_PUNCH_ENABLED", @"パンチ")

#define S_PRINT_N_UP_ONE_UP           NSLocalizedString(@"S_PRINT_N_UP_ONE_UP", @"1-Up")
#define S_PRINT_N_UP_TWO_UP           NSLocalizedString(@"S_PRINT_N_UP_TWO_UP", @"2-Up")
#define S_PRINT_N_UP_FOUR_UP          NSLocalizedString(@"S_PRINT_N_UP_FOUR_UP", @"4-Up")

#define S_PRINT_TWO_UP_LEFT_TO_RIGHT            NSLocalizedString(@"S_PRINT_TWO_UP_LEFT_TO_RIGHT", @"左から右へ")
#define S_PRINT_TWO_UP_RIGHT_TO_LEFT            NSLocalizedString(@"S_PRINT_TWO_UP_RIGHT_TO_LEFT", @"右から左へ")
#define S_PRINT_FOUR_UP_UPPERLEFT_TO_RIGHT      NSLocalizedString(@"S_PRINT_FOUR_UP_UPPERLEFT_TO_RIGHT", @"左上から右方向へ")
#define S_PRINT_FOUR_UP_UPPERLEFT_TO_BOTTOM     NSLocalizedString(@"S_PRINT_FOUR_UP_UPPERLEFT_TO_BOTTOM", @"左上から下方向へ")
#define S_PRINT_FOUR_UP_UPPERRIGHT_TO_LEFT      NSLocalizedString(@"S_PRINT_FOUR_UP_UPPERRIGHT_TO_LEFT", @"右上から左方向へ")
#define S_PRINT_FOUR_UP_UPPERRIGHT_TO_BOTTOM    NSLocalizedString(@"S_PRINT_FOUR_UP_UPPERRIGHT_TO_BOTTOM", @"右上から下方向へ")

#define S_TITLE_SETTING_EMAIL_SERVER_IMAP NSLocalizedString(@"S_TITLE_SETTING_EMAIL_SERVER_IMAP", @"IMAPサーバーの設定を登録してください。")

#define MSG_SCAN_CONFIRM_FREESIZE   NSLocalizedString(@"MSG_SCAN_CONFIRM_FREESIZE", @"保存領域が少なくなっているため、取り込みに失敗する可能性があります。")
#define S_EMAIL_HEADER_CC NSLocalizedString(@"S_EMAIL_HEADER_CC", @"Cc")
#define SUBMSG_RETENTION_FORMAT     NSLocalizedString(@"SUBMSG_RETENTION_FORMAT", @"半角数値5〜8桁")

#define MSG_REMOTESCAN_ACCESSDENIED_MAIN     NSLocalizedString(@"MSG_REMOTESCAN_ACCESSDENIED_MAIN", @"接続先のスキャナーは、使用を禁止されているため利用できません。")
#define S_PRINT_TWO_UP_TOP_TO_BOTTOM            NSLocalizedString(@"S_PRINT_TWO_UP_TOP_TO_BOTTOM", @"上から下へ")

// V2.1 メール添付ファイル印刷
#define S_ENCRYPTZIP_PASSWORD NSLocalizedString(@"S_ENCRYPTZIP_PASSWORD", @"パスワード")
#define S_TITLE_ATTACH_PRINT NSLocalizedString(@"S_TITLE_ATTACH_PRINT", @"添付ファイルを印刷する")
#define MSG_ENCRYPTZIP_ERROR   NSLocalizedString(@"MSG_ENCRYPTZIP_ERROR", @"ZIPファイルの操作中にエラーが発生しました。")
#define MSG_PRINT_COMPLETE_ATTACHMENT_MAIL   NSLocalizedString(@"MSG_PRINT_COMPLETE_ATTACHMENT_MAIL", @"続けて印刷を行いますか？")
#define MSG_BUTTON_YES NSLocalizedString(@"MSG_BUTTON_YES", @"はい")
#define MSG_BUTTON_NO NSLocalizedString(@"MSG_BUTTON_NO", @"いいえ")
#define MSG_PRINT_CONFIRM_NUP_DISABLE   NSLocalizedString(@"MSG_PRINT_CONFIRM_NUP_DISABLE", @"選択したプリンターにはN-Upを指定することが出来ません。N-Upを無効にして印刷を続行しますか？")



//メッセージボックス（アラート）のタグID
enum{
    ALERT_TAG_PREVIEW_MEMORY_ERROR = 11,
    ALERT_TAG_PROGRESS_ALERT = 1,
    ALERT_TAG_PRINT_CONFIRM                         = 99, //印刷します。OKですか？
    ALERT_TAG_PRINT_CONFIRM_OPTION_ERROR_RECONFIRM  = 98, //印刷できないファイルを除いて印刷しますか？
    ALERT_TAG_COMMPROCESS                           = 97, //プリンター/スキャナー情報の取得中です。
};


// 印刷画面ボタンID
enum PRINTER_SETTING_BUTTON {
    BUTTON_PRINT = 1,
    BUTTON_PRINTER,
    BUTTON_NUM,
    BUTTON_DUPLEX,
    BUTTON_COLOR,
    BUTTON_PAPERSIZE,
    BUTTON_PAPERTYPE,
    BUTTON_FINISHING,
    BUTTON_NUP,
    BUTTON_RANGE,
    BUTTON_TARGET,
    BUTTON_RETENTION,
    BUTTON_PRINTRELEASE,
    BUTTON_OTHERAPP,
};


#define MSG_PRINT_MAILATTACHMENT_CONFIRM NSLocalizedString(@"MSG_PRINT_MAILATTACHMENT_CONFIRM", @"Delete The registered e-mail text,print attached file?")
#define S_SETTING_MAILSERVER_CONNECT_TEST NSLocalizedString(@"S_SETTING_MAILSERVER_CONNECT_TEST", @"接続テスト")
#define MSG_SERVER_CONNECT_SUCCESS NSLocalizedString(@"MSG_SERVER_CONNECT_SUCCESS", @"接続に成功しました。設定を保存してください。")
#define MSG_SERVER_CONNECT_FAILED NSLocalizedString(@"MSG_SERVER_CONNECT_FAILED", @"接続に失敗しました。設定を確認してください。")

#define MSG_ACCESS_INHIBIT_PHOTOS_ERR NSLocalizedString(@"MSG_ACCESS_INHIBIT_PHOTOS_ERR", @"写真の取得に失敗しました。")
#define MSG_ENTERED_FOLDERNAME_ERR NSLocalizedString(@"MSG_ENTERED_FOLDERNAME_ERR", @"入力された名前は使用できません。")
#define MSG_MOVEFOLDER_FOLDERNAME_ERR NSLocalizedString(@"MSG_MOVEFOLDER_FOLDERNAME_ERR", @"移動できないフォルダーが選択されています。")
#define MSG_UPGRADING_INTERNALDATA NSLocalizedString(@"MSG_UPGRADING_INTERNALDATA", @"内部データの更新中です。")
#define MSG_UPGRADE_INTERNALDATA_COMPLETE NSLocalizedString(@"MSG_UPGRADE_INTERNALDATA_COMPLETE", @"内部データの更新が終了しました。")
#define MSG_UPGRADE_INTERNALDATA_ERR NSLocalizedString(@"MSG_UPGRADE_INTERNALDATA_ERR", @"更新に失敗したファイルはScanFileフォルダーに保存しました。「ファイルを管理する」よりご確認ください。")

