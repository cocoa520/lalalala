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
#import "IMBLackCornerView.h"
#import "HoverButton.h"

@interface IMBDevicePageViewController : IMBBaseViewController<CNGridViewDelegate,CNGridViewDataSource>
{
    IBOutlet NSBox *_rootBox;
    IBOutlet CNGridView *_gridView;
    IBOutlet IMBWhiteView *_mainView;
    IMBBaseViewController *_baseViewController;

    IBOutlet IMBBackgroundBorderView *_topLineView;
    IBOutlet IMBWhiteView *_topView;
    IBOutlet HoverButton *_backButton;
    IBOutlet NSBox *_contenBox;
}
- (void)backAction:(id)sender;
- (id)initWithiPod:(IMBiPod *)ipod withDelegate:(id)delegate;

@end
