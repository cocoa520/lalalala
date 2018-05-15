//
//  IMBPathMenuView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/2.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBPathMenuView : NSView {
    NSShadow *_shadow;
    id		_target;
    SEL		_action;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end

@interface IMBPathItem : NSView {
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) int itemTag;
@property (nonatomic, retain) NSString *pathTitle;
@property (nonatomic, retain) NSImage *pathImage;

@end