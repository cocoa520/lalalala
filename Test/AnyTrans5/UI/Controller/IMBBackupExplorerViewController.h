//
//  IMBBackupExplorerViewController.h
//  iMobieTrans
//
//  Created by iMobie on 14-7-3.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBBackgroundBorderView.h"
#import "HoverButton.h"
#import "SimpleNode.h"
#import "LoadingView.h"
#import "IMBBackupManager.h"
@class IMBBlankDraggableCollectionView;
typedef enum
{
    BackupExploreType = 0,
    AppDocumentExploreType = 1,
    FileSystemExploreType = 2,
    CrashLogExploreType = 3
}FileExploreType;
@interface IMBBackupExplorerViewController : IMBBaseViewController
{
    IBOutlet NSImageView *_nodataImageView;
    NSMutableArray *_backupFileArray;
    NSMutableArray *_tempbackupFileArray;
    IBOutlet IMBBackgroundBorderView *_backandnextView;
    IBOutlet NSTextField *_itemTitleField;
    IBOutlet NSSegmentedControl *backandnext;
    IBOutlet NSScrollView *collectionScollView;
    NSMutableArray *_backContainer;
    NSMutableArray *_nextContainer;
    NSString *_backupPath;
    NSString *_decryptPath;
    FileExploreType type;
    IBOutlet HoverButton *advanceButton;
    IBOutlet HoverButton *backButton;
    NSString *_currentDevicePath;
    int currentIndex;
    IBOutlet NSView *_noDataView;
    IBOutlet NSView *_dataView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSTextField *_noDataTitle;

    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet NSBox *_explorerBox;
   
    IBOutlet LoadingView *_loadingViewAnimaView;
    IBOutlet NSProgressIndicator *_progressIndicator;
    IMBBackupDecryptAbove4 *_decryptAbove4;
    NSString *_iosVersion;
    IMBBackupManager *_backup;
}

@property(nonatomic,retain)NSMutableArray *backupFileArray;
@property (nonatomic,retain)NSString *currentDevicePath;
//@property(nonatomic,retain)NSMutableArray *curRecordArray;


- (IBAction)backAction:(id)sender;
- (IBAction)nextAction:(id)sender;

@end

@interface IMBFolderOrFileCollectionViewItem : NSCollectionViewItem

@end

@interface IMBFolderOrFileCollectionItemView : NSView
{
    NSTrackingArea *_trackingArea;
    BOOL _done;
}
@property (nonatomic,assign) BOOL done;
@end