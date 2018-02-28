//
//  IMBDriveWindow.h
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDriveManage.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBSystemCollectionViewController.h"
#import "IMBToolBarView.h"
@interface IMBDriveWindow : NSWindowController <NSCollectionViewDelegate,IMBImageRefreshCollectionListener>
{
    IMBDriveManage *_drivemanage;
    NSMutableArray *_bindArray;
    IBOutlet NSArrayController *_arrayController;
    IBOutlet IMBBlankDraggableCollectionView *_blankCollection;
    NSMutableArray *_backContainer;
    NSMutableArray *_nextContainer;
    IBOutlet IMBToolBarView *_toolBarView;
    NSMutableArray *_currentArray;
    NSString *_currentDevicePath;
    IBOutlet HoverButton *advanceButton;
    IBOutlet HoverButton *backButton;
    BOOL _isReload;
    IBOutlet IMBWhiteView *_detailView;
    IBOutlet NSBox *_rootBox;
    IBOutlet IMBWhiteView *_loadView;
    IBOutlet LoadingView *_loadAnimation;
    NSOpenPanel *_openPanel;
}
@property (nonatomic,retain) NSMutableArray *bindArray;
- (id)initWithDrivemanage:(IMBDriveManage*)driveManage;
- (void)loadSonAryComplete:(NSMutableArray *) sonAry;
- (void)refresh;
- (void)toMac;
@end
