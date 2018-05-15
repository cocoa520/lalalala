//
//  IMBNoTitleBarWindow.h
//  MacClean
//
//  Created by LuoLei on 15-11-23.
//  Copyright (c) 2015年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BackGroundView;
@interface IMBNoTitleBarWindow : NSWindow
{
    NSButton *_closeButton;
    NSButton *_minButton;
    NSButton *_maxButton;
    BackGroundView *_maxAndminView;
}
@property (nonatomic,assign)BackGroundView *maxAndminView;
@property(nonatomic,assign)NSButton *closeButton;
@property(nonatomic,assign)NSButton *minButton;
@property(nonatomic,assign)NSButton *maxButton;

- (void)setTrackingArea:(int)count;

@end

@interface BackGroundView : NSView
{
    NSColor *_backgroundColor;
}
@property (nonatomic,retain)NSColor *backgroundColor;
@end