//
//  IMBNoteContentView.m
//  iMobieTrans
//
//  Created by iMobie on 5/27/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBNoteContentView.h"
#import "StringHelper.h"
@implementation IMBNoteContentView
@synthesize time = _time;
@synthesize content = _content;

- (id)init{
    if (self = [super init]) {
        [self resizeRect];
        
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        [self resizeRect];
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self drawText:self.time withFrame:_timeRect withFontSize:14.0 withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] width:dirtyRect.size.width - 30];
    [self drawText:self.content withFrame:_contentRect withFontSize:14.0 withColor:[NSColor blackColor] width:dirtyRect.size.width - 30];
    
}

- (void)awakeFromNib{
    [self resizeRect];
    [self setNeedsDisplay:YES];
    
}

- (void)resizeRect{
    if(_time == nil){
        _time = [[NSString alloc] initWithString:@""];
    }
    if (_content == nil) {
        _content = [[NSString alloc] initWithString:@""];
    }
    
    _timeRect = NSMakeRect(18.0, 15, self.frame.size.width - 30, 20);
    float height =[self heightForStringDrawing:self.content fontSize:14.0 myWidth:self.frame.size.width - 30];
    NSRect contentRect =NSMakeRect(0, 0, self.frame.size.width - 30, height);
    _contentRect = NSMakeRect(18.0, 55, self.frame.size.width - 30, contentRect.size.height);
    if (contentRect.size.height + 45>532) {
        [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, contentRect.size.height+70)];
    }else
    {
        [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, 532-5)];
    }
    
    [self setNeedsDisplay:YES];
}

- (BOOL)isFlipped{
    return YES;
}

- (void)dealloc{
    if (_time != nil) {
        [_time release];
        _time = nil;
    }
    
    if (_content != nil) {
        [_content release];
        _content = nil;
    }
    
    [super dealloc];
}

- (void)setContent:(NSString *)content{
    [_content release];
    _content =[content retain];
    [self resizeRect];
    [self setNeedsDisplay:YES];
}

- (void)setTime:(NSString *)time{
    [_time release];
    _time = [time retain];
    [self resizeRect];
    [self setNeedsDisplay:YES];
}




- (float)heightForStringDrawing:(NSString *)myString fontSize:(float)fontSize myWidth:(float) myWidth {
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:18.0f];
    [textParagraph setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:fontSize],NSFontAttributeName,nil];
    //    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    //    [textContainer setLineFragmentPadding:0.0];
    //    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    //    return [layoutManager
    //            usedRectForTextContainer:textContainer].size.height+20;
    //
    //    NSMutableParagraphStyle *ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //    NSColor *color = [NSColor colorWithDeviceRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
    //
    //    [ps setLineBreakMode:NSLineBreakByCharWrapping];
    //    ps.alignment = NSJustifiedTextAlignment;
    //    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    //    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    //    [paragraphStyle setAlignment:NSLeftTextAlignment];
    //    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    //    [paragraphStyle setLineSpacing:5];
    //
    //    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                sysFont, NSFontAttributeName,
    //                                color, NSForegroundColorAttributeName,
    //                                paragraphStyle, NSParagraphStyleAttributeName,
    //                                nil];
    NSRect rect = [myString boundingRectWithSize:NSMakeSize(myWidth, 30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
    return rect.size.height;
}



- (void)drawText:(NSString *)text withFrame:(NSRect)frame withFontSize:(float)withFontSize withColor:(NSColor *)color width:(float)width{
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:withFontSize];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        [paragraphStyle setLineSpacing:15.0f];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    sysFont, NSFontAttributeName,
                                    color, NSForegroundColorAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName,
                                    nil];
        CGFloat height = [self heightForStringDrawing:text fontSize:withFontSize myWidth:width];
        NSRect f = NSMakeRect(frame.origin.x , frame.origin.y, width, height);
        [as.string drawInRect:f withAttributes:attributes];
    }
    
}


@end
