//
//  IMBiTunesSecureTextFieldCell.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-25.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBiTunesSecureTextFieldCell.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "StringHelper.h"
#define LINE 5
@implementation IMBiTunesSecureTextFieldCell
@synthesize isHasLogBtn = _isHasLogBtn;
@synthesize cursorColor = _cursorColor;
- (void)awakeFromNib {
    [self setDrawsBackground:NO];
    _loadingLayer = [[CALayer alloc]init];
    _loadingLayer.contents = [StringHelper imageNamed:@"itunes_loading"];
    [_loadingLayer setHidden:YES];
    _cFlags.vCentered = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BtnDownSignin:) name:NOTIFY_ITUNES_SIGNINBTN_DOWN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterSignin:) name:NOTIFY_ITUNES_ENTER_SIGNIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signFail:) name:NOTIFY_ITUNES_SIGNIN_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPass:) name:NOTIFY_ITUNES_SIGNIN_SUCCESS object:nil];
}

-(void)dealloc{
    [super dealloc];
    if (_loadingLayer != nil) {
        [_loadingLayer release];
        _loadingLayer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ITUNES_ENTER_SIGNIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ITUNES_SIGNIN_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ITUNES_SIGNINBTN_DOWN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ITUNES_SIGNIN_SUCCESS object:nil];
}

- (id)copyWithZone:(NSZone *)zone {
    IMBiTunesSecureTextFieldCell *cell = (IMBiTunesSecureTextFieldCell *)[super copyWithZone:zone];
    cell->_cursorColor = [_cursorColor retain];
    return cell;
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
    NSRect rect = NSMakeRect(aRect.origin.x+6, aRect.origin.y, aRect.size.width -30, aRect.size.height);
	//aRect = [self titleRectForBounds:aRect];
	[super selectWithFrame:rect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
	//aRect = [self titleRectForBounds:aRect];
    NSRect rect = NSMakeRect(aRect.origin.x+6, aRect.origin.y, aRect.size.width -30, aRect.size.height);
	[super editWithFrame:rect inView:controlView editor:textObj delegate:anObject event:theEvent];
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
//    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.0f, 1.0f) xRadius:5 yRadius:5] addClip];
//    [[NSColor whiteColor] setFill];
//    NSRectFillUsingOperation(frame, NSCompositeSourceOver);
//    [NSGraphicsContext restoreGraphicsState];
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:5 yRadius:5];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [[NSColor clearColor] set];
    [clipPath fill];
    [clipPath setLineWidth:2];
    [clipPath addClip];
    [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] setStroke];
    [clipPath stroke];
    int oringeCenter = controlView.frame.size.width - 20;
    [_loadingLayer setFrame:NSMakeRect(oringeCenter, frame.origin.y + (frame.size.height - 14) / 2 ,14,14)];
    [controlView setWantsLayer:YES];
    [controlView.layer addSublayer:_loadingLayer];

    NSRect rect = NSMakeRect(6, frame.origin.y, frame.size.width - 6, frame.size.height);
    //    }
    [self drawInteriorWithFrame:rect inView:controlView];
    
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
-(void)BtnDownSignin:(NSNotification *)obj{
    dispatch_async(dispatch_get_main_queue(), ^{
        _isEnterBtn = YES;

        [_loadingLayer setHidden:NO];
        [_loadingLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [_loadingLayer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];

    });
}
-(void)enterSignin:(NSNotification *)obj {
    dispatch_async(dispatch_get_main_queue(), ^{
        _isEnterBtn = YES;

        [_loadingLayer setHidden:NO];
        [_loadingLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [_loadingLayer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];

    });
 }

-(void)signFail:(NSNotification *)obj{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_loadingLayer setHidden:YES];
        _isEnterBtn = NO;
    });
}

-(void)successPass:(NSNotification *)obj{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_loadingLayer setHidden:YES];
        _isEnterBtn = YES;
    });
}

@end
