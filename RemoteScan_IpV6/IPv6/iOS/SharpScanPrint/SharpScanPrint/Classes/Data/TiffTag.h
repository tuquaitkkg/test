
#import <Foundation/Foundation.h>


@interface TiffTag : NSObject {
    

}

@property (strong) NSData* byteTagID;
@property (strong) NSData* byteFieldType;
@property (strong) NSData* byteNumberOfValues;
@property (strong) NSData* byteOffset;

@property int tagID;
@property int tagType;
@property int nNumberOfValues;
@property int nOffSet;

@end
