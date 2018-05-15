//
//  IMBSecureTextFieldCell.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-19.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBSecureTextFieldCell.h"
#import "StringHelper.h"
#define LINE 5
@implementation IMBSecureTextFieldCell
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

    // dirty and you aren't supposed to do this
    [self setEditable:YES];
    // using this until we find a better solution
    _cFlags.vCentered = 1;
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


-(void)dealloc{
    [_cursorColor release], _cursorColor = nil;
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self) {
        [self setDrawsBackground:NO];
    }
    return self;
}

#pragma mark - Editing Methods
- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
    NSRect rect = NSMakeRect(aRect.origin.x -2 , aRect.origin.y +4, aRect.size.width - 4, aRect.size.height);
	//aRect = [self titleRectForBounds:aRect];
	[super selectWithFrame:rect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
	//aRect = [self titleRectForBounds:aRect];
    NSRect rect = NSMakeRect(aRect.origin.x -2 , aRect.origin.y +4, aRect.size.width - 4, aRect.size.height);
	[super editWithFrame:rect inView:controlView editor:textObj delegate:anObject event:theEvent];
}

#pragma mark - Drawing Methods

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)controlView {
    NSRect rect = NSMakeRect(4, frame.origin.y, frame.size.width - 4, frame.size.height);
    [super drawWithFrame:rect inView:controlView];

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

@end
