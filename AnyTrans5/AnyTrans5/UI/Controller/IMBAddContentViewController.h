//
//  IMBAddContentViewController.h
//  AnyTrans
//
//  Created by m on 16/12/14.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBiPod.h"
#import "IMBBackgroundBorderView.h"
#import "IMBBackgroundBorderView.h"
#import "HoverButton.h"
#import "IMBCustomHeaderTableView.h"
#import "IMBPhotoEntity.h"
#import "IMBWhiteView.h"
#import "IMBTransferViewController.h"
#import "LoadingView.h"
@interface IMBAddContentViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate , IMBImageRefreshListListener>
{
    IMBiPod *_iPod;
    NSMutableArray *_allPaths;
    HoverButton *_closebutton;
    NSMutableArray *_catagoryArray;
    NSMutableArray *_musicArray;
    NSMutableArray *_videoArray;
    NSMutableArray *_voiceMemoArray;
    NSMutableArray *_ringtoneArray;
    NSMutableArray *_photoArray;
    NSMutableArray *_bookArray;
    NSMutableArray *_appArray;
    NSMutableArray *_detailArray;
    NSMutableArray *_selectArray;
    //新增
    NSMutableArray *_contactArray;
    NSMutableArray *_noteArray;
    BOOL _isiCloudAdd;
    
    IMBPhotoEntity *_photoAlbum;
    int64_t _playlistID;
    HoverButton *_nextBtn;
    id _delegate;
    IBOutlet NSBox *_mainBox;
    IBOutlet IMBBackgroundBorderView *_selectView;
    IBOutlet IMBWhiteView *_contentView;
    IBOutlet NSView *_categoryView;
    IBOutlet NSView *_detailView;
    IBOutlet NSView *_topView;
    IBOutlet IMBCustomHeaderTableView *_catagoryTableView;
    IBOutlet IMBCustomHeaderTableView *_detailTableView;
    IBOutlet NSTextField *_mainTitle;
    IBOutlet NSTextField *_subTitle;
    IBOutlet NSTextField *_detailViewTitle;
    IBOutlet NSTextField *_detailViewCount;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet NSView *topView;
    IBOutlet NSView *_loadingView;
    IBOutlet LoadingView *_animationView;
    IMBiCloudManager *_icloudManager;
    NSMutableArray *_addCategoryAryM;
    
    @public
    BOOL _endRunloop;
}
@property (nonatomic,assign)IMBiCloudManager *icloudManager;
@property (nonatomic, assign) id delegate;
@property (nonatomic,assign)BOOL isiCloudAdd;
@property (nonatomic, retain) NSMutableArray *addCategoryAryM;

-( void)loadDetailView:(AddContentCategoryEnum )category;
- (id)initWithiPod:(IMBiPod *)iPod  withAllPaths:(NSMutableArray *)allPaths WithPhotoAlbum:(IMBPhotoEntity *)albumEntity playlistID:(int64_t) playlistID;

- (void)showTopLineView;

@end

#import "HoverButton.h"

@interface IMBCategoryEntity : NSObject
{
    NSImage *_picName;
    NSString *_name;
    uint _size;
    NSMutableArray *_resultArray;
    NSInteger _itemsCount;
    AddContentCategoryEnum _category;
    CheckStateEnum _checkState;
    HoverButton *_nextBtn;
    id _delegate;
}
@property (nonatomic, assign) CheckStateEnum checkState;
@property (nonatomic, copy) NSImage *picName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger itemsCount;
@property (nonatomic, assign) uint size;
@property (nonatomic, retain) NSMutableArray *resultArray;
@property (nonatomic, assign) AddContentCategoryEnum category;
@property (nonatomic, assign) HoverButton *nextBtn;
@property (nonatomic, assign) id delegate;
@end
