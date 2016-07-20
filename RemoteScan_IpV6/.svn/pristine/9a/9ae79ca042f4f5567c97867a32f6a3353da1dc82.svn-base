
#import <Foundation/Foundation.h>
#import "RSDefine.h"

@interface RSSEListTypeData : NSObject
{
    NSArray *fullKeys;
    NSArray *fullValues;
    NSString *defaultKey;

    NSMutableArray *capableKeys;
    NSString *mfpDefaultKey;
}

- (void)addCapableKey:(NSString *)key;
- (void)setDefaultKey:(NSString *)key;
- (NSDictionary *)getCapableOptions;
- (NSArray *)getCapableOptionsKeys;
- (NSString *)getDefaultKey;
- (NSString *)getDefaultKeyWithSelectableKeys:(NSArray *)capableOptionKeys;
- (void)setFullValues;
- (NSUInteger)getFullKeyCount;

@end
