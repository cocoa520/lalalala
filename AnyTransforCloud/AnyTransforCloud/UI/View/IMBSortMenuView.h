//
//  IMBSortMenuView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/2.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBSortMenuView : NSView {
    NSShadow *_shadow;
}

@end

@interface IMBSortItem : NSView {
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) int itemTag;

@end