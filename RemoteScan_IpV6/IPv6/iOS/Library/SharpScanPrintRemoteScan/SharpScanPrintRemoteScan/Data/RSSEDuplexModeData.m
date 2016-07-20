
#import "RSSEDuplexModeData.h"

@implementation RSSEDuplexModeData
- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"simplex", @"duplex", nil];
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_DUPLEX_MODE_SIMPLEX, S_RS_XML_DUPLEX_MODE_DUPLEX, nil];
    defaultKey = @"simplex";
}
@end
