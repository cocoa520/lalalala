//
//  IMBUnlockView.h
//  AirBackupHelper
//
//  Created by m on 17/10/22.
//  Copyright (c) 2017年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBUnlockView : NSView
{
    id	_target;
    SEL	_action;
    
    BOOL _hasCorner;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseState;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) BOOL hasCorner;

@end
