//
//  IMBTableRowView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBTableRowView : NSTableRowView {
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _buttonType;
    
    BOOL _isDisable;
}

@end
