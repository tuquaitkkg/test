//
//  AlbumPickerController.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetSelectionDelegate.h"
#import "ELCAssetPickerFilterDelegate.h"
#import <Photos/PhotosTypes.h>
#import <Photos/PHFetchResult.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>
#import <Photos/PHFetchOptions.h>
#import <Photos/PHCollection.h>

@interface ELCAlbumPickerController : UITableViewController <ELCAssetSelectionDelegate>

@property (nonatomic, assign) id<ELCAssetSelectionDelegate> parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic, retain) NSMutableArray *assetCollections; // isIOS8_1Later

// optional, can be used to filter the assets displayed
@property (nonatomic, assign) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

@end

