
#import "RSSEOCROutputFontData.h"

@implementation RSSEOCROutputFontData

- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"ms_gothic", @"ms_mincho", @"ms_pgothic",
                @"ms_pmincho", @"simsun", @"simhei", @"mingliu", @"pmingliu", @"dotum", @"batang",
                @"malgun_gothic", @"arial", @"times_new_roman", nil];
    
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_OCROUTPUTFONT_MS_GOTHIC,
                  S_RS_XML_OCROUTPUTFONT_MS_MINCHO, S_RS_XML_OCROUTPUTFONT_MS_PGOTHIC, S_RS_XML_OCROUTPUTFONT_MS_PMINCHO,
                  S_RS_XML_OCROUTPUTFONT_SIMSUN, S_RS_XML_OCROUTPUTFONT_SIMHEI, S_RS_XML_OCROUTPUTFONT_MINGLIU,
                  S_RS_XML_OCROUTPUTFONT_PMINGLIU, S_RS_XML_OCROUTPUTFONT_DOTUM, S_RS_XML_OCROUTPUTFONT_BATANG,
                  S_RS_XML_OCROUTPUTFONT_MALGUN_GOTHIC, S_RS_XML_OCROUTPUTFONT_ARIAL, S_RS_XML_OCROUTPUTFONT_TIMES_NEW_ROMAN, nil];
    
    defaultKey = @"arial";
}

@end
