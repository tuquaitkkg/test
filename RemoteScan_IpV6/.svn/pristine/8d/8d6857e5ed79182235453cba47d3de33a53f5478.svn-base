
#import "PaperSetMatrix.h"

@implementation PaperSetMatrix

@synthesize paperMatrixPortrate;
@synthesize paperMatrixLandscape;
@synthesize paperIndex;

//- (NSArray*)scan:(NSString*)scanPaperSize orientation: (NSInteger)orientation
//{
//};

//- (NSArray*)save:(NSString*)savePaperSize orientation: (NSInteger)orientation
//{
//};


- (BOOL)originalSize:(NSString*)scanPaper sendSize: (NSString*)savePaper rotation: (NSString*)rotation
{
    if([scanPaper isEqualToString: @"auto"]||[savePaper isEqualToString: @"auto"])
    {
        return YES;
    }
    else
    {
        NSInteger scanIndex = NSNotFound;
        NSInteger saveIndex = NSNotFound;
        for (int i = 0;i < [self.paperIndex count]; i++)
        {
            if ([[self.paperIndex objectAtIndex: i] isEqualToString: scanPaper]) {
                scanIndex = i + 1;
            }
            if ([[self.paperIndex objectAtIndex: i] isEqualToString: savePaper]) {
                saveIndex = i + 1;
            }
        }
        
        if (scanIndex == NSNotFound) {
            return NO;
        }
        if (saveIndex == NSNotFound) {
            return NO;
        }

        if ([rotation isEqualToString: @"rot_off"])
        {
            if([[[self.paperMatrixPortrate objectAtIndex: scanIndex] objectAtIndex: saveIndex] isEqualToString:  @"Y"])
               {
                   return YES;
               }
               else
               {
                   return NO;
               }
        }
        else if([rotation isEqualToString: @"rot_90"])
        {
            if([[[self.paperMatrixLandscape objectAtIndex: scanIndex] objectAtIndex: saveIndex] isEqualToString:  @"Y"])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    return NO;
}

- (void)setMatirx
{
    if(paperMatrixPortrate == nil)
    {
        paperMatrixPortrate =
        [[NSArray alloc] initWithObjects:
         [NSArray arrayWithObjects: @"rot_off"     ,@"a3",@"b4",@"a4",@"a4_r",@"b5",@"b5_r",@"a5",@"a5_r",@"ledger",@"legal",
                                    @"8_1/2x13_1/2", @"8_1/2x13_2/5", @"foolscap",@"letter",@"letter_r",@"invoice",@"invoice_r",@"8k",@"16k",@"16k_r",nil],
         [NSArray arrayWithObjects: @"a3"          ,@"Y", @"Y", @"N", @"Y", @"N", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"b4"          ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"a4"          ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"a4_r"        ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"b5"          ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"b5_r"        ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"a5"          ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"a5_r"        ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"ledger"      ,@"Y", @"Y", @"N", @"Y", @"N", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"N", @"N", nil],
         [NSArray arrayWithObjects: @"legal"       ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"8_1/2x13_1/2",@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"8_1/2x13_2/5",@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"foolscap"    ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"letter"      ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"letter_r"    ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"invoice"     ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"invoice_r"   ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"8k"          ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"16k"         ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"16k_r"       ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil], nil];
    }
    
    if(paperMatrixLandscape == nil)
    {
        paperMatrixLandscape =
        [[NSArray alloc] initWithObjects:
         [NSArray arrayWithObjects: @"rot_90"      ,@"a3",@"b4",@"a4",@"a4_r",@"b5",@"b5_r",@"a5",@"a5_r",@"ledger",@"legal",
                                    @"8_1/2x13_1/2", @"8_1/2x13_2/5", @"foolscap",@"letter",@"letter_r",@"invoice",@"invoice_r",@"8k",@"16k",@"16k_r",nil],
         [NSArray arrayWithObjects: @"a3"          ,@"Y", @"Y", @"Y", @"N", @"N", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"b4"          ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"a4"          ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"a4_r"        ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"b5"          ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"b5_r"        ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"a5"          ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"a5_r"        ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"ledger"      ,@"Y", @"Y", @"Y", @"N", @"N", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"N", @"N", @"Y", @"N", @"N", nil],
         [NSArray arrayWithObjects: @"legal"       ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"8_1/2x13_1/2",@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"8_1/2x13_2/5",@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"foolscap"    ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"letter"      ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"letter_r"    ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"invoice"     ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"invoice_r"   ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"8k"          ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"N", @"N", @"Y", @"Y", @"N", nil],
         [NSArray arrayWithObjects: @"16k"         ,@"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", @"Y", nil],
         [NSArray arrayWithObjects: @"16k_r"       ,@"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"Y", @"Y", @"Y", @"Y", @"N", @"Y", @"N", @"Y", @"Y", @"N", nil], nil];
    }
    
    if(paperIndex == nil)
    {
        paperIndex = [[NSArray alloc] initWithObjects:  @"a3",           @"b4",           @"a4",       @"a4_r",   @"b5",       @"b5_r",    @"a5",        @"a5_r", @"ledger", @"legal",
                      @"8_1/2x13_1/2", @"8_1/2x13_2/5", @"foolscap", @"letter", @"letter_r", @"invoice", @"invoice_r", @"8k",   @"16k",    @"16k_r",
                      /*@"auto", @"long",*/  nil];
    }
}
@end
