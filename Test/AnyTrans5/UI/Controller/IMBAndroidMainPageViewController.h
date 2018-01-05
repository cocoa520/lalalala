//
//  IMBAndroidMainPageViewController.h
//  AnyTrans
//
//  Created by imobie on 17-07-10.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBMainFunctionButton.h"
#import "IMBCustomScrollView.h"
#import "IMBCategoryBarButtonView.h"
#import "IMBiCloudManager.h"
#import "IMBMenuPopupButton.h"
#import "IMBMenuItem.h"

@interface IMBAndroidMainPageViewController : IMBBaseViewController<IMBScrollerProtocol,NSMenuDelegate>
{
    IBOutlet IMBMainFunctionButton *_androidToiOS;
    IBOutlet IMBMainFunctionButton *_androidToiTunes;
    IBOutlet IMBMainFunctionButton *_androidToiCloud;
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
    NSPopover *_loadPopover;
    BOOL _loadFinish;
    
    IMBMenuItem *_selectedItem;
    IMBFunctionButton *_selectedBtn;
    NSPopover *_tipPopover;
    IBOutlet NSImageView *_arrowImageView;
    IBOutlet NSImageView *_iCloudBgView;
    IBOutlet IMBCategoryBarButtonView *_categoryBtnBarView;
}
@property (nonatomic, retain) IMBMenuPopupButton *popUpButton;
- (id)initWithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate;

- (void)refeashBadgeConut:(int)badgeConut WithCategory:(CategoryNodesEnum)category;
- (void)loadAndroidDataCount:(int)count;
#pragma mark - 检查设备是否赋予权限
- (void)checkDeviceGreantedPermission:(NSNumber *)functionType;
- (void)setShowTopLineView:(BOOL)isShow;
@end
