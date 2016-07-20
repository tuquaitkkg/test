
#import "RSSEFileFormatData.h"

@implementation RSSEFileFormatData
- (void)setFullValues
{
    fullKeys = [[NSArray alloc] initWithObjects:@"pdf", @"pdfa", @"encrypt_pdf", @"tiff", @"jpeg", @"xps", @"compact_pdf", @"compact_pdf_ultra_fine", @"compact_pdfa", @"compact_pdfa_ultra_fine", @"encrypt_compact_pdf",
                                                @"encrypt_compact_pdf_ultra_fine", @"priority_black_pdf", @"priority_black_pdfa", @"encrypt_priority_black_pdf",
                @"pdfa_1a", @"rtf", @"txt", @"docx", @"xlsx", @"pptx", @"compact_pdfa_1a", @"compact_pdfa_1a_ultra_fine", @"priority_black_pdfa_1a", nil];
    fullValues = [[NSArray alloc] initWithObjects:S_RS_XML_FILE_FORMAT_PDF, S_RS_XML_FILE_FORMAT_PDFA, @"", S_RS_XML_FILE_FORMAT_TIFF, S_RS_XML_FILE_FORMAT_JPEG, @"", S_RS_XML_FILE_FORMAT_COMPACT_PDF, S_RS_XML_FILE_FORMAT_COMPACT_PDF_ULTRA_FINE, S_RS_XML_FILE_FORMAT_COMPACT_PDFA, S_RS_XML_FILE_FORMAT_COMPACT_PDFA_ULTRA_FINE, S_RS_XML_FILE_FORMAT_ENCRYPT_COMPACT_PDF,
                                                  S_RS_XML_FILE_FORMAT_ENCRYPT_COMPACT_PDF_ULTRA_FINE, S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDF, S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDFA, S_RS_XML_FILE_FORMAT_ENCRYPT_PRIORITY_BLACK_PDF,
                  S_RS_XML_FILE_FORMAT_PDFA_1A, @"", @"", S_RS_XML_FILE_FORMAT_DOCX, S_RS_XML_FILE_FORMAT_XLSX, S_RS_XML_FILE_FORMAT_PPTX, S_RS_XML_FILE_FORMAT_COMPACT_PDFA_1A, S_RS_XML_FILE_FORMAT_COMPACT_PDFA_1A_ULTRA_FINE, S_RS_XML_FILE_FORMAT_PRIORITY_BLACK_PDFA_1A, nil];
    defaultKey = @"pdf";
}
@end
