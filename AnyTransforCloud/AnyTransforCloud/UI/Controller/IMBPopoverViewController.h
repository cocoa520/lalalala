//
//  IMBPopoverViewController.h
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/7.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "PopoverRootView.h"
#import "IMBCloudEntity.h"
//#import "IMBIPodPool.h"


@interface IMBPopoverViewController : NSViewController
{
@private
    id _target;
    SEL _action;
    NSMutableArray *_deviceInfoArray;
    int itemCount;
    NSMutableDictionary *_deviceItemDic;
    id _delegate;
    IBOutlet PopoverRootView *rootView;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
/**
 *  初始化
 *
 *  @param ary  要显示的数据
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithAllAry:(NSMutableArray *)ary;

@end
