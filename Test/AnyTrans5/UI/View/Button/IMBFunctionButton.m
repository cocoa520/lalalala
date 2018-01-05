//
//  IMBFunctionButton.m
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBFunctionButton.h"
#import "IMBFunctionButtonCell.h"
#import "IMBBackgroundBorderView.h"
#import "StringHelper.h"
@implementation IMBFunctionButton
@synthesize mouseEnteredImage = _mouseEnteredImage;
@synthesize mouseExitImage = _mouseExitImage;
@synthesize isEntered = _isEntered;
@synthesize isCliked = _isCliked;
@synthesize isContainer = _isContainer;
@synthesize isWhite = _isWhite;
@synthesize badgeCount = _badgeCount;
@synthesize showbadgeCount = _showbadgeCount;
@synthesize buttonName = _buttonName;
@synthesize openiCloud = _openiCloud;
@synthesize containerOpened = _containerOpened;
@synthesize navagationIcon = _navagationIcon;
@synthesize selectIcon = _selectIcon;
@synthesize isAndroid = _isAndroid;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        IMBFunctionButtonCell *cell = [[IMBFunctionButtonCell alloc]init];
        //NSLog(@"%@",NSStringFromRect([cell frame]));
        [cell setLineBreakMode:NSLineBreakByTruncatingTail];
        [cell setWraps:NO];
        [cell setScrollable:NO];
        [cell setAlignment:NSCenterTextAlignment];
        [self setCell:cell];
        [cell release];
        cell = nil;
        [self setButtonType:NSMomentaryPushInButton];
//        [self setBezelStyle:NSTexturedSquareBezelStyle];
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSImageAbove];
        [self setBordered:NO];
        _isEntered = NO;
        _isCliked = NO;
        _badgeCount = 0;
        _isContainer = NO;
        _isWhite = NO;
        _showbadgeCount = YES;
//        _maskView = [[IMBBackgroundBorderView alloc] initWithFrame:NSMakeRect(9, 8, 62, 62)];
//        [_maskView setHasRadius:YES];
//        [_maskView setBackgroundColor:[NSColor blackColor]];
//        [_maskView setXRadius:14.0 YRadius:14.0];
//        _maskView.alphaValue = 0.2;
        _buttonState = 1;
    }
    return self;
}

- (void)dealloc
{
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    [_navagationIcon release],_navagationIcon = nil;
    [_selectIcon release],_selectIcon = nil;
    [_mouseEnteredImage release],_mouseEnteredImage = nil;
    [_mouseExitImage release],_mouseExitImage = nil;
    [loadingView release],loadingView = nil;
    [_iconiCloudImageView release],_iconiCloudImageView = nil;
    [super dealloc];
}

- (void)setContainerOpened:(BOOL)containerOpened
{
    if (_containerOpened != containerOpened) {
        _containerOpened = containerOpened;
        if (_containerOpened) {
            [self setAlphaValue:0.5];
        }else{
            [self setAlphaValue:1.0];
        }
    }
}

- (void)addLoadingView {
    if (loadingView != nil) {
        [loadingView release];
        loadingView = nil;
    }
    loadingView = [[IMBButtonLoadingView alloc] initWithFrame:NSMakeRect(9, 8, 62, 62) WithAndroid:NO];
    [self addSubview:loadingView];
    [self setEnabled:NO];
}

- (void)addAndroidLoadingView{
    if (loadingView != nil) {
        [loadingView release];
        loadingView = nil;
    }
    loadingView = [[IMBButtonLoadingView alloc] initWithFrame:NSMakeRect(9, 8, 62, 62) WithAndroid:YES];
    [self addSubview:loadingView];
    [self setEnabled:NO];
}

- (void)showloading:(BOOL)loading
{
    if (loading) {
//        [loadingView startAnimation];
    }else
    {
//        double delayInSeconds = 2;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [loadingView startTwoAnimation];
//            [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.5];
//        });
        [self removeLoadingView];
    }

}

- (void)removeLoadingView {
    [loadingView stopAnimation];
    if ([loadingView superview]) {
        [loadingView removeFromSuperview];
        [loadingView release];
        loadingView = nil;
    }
    [self setEnabled:YES];
}

- (void)setOpeniCloud:(BOOL)openiCloud
{
    if (_openiCloud != openiCloud) {
        _openiCloud = openiCloud;
        if (_iconiCloudImageView == nil&&openiCloud) {
            _iconiCloudImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(80-20-5, 3, 20, 20)];
            [_iconiCloudImageView setImage:[StringHelper imageNamed:@"icon_icloud"]];
            [self addSubview:_iconiCloudImageView];
            
        }else if(openiCloud)
        {
            if (![_iconiCloudImageView superview]) {
                 [self addSubview:_iconiCloudImageView];
            }
            
        }else
        {
            if ([_iconiCloudImageView superview]) {
                [_iconiCloudImageView removeFromSuperview];
            }
        }
    }
}

- (void)setIsWhite:(BOOL)isWhite
{
    if (_isWhite != isWhite) {
        _isWhite = isWhite;
        [self setAttributedTitle:[self attributedTitle:NO]];
    }
}

- (void)setShowbadgeCount:(BOOL)showbadgeCount
{
    if (_showbadgeCount != showbadgeCount) {
        _showbadgeCount = showbadgeCount;
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
//    [[NSColor whiteColor] setFill];
//    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    NSBezierPath *path = nil;
    if (_buttonState == 2) {
        //        _maskView = [[IMBBackgroundBorderView alloc] initWithFrame:NSMakeRect(9, 8, 62, 62)];
        //        [_maskView setHasRadius:YES];
        //        [_maskView setBackgroundColor:[NSColor blackColor]];
        //        [_maskView setXRadius:14.0 YRadius:14.0];
        //        _maskView.alphaValue = 0.2;
        if (_isAndroid) {
            path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(9, 8, 62, 62) xRadius:5 yRadius:5];
        }else{
            path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(9, 8, 62, 62) xRadius:14 yRadius:14];
        }
       
        [[StringHelper getColorFromString:CustomColor(@"functionBtn_enter_bgColor", nil)] setFill];
        [path fill];
        [path closePath];
    }else if (_buttonState == 3) {
        if (_isAndroid) {
            path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(9, 8, 62, 62) xRadius:5 yRadius:5];
        }else{
            path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(9, 8, 62, 62) xRadius:14 yRadius:14];
        }
        
        [[StringHelper getColorFromString:CustomColor(@"functionBtn_down_bgColor", nil)] setFill];
        [path fill];
        [path closePath];
    }
   
    if (!_isContainer&&_badgeCount>0&&_showbadgeCount) {
        NSString *badgecountStr = nil;
        if (_badgeCount>=999) {
            badgecountStr = [NSString stringWithFormat:@"%ld+",(long)999];
        }else
        {
        
            badgecountStr = [NSString stringWithFormat:@"%ld",(long)_badgeCount];
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:badgecountStr?badgecountStr:@""];
        if (_badgeCount>=999) {
             [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:10] range:NSMakeRange(0, str.length)];
        }else
        {
             [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12] range:NSMakeRange(0, str.length)];
        }
       
        [str addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] range:NSMakeRange(0, str.length)];
        NSRect rect;
        NSRect textrect;
        if (str.length == 1) {
            rect = NSMakeRect(58, 2, 20, 20);
            textrect = NSMakeRect(58+(20-str.size.width)/2, 1+(20-str.size.height)/2, str.size.width, str.size.height);
        }else {
            rect = NSMakeRect(48, 2, 30, 20);
            textrect = NSMakeRect(48+(30-str.size.width)/2, 1+(20-str.size.height)/2, str.size.width, str.size.height);
        }
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:10 yRadius:10];
        [[StringHelper getColorFromString:CustomColor(@"functionBtn_badgeCount_bgColor", nil)] setFill];
        [path fill];
        [path setLineWidth:2];
        [[StringHelper getColorFromString:CustomColor(@"functionBtn_badgeCount_borderColor", nil)] setStroke];
        [path stroke];
        [str drawInRect:textrect];
    }
    
    if (_isEntered && !_isCliked) {
//        NSRect rect = dirtyRect;
//        rect.origin.y = dirtyRect.origin.y + 1;
//        rect.size.height = dirtyRect.size.height-2;
//        
//        [[NSColor colorWithDeviceRed:146/255.0 green:216/255.0 blue:250/255.0 alpha:1.0] setStroke];
//        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
//        [path setLineWidth:1.0];
//        [path addClip];
//        [path stroke];

    }else if (_isEntered && _isCliked)
    {
//        NSRect rect = dirtyRect;
//        rect.origin.y = dirtyRect.origin.y + 1;
//        rect.size.height = dirtyRect.size.height-2;
//        
//        [[NSColor colorWithDeviceRed:55/255.0 green:181/255.0 blue:228/255.0 alpha:1.0] setStroke];
//        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
//        [path setLineWidth:1.0];
//        [path addClip];
//        [path stroke];
        _isCliked = NO;
    }
}

-(void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (trackingArea == nil) {
//        [self removeTrackingArea:trackingArea];
//        [trackingArea release];
//        trackingArea = nil;
         NSTrackingAreaOptions options =   ( NSTrackingActiveAlways  | NSTrackingCursorUpdate|NSTrackingMouseEnteredAndExited);
         trackingArea = [[NSTrackingArea alloc]initWithRect:self.bounds options:options owner:self userInfo:nil];
        [self addTrackingArea:trackingArea];
        [trackingArea release];
    }
}

- (void)setBadgeCount:(NSInteger)badgeCount
{
    if (_badgeCount != badgeCount) {
        _badgeCount = badgeCount;
        [self setNeedsDisplay:YES];
    }
}

-(BOOL)isEntered{
    return _isEntered;
}

-(void)setIsEntered:(BOOL)isEntered{
    if (_isEntered != isEntered) {
        _isEntered = isEntered;
        [self setNeedsDisplay:YES];
    }
}

-(BOOL)isCliked {
    return _isCliked;
}

-(void)setIsCliked:(BOOL)isCliked {
    _isCliked = isCliked;
    [self setNeedsDisplay:YES];
}

-(void)setImageWithImageName:(NSString *)imageName withButtonName:(NSString *)buttonName{
    _mouseExitImage = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@1",imageName]] retain];
    _mouseEnteredImage = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@1",imageName]] retain];
    _buttonName = [buttonName retain];
    [self setImage:_mouseExitImage];
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setButtonType:NSMomentaryPushInButton];
    [self setAttributedTitle:[self attributedTitle:NO]];
    [self highlight:NO];
    [[self cell] setHighlightsBy:NSContentsCellMask];
    [self setBordered:NO];
    [[self cell] setBordered:NO];
    [[self cell] setHighlighted:NO];
}

- (void)changeBtnName{
    [self setAttributedTitle:[self attributedTitle:NO]];
    [self setNeedsDisplay:YES];
}


-(void)mouseDown:(NSEvent *)theEvent{
//    _maskView.alphaValue = 0.3;
    [self setImage:_mouseEnteredImage];
    [self setIsEntered:YES];
//    [self setAttributedTitle:[self attributedTitle:YES]];
    _evNum = theEvent.eventNumber;
    [self setIsCliked:YES];
    _buttonState = 3;
    [self setNeedsDisplay:YES];
}

-(void)mouseEntered:(NSEvent *)theEvent{
    [self setImage:_mouseExitImage];
    [self setIsEntered:YES];
    [self setAlphaValue:1.0];
    _buttonState = 2;
    [self setNeedsDisplay:YES];
}

-(void)mouseExited:(NSEvent *)theEvent{
    [self setImage:_mouseExitImage];
    [self setIsEntered:NO];
    [self setAttributedTitle:[self attributedTitle:NO]];
    if (_containerOpened) {
        [self setAlphaValue:0.5];
    }
    _buttonState = 1;
    [self setNeedsDisplay:YES];
}


-(void)mouseUp:(NSEvent *)theEvent{
    [self setImage:_mouseExitImage];
    [self setAttributedTitle:[self attributedTitle:NO]];
    int64_t delayInSeconds = 0.00001;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setImage:_mouseExitImage];
        [self setIsEntered:NO];
        [self setAttributedTitle:[self attributedTitle:NO]];
    });
    int num = (int)[theEvent clickCount];
    if (num == 1 && _evNum == theEvent.eventNumber) {
        if (!_isCliked && self.isEnabled) {
            [NSApp sendAction:self.action to:self.target from:self];
            [self setIsCliked:NO];
        }
    }
    if (!_isContainer) {
//        [_maskView removeFromSuperview];
    }
    _buttonState = 4;
    [self setNeedsDisplay:YES];
}



-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered{
    if (_buttonName) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:_buttonName?_buttonName:@""]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
        if (isEntered) {
            [attributedTitles addAttributes:[self attributed:[NSColor colorWithCalibratedRed:77.0/255 green:131.0/255 blue:213.0/255 alpha:1.0]] range:NSMakeRange(0, _buttonName.length)];
//            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:77.0/255 green:131.0/255 blue:213.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
        }else if(!_isWhite){
             [attributedTitles addAttributes:[self attributed:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]] range:NSMakeRange(0, _buttonName.length)];
//            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
        }else
        {
             [attributedTitles addAttributes:[self attributed:[NSColor whiteColor]] range:NSMakeRange(0, _buttonName.length)];
//             [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, _buttonName.length)];
        }
//        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, _buttonName.length)];
        return attributedTitles;
    }
    return nil;
}

- (NSDictionary *)attributed:(NSColor *)textColor{
    
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [textParagraph setAlignment:NSCenterTextAlignment];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName,textColor,NSForegroundColorAttributeName,nil];
    return fontDic;
}


- (void)setTitle:(NSString *)aString
{
//    [super setTitle:aString];
    [self setToolTip:aString];
}

- (NSArray *)exposedBindings
{
    return [NSArray arrayWithObjects:@"badgeCount",@"navagationIcon", nil];
}


@end
