
#import "MultiPrintPictCell.h"
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Define.h"
#import <Photos/PhotosTypes.h>
#import <Photos/PHFetchResult.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>
#import <Photos/PHFetchOptions.h>
#import <Photos/PHCollection.h>

@interface MultiPrintPictCell()
@end

@implementation MultiPrintPictCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	[super layoutSubviews];
    
    if (self.isEditing) {
		CGRect contentFrame    = self.contentView.frame;
		contentFrame.origin.x  = 33;//0;//EDITING_HORIZONTAL_OFFSET;
		self.contentView.frame = contentFrame;
	} else {
		CGRect contentFrame    = self.contentView.frame;
		contentFrame.origin.x  = 0;
		self.contentView.frame = contentFrame;
	}
    
	[UIView commitAnimations];
}

- (void)setModel:(ScanData *)aScanData hasDisclosure:(BOOL)newDisclosure {
    [super setModel:aScanData hasDisclosure:newDisclosure];
}

- (void)setPictModel:(NSDictionary *)data
{
    self.accessoryType =  TABLE_CELL_ACCESSORY;
    //アセットのurl
    NSURL *referenceURL = [data objectForKey:UIImagePickerControllerReferenceURL];
    DLog(@"referenceURL %@",referenceURL);

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    __block BOOL foundTheAsset = NO;
 
    //アセット取得成功時ブロック定義
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset)
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
    };
    
    //アセット取得実行
    [library assetForURL:referenceURL
             resultBlock:resultBlock
            failureBlock:^(NSError *error){
                DLog(@"アセット取得失敗　error:%@",error);
            }];
}

- (void)assetAction :(ALAsset*)asset {
    NSString *url = [[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] absoluteString];
    DLog(@"url: %@",url);
    
    //ファイル名
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        self.nameLabel.text = [[asset defaultRepresentation]filename];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@%@",[self fileType:url.pathExtension.lowercaseString],S_LABEL_FILE];
    }
    
    //日付
    NSDate *date = (NSDate *)[asset valueForProperty:ALAssetPropertyDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    self.dateLabel.text = [NSString stringWithString:[formatter stringFromDate:date]];
    
    //ファイルサイズ
    self.fsizeLabel.text = [self calcFileSize:[[asset defaultRepresentation]size]];
    
    //サムネイル
    CGImageRef imgRef = asset.thumbnail;
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:1.0f
                                 orientation:UIImageOrientationUp];
    self.imgView.image = img;
}

- (NSString *)calcFileSize:(long long)fSize {
    NSString *byteStr = S_UNIT_BYTE;
    int    bytecnt = 0;
    while (fSize > 1024) {
        fSize = fSize / 1024;
        bytecnt++;
    }
    switch (bytecnt) {
        case 0:
            break;
        case 1:
            byteStr = S_UNIT_KB;
            break;
        case 2:
            byteStr = S_UNIT_MB;
            break;
        default:
            byteStr = S_UNIT_GB;
            break;
    }
    return [NSString stringWithFormat:@"%.1lld %@", fSize, byteStr];
}

- (NSString*)fileType:(NSString *)pathExt;
{
    NSString *filetype = @"unknown";
    // pdfファイルチェック
    if ([pathExt isEqualToString:@"pdf"]) {
        filetype = @"PDF";
    } else if ([pathExt isEqualToString:@"tif"] || [pathExt isEqualToString:@"tiff"]) {
        filetype = @"TIFF";
    } else if ([pathExt isEqualToString:@"jpg"] || [pathExt isEqualToString:@"ipeg"] || [pathExt isEqualToString:@"jpe"]) {
        filetype = @"JPEG";
    } else if ([pathExt isEqualToString:@"png"]) {
        filetype = @"PNG";
    } else if ([pathExt isEqualToString:@"docx"]) {
        filetype = @"DOCX";
    } else if ([pathExt isEqualToString:@"xlsx"]) {
        filetype = @"XLSX";
    } else if ([pathExt isEqualToString:@"pptx"]) {
        filetype = @"PPTX";
    } else {
        filetype = @"UNKNOWN";
    }
    return [filetype copy];
}

- (void)setPictModelByPhotos:(NSDictionary *)phAssetInfo
{
    self.accessoryType =  TABLE_CELL_ACCESSORY;
    
    // PHAssetを取得する
    PHAsset *phAsset = [phAssetInfo objectForKey:@"PHAsset"];

    //日付
    NSDate *date = (NSDate *)[phAsset creationDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];        // 12時間表示にならないように
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];  // localeを再設定する。
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    self.dateLabel.text = [NSString stringWithString:[formatter stringFromDate:date]];

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同期処理にする場合にはYES (デフォルトはNO)
    options.synchronous = YES;

    //ファイル名、ファイルサイズ、サムネイルを取得する
    [[PHImageManager defaultManager] requestImageDataForAsset:phAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        
        //ファイル名
        self.nameLabel.text = [[info objectForKey:@"PHImageFileURLKey"] lastPathComponent];
        //ファイルサイズ
        float imageSize = imageData.length;
        self.fsizeLabel.text = [self calcFileSizeByPhotos:imageSize];
//        // サムネイルの取得
//        self.imgView.image = [UIImage imageWithData:imageData];
    }];
    
    // サムネイルだけリサイズしたものを取得する
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = CGSizeMake(75 * scale, 75 * scale);
    [[PHImageManager defaultManager] requestImageForAsset:phAsset
                                               targetSize:cellSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                
                                                // サムネイル取得
                                                self.imgView.image = result;
                                            }
     ];

}

- (NSString *)calcFileSizeByPhotos:(float)fSize {
    NSString *byteStr = S_UNIT_BYTE;
    int    bytecnt = 0;
    while (fSize > 1024) {
        fSize = fSize / 1024;
        bytecnt++;
    }
    switch (bytecnt) {
        case 0:
            break;
        case 1:
            byteStr = S_UNIT_KB;
            break;
        case 2:
            byteStr = S_UNIT_MB;
            break;
        default:
            byteStr = S_UNIT_GB;
            break;
    }
    return [NSString stringWithFormat:@"%.1f %@", fSize, byteStr];
}

@end
