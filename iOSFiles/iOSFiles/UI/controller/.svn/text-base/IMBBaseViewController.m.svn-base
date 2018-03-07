//
//  IMBBaseViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/2/26.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBToolBarView.h"
#import "IMBiPod.h"

#import <objc/runtime.h>


@interface IMBBaseViewController ()
{
    IMBToolBarView *_toolMenuView;
}
@end

@implementation IMBBaseViewController

@synthesize iPod = _iPod;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib {
    _toolMenuView = objc_getAssociatedObject(_iPod, &kIMBDevicePageToolBarViewKey);
    [_toolMenuView setDelegate:self];
}

- (void)refresh:(IMBInformation *)information {
    
}

- (void)toMac:(IMBInformation *)information {
    
}

- (void)addToDevice:(IMBInformation *)information {
    
}

- (void)deleteItem:(IMBInformation *)information {
    
}

- (void)toDevice:(IMBInformation *)information {
    
}
@end
