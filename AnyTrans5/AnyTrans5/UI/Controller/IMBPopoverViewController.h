//
//  IMBPopoverViewController.h
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/7.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "IMBDeviceConnection.h"
#import "PopoverRootView.h"
//#import "IMBIPodPool.h"


@interface IMBPopoverViewController : NSViewController
{
@private
    id _target;
    SEL _action;
    id _exitTarget;
    SEL _exitAction;
    NSArray *deviceInfoArray;
    int itemCount;
    NSString* _selectValue;
    NSMutableDictionary *_deviceItemDic;
    id _delegate;
    IMBBaseInfo *baseInfo;
    IPodFamilyEnum _connectType;
    IBOutlet PopoverRootView *rootView;
    BOOL _isHasiPod;
    BOOL _isHasAndroid;
    BOOL _isHasiCloud;
    BOOL _isHasAddiCloud;
    BOOL _isFirstiPod;
    BOOL _isFirstAndroid;
    BOOL _isFirstiCloud;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, readwrite, retain) id exitTarget;
@property (nonatomic, readwrite) SEL exitAction;
@property (nonatomic, readwrite, retain) NSString *selectValue;
@property (nonatomic, assign) IPodFamilyEnum connectType;
@property (nonatomic, assign) BOOL isHasiPod;
@property (nonatomic, assign) BOOL isHasAndroid;
@property (nonatomic, assign) BOOL isHasiCloud;
@property (nonatomic, assign) BOOL isHasAddiCloud;
@property (nonatomic, assign) BOOL isFirstiPod;
@property (nonatomic, assign) BOOL isFirstAndroid;
@property (nonatomic, assign) BOOL isFirstiCloud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSelectedValue:(NSString*)selectedValue WithDevice:(NSMutableArray *)ary withConnectType:(IPodFamilyEnum)connectType;
- (void)setSelectValue:(NSString *)selectValue;
- (NSString*)selectValue;
- (void)iPodLoadComplete:(NSString*)uniqueKey;

@end
