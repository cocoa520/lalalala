//
//  IMBDevicePageWindow.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/1/31.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBLackCornerView.h"
#import "IMBSystemCollectionViewController.h"
@class IMBiPod,IMBStackBox;


@interface IMBDevicePageWindow : NSWindowController
{
    IBOutlet IMBLackCornerView *_topView;
    IMBiPod *_iPod;
    IBOutlet NSTextField *_title;
    IBOutlet IMBStackBox *_rootBox;
    IMBSystemCollectionViewController *_systemCollectionViewController;
}

- (id)initWithiPod:(IMBiPod *)ipod;
@end
