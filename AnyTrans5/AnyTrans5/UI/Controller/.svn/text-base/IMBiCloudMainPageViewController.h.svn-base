//
//  IMBiCloudMainPageViewController.h
//  AnyTrans
//
//  Created by LuoLei on 17-1-16.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBMainFunctionButton.h"
#import "IMBCustomScrollView.h"
#import "IMBCategoryBarButtonView.h"
#import "IMBiCloudManager.h"
#import "IMBMenuPopupButton.h"
#import "IMBMenuItem.h"
@interface IMBiCloudMainPageViewController : IMBBaseViewController<IMBScrollerProtocol,NSMenuDelegate>
{
    IBOutlet IMBMainFunctionButton *_icloudDriver; //icloudDriver
    IBOutlet IMBMainFunctionButton *_icloudSync;
    IBOutlet IMBMainFunctionButton *_icloudImport;
    IBOutlet IMBMainFunctionButton *_icloudExport;
    IBOutlet NSView *_mainFunctionView;
    IBOutlet NSBox *_contentBox;
    IBOutlet NSView *_functionView;
    IBOutlet NSView *_contentView;
    IBOutlet IMBCustomScrollView *_scrollView;
    IBOutlet NSView *_firstCustomView;
    IBOutlet NSBox *_detailBox;
    IBOutlet IMBCategoryBarButtonView *_categoryBarView;
    IBOutlet NSTextField *_firstViewmainTitle;
    IBOutlet NSTextField *_secondViewMainTitle;
    IBOutlet IMBMenuPopupButton *_popUpButton;
    IBOutlet IMBWhiteView *_occlusionView;
    IBOutlet NSTextField *_loadLabel;
    NSMutableDictionary *_detailPageDic;
    NSMutableDictionary *_displayModeDic;
    BOOL _isFail;
    NSPopover *_loadPopover;
    BOOL _loadFinish;
    
    IMBMenuItem *_selectedItem;
    IMBFunctionButton *_selectedBtn;
    NSPopover *_tipPopover;
    
    BOOL _hasTwoStepAuth;///如果加了双重验证，iCloudBackup不能用
    
    IBOutlet NSImageView *_arrowImageView;
    IBOutlet NSImageView *_iCloudBgView;
}
@property (nonatomic, assign) BOOL isFail;
@property (nonatomic, retain) IMBMenuPopupButton *popUpButton;
@property (nonatomic, assign) BOOL hasTwoStepAuth;
- (id)initWithClient:(IMBiCloudManager *)iCloudManager withDelegate:(id)delegate;
//切换账号时，重新设置cookie;
- (void)setCookieStorage;
- (NSDictionary *)getiCloudAccountViewCollection;
- (void)refeashBadgeConut:(int)badgeConut WithCategory:(CategoryNodesEnum)category;
- (void)loadicloudCount:(int)count;
- (void)setTrackingAreaEnable:(BOOL)enable;
- (void)setShowTopLineView:(BOOL)isShow;

@end
