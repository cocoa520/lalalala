//
//  IMBAddCloudAnimationView.h
//  AnyTransforCloud
//
//  Created by hym on 18/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import <QuartzCore/QuartzCore.h>
@interface IMBAddCloudAnimationView : NSView
{
    MouseStatusEnum _buttonType;
    NSTrackingArea *_trackingArea;
    CATextLayer *_titleLayer;
    CALayer *_imageLayer;
    
    id		_target;
    SEL		_action;
    CALayer *_bgAnimationLayer;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@end
