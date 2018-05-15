//
//  IMBTransferTipShadowsView.m
//  AnyTransforCloud
//
//  Created by hym on 07/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBTransferTipShadowsView.h"
#import "IMBCurrencySvgButton.h"
#import "StringHelper.h"
@implementation IMBTransferTipShadowsView
@synthesize target = _target;
@synthesize action = _action;

- (void)awakeFromNib {
    _textFiled = [[NSTextField alloc] initWithFrame:NSMakeRect(8, ceil((self.frame.size.height - 20)/2.0), self.frame.size.width - 30, 20)];
    [_textFiled setDrawsBackground:NO];
    [_textFiled setAlignment:NSLeftTextAlignment];
    [_textFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:13]];
    [_textFiled setBordered:NO];
    _textFiled.editable = NO;
    [_textFiled setSelectable:NO];
    [self addSubview:_textFiled];
    [_textFiled release];
    
    _closeBtn = [[IMBCurrencySvgButton alloc] initWithFrame:NSMakeRect(self.bounds.size.width - 50, (self.frame.size.height - 40)/ 2.0, 40, 40)];
    [_closeBtn setSvgFileName:@"menu_close" withUseFillColor:NO withSVGSize:NSMakeSize(12, 12) withEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] withOutColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] withDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
    [_closeBtn setTarget:self];
    [_closeBtn setAction:@selector(closeTip)];
    [self addSubview:_closeBtn];
    [_closeBtn release];
}

- (void)setShowString:(nonnull NSString *)str{
    [_textFiled setStringValue:str];
}

- (void)closeTip {
    [self.target performSelector:self.action withObject:self];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    _shadow = [[NSShadow alloc] init];
    [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_deepColor", nil)]];
    [_shadow setShadowOffset:NSMakeSize(0.0, -0.2)];
    [_shadow setShadowBlurRadius:2.0];
    [_shadow set];
    NSRect newRect = NSMakeRect(dirtyRect.origin.x + 5, dirtyRect.origin.y + 5, self.frame.size.width-10, self.frame.size.height - 15);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:3 yRadius:3];
    [path moveToPoint: CGPointMake(dirtyRect.size.width - 16, dirtyRect.size.height - 11)];
    [path lineToPoint: CGPointMake(dirtyRect.size.width - 24, dirtyRect.size.height - 1)];
    [path lineToPoint: CGPointMake(dirtyRect.size.width - 32, dirtyRect.size.height - 11)];
    [path setLineWidth:1.f];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
    [path stroke];
    [path closePath];
    
    
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [path closePath];
}

- (void)dealloc {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    [super dealloc];
}
@end
