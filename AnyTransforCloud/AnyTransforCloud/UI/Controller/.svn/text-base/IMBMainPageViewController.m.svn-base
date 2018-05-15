//
//  IMBMainPageViewController.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/17.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBMainPageViewController.h"
#import "StringHelper.h"
#import "IMBAddMenuView.h"
#import "IMBAnimation.h"
#import "IMBMainViewController.h"
#import "IMBHistoryViewController.h"
#import "IMBShareViewController.h"
#import "IMBStarViewController.h"
#import "IMBTrashViewController.h"
#import "IMBAllCloudViewController.h"
#import "IMBGoogleManager.h"
#import "IMBPCloudManager.h"
#import "IMBSearchView.h"
#import "IMBDrawImageBtn.h"
#import "IMBSearchParamterChooseView.h"
#import "IMBBorderRectAndColorView.h"
#import "IMBTransferViewController.h"
#import "IMBTransferTipShadowsView.h"
#import "IMBCurrencySvgButton.h"
#import "IMBDrawImageBtn.h"
#import "IMBSearchCloudViewController.h"


@implementation IMBMainPageViewController

- (id)initWithDelegate:(id)delegate CloudEntity:(IMBCloudEntity *)curCloudEntity {
    if (self = [super initWithNibName:@"IMBMainPageViewController" bundle:nil]) {
        _curCloudEntity = [curCloudEntity retain];
        _delegate = delegate;
        _nc = [NSNotificationCenter defaultCenter];
        [_nc addObserver:self selector:@selector(removeAddMenuView:) name:GLOBAL_MOUSE_DOWN object:nil];
        [_nc addObserver:self selector:@selector(changeSearchView:) name:GLOBAL_MOUSE_DOWN object:nil];
        [_nc addObserver:self selector:@selector(closeTransferView:) name:GLOBAL_MOUSE_DOWN object:nil];
        _driveViewDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_driveViewDic) {
        [_driveViewDic release];
        _driveViewDic = nil;
    }
    if (_addMenu) {
        [_addMenu removeFromSuperview];
        [_addMenu release];
        _addMenu = nil;
    }
    if (_curCloudEntity) {
        [_curCloudEntity release];
        _curCloudEntity = nil;
    }
    if (_baseViewController) {
        [_baseViewController release];
        _baseViewController = nil;
    }
    [_nc removeObserver:self];
    [super dealloc];
}

- (void)awakeFromNib {
    [self configTopViewContent];
    _searchView.delegate = self;
    [self.view addSubview:_searchView positioned:NSWindowAbove relativeTo:_detailView];
    [_searchView setFrame:NSMakeRect(ceil((self.view.frame.size.width - 288)/2.0), ceil(self.view.frame.size.height - 38 - 10), 288, 38)];
    [_searchView setSearchType:unUseType];
    [_chooseSearchParaterView setTarget:self];
    [_chooseSearchParaterView setAction:@selector(chooseSearchParameter:)];
    
    [_clearSearchBtn setSvgFileName:@"menu_close" withUseFillColor:NO withSVGSize:NSMakeSize(12, 12) withEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] withOutColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] withDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
    
    NSMutableArray *ary = [[IMBCloudManager singleton].driveManager driveArray];
    IMBCloudEntity *cloudEntity = [[IMBCloudEntity alloc] init] ;
    if (ary.count == 1) {
        BaseDrive *drive = [ary objectAtIndex:0];
        [TempHelper setDriveDefultImage:drive CloudEntity:cloudEntity];
    }else {
        cloudEntity.name = CustomLocalizedString(@"SearchControl_AllCloud", nil);
        cloudEntity.image = [NSImage imageNamed:@"search_all"];
        cloudEntity.driveID = @"";
    }
    
    _currentFileType = AllFile;
    _currentDateType = AnytimeEnum;
    
    [_searchView setSelectedCloudEntity:cloudEntity];
    [cloudEntity release], cloudEntity = nil;
    [_searchView.cloudImage setImage:_searchView.selectedCloudEntity.image];
    [_searchView.cloudImageView setImage:_searchView.selectedCloudEntity.image];
    [_searchView.selectedNameTextFiled setStringValue: _searchView.selectedCloudEntity.name];
    [_searchView.selectedTypeTextFiled setStringValue:CustomLocalizedString(@"SearchControl_Type1", nil)];
    [_searchView.selectedTimeTextFiled setStringValue:CustomLocalizedString(@"SearchControl_Time1", nil)];
    [_searchView setNeedsDisplay:YES];
    [_topView setIsOffSetY:YES];
    [_topView setOffsetY:4];
    [_topView setLuCorner:NO LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setNeedsDisplay:YES];
    
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    cloudManager.transferViewController = [[IMBTransferViewController alloc] initWithNibName:@"IMBTransferViewController" bundle:nil];
    [_transferTipView setTarget:self];
    [_transferTipView setAction:@selector(closeTransferTipView:)];

}

#pragma mark - 切换云盘详细页面方法
- (void)cloudDriveDetailSwitch:(IMBCloudEntity *)cloudEnity {
    BOOL isReslease = NO;
    IMBBaseViewController *viewController = nil;
    [_addButton setHidden:YES];
    if (cloudEnity.categoryCloudEnum == AccountBtnEnum) {//账号详细页面按钮
        if ([_driveViewDic.allKeys containsObject:ACCOUNT_DETAIL_PAGE]) {
            viewController = [_driveViewDic objectForKey:ACCOUNT_DETAIL_PAGE];
            [(IMBHomePageViewController *)viewController configRecentlyVisitsView];
        }else {
            isReslease = YES;
            viewController = [[IMBHomePageViewController alloc] initWithDelegate:_delegate];
            [_driveViewDic setObject:viewController forKey:ACCOUNT_DETAIL_PAGE];
        }
    }else if (cloudEnity.categoryCloudEnum == HistoryBtnEnum) {//_historyBtn
        if ([_driveViewDic.allKeys containsObject:ACCOUNT_HISTORY_PAGE]) {
            viewController = [_driveViewDic objectForKey:ACCOUNT_HISTORY_PAGE];
            [(IMBHistoryViewController *)viewController loadFileHistoryRecords];
        }else {
            viewController = [[IMBHistoryViewController alloc] initWithDelegate:_delegate];
            [_driveViewDic setObject:viewController forKey:ACCOUNT_HISTORY_PAGE];
        }
    }else if (cloudEnity.categoryCloudEnum == ShareBtnEnum) {//_shareBtn
        if ([_driveViewDic.allKeys containsObject:ACCOUNT_SHARE_PAGE]) {
            viewController = [_driveViewDic objectForKey:ACCOUNT_SHARE_PAGE];
        }else {
            viewController = [[IMBShareViewController alloc] initWithDelegate:_delegate];
            [_driveViewDic setObject:viewController forKey:ACCOUNT_SHARE_PAGE];
        }
    }else if (cloudEnity.categoryCloudEnum == StarBtnEnum) {//_starBtn
        if ([_driveViewDic.allKeys containsObject:ACCOUNT_STAR_PAGE]) {
            viewController = [_driveViewDic objectForKey:ACCOUNT_STAR_PAGE];
        }else {
            viewController = [[IMBStarViewController alloc] initWithDelegate:_delegate];
            [_driveViewDic setObject:viewController forKey:ACCOUNT_STAR_PAGE];
        }
    }else if (cloudEnity.categoryCloudEnum == TrashBtnEnum) {//_trashBtn
        if ([_driveViewDic.allKeys containsObject:ACCOUNT_TRASH_PAGE]) {
            viewController = [_driveViewDic objectForKey:ACCOUNT_TRASH_PAGE];
        }else {
            viewController = [[IMBTrashViewController alloc] initWithDelegate:_delegate];
            [_driveViewDic setObject:viewController forKey:ACCOUNT_TRASH_PAGE];
        }
    }else if (cloudEnity.categoryCloudEnum == iCloudDriveEnum) {
        [_addButton setHidden:NO];
        if ([_driveViewDic.allKeys containsObject:cloudEnity.driveID]) {
            viewController = [_driveViewDic objectForKey:cloudEnity.driveID];
            [(IMBAllCloudViewController *)viewController loadDriveComplete:cloudEnity.cloudAry WithEvent:loadAction];
        }else {
            viewController = [[IMBAllCloudViewController alloc] initWithDelegate:_delegate withCloudEntity:cloudEnity];
            [(IMBAllCloudViewController *)viewController loadDriveComplete:cloudEnity.cloudAry WithEvent:loadAction];
            [_driveViewDic setObject:viewController forKey:cloudEnity.driveID];
        }
    }else {
        [_addButton setHidden:NO];
        if ([_driveViewDic.allKeys containsObject:cloudEnity.driveID]) {
            viewController = [_driveViewDic objectForKey:cloudEnity.driveID];
        }else {
            viewController = [[IMBAllCloudViewController alloc] initWithDelegate:_delegate withDriveID:cloudEnity.driveID];
            viewController.displayDelegate = self;
            [_driveViewDic setObject:viewController forKey:cloudEnity.driveID];
        }
    }
    [_detailBox setContentView:viewController.view];
    _baseViewController = [viewController retain];
    if (isReslease) {
        [viewController release];
    }
}

#pragma mark - 配置topView
- (void)configTopViewContent {
    [_addButton setIsAddButton:YES];
    [_addButton setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_addButton setButtonTitle:CustomLocalizedString(@"TopControl_Add", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_addButton setSpaceWithText:4];
    [_addButton setTarget:self];
    [_addButton setAction:@selector(addNewButtonClick:)];
    [_addButton setNeedsDisplay:YES];
    
    _addMenu = [[IMBAddMenuView alloc] initWithFrame:NSMakeRect(_addButton.frame.origin.x - 4, _addButton.frame.origin.y - 288 + _topView.frame.origin.y, 218, 298 - 7)];
    for (int itemTag = 1; itemTag <= 5; itemTag++) {
        IMBAddItem *item = [[IMBAddItem alloc] initWithFrame:NSMakeRect(5, 222 - (itemTag - 1)*52, 208, 52)];
        [item setItemTag:itemTag];
        [item setTarget:self];
        [item setAction:@selector(menuItemClick:)];
        [_addMenu addSubview:item];
        [item release];
        item = nil;
    }
    
    [_syncButton mouseDownImage:[NSImage imageNamed:@"menu_sync3"] withMouseUpImg:[NSImage imageNamed:@"menu_sync2"] withMouseExitedImg:[NSImage imageNamed:@"menu_sync"] mouseEnterImg:[NSImage imageNamed:@"menu_sync2"]];
    [_syncButton setTarget:self];
    [_syncButton setAction:@selector(showOrCloseSyncView)];
    [_transferButton mouseDownImage:[NSImage imageNamed:@"menu_transfer3"] withMouseUpImg:[NSImage imageNamed:@"menu_transfer2"] withMouseExitedImg:[NSImage imageNamed:@"menu_transfer"] mouseEnterImg:[NSImage imageNamed:@"menu_transfer2"]];
    [_transferButton setTarget:self];
    [_transferButton setAction:@selector(showOrCloseTransferView)];
}

#pragma mark - button action
- (void)addNewButtonClick:(id)sender {
    
    if ([_addMenu superview]) {
        [self removeAddMenuViewAnimation];
    } else {
        [_addButton setIsOpenMenu:YES];
        
        [_addMenu setFrameOrigin:NSMakePoint(_addButton.frame.origin.x - 4, _addButton.frame.origin.y + _topView.frame.origin.y - 288)];
        _isOpenMenu = YES;
        [_addMenu setWantsLayer:YES];
        
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        transition.removedOnCompletion = NO;
        transition.fillMode = kCAFillModeForwards;
        [_addMenu.layer addAnimation:transition forKey:@"animation"];
        [self.view addSubview:_addMenu];
        [_nc postNotificationName:DISABLE_ENTER_STATE object:[NSNumber numberWithBool:YES]];
    }
}

- (void)menuItemClick:(id)sender {
    int itemTag = [(IMBAddItem *)sender itemTag];
    if (itemTag == 1) {//新建文件夹
        [_baseViewController createFolder:nil];
    } else if (itemTag == 2) {//上传文件
        [_baseViewController uploadFile:nil];
    } else if (itemTag == 3) {//上传文件夹
        [_baseViewController uploadFolder:nil];
    } else if (itemTag == 4) {//同步
        [_baseViewController sync:nil];
    } else if (itemTag == 5) {//添加cloud
        [_delegate gotoAddCloudView:nil];
    }
    [self removeAddMenuViewAnimation];
}

- (void)removeAddMenuView:(NSNotification *)notification {
    NSEvent *theEvent = notification.object;
    NSPoint point = [_addMenu convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [_addMenu bounds], [_addMenu isFlipped]);
    
    NSPoint point1 = [_addButton convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner1 = NSMouseInRect(point1, [_addButton bounds], [_addButton isFlipped]);
    
    if (_isOpenMenu) {
        if (!inner && !inner1) {
            [self removeAddMenuViewAnimation];
        }
    }
}

- (void)removeAddMenuViewAnimation {
    [_addButton setIsOpenMenu:NO];
    _isOpenMenu = NO;
    [_addMenu removeFromSuperview];
    [_nc postNotificationName:DISABLE_ENTER_STATE object:[NSNumber numberWithBool:NO]];
}

- (void)showOrCloseSyncView {
    
}

#pragma mark - 传输界面
- (void)showOrCloseTransferView {
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    IMBTransferViewController *transferViewController = cloudManager.transferViewController;
    if (transferViewController.view.superview) {
        [transferViewController.view.layer removeAllAnimations];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            CABasicAnimation *animation = [IMBAnimation moveX:0.5 X:[NSNumber numberWithFloat:transferViewController.view.frame.size.width] repeatCount:0 beginTime:0.0];
            [transferViewController.view.layer addAnimation:animation forKey:@"1"];
        } completionHandler:^{
            [transferViewController.view removeFromSuperview];
        }];
    }else {
        [transferViewController.view.layer removeAllAnimations];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [_contentBox setContentView:transferViewController.view];
            [transferViewController.view setWantsLayer:YES];
            CABasicAnimation *animation = [IMBAnimation moveX:0.6 fromX:[NSNumber numberWithFloat:transferViewController.view.frame.size.width] toX:@0 repeatCount:0 beginTime:0.0];
            [transferViewController.view.layer addAnimation:animation forKey:@"1"];
        } completionHandler:^{
            [transferViewController.view setFrame:NSMakeRect(0, 0, transferViewController.view.frame.size.width, transferViewController.view.frame.size.height)];
        }];
    }
}

- (void)showTransferView {
    
}

- (void)closeTransferView:(NSNotification *)notification {
    NSEvent *envent = notification.object;
    NSPoint point = envent.locationInWindow;
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    IMBTransferViewController *transferViewController = cloudManager.transferViewController;
    //是否是popover
    BOOL popOverShown =  [transferViewController.devPopover isShown];
    
    if (!NSMouseInRect(point, NSMakeRect(_contentBox.frame.origin.x + 74, _contentBox.frame.origin.y, _contentBox.frame.size.width, _contentBox.frame.size.height), [_contentBox isFlipped]) && !NSMouseInRect(point, NSMakeRect(_transferButton.frame.origin.x + 74, _transferButton.frame.origin.y  + self.view.frame.size.height - 58, _transferButton.frame.size.width, _transferButton.frame.size.height), [_transferButton isFlipped])  && !NSMouseInRect(point, NSMakeRect(_syncButton.frame.origin.x + 74, _syncButton.frame.origin.y  + self.view.frame.size.height - 58, _syncButton.frame.size.width, _syncButton.frame.size.height + self.view.frame.size.height), [_syncButton isFlipped]) && transferViewController.view.superview && !popOverShown) {
        [transferViewController.view.layer removeAllAnimations];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            CABasicAnimation *animation = [IMBAnimation moveX:0.5 X:[NSNumber numberWithFloat:transferViewController.view.frame.size.width] repeatCount:0 beginTime:0.0];
            [transferViewController.view.layer addAnimation:animation forKey:@"1"];
        } completionHandler:^{
            [transferViewController.view removeFromSuperview];
        }];
    }
}

- (void)showTransferTipViewWithCount:(int)count isDownLoad:(BOOL)isDownLoad {
    [_transferTipView setFrame:NSMakeRect(ceil(self.view.frame.size.width - _transferTipView.frame.size.width - 6), ceil(self.view.frame.size.height - _transferTipView.frame.size.height - 50), _transferTipView.frame.size.width, _transferTipView.frame.size.height)];
    if (isDownLoad) {
        [_transferTipView setShowString:[[NSString stringWithFormat:CustomLocalizedString(@"TransferControl_Tips", nil),count] stringByAppendingString:CustomLocalizedString(@"TransferControl_Downloading", nil)]];
    }else {
        [_transferTipView setShowString:[[NSString stringWithFormat:CustomLocalizedString(@"TransferControl_Tips", nil),count] stringByAppendingString:CustomLocalizedString(@"TransferControl_Uploading", nil)]];
    }
    [_transferTipView setAutoresizingMask:NSViewMinXMargin | NSViewMinYMargin ];
    [_transferTipView setWantsLayer:YES];
    [self.view addSubview:_transferTipView positioned:NSWindowAbove relativeTo:_detailView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(closeTransferTipView:) userInfo:nil repeats:NO];
}

- (void)closeTransferTipView:(id)sender {
    [_transferTipView removeFromSuperview];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark - 改变SearchView的Frame
- (void)changeSearchView:(NSNotification *)noti {
    NSEvent *envent = noti.object;
    NSPoint point = envent.locationInWindow;
    if (NSMouseInRect(point, NSMakeRect(_searchView.frame.origin.x + 74, _searchView.frame.origin.y, _searchView.frame.size.width, _searchView.frame.size.height), [_searchView isFlipped]) || (NSMouseInRect(point, NSMakeRect(_chooseSearchParaterView.frame.origin.x + 74, _chooseSearchParaterView.frame.origin.y, _chooseSearchParaterView.frame.size.width, _chooseSearchParaterView.frame.size.height), [_chooseSearchParaterView isFlipped]) && [_chooseSearchParaterView superview])) {
        if (_searchView.searchType == unUseType) {
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                [[_searchView animator] setFrame:NSMakeRect(ceil((self.view.frame.size.width - 480)/2.0), ceil(self.view.frame.size.height - 38 - 10), 480, 38)];
                context.duration = 2.0;
            } completionHandler:^{
//                [_searchView setWantsLayer:YES];
                [_searchView setSearchType:useType];
            }];
        }
    }else {
        if ([StringHelper stringIsNilOrEmpty:_searchView.searchTextFiled.stringValue]) {
            if (_searchView.searchType != unUseType) {
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                    [[_searchView animator] setFrame:NSMakeRect(ceil((self.view.frame.size.width - 288)/2.0), ceil(self.view.frame.size.height - 38 - 10), 288, 38)];
                    context.duration = 2.0;
                } completionHandler:^{
                    [_searchView setFrame:NSMakeRect(ceil((self.view.frame.size.width - 288)/2.0), ceil(self.view.frame.size.height - 38 - 10), 288, 38)];
                    [_searchView.searchTextFiled resignFirstResponder];
                    [_searchView.searchTextFiled abortEditing];
                    _searchView.searchType = unUseType;
                }];
                [_chooseSearchParaterView removeFromSuperview];
            }
        }else {
            if (_searchView.searchType == pullDownType) {
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                    [[_searchView animator] setFrame:NSMakeRect(ceil((self.view.frame.size.width - 480)/2.0), ceil(self.view.frame.size.height - 38 - 10), 480, 38)];
                    context.duration = 2.0;
                } completionHandler:^{
//                    [_searchView setWantsLayer:YES];
                    _searchView.searchType = useType;
                }];
                [_chooseSearchParaterView removeFromSuperview];
            }

        }
    }
}

- (void)pullDownSearchView {
    if (_searchView.searchType == pullDownType) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [[_searchView animator] setFrame:NSMakeRect(ceil((self.view.frame.size.width - 480)/2.0), ceil(self.view.frame.size.height - 38 - 10), 480, 38)];
            context.duration = 2.0;
        } completionHandler:^{
            [_searchView setFrame:NSMakeRect(ceil((self.view.frame.size.width - 480)/2.0), ceil(self.view.frame.size.height - 38 - 10), 480, 38)];
            _searchView.searchType = useType;
        }];

    }else {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
//            [_searchView setWantsLayer:YES];
            [_searchView removeFromSuperview];
            [self.view addSubview:_searchView positioned:NSWindowAbove relativeTo:_detailView];
            [[_searchView animator] setFrame:NSMakeRect(ceil((self.view.frame.size.width - 480)/2.0), ceil(self.view.frame.size.height - 186 - 10), 480, 186)];
            context.duration = 2.0;
        } completionHandler:^{
            [_searchView setFrame:NSMakeRect(ceil((self.view.frame.size.width - 480)/2.0), ceil(self.view.frame.size.height - 186 - 10), 480, 186)];
            _searchView.searchType = pullDownType;
        }];
    }
}

- (void)pullDownSearchParameter:(id)sender {
    IMBDrawImageBtn *btn = (IMBDrawImageBtn *)sender;
    if (_chooseSearchParaterView.superview) {
        if (_pullDownIndex == 1) {
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_chooseSearchParaterView.frame.origin.x,  _searchView.frame.origin.y + _searchView.secondLineView.frame.origin.y - 1,346,1)];
                context.duration = 2.0;
            } completionHandler:^{
                [_chooseSearchParaterView removeFromSuperview];
            }];
        }else if (_pullDownIndex == 2) {
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_chooseSearchParaterView.frame.origin.x,  _searchView.frame.origin.y + _searchView.thirdLineView.frame.origin.y - 1,346,1)];
                context.duration = 2.0;
            } completionHandler:^{
                [_chooseSearchParaterView removeFromSuperview];
            }];
        }else if (_pullDownIndex == 3) {
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_chooseSearchParaterView.frame.origin.x, _searchView.frame.origin.y + _searchView.fourthLineView.frame.origin.y - 1,346,1)];
                context.duration = 2.0;
            } completionHandler:^{
                [_chooseSearchParaterView removeFromSuperview];
            }];
        }
        
    }else {
        [_chooseSearchParaterView setWantsLayer:YES];
        if (btn.tag == 1) {//打开选择网盘下拉框
            _pullDownIndex = 1;
            NSMutableArray *ary = [[IMBCloudManager singleton].driveManager driveArray];
            [_chooseSearchParaterView setChooseCloudAry:ary];
            [_chooseSearchParaterView setFrame:NSMakeRect(_searchView.frame.origin.x + _searchView.secondLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.secondLineView.frame.origin.y - 1,346,1)];
            [self.view addSubview:_chooseSearchParaterView];
            int count = (int) ary.count > 1 ? (int)(ary.count + 1) : 1;
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_searchView.frame.origin.x + _searchView.secondLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.secondLineView.frame.origin.y - (count*30 + 5),346,(count*30 + 5))];
                context.duration = 2.0;
            } completionHandler:^{
                [_chooseSearchParaterView setFrameOrigin:NSMakePoint(_searchView.frame.origin.x + _searchView.secondLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.secondLineView.frame.origin.y - (count*30 + 5))];
            }];
        }else if(btn.tag == 2) {//打开选择类型下拉框
            _pullDownIndex = 2;
            NSMutableArray *aryM = [[NSMutableArray alloc] init];
            [self congfigFileTypeAryM:aryM];
            [_chooseSearchParaterView setchooseStyleOrTimeAry:aryM];
            
            [_chooseSearchParaterView setFrame:NSMakeRect(_searchView.frame.origin.x + _searchView.thirdLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.thirdLineView.frame.origin.y - 1,346,1)];
            [self.view addSubview:_chooseSearchParaterView];
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_searchView.frame.origin.x + _searchView.thirdLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.thirdLineView.frame.origin.y - (aryM.count*30 + 5),346,(aryM.count*30 + 5))];
                context.duration = 2.0;
            } completionHandler:^{
                [_chooseSearchParaterView setFrameOrigin:NSMakePoint(_searchView.frame.origin.x + _searchView.thirdLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.thirdLineView.frame.origin.y - (aryM.count*30 + 5))];
            }];
            [aryM release];
        }else if(btn.tag == 3) {//打开时间类型下拉框
            _pullDownIndex = 3;
             NSMutableArray *aryM = [[NSMutableArray alloc] init];
            [self congfigDateTypeAryM:aryM];
            [_chooseSearchParaterView setchooseStyleOrTimeAry:aryM];

            [_chooseSearchParaterView setFrame:NSMakeRect(_searchView.frame.origin.x + _searchView.fourthLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.fourthLineView.frame.origin.y - 1,346,1)];
            [self.view addSubview:_chooseSearchParaterView];
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_searchView.frame.origin.x + _searchView.fourthLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.fourthLineView.frame.origin.y - (aryM.count*30 + 5),346,aryM.count*30 + 5)];
                context.duration = 2.0;
            } completionHandler:^{
                [_chooseSearchParaterView setFrameOrigin:NSMakePoint(_searchView.frame.origin.x + _searchView.fourthLineView.frame.origin.x - 5, _searchView.frame.origin.y + _searchView.fourthLineView.frame.origin.y - (aryM.count*30 + 5))];
            }];
            [aryM release];
        }
    }
}

- (void)congfigFileTypeAryM:(NSMutableArray *)aryM {
    IMBParamterItem *item1 = [[IMBParamterItem alloc] init];
    item1.title = CustomLocalizedString(@"SearchControl_Type1", nil);
    item1.fileType = AllFile;
    [aryM addObject:item1];
    [item1 release], item1 = nil;
    
    IMBParamterItem *item2 = [[IMBParamterItem alloc] init];
    item2.title = CustomLocalizedString(@"SearchControl_Type2", nil);
    item2.fileType = MovieFile;
    [aryM addObject:item2];
    [item2 release], item2 = nil;
    
    IMBParamterItem *item3 = [[IMBParamterItem alloc] init];
    item3.title = CustomLocalizedString(@"SearchControl_Type3", nil);
    item3.fileType = DocFile;
    [aryM addObject:item3];
    [item3 release], item3 = nil;
    
    IMBParamterItem *item4 = [[IMBParamterItem alloc] init];
    item4.title = CustomLocalizedString(@"SearchControl_Type4", nil);
    item4.fileType = ImageFile;
    [aryM addObject:item4];
    [item4 release], item4 = nil;
    
    IMBParamterItem *item5 = [[IMBParamterItem alloc] init];
    item5.title = CustomLocalizedString(@"SearchControl_Type5", nil);
    item5.fileType = Folder;
    [aryM addObject:item5];
    [item5 release], item5 = nil;
    
    IMBParamterItem *item6 = [[IMBParamterItem alloc] init];
    item6.title = CustomLocalizedString(@"SearchControl_Type6", nil);
    item6.fileType = MusicFile;
    [aryM addObject:item6];
    [item6 release], item6 = nil;
}

- (void)congfigDateTypeAryM:(NSMutableArray *)aryM {
    IMBParamterItem *item1 = [[IMBParamterItem alloc] init];
    item1.title = CustomLocalizedString(@"SearchControl_Time1", nil);
    item1.dateType = AnytimeEnum;
    [aryM addObject:item1];
    [item1 release], item1 = nil;
    
    IMBParamterItem *item2 = [[IMBParamterItem alloc] init];
    item2.title = CustomLocalizedString(@"SearchControl_Time2", nil);
    item2.dateType = ToDayEnum;
    [aryM addObject:item2];
    [item2 release], item2 = nil;
    
    IMBParamterItem *item3 = [[IMBParamterItem alloc] init];
    item3.title = CustomLocalizedString(@"SearchControl_Time3", nil);
    item3.dateType = YesterdayEnum;
    [aryM addObject:item3];
    [item3 release], item3 = nil;
    
    IMBParamterItem *item4 = [[IMBParamterItem alloc] init];
    item4.title = CustomLocalizedString(@"SearchControl_Time4", nil);
    item4.dateType = Last7Enum;
    [aryM addObject:item4];
    [item4 release], item4 = nil;
    
    IMBParamterItem *item5 = [[IMBParamterItem alloc] init];
    item5.title = CustomLocalizedString(@"SearchControl_Time5", nil);
    item5.dateType = Last30Enum;
    [aryM addObject:item5];
    [item5 release], item5 = nil;
}

- (void)chooseSearchParameter:(id)sender {
    if (_pullDownIndex == 1) {//选择网盘
        if ([sender isKindOfClass:[IMBCloudEntity class]]) {
            IMBCloudEntity *entity = (IMBCloudEntity *)sender;
            [_searchView.cloudImageView setImage:entity.image];
            [_searchView.selectedNameTextFiled setStringValue:entity.name];
            [_searchView.cloudImage setImage:entity.image];
        }
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_chooseSearchParaterView.frame.origin.x,  _searchView.frame.origin.y + _searchView.secondLineView.frame.origin.y - 1,346,1)];
            context.duration = 2.0;
        } completionHandler:^{
            [_chooseSearchParaterView removeFromSuperview];
        }];

    }else if (_pullDownIndex == 2) {//选择类型
        if ([sender isKindOfClass:[IMBParamterItem class]]) {
            IMBParamterItem *item = (IMBParamterItem *)sender;
            [_searchView.selectedTypeTextFiled setStringValue:item.title];
            _currentFileType = item.fileType;
        }
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_chooseSearchParaterView.frame.origin.x,  _searchView.frame.origin.y + _searchView.thirdLineView.frame.origin.y - 1,346,1)];
            context.duration = 2.0;
        } completionHandler:^{
            [_chooseSearchParaterView removeFromSuperview];
        }];

    }else {//选择时间
        if ([sender isKindOfClass:[IMBParamterItem class]]) {
            IMBParamterItem *item = (IMBParamterItem *)sender;
            [_searchView.selectedTimeTextFiled setStringValue:item.title];
            _currentDateType = item.dateType;
        }
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [[_chooseSearchParaterView animator] setFrame:NSMakeRect(_chooseSearchParaterView.frame.origin.x, _searchView.frame.origin.y + _searchView.fourthLineView.frame.origin.y - 1,346,1)];
            context.duration = 2.0;
        } completionHandler:^{
            [_chooseSearchParaterView removeFromSuperview];
        }];
    }
}
#pragma mark - search
- (void)clearSearch:(id)sender {
    _searchViewController.searchManager.isCancel = YES;
}

- (void)startSearch:(id)sender {
    if ([_driveViewDic.allKeys containsObject:ACCOUNT_SEARCH_PAGE]) {
        _searchViewController = [_driveViewDic objectForKey:ACCOUNT_SEARCH_PAGE];
        
    }else {
       _searchViewController = [[IMBSearchCloudViewController alloc] initWithDelegate:self];
        [_driveViewDic setObject:_searchViewController forKey:ACCOUNT_SEARCH_PAGE];
    }
    [_searchViewController searchName:_searchView.searchTextFiled.stringValue WithCloudDriveID:_searchView.selectedCloudEntity.driveID WithFileType:_currentFileType WithDate:_currentDateType];
    [_detailBox setContentView:_searchViewController.view];
    
}


@end
