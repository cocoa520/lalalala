//
//  IMBBuyView.h
//  AnyTrans
//
//  Created by m on 17/8/22.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBBuyView : NSView
{
    id	_target;
    SEL	_action;
    
    NSTrackingArea *_trackingArea;
    NSColor *_normalColor;
    NSColor *_enterColor;
    NSColor *_downColor;
    MouseStatusEnum _mouseState;
    NSTimer *_timer;
    NSImage *_image1;
    NSImage *_image2;
    NSImage *_image3;
    int count;
    BOOL _isOpen;
    BOOL _isClick;
    
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isClick;
@end
