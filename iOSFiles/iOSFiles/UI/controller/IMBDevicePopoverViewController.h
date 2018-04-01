//
//  IMBDevicePopoverViewController.h
//  iOSFiles
//
//  Created by hym on 31/03/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDeviceConnection.h"
@interface IMBDevicePopoverViewController : NSViewController
{
    id _target;
    SEL _action;
    NSMutableArray *_deviceAry;
}

@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDeviceAry:(NSMutableArray *)deviceAry;

@end


@interface IMBDeviceItemView : NSView
{
    id _target;
    SEL _action;
    id _delegate;
    IMBBaseInfo *_baseInfo;
    MouseStatusEnum _mouseSatue;
    NSTrackingArea *_trackingArea;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, readwrite, retain) IMBBaseInfo* baseInfo;
- (instancetype)initWithFrame:(NSRect)frameRect withBaseinfo:(IMBBaseInfo *)baseInfo;
@end
