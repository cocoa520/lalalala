//
//  IMBCustomPopupButton.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCustomPopupButton.h"
#import "StringHelper.h"
#import "IMBWhiteView.h"
#import "IMBNotificationDefine.h"
@implementation IMBCustomPopupButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [self.cell setImagePosition:NSImageOnly];
    [self.cell setArrowPosition:NSPopUpNoArrow];
    [self.cell setLineBreakMode:NSLineBreakByTruncatingTail];
//    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
//        _arrBgView = [[[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 4, 16, 16)] autorelease];
//        _arrImageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(1, 0, 16, 16)] autorelease];
//    }else {
        _arrBgView = [[[IMBWhiteView alloc] initWithFrame:NSMakeRect(self.frame.size.width-12, 4, 16, 16)] autorelease];
        _arrImageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)] autorelease];
//    }
    [_arrBgView setBackgroundColor:[NSColor clearColor]];
    [_arrImageView setImage:[StringHelper imageNamed:@"download_textarrow"]];
    [_arrBgView addSubview:_arrImageView];
    [_arrBgView setAutoresizingMask:NSViewMaxXMargin];
    [self addSubview:_arrBgView];
}

- (void)setTitle:(NSString *)aString
{
    [super setTitle:aString];
    
}

- (void)resizeSize:(NSString *)aString
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(aString?aString:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)], NSForegroundColorAttributeName, nil]];
    if (_title != aString) {
        [_title release];
        _title = nil;
        _title = [aString retain];
    }
    
    int width = 0;
    width = title.size.width + 10*3;
    if (width>100) {
        width = 100;
    }
    [self setFrameSize:NSMakeSize(width, 22)];
    [title release];
    [self setNeedsDisplay:YES];
    [_arrBgView setFrameOrigin:NSMakePoint(self.frame.size.width-12, 4)];

}

- (void)selectItem:(NSMenuItem *)item
{
    [super selectItem:item];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if(_title != nil) {
        NSSize size = NSMakeSize(self.frame.size.width, self.frame.size.height);
        NSMutableAttributedString *retStr = [StringHelper TruncatingTailForStringDrawing:_title withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:self.frame.size.width - 20 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withAlignment:NSLeftTextAlignment];
        
        NSRect rect;
        int width = size.width;
        if (width > 100) {
            width = 100;
        }
        
        rect = NSMakeRect(ceilf((NSWidth(self.frame) - width - 8)/2.0 + 17)-10, ceilf((NSHeight(self.frame) - retStr.size.height)/2.0) - 2, width+4, retStr.size.height);
     
        [retStr drawInRect:rect];
    }
}

- (void)changeSkin:(NSNotification *)noti {
    [_arrImageView setImage:[StringHelper imageNamed:@"download_textarrow"]];
}

- (void)dealloc {
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

@end
