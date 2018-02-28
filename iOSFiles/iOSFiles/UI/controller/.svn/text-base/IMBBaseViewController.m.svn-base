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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib {
    _toolMenuView = objc_getAssociatedObject(_iPod, &kIMBDevicePageToolBarViewKey);
    [_toolMenuView setDelegate:self];
}

- (void)refresh {

}

- (void)toMac {

}

- (void)addItems {

}

- (void)deleteItem {

}
@end
