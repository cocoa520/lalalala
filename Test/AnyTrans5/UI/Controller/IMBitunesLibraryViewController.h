//
//  IMBitunesLibraryViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBToolTipViewController.h"
#import "IMBiTunes.h"
#import "IMBLackCornerView.h"
#import "LoadingView.h"
#import "IMBCategoryView.h"
#import "IMBWhiteView.h"
@class IMBiTunesCategoryBindData;
@interface IMBitunesLibraryViewController : IMBBaseViewController <NSPopoverDelegate>
{
    IMBToolTipViewController *_toolTipViewController;
     NSMutableArray *_bindCategoryArray;
    IMBiTunes *_iTunes;
    CategoryNodesEnum _itunesCategory;
    IBOutlet NSBox *_iTunesMainBox;
    IMBCategoryView *categoryView;
    IBOutlet IMBLackCornerView *bgView;
    NSNotificationCenter *nc;
    NSView *_curContenView;
    NSMutableDictionary *_contentViewControllerDic;
    IMBiTunesCategoryBindData *lastBinditem;
    NSString *lastCategoryString;
    NSPopover *_popover;

    IBOutlet NSView *_dataView;
    IBOutlet IMBWhiteView *_loadView;
    IBOutlet LoadingView *_loadAnimationView;
    IBOutlet IMBWhiteView *_loadTwoView;
    IBOutlet LoadingView *_loadTwoAnimationView;
    BOOL _itunesIsOpen;
    IBOutlet NSView *_disConnectView;

    IBOutlet NSTextField *_disConnectTitleStr;
    IBOutlet NSTextField *_disSubTitleStr;
    IBOutlet NSImageView *_bgImageView;
    BOOL _isNotFirstLoadView;
}
@property (nonatomic, retain)IMBCategoryView *categoryView;
@property (nonatomic, readwrite, retain) NSMutableArray *bindCategoryArray;
- (void)loadiTunesData;
@end
