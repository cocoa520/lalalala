//
//  IMBArrowButton.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/3.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBArrowButton : NSButton {
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, assign) BOOL isAscending;//是否处于升序状态
@property (nonatomic, assign) BOOL isHightLight;//除非处于高亮状态（高亮就是白色  相当于隐藏）

@end
