//
//  IMBSearchParamterChooseView.m
//  AnyTransforCloud
//
//  Created by hym on 26/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBSearchParamterChooseView.h"
#import "StringHelper.h"
#import "IMBCloudEntity.h"
#import "BaseDrive.h"
#import "TempHelper.h"
@implementation IMBSearchParamterChooseView

- (void)drawRect:(NSRect)dirtyRect {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    _shadow = [[NSShadow alloc] init];
    [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
    [_shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
    [_shadow setShadowBlurRadius:4.0];
    [_shadow set];
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+5, dirtyRect.origin.y+3, self.frame.size.width-10, self.frame.size.height -3);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [[StringHelper getColorFromString:CustomColor(@"search_borderColor", nil)] setStroke];
    path.lineWidth = 0.3;
    [path stroke];
    [path closePath];
}

- (void)setChooseCloudAry:(NSMutableArray *)ary; {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    
    for (int i = 0; i < ary.count; i ++) {
        BaseDrive *baseDrive = [ary objectAtIndex:i];
        
        IMBCloudEntity *cloudEntity = [[[IMBCloudEntity alloc] init] autorelease];
        [TempHelper setDriveDefultImage:baseDrive CloudEntity:cloudEntity];
        
        IMBSearchPullDownItem *item = [[IMBSearchPullDownItem alloc] initWithFrame:NSMakeRect(5, 5 + i * 30, self.frame.size.width - 10, 30)];
        [self addSubview:item];
        
        item.target = self.target;
        item.action = self.action;
        item.cloudEntity = cloudEntity;
        [item release], item = nil;
    }
    if (ary.count > 1) {
        IMBCloudEntity *cloudEntity = [[[IMBCloudEntity alloc] init] autorelease];
        cloudEntity.name = CustomLocalizedString(@"SearchControl_AllCloud", nil);
        cloudEntity.image = [NSImage imageNamed:@"search_all"];
        IMBSearchPullDownItem *item = [[IMBSearchPullDownItem alloc] initWithFrame:NSMakeRect(5, 5 + ary.count * 30, self.frame.size.width - 10, 30)];
        [self addSubview:item];
        
        item.target = self.target;
        item.action = self.action;
        item.cloudEntity = cloudEntity;
    }
    
}

- (void)setchooseStyleOrTimeAry:(NSArray *)ary {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    for (int i = 0; i < ary.count; i ++) {
        IMBParamterItem *paramterItem = [ary objectAtIndex:i];
        IMBSearchPullDownItem *item = [[IMBSearchPullDownItem alloc] initWithFrame:NSMakeRect(5, 5 + i * 30, self.frame.size.width - 10, 30)];
        [self addSubview:item];
        
        item.target = self.target;
        item.action = self.action;
        item.paramterItem = paramterItem;
        [item release], item = nil;
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}







@end


@implementation IMBSearchPullDownItem
@synthesize hasImage = _hasImage;
@synthesize cloudEntity = _cloudEntity;


- (void)setParamterItem:(IMBParamterItem *)paramterItem {
    if (_paramterItem) {
        [_paramterItem release];
        _paramterItem = nil;
    }
    _paramterItem = [paramterItem retain];
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_buttonType == MouseEnter || _buttonType == MouseUp) {
        [[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] setFill];
    }else if (_buttonType == MouseDown) {
        [[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] setFill];
    }else {
         [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
    }
    [path fill];
    [path closePath];
    
    if (_paramterItem.title) {
        NSDictionary *dic = @{NSFontAttributeName:[NSFont fontWithName:@"Helvetica Neue" size:13],NSForegroundColorAttributeName:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]};
        [_paramterItem.title drawInRect:NSMakeRect(10, 5, self.frame.size.width - 10, 20)withAttributes:dic];
    }
    if (_cloudEntity) {
        [_cloudEntity.image drawInRect:NSMakeRect(0, 0, 30, 30)];
        NSDictionary *dic = @{NSFontAttributeName:[NSFont fontWithName:@"Helvetica Neue" size:13],NSForegroundColorAttributeName:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]};
        [_cloudEntity.name drawInRect:NSMakeRect(38, 5, self.frame.size.width - 30, 20)withAttributes:dic];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _buttonType = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _buttonType = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _buttonType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _buttonType = MouseUp;
    if (_paramterItem) {
       [NSApp sendAction:self.action to:self.target from:_paramterItem];
    }else if (_cloudEntity) {
        [NSApp sendAction:self.action to:self.target from:_cloudEntity];
    }else {
        [NSApp sendAction:self.action to:self.target from:self];
    }
    [self setNeedsDisplay:YES];
}


- (void)dealloc {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_paramterItem) {
        [_paramterItem release];
        _paramterItem = nil;
    }
    [super dealloc];
}

@end

@implementation IMBParamterItem
@synthesize fileType = _fileType;
@synthesize dateType = _dateType;

@end
