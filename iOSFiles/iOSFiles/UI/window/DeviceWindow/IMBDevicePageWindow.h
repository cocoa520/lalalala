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
#import "IMBSelecedDeviceBtn.h"
#import "IMBDevViewController.h"
@class IMBiPod,IMBStackBox;


@interface IMBDevicePageWindow : NSWindowController<NSPopoverDelegate>
{
    IBOutlet IMBLackCornerView *_topView;
    IMBiPod *_iPod;
    IBOutlet NSTextField *_title;
    IBOutlet IMBStackBox *_rootBox;
    IMBSystemCollectionViewController *_systemCollectionViewController;
    IBOutlet NSView *_topTextView;
    IMBSelecedDeviceBtn *_selectedDeviceBtn;
    NSPopover *_devPopover;
//    IBOutlet IMBSelecedDeviceBtn *_chooseViewBtn;
}

- (id)initWithiPod:(IMBiPod *)ipod;

- (void)setTitleStr:(NSString *)title;

@end
