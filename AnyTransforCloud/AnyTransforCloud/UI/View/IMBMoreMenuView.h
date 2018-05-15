//
//  IMBMoreMenuView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBMoreMenuView : NSView {
    NSShadow *_shadow;
    id		_target;
    SEL		_action;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end

@interface IMBMoreItem : NSView {
    id		_target;
    SEL		_action;
    int _itemTag;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) int itemTag;
@property (nonatomic, assign) ActionTypeEnum actionType;

@end
