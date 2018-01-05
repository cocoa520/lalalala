//
//  IMBMyAlbumsViewController.h
//  iMobieTrans
//
//  Created by iMobie on 7/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBTabTableView.h"
#import "IMBScrollView.h"
#import "IMBBGColoerView.h"
#import "HoverButton.h"
#import "IMBPhotoEntity.h"
#import "IMBImageAndTitleButton.h"
#import "LoadingView.h"
@class IMBAlertViewController;
@interface IMBMyAlbumsViewController : IMBBaseViewController {
    
    IBOutlet IMBCustomHeaderTableView *_albumTableView;
//    IBOutlet HoverButton *_addAlbumBtn;
//    IBOutlet HoverButton *_deleteAlbumBtn;
    IBOutlet NSBox *_boxContent;
    IBOutlet NSMenu *_menu;
    IBOutlet NSMenuItem *_renameMenuItem;
    IBOutlet NSMenuItem *_deleteItem;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_containTableView;
    IBOutlet NSBox *_mainBox;
    IMBAlertViewController *alerView;
    NSMutableDictionary *_contentDic;
    IMBPhotoEntity *_currentEntity;
    int _currentSelectView;
    int _curIndex;
    NSViewController *_currentContorller;
    AlbumTypeEnum _selectedType;
    
    IBOutlet IMBWhiteView *_bottomView;
    IBOutlet IMBImageAndTitleButton *_addAlbumBtn;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    NSTrackingArea *_trackingArea;
}

@property (nonatomic, retain) IMBCustomHeaderTableView *albumTableView;
@property (nonatomic,assign) AlbumTypeEnum selectedType;
@property (nonatomic,assign) int currentSelectView;
@property (nonatomic,assign) IMBPhotoEntity *currentEntity;
- (IBAction)addAlbumBtn:(id)sender;
- (IBAction)doRenameAlbum:(id)sender;
- (NSMutableArray *)getSelectedItemsArray:(NSIndexSet *)sets;
@end
