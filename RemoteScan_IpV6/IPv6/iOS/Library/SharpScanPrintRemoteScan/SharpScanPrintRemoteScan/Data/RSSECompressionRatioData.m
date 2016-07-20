
#import "RSSECompressionRatioData.h"

@implementation RSSECompressionRatioData
- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"low", @"middle", @"high", nil];
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_COMPRESSION_RATIO_LOW, S_RS_XML_COMPRESSION_RATIO_MIDDLE, S_RS_XML_COMPRESSION_RATIO_HIGH, nil];
    defaultKey = @"low";
}
@end
