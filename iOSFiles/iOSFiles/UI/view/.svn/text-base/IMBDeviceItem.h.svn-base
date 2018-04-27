//
//  IMBDeviceItem.h
//  iMobieTrans
//
//  Created by Pallas on 3/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDeviceConnection.h"
#import "IMBCommonEnum.h"
#import "IMBSignOutButton.h"
#import "IMBMainWindowController.h"
#import "IMBNotificationDefine.h"

@interface IMBDeviceItem : NSView {
@private
    int _index;
    IMBBaseInfo *_baseInfo;
    NSTrackingArea *_trackingArea;
    NSButton *_exitbutton;
    BOOL _isSelected;
    BOOL _isAddContent;
    id _target;
    SEL _action;
    MouseStatusEnum _mouseStatus;
    NSNotificationCenter *nc;
    IMBSignOutButton *_signOutBtn;
    IMBSignOutButton *_openWindowBtn;
    id _delegate;
    NSString *_btnStatus;
    BOOL _isTitle;
    BOOL _isAndroidView;
    BOOL _isiCloudView;
    BOOL _isShowLine;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite) int index;
@property (nonatomic, readwrite, retain) IMBBaseInfo* baseInfo;
@property (nonatomic, setter = setExitbutton:, getter = exitbutton, retain) NSButton* exitbutton;
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, assign) BOOL isAddContent;
@property (nonatomic, assign) BOOL isTitle;
@property (nonatomic, assign) BOOL isAndroidView;
@property (nonatomic, assign) BOOL isiCloudView;
@property (nonatomic, assign) BOOL isShowLine;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;

- (void)refresh;
-(void)signOutDrive;

@end
