
#import "RSCustomPaperSizeData.h"
#import "RSDefine.h"

@implementation RSCustomPaperSizeData

@synthesize name;
@synthesize paperWidthMilli;
@synthesize paperHeightMilli;
@synthesize paperWidthInch;
@synthesize paperHeightInch;
@synthesize bMilli;
@synthesize paperWidthInchLow;
@synthesize paperHeightInchLow;
@synthesize customSizeKey;

//
// イニシャライザ定義
//
- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }

    return self;
}

- (id)initWithInchValue:(NSString *)paperName width:(float)paperWidth height:(float)paperHeight
{
    self = [super init];
    if (self)
    {
        bMilli = NO;
        name = paperName;
        paperWidthInch = paperWidth;
        paperHeightInch = paperHeight;
    }
    return self;
}

- (id)initWithMilliValue:(NSString *)paperName width:(float)paperWidth height:(float)paperHeight
{
    self = [super init];
    if (self)
    {
        bMilli = YES;
        name = paperName;
        paperWidthMilli = paperWidth;
        paperHeightMilli = paperHeight;
    }
    return self;
}

- (NSString *)getDisplayName
{
    NSString *str = nil;
    if (bMilli)
    {
        str = [NSString stringWithFormat:@"%@ （ %d x %d ） %@", name, paperWidthMilli, paperHeightMilli, S_RS_CUSTOMSIZE_MILLIMETER];
    }
    else
    {
        // TODO 分数表示にする
        if ([paperWidthInchLow isEqualToString:@"-"] && ![paperHeightInchLow isEqualToString:@"-"])
        {
            str = [NSString stringWithFormat:@"%@ （ %d x %d %@ ） %@", name, paperWidthInch, paperHeightInch, paperHeightInchLow, S_RS_CUSTOMSIZE_INCH];
        }
        else if (![paperWidthInchLow isEqualToString:@"-"] && [paperHeightInchLow isEqualToString:@"-"])
        {
            str = [NSString stringWithFormat:@"%@ （ %d %@ x %d ） %@", name, paperWidthInch, paperWidthInchLow, paperHeightInch, S_RS_CUSTOMSIZE_INCH];
        }
        else if ([paperWidthInchLow isEqualToString:@"-"] && [paperHeightInchLow isEqualToString:@"-"])
        {
            str = [NSString stringWithFormat:@"%@ （ %d x %d ） %@", name, paperWidthInch, paperHeightInch, S_RS_CUSTOMSIZE_INCH];
        }
        else
        {
            str = [NSString stringWithFormat:@"%@ （ %d %@ x %d %@ ） %@", name, paperWidthInch, paperWidthInchLow, paperHeightInch, paperHeightInchLow, S_RS_CUSTOMSIZE_INCH];
        }
    }
    return str;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        name = [coder decodeObjectForKey:@"name"];
        paperWidthMilli = [coder decodeInt32ForKey:@"paperWidthMilli"];
        paperHeightMilli = [coder decodeInt32ForKey:@"paperHeightMilli"];
        paperWidthInch = [coder decodeFloatForKey:@"paperWidthInch"];
        paperHeightInch = [coder decodeFloatForKey:@"paperHeightInch"];
        paperWidthInchLow = [coder decodeObjectForKey:@"paperWidthInchLow"];
        paperHeightInchLow = [coder decodeObjectForKey:@"paperHeightInchLow"];
        bMilli = [coder decodeBoolForKey:@"bMilli"];
        customSizeKey = [coder decodeObjectForKey:@"customSizeKey"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeInt32:paperWidthMilli forKey:@"paperWidthMilli"];
    [coder encodeInt32:paperHeightMilli forKey:@"paperHeightMilli"];
    [coder encodeFloat:paperWidthInch forKey:@"paperWidthInch"];
    [coder encodeFloat:paperHeightInch forKey:@"paperHeightInch"];
    [coder encodeObject:paperWidthInchLow forKey:@"paperWidthInchLow"];
    [coder encodeObject:paperHeightInchLow forKey:@"paperHeightInchLow"];
    [coder encodeBool:bMilli forKey:@"bMilli"];
    [coder encodeObject:customSizeKey forKey:@"customSizeKey"];
}

// ログ出力
- (NSString *)description
{
    return [NSString stringWithFormat:
                         @"name[%@] paperWidthMilli[%d] paperHeightMilli[%d] paperWidthInch[%d] paperHeightInch[%d] paperWidthInchLow[%@] paperHeightInchLow[%@] bMilli[%d] customSizeKey[%@]", name, paperWidthMilli, paperHeightMilli, paperWidthInch, paperHeightInch, paperWidthInchLow, paperHeightInchLow, bMilli, customSizeKey];
}

- (int)getMilliWidth
{
    if (bMilli)
    {
        return paperWidthMilli;
    }
    else
    {
        return (int)roundf(((paperWidthInch + [self getFloatInch:paperWidthInchLow]) * 25.4));
    }
}

- (int)getMilliHeight
{
    if (bMilli)
    {
        return paperHeightMilli;
    }
    else
    {
        return (int)roundf(((paperHeightInch + [self getFloatInch:paperHeightInchLow]) * 25.4));
    }
}

- (float)getFloatInch:(NSString *)strInchLow
{
    float fInch = 0;

    NSArray *inchLowValue = [[NSArray alloc] initWithObjects:@"-", @"1/8", @"1/4", @"3/8", @"1/2", @"5/8", @"3/4", @"7/8", nil];
    NSUInteger inchLowValueIndex = [inchLowValue indexOfObject:strInchLow];
    switch (inchLowValueIndex)
    {
    case 1:
        fInch = 0.125;
        break;
    case 2:
        fInch = 0.25;
        break;
    case 3:
        fInch = 0.375;
        break;
    case 4:
        fInch = 0.5;
        break;
    case 5:
        fInch = 0.625;
        break;
    case 6:
        fInch = 0.75;
        break;
    case 7:
        fInch = 0.875;
        break;
    default:
        break;
    }

    return fInch;
}

@end
