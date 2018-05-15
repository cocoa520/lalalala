//
//  IMBCloudHistoryView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBCloudEntity.h"
#import "IMBNotificationDefine.h"

@interface IMBCloudHistoryView : NSView {
    NSShadow *_shadow;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, assign) int buttonTag;

@end

@interface IMBCloudItemView : NSView {
    IBOutlet NSTextField *_nameTextField;
    IBOutlet NSTextField *_emailTextField;
    IBOutlet NSTextField *_sizeTextField;
}

@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, assign) BOOL isCloudHistoryAdd;

@end
