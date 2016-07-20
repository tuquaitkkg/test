
#import "RSSECompressionData.h"

@implementation RSSECompressionData
- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"none", @"mh", @"mmr", @"jpeg", nil];
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_COMPRESSION_NONE, S_RS_XML_COMPRESSION_MH, S_RS_XML_COMPRESSION_MMR, S_RS_XML_COMPRESSION_JPEG, nil];
    defaultKey = @"jpeg";
}
@end
