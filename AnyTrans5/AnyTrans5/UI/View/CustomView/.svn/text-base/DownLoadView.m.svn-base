//
//  DownLoadView.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-22.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "DownLoadView.h"
#import "StringHelper.h"
#import "CALayer+Animation.h"
#import "HoverButton.h"
#import "IMBNotificationDefine.h"
@implementation DownLoadView
@synthesize badgeCount = _badgeCount;
@synthesize isiCloudDownLoadView = _isiCloudDownLoadView;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _badgeCount = 0;
        [self setWantsLayer:YES];
        [self.layer setAnchorPoint:CGPointMake(0, 0)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
        
    }
    return self;
}

- (NSInteger)setBadgeCountDecrease
{
    _badgeCount--;
    if (_badgeCount<0) {
        _badgeCount = 0;
    }
    return _badgeCount;
}


- (void)setBadgeCount:(NSInteger)badgeCount
{
    _badgeCount = badgeCount;
    [self setNeedsDisplay:YES];
    HoverButton *downloadButton = [self viewWithTag:100];
    if (!_isiCloudDownLoadView) {
        if (_animationLayer == nil) {
            _animationLayer = [[CALayer layer] retain];
            NSRect rect = NSMakeRect(downloadButton.frame.origin.x+1, downloadButton.frame.origin.y+1, downloadButton.frame.size.width-2, downloadButton.frame.size.height-2);
            [_animationLayer setFrame:NSRectToCGRect(rect)];
            _animationLayer.contents = [StringHelper imageNamed:@"download_progresslight"];
        }
        if (_badgeCount == 0) {
            //停止动画
            [downloadButton setMouseEnteredImage:[StringHelper imageNamed:@"download_progress2"] mouseExitImage:[StringHelper imageNamed:@"download_progress1"] mouseDownImage:[StringHelper imageNamed:@"download_progress2"]];
            [_animationLayer removeAllAnimations];
            [_animationLayer removeFromSuperlayer];
        }else{
            //开始动画
            if ([_animationLayer.animationKeys count] == 0) {
                [downloadButton setMouseEnteredImage:[StringHelper imageNamed:@"download_progress3"] mouseExitImage:[StringHelper imageNamed:@"download_progress3"] mouseDownImage:[StringHelper imageNamed:@"download_progress3"]];
                [self.layer addSublayer:_animationLayer];
                float circleTime = 2.0;
                [_animationLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
                    animation.repeatCount = NSIntegerMax;
                    animation.duration = circleTime;
                }];
            }
        }

    }
    [self addSubview:_badgeCountView];
    [_badgeCountView setBadgeCount:badgeCount];

}

- (void)addOBServer
{
    if (_badgeCountView == nil) {
        _badgeCountView = [[BadgeCountView alloc] initWithFrame:NSMakeRect(0, 0, 6, 6)];
        _badgeCountView.isiCloudDownLoadView = _isiCloudDownLoadView;
    }
    [self addSubview:_badgeCountView];
    [_badgeCountView setBadgeCount:0];
    HoverButton *downloadButton = [self viewWithTag:100];
    [downloadButton addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        int status = [[change objectForKey:@"new"] intValue];
        if (status == 3) {
            _state = 3;
            [self setNeedsDisplay:YES];
        }else if (status == 1){
            _state = 1;
            [self setNeedsDisplay:YES];
        }
    }
}

- (void)setEnable:(BOOL)enable
{
    HoverButton *downloadButton = [self viewWithTag:100];
    [downloadButton setEnabled:enable];
}

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate|NSTrackingAssumeInside);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
    }
}

#pragma mark - Mouse Actions
- (void)mouseEntered:(NSEvent *)theEvent
{
    _state = 2;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    _state = 1;
    [super mouseExited:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    _state = 3;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    _state = 2;
    [self setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)dirtyRect
{
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    if (_state == 2) {
        [[StringHelper getColorFromString:CustomColor(@"download_detail_enterbg", nil)] setFill];
    }else if (_state == 3) {
        [[StringHelper getColorFromString:CustomColor(@"download_detail_downbg", nil)] setFill];
    }else{
        [[NSColor clearColor] setFill];
    }
    [path fill];
}

- (void)changeSkin:(NSNotification *)noti {
    [self setNeedsDisplay:YES];
    [_badgeCountView setNeedsDisplay:YES];
    HoverButton *downloadButton = [self viewWithTag:100];
    if (_isiCloudDownLoadView) {
        [downloadButton setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_continuedownload2"] mouseExitImage:[StringHelper imageNamed:@"iCloud_continuedownload1"] mouseDownImage:[StringHelper imageNamed:@"iCloud_continuedownload2"]];
    }else{
        if (_badgeCount == 0) {
            [downloadButton setMouseEnteredImage:[StringHelper imageNamed:@"download_progress2"] mouseExitImage:[StringHelper imageNamed:@"download_progress1"] mouseDownImage:[StringHelper imageNamed:@"download_progress2"]];
            
        }else if (_badgeCount>=1){
            [downloadButton setMouseEnteredImage:[StringHelper imageNamed:@"download_progress3"] mouseExitImage:[StringHelper imageNamed:@"download_progress3"] mouseDownImage:[StringHelper imageNamed:@"download_progress3"]];
        }
        _animationLayer.contents = [StringHelper imageNamed:@"download_progresslight"];
    }
    
}

- (void)dealloc
{
    HoverButton *downloadButton = [self viewWithTag:100];
    [downloadButton removeObserver:self forKeyPath:@"status"];
    [_trackingArea release];_trackingArea = nil;
    [_animationLayer  release],_animationLayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}
@end

@implementation BadgeCountView
@synthesize badgeCount =  _badgeCount;
@synthesize isiCloudDownLoadView = _isiCloudDownLoadView;
- (void)setBadgeCount:(NSInteger)badgeCount
{
    _badgeCount = badgeCount;
    NSString *badgecountStr = nil;
    if (_badgeCount>9) {
        badgecountStr = [NSString stringWithFormat:@"%ld+",(long)9];
    }else
    {
        badgecountStr = [NSString stringWithFormat:@"%ld",(long)_badgeCount];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:badgecountStr?badgecountStr:@""];
    [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:10] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] range:NSMakeRange(0, str.length)];
    NSRect rect;
    if (_badgeCount != 0) {
        if (str.length == 1) {
            if (_isiCloudDownLoadView) {
                rect = NSMakeRect(23, 15, 14, 14);

            }else{
                rect = NSMakeRect(21, 13, 14, 14);

            }
        }else {
            if (_isiCloudDownLoadView) {
                rect = NSMakeRect(21, 15, 18, 16);

            }else{
                rect = NSMakeRect(19, 13, 18, 16);
            }
        }
    }else{
        rect = NSMakeRect(24, 17, 6, 6);
    }
    [self setFrame:rect];
    [str release];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSString *badgecountStr = nil;
    if (_badgeCount>9) {
        badgecountStr = [NSString stringWithFormat:@"%ld+",(long)9];
    }else
    {
        badgecountStr = [NSString stringWithFormat:@"%ld",(long)_badgeCount];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:badgecountStr?badgecountStr:@""];
    [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:10] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] range:NSMakeRange(0, str.length)];
    NSRect textrect;
    textrect = NSMakeRect((NSWidth(dirtyRect)-str.size.width)/2, (NSHeight(dirtyRect)-str.size.height)/2, str.size.width, str.size.height);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:8 yRadius:8];
    if (_badgeCount >=1) {
        [[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] setFill];
        [path fill];
//        [path setLineWidth:2];
//        [[StringHelper getColorFromString:CustomColor(@"functionBtn_badgeCount_borderColor", nil)] setStroke];
//        [path stroke];
        [str drawInRect:textrect];
    }else{
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
        [[NSColor clearColor] setFill];
        [path fill];
        NSBezierPath *path1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        [[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] setFill];
        [path1 fill];
    }
    [str release];
}

@end
