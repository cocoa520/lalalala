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
#import "IMBiCloudPathSelectBtn.h"
#import "IMBTagImageView.h"

@interface IMBDevicePageViewController : IMBBaseViewController<CNGridViewDelegate,CNGridViewDataSource>
{
    IBOutlet CNGridView *_gridView;
    IBOutlet IMBWhiteView *_mainView;
    IBOutlet IMBBackgroundBorderView *_topLineView;
    IBOutlet IMBWhiteView *_topView;
    IBOutlet NSBox *_contenBox;
    NSMutableDictionary *_sonControllerDic;
    IMBiCloudPathSelectBtn *_button1;
    IMBiCloudPathSelectBtn *_button2;
    IMBTagImageView *_tagImageView;
}

- (void)backAction:(id)sender;
- (id)initWithiPod:(IMBiPod *)ipod withDelegate:(id)delegate;

@end
