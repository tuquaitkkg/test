//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"
#import <CoreLocation/CoreLocation.h>

@implementation ELCImagePickerController

@synthesize delegate = _myDelegate;

- (void)cancelImagePicker
{
	if([_myDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[_myDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount {
    BOOL shouldSelect = previousCount < self.maximumImagesCount;
    if (!shouldSelect) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Only %d photos please!", nil), self.maximumImagesCount];
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You can only send %d photos at a time.", nil), self.maximumImagesCount];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // OK用のアクションを生成
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:NSLocalizedString(@"Okay", nil)
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // NOP                                   
                               }];
        
        // コントローラにアクションを追加
        [alertController addAction:okAction];
        // アラート表示処理
        [self presentViewController:alertController animated:YES completion:nil];

    }
    return shouldSelect;
}

- (void)selectedAssets:(NSArray *)assets
{
    
    if (isIOS8_1Later) {
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        
        for(PHAsset *phAsset in assets) {
            NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
            
            // 対象のPHAssetをセットし、印刷プレビュー画面で受け取ること
            [workingDictionary setObject:phAsset forKey:@"PHAsset"];

            for (NSInteger i = 0; i < [[workingDictionary allKeys] count]; i++)
            {
                DLog(@"key: %@, value:%@", [[workingDictionary allKeys] objectAtIndex:i], [workingDictionary objectForKey:[[workingDictionary allKeys] objectAtIndex:i]]);
            }
            [returnArray addObject:workingDictionary];
            
        }
        if(_myDelegate != nil && [_myDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
            [_myDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
        } else {
            [self popToRootViewControllerAnimated:NO];
        }

    } else {
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        
        for(ALAsset *asset in assets) {
            NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
            
            CLLocation* wgs84Location = [asset valueForProperty:ALAssetPropertyLocation];
            if (wgs84Location) {
                [workingDictionary setObject:wgs84Location forKey:ALAssetPropertyLocation];
            }
            
            [workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
            
            [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
            
            for (NSInteger i = 0; i < [[workingDictionary allKeys] count]; i++)
            {
                DLog(@"key: %@, value:%@", [[workingDictionary allKeys] objectAtIndex:i], [workingDictionary objectForKey:[[workingDictionary allKeys] objectAtIndex:i]]);
            }
            
            [returnArray addObject:workingDictionary];
            
        }
        
        if(_myDelegate != nil && [_myDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
            [_myDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
        } else {
            [self popToRootViewControllerAnimated:NO];
        }
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    NSLog(@"ELC Image Picker received memory warning.");
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
