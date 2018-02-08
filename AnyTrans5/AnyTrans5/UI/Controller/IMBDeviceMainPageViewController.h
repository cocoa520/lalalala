//
//  iMBDeviceMainPageViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-14.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBMainFunctionButton.h"
#import "IMBCustomScrollView.h"
#import "IMBCategoryBarButtonView.h"
#import "IMBGrayCapacityView.h"
#import "IMBMenuPopupButton.h"
#import "IMBMenuItem.h"
#import "IMBGuideViewController.h"
#import "IMBAddContentViewController.h"
@class IMBFastDriverSegViewController;
@interface IMBDeviceMainPageViewController : IMBBaseViewController <IMBScrollerProtocol,NSMenuDelegate,NSPopoverDelegate> {
    IBOutlet IMBCustomScrollView *_scrollView;
    IBOutlet NSBox *_contentBox;
    IBOutlet NSView *_functionView;
    IBOutlet NSView *_contentView;
    IBOutlet NSView *_firstCustomView;
    IBOutlet IMBCategoryBarButtonView *_categoryBtnBarView;
    IBOutlet NSBox *_detailBox;
    IBOutlet IMBMenuPopupButton *_popUpButton;
    IBOutlet NSTextField *_mainFirstTitle;
    IBOutlet NSTextField *_mainSecondTitle;
    NSMutableDictionary *_detailPageDic;
    NSMutableDictionary *_displayModeDic;
    @public
    IBOutlet IMBMainFunctionButton *_mergeBtn;
    IBOutlet IMBMainFunctionButton *_toMacBtn;
    IBOutlet IMBMainFunctionButton *_toiTunesBtn;
    IBOutlet IMBMainFunctionButton *_toDevcieBtn;
    IBOutlet IMBMainFunctionButton *_addBtn;
    IBOutlet IMBMainFunctionButton *_cloneBtn;
    IBOutlet IMBMainFunctionButton *_fastDriverBtn;
    
    IMBMenuItem *_selectedItem;
    IMBFunctionButton *_selectedBtn;
    IBOutlet NSView *_mainFunctionView;
    IBOutlet IMBWhiteView *_occlusionView;
    IBOutlet NSTextField *_loadLabel;
    
    IBOutlet IMBBackgroundBorderView *_mainView;
    NSPopover *_loadPopover;
    NSPopover *_tipPopover;
    IBOutlet NSImageView *_devicebgView;
    IBOutlet NSImageView *_arrowImageView;
    IMBiPod *_newIpod;
    NSMutableArray *_addContentCategoryAryM;
    IBOutlet IMBWhiteView *_photoPromptBgView;
    IBOutlet NSTextField *_photoPromptString;
    IBOutlet IMBTextButtonView *_photoPromptBtn;
    BOOL _isfirstEnter;
}
@property (nonatomic, retain) NSMutableArray *addContentCategoryAryM;
#pragma mark - 六个大按钮
- (IBAction)merge:(id)sender;
- (IBAction)clone:(id)sender;
- (IBAction)conentToiTunes:(id)sender;
- (IBAction)conentToDevice:(id)sender;
- (IBAction)conentToMac:(id)sender;
- (IBAction)addContent:(id)sender;
- (IBAction)fastDriver:(id)sender;
- (void)doSwitchView:(id)sender;
- (void)doBackView:(id)sender;
- (void)loadDeviceContent;

- (void)loadMyAlbumButton:(AlbumTypeEnum)albumEnum withIsViewDisplay:(BOOL)isViewDisplay withViewController:(id)viewController;
- (void)loadPlaylistButton:(BOOL)isType withViewController:(id)viewController;
- (void)refeashBadgeConut:(int)badgeConut WithCategory:(CategoryNodesEnum)category;

- (void)setTrackingAreaEnable:(BOOL)enable;
- (void)setShowTopLineView:(BOOL)isShow;

@end
