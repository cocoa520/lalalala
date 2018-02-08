//
//  IMBMonitorBtn.h
//  MacClean
//
//  Created by JGehry on 9/12/15.
//  Copyright (c) 2015 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface IMBMonitorBtn : NSButton {
    NSImage *_leftImage;
    NSImage *_middleImage;
    NSImage *_rightImage;
    NSImage *_leftEnterImage;
    NSImage *_middleEnterImage;
    NSImage *_rightEnterImage;
    NSImage *_leftDownImage;
    NSImage *_middleDownImage;
    NSImage *_rightDownImage;
    BOOL _isBigButton;
    BOOL _isMouseEnter;
    BOOL _isMouseDown;
    
    NSFont *_font;
    NSColor *_fontColor;
    NSColor *_fontEnterColor;
    NSColor *_fontDownColor;
    NSTrackingArea *_trackingArea;
    float _minWidth;
    
    NSImage *_bgImage;
}
@property (nonatomic,assign)float minWidth;
@property (nonatomic, readwrite, retain) NSImage *leftImage;
@property (nonatomic, readwrite, retain) NSImage *middleImage;
@property (nonatomic, readwrite, retain) NSImage *rightImage;
@property (nonatomic, readwrite, retain) NSImage *leftEnterImage;
@property (nonatomic, readwrite, retain) NSImage *middleEnterImage;
@property (nonatomic, readwrite, retain) NSImage *rightEnterImage;
@property (nonatomic, readwrite, retain) NSImage *leftDownImage;
@property (nonatomic, readwrite, retain) NSImage *middleDownImage;
@property (nonatomic, readwrite, retain) NSImage *rightDownImage;
@property (nonatomic, readwrite, retain) NSImage *bgImage;

@property (nonatomic, assign) BOOL isBigButton;
@property (nonatomic, assign) BOOL isMouseEnter;
@property (nonatomic, assign) BOOL isMouseDown;
@property (nonatomic, readwrite, retain) NSFont *font;
@property (nonatomic, readwrite, retain) NSColor *fontColor;
@property (nonatomic, readwrite, retain) NSColor *fontEnterColor;
@property (nonatomic, readwrite, retain) NSColor *fontDownColor;
@end
