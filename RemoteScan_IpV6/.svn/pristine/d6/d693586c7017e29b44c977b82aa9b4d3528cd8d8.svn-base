
#import "UIPlaceHolderTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIPlaceHolderTextView
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize placeholderLabel;

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
        // アウトライン
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.cornerRadius = 8;
    }
    return self;
}

// 表示テキストに変更があった時
- (void)textChanged:(NSNotification *)notification {
    if([[self placeholder] length] == 0) {
        return;
    }
    
    if([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    else {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

// drawRect時にplaceholderのUILabelを準備してViewに追加する
- (void)drawRect:(CGRect)rect {
    if([[self placeholder] length] > 0) {
        if (placeholderLabel == nil) {
            placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeholderLabel.numberOfLines = 0;
            placeholderLabel.font = self.font;
            placeholderLabel.backgroundColor = [UIColor clearColor];
            placeholderLabel.textColor = self.placeholderColor;
            placeholderLabel.alpha = 0;
            placeholderLabel.tag = 999;
            [self addSubview:placeholderLabel];
        }
        
        placeholderLabel.text = self.placeholder;
        [placeholderLabel sizeToFit];
        [self sendSubviewToBack:placeholderLabel];
    }
    
    if([[self text] length] == 0 && [[self placeholder] length] > 0 ) {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}
@end
