//
//  IMBDriveWindow.h
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDriveManage.h"
#import "IMBToolBarView.h"
#import "IMBiCloudDriveManager.h"
#import "IMBDriveBaseManage.h"
#import "DriveItem.h"
#import "IMBiCloudDriverViewController.h"
#import "IMBNoTitleBarContentView.h"
#import "IMBLackCornerView.h"

@interface IMBDriveWindow : NSWindowController
{
    IBOutlet IMBNoTitleBarContentView *_mainContentView;
    IBOutlet IMBLackCornerView *_topView;
    IBOutlet IMBWhiteView *_bgWhiteView;
    NSMutableArray *_bindArray;
    NSMutableArray *_currentArray;
    NSString *_currentDevicePath;
    BOOL _isReload;
    IBOutlet NSBox *_rootBox;
    NSOpenPanel *_openPanel;
    IMBDriveBaseManage *_driveBaeManage;
    BOOL _isiCloudDirve;
    DriveItem *_downloaditem;
    NSString *_oldDocwsid;
    IMBBaseViewController *_baseViewController;
}
@property (nonatomic,retain) DriveItem *downloaditem;
@property (nonatomic,retain) NSMutableArray *bindArray;
- (id)initWithDrivemanage:(IMBDriveBaseManage*)driveManage withisiCloudDrive:(BOOL) isiCloudDirve;
- (void)refresh;
- (void)toMac;
@end
