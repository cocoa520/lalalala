//
//  IMBiCloudItemView.h
//  AnyTrans
//
//  Created by LuoLei on 17-1-18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBSignOutButton.h"
#import "IMBiCloudNetClient.h"
@interface IMBiCloudItemView : NSView
{
    NSTrackingArea *_trackingArea;
    NSString *_accountName;
    id _target;
    SEL _action;
    MouseStatusEnum _mouseStatus;
    BOOL _isSelected;
    BOOL _isAddContent;
    IMBSignOutButton *_signOutBtn;;
    IMBiCloudNetClient *_client;
}
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, readwrite, assign) id target;
@property (nonatomic, readwrite, assign) SEL action;

@property (nonatomic, readwrite, retain)NSString *accountName;
@property (nonatomic, assign) BOOL isAddContent;
@property (nonatomic, retain) IMBiCloudNetClient *client;
- (void)loadCapacity:(float)percent;
@end
