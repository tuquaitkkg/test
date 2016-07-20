//
//  AssetTablePicker.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"

@interface ELCAssetTablePicker ()

@property (nonatomic, assign) int columns;

@end

@implementation ELCAssetTablePicker

@synthesize parent = _parent;;
@synthesize selectedAssetsLabel = _selectedAssetsLabel;
@synthesize assetGroup = _assetGroup;
@synthesize elcAssets = _elcAssets;
@synthesize singleSelection = _singleSelection;
@synthesize columns = _columns;
@synthesize fetchResult = _fetchResult; // isIOS8_1Later

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView setAllowsSelection:NO];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
	
    if (self.immediateReturn) {
        
    } else {
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
        [self.navigationItem setRightBarButtonItem:doneButtonItem];
        //[self.navigationItem setTitle:@"Loading..."];
    }

	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.columns = self.view.bounds.size.width / 80; // 列数を計算 iOS9ではviewWillLayoutSubviewsでないとサイズ調整後の値が取得できないが、tableViewのデリゲートが呼ばれて変数が使用されるので一旦デフォルトの値を格納する目的で処理を残している。(ないと縦向きのときに落ちる)
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.columns = self.view.bounds.size.width / 80;    //　サイズ調整されたviewで列数を計算 for iOS9
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.columns = self.view.bounds.size.width / 80;
    [self.tableView reloadData];
}

- (void)preparePhotos
{
    if (isIOS8_1Later) {
        @autoreleasepool {
            NSLog(@"enumerating photos");
            [self.fetchResult enumerateObjectsUsingBlock:^(PHAsset *result, NSUInteger index, BOOL *stop) {
                
                if(result == nil) {
                    return;
                }
                
                ELCAsset *elcAsset = [[ELCAsset alloc] initWithPHAsset:result];
                [elcAsset setParent:self];
                
                BOOL isAssetFiltered = NO;
                if (self.assetPickerFilterDelegate &&
                    [self.assetPickerFilterDelegate respondsToSelector:@selector(assetTablePicker:isAssetFilteredOut:)])
                {
                    isAssetFiltered = [self.assetPickerFilterDelegate assetTablePicker:self isAssetFilteredOut:(ELCAsset*)elcAsset];
                }
                
                if (!isAssetFiltered) {
                    [self.elcAssets addObject:elcAsset];
                }
            }];
            NSLog(@"done enumerating photos");
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                // scroll to bottom
                long section = [self numberOfSectionsInTableView:self.tableView] - 1;
                long row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
                if (section >= 0 && row >= 0) {
                    NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                                         inSection:section];
                    [self.tableView scrollToRowAtIndexPath:ip
                                          atScrollPosition:UITableViewScrollPositionBottom
                                                  animated:NO];
                }
                
                //[self.navigationItem setTitle:self.singleSelection ? @"Pick Photo" : @"Pick Photos"];
            });
        }

    } else {
        @autoreleasepool {
            NSLog(@"enumerating photos");
            [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if(result == nil) {
                    return;
                }
                
                ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
                [elcAsset setParent:self];
                
                BOOL isAssetFiltered = NO;
                if (self.assetPickerFilterDelegate &&
                    [self.assetPickerFilterDelegate respondsToSelector:@selector(assetTablePicker:isAssetFilteredOut:)])
                {
                    isAssetFiltered = [self.assetPickerFilterDelegate assetTablePicker:self isAssetFilteredOut:(ELCAsset*)elcAsset];
                }
                
                if (!isAssetFiltered) {
                    [self.elcAssets addObject:elcAsset];
                }
            }];
            NSLog(@"done enumerating photos");
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                // scroll to bottom
                long section = [self numberOfSectionsInTableView:self.tableView] - 1;
                long row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
                if (section >= 0 && row >= 0) {
                    NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                                         inSection:section];
                    [self.tableView scrollToRowAtIndexPath:ip
                                          atScrollPosition:UITableViewScrollPositionBottom
                                                  animated:NO];
                }
                
                //[self.navigationItem setTitle:self.singleSelection ? @"Pick Photo" : @"Pick Photos"];
            });
        }
    }
}

- (void)doneAction:(id)sender
{	
	NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
	    
	for(ELCAsset *elcAsset in self.elcAssets) {

		if([elcAsset selected]) {
			
            if (isIOS8_1Later) {
                [selectedAssetsImages addObject:[elcAsset phAsset]];
            } else {
                [selectedAssetsImages addObject:[elcAsset asset]];
            }
		}
	}
        
    [self.parent selectedAssets:selectedAssetsImages];
}


- (BOOL)shouldSelectAsset:(ELCAsset *)asset {
    NSUInteger selectionCount = 0;
    for (ELCAsset *elcAsset in self.elcAssets) {
        if (elcAsset.selected) selectionCount++;
    }
    BOOL shouldSelect = YES;
    if ([self.parent respondsToSelector:@selector(shouldSelectAsset:previousCount:)]) {
        shouldSelect = [self.parent shouldSelectAsset:asset previousCount:selectionCount];
    }
    return shouldSelect;
}

- (void)assetSelected:(id)asset
{
    if (self.singleSelection) {

        for(ELCAsset *elcAsset in self.elcAssets) {
            if(asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }
    if (self.immediateReturn) {
        NSArray *singleAssetArray = [NSArray arrayWithObject:[asset asset]];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([self.elcAssets count] / (float)self.columns);
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.elcAssets count] - index);
    return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
        
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {		        
        cell = [[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];

    } else {		
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}

- (int)totalSelectedAssets {
    
    int count = 0;
    
    for(ELCAsset *asset in self.elcAssets) {
		if([asset selected]) {   
            count++;	
		}
	}
    
    return count;
}

@end
