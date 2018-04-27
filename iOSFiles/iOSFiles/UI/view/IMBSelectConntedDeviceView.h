//
//  IMBSelectConntedDeviceView.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/15.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IMBDevViewController;

@interface IMBSelectConntedDeviceView : NSView
{
    @private
    NSView *_contentView;
    BOOL _isShowing;
}

@property(nonatomic, retain)NSView *contentView;
@property(nonatomic, assign)BOOL isShowing;

- (void)showWithOriginalFrame:(NSRect)originalF finalF:(NSRect)finalF;
- (void)hideWithTimeInterval:(CGFloat)timeInterval;



@end
