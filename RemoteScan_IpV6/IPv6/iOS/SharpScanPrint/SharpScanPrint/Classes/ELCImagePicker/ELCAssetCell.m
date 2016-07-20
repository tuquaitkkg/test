//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"

@interface ELCAssetCell ()

@property (nonatomic, retain) NSArray *rowAssets;
@property (nonatomic, retain) NSMutableArray *imageViewArray;
@property (nonatomic, retain) NSMutableArray *overlayViewArray;

@end

@implementation ELCAssetCell

@synthesize rowAssets = _rowAssets;

- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	if(self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;

        [self setAssets:assets];
	}
	return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
	for (UIImageView *view in _imageViewArray) {
        [view removeFromSuperview];
	}
    for (UIImageView *view in _overlayViewArray) {
        [view removeFromSuperview];
	}
    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
    UIImage *overlayImage = nil;
    for (int i = 0; i < [_rowAssets count]; ++i) {

        ELCAsset *asset = [_rowAssets objectAtIndex:i];

        if (i < [_imageViewArray count]) {
            if (isIOS8_1Later) {
                __block UIImage *image = nil;
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                // 同期処理にする場合にはYES (デフォルトはNO)
                options.synchronous = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeExact;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                CGFloat scale = [UIScreen mainScreen].scale;
                CGSize cellSize = CGSizeMake(75 * scale, 75 * scale);
                [[PHImageManager defaultManager] requestImageForAsset:asset.phAsset
                                                           targetSize:cellSize
                                                          contentMode:PHImageContentModeAspectFill
                                                              options:options
                                                        resultHandler:^(UIImage *result, NSDictionary *info) {
                                                            
                                                            // サムネイル取得
                                                            image = result;
                                                        }
                 ];
                UIImageView *imageView = [_imageViewArray objectAtIndex:i];
                imageView.image = image;
                
            } else {
                UIImageView *imageView = [_imageViewArray objectAtIndex:i];
                imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
            }
        } else {
            if (isIOS8_1Later) {
                __block UIImage *image = nil;
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                // 同期処理にする場合にはYES (デフォルトはNO)
                options.synchronous = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeExact;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                CGFloat scale = [UIScreen mainScreen].scale;
                CGSize cellSize = CGSizeMake(75 * scale, 75 * scale);
                [[PHImageManager defaultManager] requestImageForAsset:asset.phAsset
                                                           targetSize:cellSize
                                                          contentMode:PHImageContentModeAspectFill
                                                              options:options
                                                        resultHandler:^(UIImage *result, NSDictionary *info) {
                                                            
                                                            // サムネイル取得
                                                            image = result;
                                                        }
                 ];
                CGRect imageFrame = CGRectMake(0, 0, 75, 75);
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [imageView setImage:image];
                [_imageViewArray addObject:imageView];
                
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
                [_imageViewArray addObject:imageView];
            }
        }
        
        if (i < [_overlayViewArray count]) {
            UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = asset.selected ? NO : YES;
        } else {
            if (overlayImage == nil) {
                overlayImage = [UIImage imageNamed:@"Overlay.png"];
            }
            UIImageView *overlayView = [[UIImageView alloc] initWithImage:overlayImage];
            [_overlayViewArray addObject:overlayView];
            overlayView.hidden = asset.selected ? NO : YES;
        }
    }
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint point = [tapRecognizer locationInView:self];
    
    //中央
    //CGFloat totalWidth = self.rowAssets.count * 75 + (self.rowAssets.count - 1) * 4;
    //CGFloat startX = (self.bounds.size.width - totalWidth) / 2;
    
    //左よせ
    int maxItemsPerRow = (self.bounds.size.width-75) / (75 + 4) + 1;
    CGFloat startX = (self.bounds.size.width - maxItemsPerRow * (75 + 4) + 4 ) / 2;
    
	CGRect frame = CGRectMake(startX, 2, 75, 75);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
        if (CGRectContainsPoint(frame, point)) {
            ELCAsset *asset = [_rowAssets objectAtIndex:i];
            asset.selected = !asset.selected;
            UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = !asset.selected;
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}

- (void)layoutSubviews
{
    //中央
    //CGFloat totalWidth = self.rowAssets.count * 75 + (self.rowAssets.count - 1) * 4;
    //CGFloat startX = (self.bounds.size.width - totalWidth) / 2;
    
    //左よせ
    int maxItemsPerRow = (self.bounds.size.width-75) / (75 + 4) + 1;
    CGFloat startX = (self.bounds.size.width - maxItemsPerRow * (75 + 4) + 4 ) / 2;
    
    
	CGRect frame = CGRectMake(startX, 2, 75, 75);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
		UIImageView *imageView = [_imageViewArray objectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];
        
        UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
        [overlayView setFrame:frame];
        [self addSubview:overlayView];
		
		frame.origin.x = frame.origin.x + frame.size.width + 4;
	}
}

@end
