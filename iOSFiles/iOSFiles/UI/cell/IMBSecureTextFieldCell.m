//
//  IMBSecureTextFieldCell.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-19.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBSecureTextFieldCell.h"
//#import "IMBCommonDefine.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
//#import "IMBColorDefine.h"
#import "StringHelper.h"
#define LINE 5
@implementation IMBSecureTextFieldCell
//@synthesize logBtn = _logBtn;
@synthesize isHasLogBtn = _isHasLogBtn;
@synthesize delegate = _delegate;
@synthesize cursorColor = _cursorColor;
- (id)copyWithZone:(NSZone *)zone {
    IMBSecureTextFieldCell *cell = (IMBSecureTextFieldCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_cursorColor = [_cursorColor retain];
    return cell;
}

- (void)awakeFromNib {
    [self setDrawsBackground:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
//    _logBtn = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(0, 0, 24, 24)];
//    [_logBtn mouseDownImage:[StringHelper imageNamed:@"iCloud_log_in3"] withMouseUpImg:[StringHelper imageNamed:@"iCloud_log_in1"] withMouseExitedImg:[StringHelper imageNamed:@"iCloud_log_in1"] mouseEnterImg:[StringHelper imageNamed:@"iCloud_log_in2"]];
//    [_logBtn setLongTimeImage:[StringHelper imageNamed:@"iCloud_log_in4"]];
//    [_logBtn setLongTimeDown:YES];
//    [_logBtn setEnabled:NO];
//    [_logBtn setTarget:self];
//    [_logBtn setAction:@selector(downLog:)];
//    [_logBtn setBordered:NO];
//    _loadLayer = [CALayer layer];
//    _loadLayer.contents = [NSImage imageNamed:@"log_loading"];
//    _loadingImg = [[NSImageView alloc]init];
//    [_loadingImg setImage:[StringHelper imageNamed:@"log_loading"]];
//    [_loadingImg setImageFrameStyle:NSImageFrameNone];
//    [_loadLayer setHidden:YES];
    //   [self.controlView setFrame: NSMakeRect(6, 0, self.controlView.frame.size.width -6, self.controlView.frame.size.height)];
    // dirty and you aren't supposed to do this
    [self setEditable:YES];
    // using this until we find a better solution
    _cFlags.vCentered = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterSignin:) name:NOTIFY_ICLOUD_ENTER_SIGNIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signFail:) name:NOTIFY_ICLOUD_SIGNIN_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePass:) name:NOTIFY_ICLOUD_SIGNIN_IDAndPass object:nil];
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj
{
    if (_cursorColor) {
        NSText *text = [super setUpFieldEditorAttributes:textObj];
        [(NSTextView*)text setInsertionPointColor:_cursorColor];
        return text;
    }else{
        return [super setUpFieldEditorAttributes:textObj];
    }
    
}

- (void)changeSkin:(NSNotification *)notification {
//    [_logBtn mouseDownImage:[StringHelper imageNamed:@"iCloud_log_in3"] withMouseUpImg:[StringHelper imageNamed:@"iCloud_log_in1"] withMouseExitedImg:[StringHelper imageNamed:@"iCloud_log_in1"] mouseEnterImg:[StringHelper imageNamed:@"iCloud_log_in2"]];
//    [_logBtn setLongTimeImage:[StringHelper imageNamed:@"iCloud_log_in4"]];
//    [_logBtn setNeedsDisplay:YES];
}


-(void)dealloc{
    [super dealloc];
    [_cursorColor release], _cursorColor = nil;
//    if (_logBtn != nil) {
//        [_logBtn release];
//        _logBtn = nil;
//    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_ICLOUD_SIGNIN_IDAndPass object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ICLOUD_ENTER_SIGNIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ICLOUD_SIGNIN_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
}

- (id) init {
    self = [super init];
    if (self) {
        [self setDrawsBackground:NO];
    }
    return self;
}

#pragma mark - Editing Methods
//- (NSRect)titleRectForBounds:(NSRect)theRect {
//    NSRect titleFrame = [super titleRectForBounds:theRect];
//    NSSize titleSize = [[self attributedStringValue] size];
//    titleFrame.origin.y = theRect.origin.y + (theRect.size.height - titleSize.height) / 2.0;
//    return titleFrame;
//}
//
//- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//    NSRect titleRect = [self titleRectForBounds:cellFrame];
//    [[self attributedStringValue] drawInRect:titleRect];
//}
//- (NSRect)titleRectForBounds:(NSRect)theRect {
//    NSRect titleFrame = [super titleRectForBounds:theRect];
//    NSSize titleSize = [[self attributedStringValue] size];
//
//    // modified:
//    theRect.origin.y += (theRect.size.height - titleSize.height)/2.0 - 2;
//    return theRect;
//}


- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
    NSRect rect = NSMakeRect(aRect.origin.x+12, aRect.origin.y, aRect.size.width -48, aRect.size.height);
	//aRect = [self titleRectForBounds:aRect];
	[super selectWithFrame:rect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
	//aRect = [self titleRectForBounds:aRect];
    NSRect rect = NSMakeRect(aRect.origin.x+12, aRect.origin.y, aRect.size.width -48, aRect.size.height);
	[super editWithFrame:rect inView:controlView editor:textObj delegate:anObject event:theEvent];
}

#pragma mark - Drawing Methods

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)controlView {
    //    CGFloat borderRadius = 4.0f;
    //
    //    [NSGraphicsContext saveGraphicsState];
    //    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:borderRadius yRadius:borderRadius];
    //
    //    [[NSColor grayColor] setFill];
    //    [path fill];
    //
    //    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.0f, 1.0f) xRadius:borderRadius - 1 yRadius:borderRadius - 1] addClip];
    //    [[NSColor whiteColor] setFill];
    //    NSRectFillUsingOperation(frame, NSCompositeSourceOver);
    //    [NSGraphicsContext restoreGraphicsState];
    
    //暂时注释
//    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:frame];
//    [clipPath setWindingRule:NSEvenOddWindingRule];
//    [clipPath addClip];
//    [[NSColor colorWithDeviceRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1] set];
//    [clipPath fill];
//    NSBezierPath *path = [NSBezierPath bezierPath];
//    [path moveToPoint:NSMakePoint(NSMinX(frame), NSMinY(frame))];
//    [path lineToPoint:NSMakePoint(NSMaxX(frame), NSMinY(frame))];
//    [path lineToPoint:NSMakePoint(NSMaxX(frame), NSMaxY(frame) - LINE)];
//    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(frame) - LINE , NSMaxY(frame) - LINE) radius:LINE startAngle:0 endAngle:90];
//    [path lineToPoint:NSMakePoint(NSMinX(frame) + LINE, NSMaxY(frame))];
//    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(frame) + LINE, NSMaxY(frame)-LINE) radius:LINE startAngle:90 endAngle:180];
//    [path lineToPoint:NSMakePoint(NSMinX(frame), NSMinY(frame))];
//    //    [path lineToPoint:NSMakePoint(NSMinX(dirtyRect), NSMinY(dirtyRect)+LINE)];
//    //    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(dirtyRect) + LINE, NSMinY(dirtyRect) ) radius:LINE startAngle:0 endAngle:90];
//    [path setLineWidth:2];
//    [path addClip];
//    [[NSColor colorWithDeviceRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1] setStroke];
//    [path stroke];
    
    NSRect rect = NSMakeRect(12, frame.origin.y, frame.size.width - 50, frame.size.height);
//        }
    [super drawInteriorWithFrame:rect inView:controlView];

}

// changes focus ring radius to match that of the text cell
- (void)drawFocusRingMaskWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [NSGraphicsContext saveGraphicsState];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:4.0f yRadius:4.0f];
    [path addClip];
    [path fill];
    [NSGraphicsContext restoreGraphicsState];
    [super drawFocusRingMaskWithFrame:cellFrame inView:controlView];
}
-(void)downLog:(id)sender{
    _isEnterBtn = YES;
//    [self.logBtn setHidden:YES];
//    [_loadLayer setHidden:NO];
 
//    [_loadingImg.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
//    [_loadingImg.layer setPosition:CGPointMake(self.logBtn.frame.origin.x + 12, self.logBtn.frame.origin.y + 12)];
//    [_loadLayer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_SIGNIN object:nil userInfo:nil];
    //    [self ]
}
-(void)enterSignin:(NSNotification *)obj{
    _isEnterBtn = YES;
//    [self.logBtn setHidden:YES];
//    [_loadLayer setHidden:NO];
//    [_loadingImg setWantsLayer:YES];
//    [_loadingImg.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    //    CGRect rect = CGRectMake(self.logBtn.frame.origin.x + self.logBtn.frame.size.width/2, self.logBtn.frame.origin.y + self.logBtn.frame.size.height/2, self.logBtn.frame.size.width, self.logBtn.frame.size.height);
    //    NSRect rect = NSMakeRect(self.logBtn.frame.origin.x + self.logBtn.frame.size.width/2, self.logBtn.frame.origin.y + self.logBtn.frame.size.height/2, self.logBtn.frame.size.width, self.logBtn.frame.size.height);
    //    [_loadingImg.layer setContentsCenter:rect];
//    [_loadingImg.layer setPosition:CGPointMake(self.logBtn.frame.origin.x + 12, self.logBtn.frame.origin.y + 12)];
//    [_loadLayer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
}

-(void)changePass:(id)sender{
//    if ([StringHelper stringIsNilOrEmpty:self.stringValue ]) {
//        [_logBtn setEnabled:NO];
//        [_logBtn setLongTimeDown:YES];
//    }else{
//        [_logBtn setEnabled:YES];
//        [_logBtn setLongTimeDown:NO];
//    }
}


-(void)signFail:(NSNotification *)obj{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [_loadLayer setHidden:YES];
//        [_loadLayer removeAllAnimations];
//        [self.logBtn setHidden:NO];
        _isEnterBtn = NO;
    });
}

@end
