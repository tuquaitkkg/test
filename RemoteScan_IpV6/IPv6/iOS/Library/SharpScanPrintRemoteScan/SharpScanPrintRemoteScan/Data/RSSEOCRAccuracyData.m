#import "RSSEOCRAccuracyData.h"

@implementation RSSEOCRAccuracyData

- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"auto", @"priority_text", nil];
    
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_OCRACCURACY_AUTO,
                  S_RS_XML_OCRACCURACY_PRIORITY_TEXT, nil];
    
    defaultKey = @"auto";
}

@end
