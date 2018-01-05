//
//  ToDeviceViewItem.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/24.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBDeviceConnection.h"
@interface ToDeviceViewItem : NSView
{
@private
    int _index;
    IMBBaseInfo *_baseInfo;
    NSTrackingArea *_trackingArea;
    NSButton *_exitbutton;
    BOOL _isSelected;
    
    id _target;
    SEL _action;
    MouseStatusEnum _mouseStatus;
    NSNotificationCenter *nc;
    id _delegate;
    NSString *_btnStatus;
    
    BOOL _needIcon;
}
@property (nonatomic, assign) BOOL needIcon;
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite) int index;
@property (nonatomic, readwrite, retain) IMBBaseInfo* baseInfo;
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@end
