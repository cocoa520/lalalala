//
//  IMBAirBackupPopoverViewController.h
//  AnyTrans
//
//  Created by smz on 17/10/20.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "IMBDeviceConnection.h"
#import "PopoverRootView.h"
@class IMBAirWifiBackupViewController;
@interface IMBAirBackupPopoverViewController : NSViewController
{
@private
    id _target;
    SEL _action;
    NSArray *deviceInfoArray;
    int itemCount;
    id _delegate;
    IMBBaseInfo *baseInfo;
    IPodFamilyEnum _connectType;
    IBOutlet PopoverRootView *rootView;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, assign) IPodFamilyEnum connectType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSelectedValue:(NSString*)selectedValue WithDevice:(NSMutableArray *)ary withConnectType:(IPodFamilyEnum)connectType;

@end
