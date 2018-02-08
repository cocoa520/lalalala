//
//  IMBButtonLoadingView.h
//  iMobieTrans
//
//  Created by iMobie on 14-7-15.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBButtonLoadingView : NSView
{
    CALayer *_loadLayer;
    CALayer *_bgLayer;
    int count;
    BOOL _isAndroid;
}
@property (nonatomic,assign) BOOL isAndroid;
- (void)startAnimation;
- (void)startTwoAnimation;
- (void)stopAnimation;
- (id)initWithFrame:(NSRect)frameRect WithAndroid:(BOOL)android;
//- (void)killTimer;
@end
