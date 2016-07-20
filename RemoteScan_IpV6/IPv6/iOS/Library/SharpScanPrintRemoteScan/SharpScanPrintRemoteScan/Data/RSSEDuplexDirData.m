
#import "RSSEDuplexDirData.h"

@implementation RSSEDuplexDirData
- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"book", @"tablet", nil];
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_DUPLEX_DIR_BOOK, S_RS_XML_DUPLEX_DIR_TABLET, nil];
    defaultKey = @"book";
}
@end
