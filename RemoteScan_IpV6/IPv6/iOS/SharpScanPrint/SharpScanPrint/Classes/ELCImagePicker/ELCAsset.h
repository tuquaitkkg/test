//
//  Asset.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PhotosTypes.h>
#import <Photos/PHFetchResult.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>
#import <Photos/PHFetchOptions.h>
#import <Photos/PHCollection.h>

@class ELCAsset;

@protocol ELCAssetDelegate <NSObject>

@optional
- (void)assetSelected:(ELCAsset *)asset;
- (BOOL)shouldSelectAsset:(ELCAsset *)asset;
@end

@interface ELCAsset : NSObject

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id<ELCAssetDelegate> parent;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) PHAsset *phAsset; // isIOS8_1Later

- (id)initWithAsset:(ALAsset *)asset;
- (id)initWithPHAsset:(PHAsset *)asset; // isIOS8_1Later

@end