
#import "RSSVSpecialModeData.h"

@implementation RSSVSpecialModeData

@synthesize blankPageSkipData;
@synthesize multiCropData;

- (id)initWithSpecialMode:(RSSESpecialModeData *)specialModeData {
    
    self = [super init];
    if (self)
    {
        
        self.blankPageSkipData = [[RSSVBlankPageSkipData alloc] initWithDictionary:[specialModeData getCapableOptionsForBlankPageSkip]
                                                                          keys:[specialModeData getCapableOptionsKeysForBlankPageSkip]
                                                                  defaultValue:[specialModeData getDefaultKeyForBlankPageSkip]];
        
        self.multiCropData = [[RSSVMultiCropData alloc] initWithDictionary:[specialModeData getCapableOptions] defaultValue:[specialModeData getDefaultKey]];
        
        [self setSelectValue];
        
    }
    return self;
}


// マルチクロップ対応MFPかどうか
- (BOOL)isMultiCropValid {
    return self.multiCropData.isMultiCropValid;
}

// マルチクロップがONかどうか
- (BOOL)isMultiCropOn {
    if ([self isMultiCropValid]) {
        return self.multiCropData.bMultiCrop;
    }
    return NO;
}

// 選択値を返す(ExecuteJobに送るべき値):特別モードに複数投げることがある場合は要修正
- (NSString *)getSelectValue {
    
    NSString *strRes;
    
    if (self.multiCropData.bMultiCrop && self.multiCropData.isMultiCropValid) {
        strRes = @"multi_crop";
    }
    else {
        strRes = [self.blankPageSkipData getSelectValue];
    }
    
    return strRes;

}

// 選択値を設定する(ExecuteJobに送るべき値)
- (void)setSelectValue {
    select = [[self getSelectValue] copy];
}

// 引数のキーを設定する
- (BOOL)setSelectValueWithSpecialModeKey:(NSString *)strValue {
    
    if ([strValue isEqualToString:@"multi_crop"] && self.multiCropData.isMultiCropValid) {
        [self.blankPageSkipData setSelectKey:@"none"];
        self.multiCropData.bMultiCrop = YES;
        return YES;
    }
    else if ([self.blankPageSkipData isExistKey:strValue]) {
        [self.blankPageSkipData setSelectKey:strValue];
        self.multiCropData.bMultiCrop = NO;
        return YES;
    }
    return NO;
}


// 引数のキーを設定できるか判定する(現在のところisExistKeyで問題はない。)
- (BOOL)checkCanSetSelectValueWithSpecialModeKey:(NSString *)strValue {
    
    if ([strValue isEqualToString:@"multi_crop"] && self.multiCropData.isMultiCropValid) {
        return YES;
    }
    else if ([self.blankPageSkipData isExistKey:strValue]) {
        return YES;
    }
    
    return NO;
    
}

// 特別機能の値を設定する
- (void)setSelectKey:(NSString *)selectKey {
    [self setSelectValueWithSpecialModeKey:selectKey];
}

@end
