//
//  IMBDevicePlaylistsViewController.h
//  iMobieTrans
//
//  Created by iMobie on 14-5-26.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "HoverButton.h"
#import "IMBTabTableView.h"
#import "IMBBGColoerView.h"
#import "IMBScrollView.h"
#import "IMBImageAndTitleButton.h"
#import "LoadingView.h"
@class IMBAlertViewController;
@interface IMBDevicePlaylistsViewController : IMBBaseViewController
{
    IBOutlet NSMenu *_leftMenuItem;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_containTableView;
    IMBCustomHeaderTableView *_playlistsTableView;
//    HoverButton *_addPlaylistBtn;
//    HoverButton *_deletePlaylistBtn;
    NSTextField *_playlistTextfield;
    IBOutlet IMBBGColoerView *_bgColorView;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet NSMenu *addListMenu;
    IBOutlet NSMenuItem *_renameMenuItem;
    IBOutlet NSBox *_rightMianBox;
    IBOutlet IMBWhiteView *_lineView;
    IMBLogManager *_logManger;
    NSArray *_selectedItems;
    NSArray *_selectedPlaylists;
    BOOL _onlyTransferPlaylist;
    IBOutlet IMBWhiteView *_bottomView;
    IBOutlet IMBImageAndTitleButton *_addPlaylistBtn;
    IBOutlet NSBox *_loadingBox;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IMBAlertViewController *alerView;
    NSNotificationCenter *_nc;
    BOOL _isPlaylistType;
}

@property (assign) BOOL isPlaylistType;
@property (assign) IBOutlet NSTableView *playlistsTableView;
//@property (assign) IBOutlet HoverButton *addPlaylistBtn;
//@property (assign) IBOutlet HoverButton *deletePlaylistBtn;
@property (assign) IBOutlet NSTextField *playlistTextfield;
@property (nonatomic, retain, getter = selectedPlaylists) NSArray *selectedPlaylists;
@property (nonatomic, retain, getter = selectedItemsByPlaylist) NSArray *selectedItems;
@property (assign) BOOL onlyTransferPlaylist;

- (void)removePlaylistWithplArr:(NSArray *)plArr;
- (void)reloadListWithPlaylistArr:(NSArray *)plArr;
- (NSArray *)selectedPlaylists;
//- (NSArray *)selectedItems;
- (void)toDevicePlaylists;
- (IBAction)doBatchHandle:(id)sender;
- (IBAction)doAddPlaylist:(id)sender;
- (IBAction)doDeletePlaylist:(id)sender;
- (IBAction)doRenamePlaylist:(id)sender;
- (NSArray *)selectedItemsByPlaylist;


@end
