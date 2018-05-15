//
//  IMBMainPageMenuView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/18.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBMainPageMenuView : NSView {
    NSShadow *_shadow;
    id		_target;
    SEL		_action;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end

@interface IMBMainPageItem : NSView {
    id		_target;
    SEL		_action;
    int _itemTag;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) int itemTag;

@end
