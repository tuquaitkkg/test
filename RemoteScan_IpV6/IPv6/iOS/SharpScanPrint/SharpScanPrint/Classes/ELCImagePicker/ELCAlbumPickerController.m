//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumCell.h"
#import "SharpScanPrintAppDelegate.h"

@interface ELCAlbumPickerController ()

@property (nonatomic, retain) ALAssetsLibrary *library;

@end

@implementation ELCAlbumPickerController

@synthesize parent = _parent;
@synthesize assetGroups = _assetGroups;
@synthesize library = _library;
@synthesize assetCollections = _assetCollections;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Loading..."];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
	[self.navigationItem setRightBarButtonItem:cancelButton];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;

    // isIOS8_1Later
    NSMutableArray *collectionArray = [[NSMutableArray alloc] init];
    self.assetCollections = collectionArray;
    
    if (isIOS8_1Later) {
        // request authorization status
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            dispatch_async(dispatch_get_main_queue(), ^
            {
                @autoreleasepool {

                    // 写真データへのアクセス許可がない場合
                    if (status != PHAuthorizationStatusAuthorized){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                                 message:MSG_ACCESS_INHIBIT_PHOTOS_ERR
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        // Cancel用のアクションを生成
                        UIAlertAction * cancelAction =
                        [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   // ボタンタップ時の処理
                                                   [self appDelegateIsRunOff];
                                               }];
                        
                        // コントローラにアクションを追加
                        [alertController addAction:cancelAction];
                        // アラート表示処理
                        [self presentViewController:alertController animated:YES completion:nil];

                        return;
                    }
                    
                    // SmartAlbumタイプからカメラロールのみ取得する
                    PHFetchResult *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                    for (PHCollection *collection in cameraRoll) {
                        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                        [self.assetCollections addObject:assetCollection];
                    }

                    // Albumタイプの全てのアルバムを取得する
                    // フォトストリームも含まれる
                    PHFetchResult *album = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                    for (PHCollection *collection in album) {
                        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                        [self.assetCollections addObject:assetCollection];
                    }
                   
                    // Reload albums
                    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                }
            });
        }];

    } else {
        // Load Albums into assetGroups
        dispatch_async(dispatch_get_main_queue(), ^
        {
            @autoreleasepool {
                // Group enumerator Block
                void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                {
                    if (group == nil) {
                        return;
                    }
                    
                    // added fix for camera albums order
                    NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                    NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                    
                    if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                        [self.assetGroups insertObject:group atIndex:0];
                    }
                    else {
                        [self.assetGroups addObject:group];
                    }
                    
                    // Reload albums
                    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                };
                
                // Group Enumerator Failure Block
                void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                    
                    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
                    // 処理実行フラグON
                    appDelegate.IsRun = TRUE;

                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                             message:MSG_ACCESS_INHIBIT_PHOTOS_ERR
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    // Cancel用のアクションを生成
                    UIAlertAction * cancelAction =
                    [UIAlertAction actionWithTitle:@"OK"
                                             style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction * action) {
                                               
                                               // ボタンタップ時の処理
                                               [self appDelegateIsRunOff];
                                           }];
                    
                    // コントローラにアクションを追加
                    [alertController addAction:cancelAction];
                    // アラート表示処理
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    NSLog(@"A problem occured %@", [error description]);
                };
                
                // Enumerate Albums
                [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                            usingBlock:assetGroupEnumerator
                                          failureBlock:assetGroupEnumberatorFailure];
                
            }
        });
    }

}

- (void)reloadTableView
{
	[self.tableView reloadData];
	[self.navigationItem setTitle:S_PRINT_SEL_PICTURE];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount {
    return [self.parent shouldSelectAsset:asset previousCount:previousCount];
}

- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (isIOS8_1Later) {
        return [self.assetCollections count];
    } else {
        return [self.assetGroups count];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    if (isIOS8_1Later) {
        ELCAlbumCell *cell = (ELCAlbumCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ELCAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        PHAssetCollection *assetCollection = (PHAssetCollection*)[self.assetCollections objectAtIndex:indexPath.row];
        NSString *title = [assetCollection localizedTitle];

        // 画像のみ取得する
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];

        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
        NSInteger resultCount = [fetchResult count];
        
        __block UIImage *image = nil;
        
        // アルバムの中の画像がある場合
        if (resultCount > 0) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            // 同期処理にする場合にはYES (デフォルトはNO)
            options.synchronous = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize cellSize = CGSizeMake(75 * scale, 75 * scale);
            [[PHImageManager defaultManager] requestImageForAsset:fetchResult.lastObject
                                                       targetSize:cellSize
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:options
                                                    resultHandler:^(UIImage *result, NSDictionary *info) {
                                                        
                                                        // サムネイル取得
                                                        image = result;;
                                                        
                                                    }
             ];
            
        // アルバムの中に画像が存在しない場合は、透明の画像をポスターイメージとしておく
        } else {
            UIImage *tempImage = [[UIImage alloc] init];
            UIColor *color = [UIColor clearColor];
            color = [color colorWithAlphaComponent:0.05]; //透過率
            CGFloat scale = [UIScreen mainScreen].scale;
            //透明のUIImageを作成します。
            image = [self colorImage:tempImage color:color rect:CGRectMake(0, 0, 75 * scale, 75 * scale)];
        }
        
        // フォントサイズ設定
        cell.albumNameLabel.font = [UIFont systemFontOfSize:16];
        cell.albumNameLabel.text = [NSString stringWithFormat:@"%@ (%ld)",title, (long)resultCount];
        [cell.albumImageView setImage:image];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        return cell;

    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Get count
        ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
        [g setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSInteger gCount = [g numberOfAssets];
        
        // フォントサイズ設定
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];

        [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
    }
}


//指定したUIColorでCGRectの大きさを塗り潰したUIImageを返す
- (UIImage *)colorImage:(UIImage *)image
                  color:(UIColor *)color
                   rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [image drawAtPoint:CGPointZero];
    [color setFill];
    UIRectFill(rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc] initWithNibName: nil bundle: nil];
	picker.parent = self;

    if (isIOS8_1Later) {
        ELCAlbumCell *cell = (ELCAlbumCell*)[tableView cellForRowAtIndexPath:indexPath];
        picker.title = cell.albumNameLabel.text;

        PHAssetCollection *assetCollection = (PHAssetCollection*)[self.assetCollections objectAtIndex:indexPath.row];
        
        // 画像のみ取得する
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
        picker.fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        picker.title = cell.textLabel.text;

        picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
        [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    }
    
	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
	
	[self.navigationController pushViewController:picker animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 57;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

// アラートボタン押下処理
- (void)appDelegateIsRunOff {
    // ボタンタップ時の処理
    SharpScanPrintAppDelegate* appDelegate = (SharpScanPrintAppDelegate*)[[UIApplication sharedApplication] delegate];
    // 処理実行フラグOFF
    appDelegate.IsRun = FALSE;
}

@end

