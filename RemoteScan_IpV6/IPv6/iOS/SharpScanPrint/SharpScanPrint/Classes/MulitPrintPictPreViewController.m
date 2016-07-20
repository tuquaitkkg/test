
#import "MulitPrintPictPreViewController.h"
#import "CommonUtil.h"

@interface MulitPrintPictPreViewController ()

@end

@implementation MulitPrintPictPreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // CommonManagerクラス生成
    m_pCmnMgr = [[CommonManager alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // メインビュー初期化
    [super InitView:[CommonUtil getSSID] menuBtnNum:PrvMenuIDFirst];
    self.navigationItem.rightBarButtonItem = nil;    
}

// 実行スレッド
- (void)ActionThread
{
    if (!m_bAbort)
    {
        // TempフォルダにPhotoLibraryで選択したファイルを保存
        if (self.IsPhotoView)
        {
            [self MainThread];
        }
        else
        {
            DLog(@"selFilePath:%@",self.SelFilePath);
            self.IsPrintPictView = YES;
            //ファイル表示
            [super ShowFile:self.SelFilePath];
        }
    }
}

//PhotoLibraryアクセス用の実行スレッド
- (void)MainThread
{
    if (isIOS8_1Later) {
        [self getPictureByPhotos];
        if (nil != self.m_pThread)
        {
            self.m_pThread = nil;
        }
        
        //スレッドフラグOFF
        m_bThread = FALSE;
        return;
    }

    NSURL *referenceURL = [self.PictEditInfo objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    DLog(@"referenceURL %@",referenceURL);
    __block BOOL foundTheAsset = NO;
    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset)
     {
         if (asset) {
             foundTheAsset = YES;
             [self assetAction:asset];
         } else {
             [library enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop)
              {
                  //ALAssetsLibraryのすべてのアルバムが列挙される
                  if (group) { // まずはフォトストリームを探す
                      DLog(@"group: %@",[group description]);
                      //アルバム(group)からALAssetの取得
                      [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                          if (result) {
                              NSDictionary *dic = [result valueForProperty:ALAssetPropertyURLs];
                              NSString *url = [[dic valueForKey:[[dic allKeys] objectAtIndex:0]] absoluteString];
                              LOG(@"url    : %@",url);
                              LOG(@"refURL : %@",referenceURL);
                              if ([[referenceURL absoluteString] isEqualToString:url]) {
                                  [self assetAction:result];
                                  foundTheAsset = YES;
                                  *stop = YES;
                              }
                          }
                      }];
                      if (foundTheAsset) {
                          *stop = YES;
                      }
                  } else { // フォトストリームにもない場合はフォトストリーム以外のアルバムも探す
                      if (!foundTheAsset) {
                          [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                           {
                               //ALAssetsLibraryのすべてのアルバムが列挙される
                               DLog(@"type : %@",[group valueForProperty:@"ALAssetsGroupType"]);
                               if (group) {
                                   if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] integerValue] != ALAssetsGroupPhotoStream) {
                                       
                                       //アルバム(group)からALAssetの取得
                                       [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                           if (result) {
                                               NSDictionary *dic = [result valueForProperty:ALAssetPropertyURLs];
                                               NSString *url = [[dic valueForKey:[[dic allKeys] objectAtIndex:0]] absoluteString];
                                               LOG(@"url    : %@",url);
                                               LOG(@"refURL : %@",referenceURL);
                                               if ([[referenceURL absoluteString] isEqualToString:url]) {
                                                   [self assetAction:result];
                                                   foundTheAsset = YES;
                                                   *stop = YES;
                                               }
                                           }
                                       }];
                                   }
                               }
                           } failureBlock:nil];
                      }
                  }
              } failureBlock:nil];
         }
         
     }failureBlock:^(NSError *error)
     {
         [super ShowFile:self.SelFilePath];
         DLog(@"failureBlock %@",error);
     }];
}

- (void)assetAction :(ALAsset*)asset {
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    NSUInteger size = [representation size];
    uint8_t *buff = (uint8_t *)malloc(sizeof(uint8_t)*size);
    if(buff != nil)
    {
        NSError *error = nil;
        NSUInteger bytesRead = [representation getBytes:buff fromOffset:0 length:size error:&error];
        if(bytesRead && !error)
        {
            NSData *data = [NSData dataWithBytesNoCopy:buff length:bytesRead freeWhenDone:YES];
            
            // NSString *path = [[self.PictEditInfo objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            NSString *filename = [[asset defaultRepresentation]filename];
            
            TempFile *localTempFile = [[TempFile alloc]initWithFileName:filename];
            [TempFileUtility deleteFile:localTempFile];
            [data writeToFile:localTempFile.tempFilePath atomically:YES];
            self.SelFilePath = localTempFile.tempFilePath;
            DLog(@"%@",self.SelFilePath);
            
            [TempFileUtility createRequiredAllImageFiles:localTempFile];
            [super ShowFile:self.SelFilePath];
        }
        else
        {
            free(buff);
        }
        if(error)
        {
            DLog(@"error %@",error);
        }
    }
}

- (void)getPictureByPhotos
{
    // PHAssetを取得する
    PHAsset *phAsset = [self.PictEditInfo objectForKey:@"PHAsset"];
        
    // TempFileを作成する
    [self createPictureFromAssetByPhotos:phAsset];
    
}

- (void)createPictureFromAssetByPhotos :(PHAsset*)asset
{
    // ファイル名
    __block NSString *filename;
    // ファイルサイズ
    __block NSUInteger size;
    // 画像データ抽出用
    __block NSData *data;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    //ファイル名とファイルサイズを取得する
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        
        //ファイル名
        filename = [[info objectForKey:@"PHImageFileURLKey"] lastPathComponent];
        //ファイルサイズ
        size = imageData.length;
        // 画像データ抽出
        data = imageData;
    }];
    
    uint8_t *buff = (uint8_t *)malloc(sizeof(uint8_t)*size);
    if(buff != nil)
    {
        NSUInteger bytesRead = size;
        if(bytesRead)
        {
            TempFile *localTempFile = [[TempFile alloc] initWithFileName:filename];
            [TempFileUtility deleteFile:localTempFile];
            [data writeToFile:localTempFile.tempFilePath atomically:YES];
            self.SelFilePath = localTempFile.tempFilePath;
            DLog(@"%@",self.SelFilePath);
            [TempFileUtility createRequiredAllImageFiles:localTempFile];
            [super ShowFile:self.SelFilePath];
        }
        else
        {
            free(buff);
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
