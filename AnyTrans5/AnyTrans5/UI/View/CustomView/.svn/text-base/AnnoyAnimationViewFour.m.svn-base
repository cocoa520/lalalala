//
//  AnnoyAnimationViewFour.m
//  AnyTrans
//
//  Created by LuoLei on 16-10-25.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "AnnoyAnimationViewFour.h"
#import "StringHelper.h"
@implementation AnnoyAnimationViewFour




- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    _bglayer = [[CALayer layer] retain];
    [_bglayer setAnchorPoint:CGPointMake(0, 0)];
    [_bglayer setMasksToBounds:YES];
    [_bglayer setFrame:NSRectToCGRect(self.bounds)];
    _bglayer.contents = [StringHelper imageNamed:@"annoy_bg_rose"];
    _countTextLayer = [[CATextLayer layer] retain];
    [_countTextLayer setAnchorPoint:CGPointMake(0, 0)];
    [_countTextLayer setFrame:CGRectMake(421, 165, 64, 42)];
    _countTextLayer.alignmentMode = kCAAlignmentCenter;
    _countTextLayer.truncationMode = kCATruncationMiddle;
    _countTextLayer.contentsScale = 1.0;
    _dayTextLayer = [[CATextLayer layer] retain];
    [_dayTextLayer setAnchorPoint:CGPointMake(0, 0)];
    [_dayTextLayer setFrame:CGRectMake(690, 191, 64, 42)];
    _dayTextLayer.alignmentMode = kCAAlignmentCenter;
    _dayTextLayer.truncationMode = kCATruncationMiddle;
    _dayTextLayer.contentsScale = 1.0;
    [_bglayer addSublayer:_countTextLayer];
    [_bglayer addSublayer:_dayTextLayer];
    [self.layer addSublayer:_bglayer];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setBackgroundImage:(NSImage *)backgroundImage
{
    _bglayer.contents = backgroundImage;
}

- (void)setRemainderCount:(int)remainderCount Unit:(NSString *)unit
{
    NSString *str = [NSString stringWithFormat:@"%d\n%@",remainderCount,unit];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str?:@""];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%d",remainderCount]];
    NSRange range1 =  [str rangeOfString:unit];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[NSColor blackColor]
                  range:range1];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue" size:14]
                  range:range1];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[NSColor redColor]
                  range:range];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue" size:22]
                  range:range];
    [_countTextLayer setString:title];
    [title release];
    
}
- (void)setRemainderDays:(int)remainderDays Unit:(NSString *)unit
{
    NSString *str = [NSString stringWithFormat:@"%d\n%@",remainderDays,unit];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str?:@""];
    NSRange range2 = [str rangeOfString:[NSString stringWithFormat:@"%d",remainderDays]];
    NSRange range3 =  [str rangeOfString:unit];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[NSColor blackColor]
                  range:range3];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue" size:14]
                  range:range3];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[NSColor redColor]
                  range:range2];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue" size:22]
                  range:range2];
    [_dayTextLayer setString:title];
    [title release];
}



- (void)startAnimation
{

}

- (void)stopAnimation
{

}

- (void)dealloc
{
    [_bglayer release],_bglayer = nil;
    [_countTextLayer release],_countTextLayer = nil;
    [_dayTextLayer release],_dayTextLayer = nil;
    [super dealloc];

}

@end
