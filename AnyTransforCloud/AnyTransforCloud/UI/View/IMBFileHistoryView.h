//
//  IMBFileHistoryView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBCloudEntity.h"

@interface IMBFileHistoryView : NSView {
    NSShadow *_shadow;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, assign) BOOL isOpenMenu;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, assign) int buttonTag;

@end

@class IMBToolBarButton;
@interface IMBFileItemView : NSView {
    
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
    IBOutlet IMBToolBarButton *_star;
    IBOutlet IMBToolBarButton *_share;
    IBOutlet IMBToolBarButton *_sync;
    IBOutlet IMBToolBarButton *_more;
    
    IBOutlet NSTextField *_titleTextField;
    IBOutlet NSTextField *_subTextField;
}
@property (nonatomic, assign) int buttonTag;
@property (nonatomic, assign) BOOL isOpenMenu;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;

@end
