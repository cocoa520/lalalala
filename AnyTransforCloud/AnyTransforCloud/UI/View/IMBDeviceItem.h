//
//  IMBDeviceItem.h
//  iMobieTrans
//
//  Created by Pallas on 3/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBCloudEntity.h"
#import "IMBCurrencySvgButton.h"
#import "IMBDrawImageBtn.h"
@interface IMBDeviceItem : NSView {
@private
    int _index;
    NSTrackingArea *_trackingArea;
    BOOL _isSelected;
    id _target;
    SEL _action;
    MouseStatusEnum _mouseStatus;
    NSNotificationCenter *nc;
    id _delegate;
    NSString *_btnStatus;
    IMBCloudEntity *_cloudEntity;
    IMBDrawImageBtn *_jumpHeadBtn;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite) int index;
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, retain) IMBCloudEntity *cloudEntity;
@end
