//
//  IMBAirBackupDeviceItemView.h
//  AnyTrans
//
//  Created by smz on 17/10/20.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDeviceConnection.h"
#import "IMBCommonEnum.h"
#import "IMBNotificationDefine.h"
#import "IMBSignOutButton.h"
@class IMBBackupRecord;
#import "IMBTextLinkButton.h"

@interface IMBAirBackupDeviceItemView : NSView  {
@private
    IMBBackupRecord *_backupRecord;
    IMBBaseInfo *_baseInfo;
    NSTrackingArea *_trackingArea;
    BOOL _isSelected;
    id _target;
    SEL _action;
    MouseStatusEnum _mouseStatus;
    NSNotificationCenter *nc;
    id _delegate;
    NSString *_btnStatus;
    BOOL _isShowLine;
    NSImageView *_onlineImageView;
    NSImageView *_disOnlineImageView;

    IMBSignOutButton *_watchBtn;
    IMBTextLinkButton *_textButton;
    BOOL _isBackupInfo;
    BOOL _isSettingView;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite, retain) IMBBackupRecord* backupRecord;
@property (nonatomic, readwrite, retain) IMBBaseInfo* baseInfo;
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, assign) BOOL isShowLine;
@property (nonatomic, readwrite) BOOL isBackupInfo;
@property (nonatomic, readwrite) BOOL isSettingView;

@end
