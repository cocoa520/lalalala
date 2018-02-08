//
//  IMBToDevicePopoverViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/24.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "IMBDeviceConnection.h"
@interface IMBToDevicePopoverViewController : NSViewController
{
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
    IBOutlet IMBWhiteView *_rootView;
    id _sender;
    BOOL _needIcon;
}
@property (nonatomic, assign) BOOL needIcon;
@property (nonatomic, assign) id sender;
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, readwrite, retain) id exitTarget;
@property (nonatomic, readwrite) SEL exitAction;
@property (nonatomic,setter = setSelectValue:,getter = selectValue,retain) NSString *selectValue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithDevice:(NSMutableArray *)allDeviceArray;
- (void)setSelectValue:(NSString *)selectValue;
- (NSString*)selectValue;
@end
