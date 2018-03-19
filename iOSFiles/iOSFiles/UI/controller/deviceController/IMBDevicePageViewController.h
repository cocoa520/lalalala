//
//  IMBDevicePageViewController.h
//  iOSFiles
//
//  Created by JGehry on 3/14/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBiPod.h"
#import "IMBInformation.h"
#import "CNGridView.h"
#import "IMBPhotoViewController.h"
#import "IMBLackCornerView.h"
#import "HoverButton.h"
#import "IMBPhotosListViewController.h"
@interface IMBDevicePageViewController : IMBBaseViewController<CNGridViewDelegate,CNGridViewDataSource>
{
    IBOutlet NSBox *_rootBox;
    IBOutlet CNGridView *_gridView;
    IBOutlet NSView *_mainView;
    IBOutlet IMBWhiteView *_toolView;
//    IBOutlet IMBLackCornerView *_topView;
    IMBBaseViewController *_baseViewController;

    IBOutlet IMBWhiteView *_topView;
    IBOutlet HoverButton *_backButton;
//    id delegate;
}
- (void)backAction:(id)sender;
- (id)initWithiPod:(IMBiPod *)ipod withDelegate:(id)delegate;
@end
