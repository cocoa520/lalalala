//
//  IMBHomePageViewController.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBHomePageViewController.h"
#import "StringHelper.h"
#import "IMBCloudEntity.h"
#import "IMBCloudManager.h"
#import "IMBMainViewController.h"
#import "IMBToolBarButton.h"
#import "IMBMoreMenuView.h"
#import "IMBCustomView.h"
#import "IMBCollectionItemView.h"

@interface IMBHomePageViewController ()

@end

@implementation IMBHomePageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (id)initWithDelegate:(id)delegate {
    if (self = [super initWithNibName:@"IMBHomePageViewController" bundle:nil]) {
        _delegate = delegate;
        _nc = [NSNotificationCenter defaultCenter];
        [self addNotification];
    }
    return self;
}

- (void)dealloc {
    if (_fileHistoryView) {
        [_fileHistoryView release];
        _fileHistoryView = nil;
    }
    if (_fileItemView) {
        [_fileItemView release];
        _fileItemView = nil;
    }
    if (_fileHistoryArr) {
        [_fileHistoryArr release];
        _fileHistoryArr = nil;
    }
    if (_moreMenu) {
        [_moreMenu release];
        _moreMenu = nil;
    }
    if (_cloudViewController) {
        [_cloudViewController release];
        _cloudViewController = nil;
    }
    if (_fileViewController) {
        [_fileViewController release];
        _fileViewController = nil;
    }
    [_nc removeObserver:self name:NSWindowDidResizeNotification object:nil];
    [_nc removeObserver:self name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc removeObserver:self name:GLOBAL_MOUSE_MOVE object:nil];
    [_nc removeObserver:self name:HomeClickCollectionEvent object:nil];
    [_nc removeObserver:self name:HomeFileClickCollectionEvent object:nil];
    [_nc removeObserver:self name:HistoryDriveSuccessedNotification object:nil];
    [_nc removeObserver:self name:HistoryDriveErroredNotification object:nil];
    [super dealloc];
}

- (void)awakeFromNib {
    
    _oldItemCount1 = 0;
    _oldItemCount2 = 0;
    [_midViewTitle setStringValue:CustomLocalizedString(@"AccountHomePage_RV", nil)];
    [_midViewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_bottomViewTitle setStringValue:CustomLocalizedString(@"AccountHomePage_FV", nil)];
    [_bottomViewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    
    [self configPersonalView];
    
    if (!_cloudViewController) {
        _cloudViewController = [[IMBHomeCloudViewController alloc] initWithNibName:@"IMBHomeCloudViewController" bundle:nil];
    }
    [_midBox setContentView:_cloudViewController.view];
    [self configRecentlyVisitsView];
    
    if (!_fileViewController) {
        _fileViewController = [[IMBHomeFileViewController alloc] initWithDelegate:self];
    }
    [_bottomBox setContentView:_fileViewController.view];
    [self configFrequentVisitsView];
}

- (void)addNotification {
    [_nc addObserver:self selector:@selector(windowScreenChange:) name:NSWindowDidResizeNotification object:nil];
    [_nc addObserver:self selector:@selector(removeMoreMenuView:) name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc addObserver:self selector:@selector(itemViewMouseMove:) name:GLOBAL_MOUSE_MOVE object:nil];
    [_nc addObserver:self selector:@selector(homeClickCollectionEvent:) name:HomeClickCollectionEvent object:nil];
    [_nc addObserver:self selector:@selector(homeFileClickCollectionEvent:) name:HomeFileClickCollectionEvent object:nil];
    [_nc addObserver:self selector:@selector(configFrequentVisitsView) name:HistoryDriveSuccessedNotification object:nil];
    [_nc addObserver:self selector:@selector(configFrequentVisitsView) name:HistoryDriveErroredNotification object:nil];
}

#pragma mark - 配置视图
//账户信息
- (void)configPersonalView {
    LoginAuthorizationDriveEntity *userInfoEntity = [IMBCloudManager singleton].driveManager.loginEntity;
    NSImage *headImage = nil;
    if (![StringHelper stringIsNilOrEmpty:userInfoEntity.avatar] && ![userInfoEntity.avatar isKindOfClass:[NSNull class]]) {
        NSURL *imageUrl = [NSURL URLWithString:userInfoEntity.avatar];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        NSImage *image = [[NSImage alloc] initWithData:imageData];
        headImage = [image retain];
        [image release];
    } else {
        headImage = [[NSImage imageNamed:@"def_person"] retain];
    }
    [_headImageView setImage:headImage];
    [headImage release];
    
    if (![StringHelper stringIsNilOrEmpty:userInfoEntity.nickName]) {
        [_homePageTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"HomeViewTitle", nil),userInfoEntity.nickName]];
    } else {
        [_homePageTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"HomeViewTitle", nil),CustomLocalizedString(@"unknown_id", nil)]];
    }
    [_homePageTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_upgradeBtn setButtonWithTitle:CustomLocalizedString(@"AccountHomePage_Upgreate", nil) WithFontSize:14.0 WithTitleColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithTitleEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithTitleDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
    [_upgradeBtn setTarget:self];
    [_upgradeBtn setAction:@selector(goUpgradeBtnClick)];
    
    [_editPersonBtn setButtonWithTitle:CustomLocalizedString(@"AccountHomePage_EditUserInfo", nil) WithFontSize:14.0 WithTitleColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithTitleEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithTitleDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
    [_editPersonBtn setTarget:self];
    [_editPersonBtn setAction:@selector(goUpgradeBtnClick)];
    
    NSRect upgradeBtnRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"AccountHomePage_Upgreate", nil) font:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_upgradeBtn setFrame:NSMakeRect(0, _upgradeBtn.frame.origin.y, upgradeBtnRect.size.width, _upgradeBtn.frame.size.height)];
    [_spaceLine setFrameOrigin:NSMakePoint(_upgradeBtn.frame.origin.x + upgradeBtnRect.size.width + 10, _spaceLine.frame.origin.y)];
    [_editPersonBtn setFrameOrigin:NSMakePoint(_spaceLine.frame.origin.x + 10, _editPersonBtn.frame.origin.y)];
    
    NSString *promptStr = [CustomLocalizedString(@"HomeView_Task_Tips", nil) stringByAppendingString:CustomLocalizedString(@"HomeView_Task_Tips1", nil)];
    [_memoryDescription setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"HomeView_Task_Tips1", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    
    [_memoryProgress setProgress:60];
    
}

//最近访问云历史记录信息
- (void)configRecentlyVisitsView {
    if (!_isChanging) {
        _isChanging = YES;
        NSArray *driveArray = [IMBCloudManager singleton].driveManager.driveArray;
        float wiewWidth = _cloudViewController.view.frame.size.width - 158;
        if (wiewWidth == 0) {
            wiewWidth = 990;
        }
        int cloudItemCount = (int)wiewWidth/270;
        if (cloudItemCount > driveArray.count) {
            cloudItemCount = (int)driveArray.count;
        }
        cloudItemCount += 1;
        if (cloudItemCount != _oldItemCount1) {
            [_cloudViewController loadDataAry:cloudItemCount];
            _oldItemCount1 = cloudItemCount;
        }
        _isChanging = NO;
    }
}

//频繁访问的文件历史记录信息
- (void)configFrequentVisitsView {
    if (!_isChangingFile && _fileViewController) {
        NSArray *fileAry = [[IMBCloudManager singleton] userTable].fileHisArray;
        if (fileAry.count > 0) {
            _isChangingFile = YES;
            float viewWidth = _fileViewController.view.frame.size.width;
            if (viewWidth == 0) {
                viewWidth = 990;
            }
            float viewHeigh = _fileViewController.view.frame.size.height;
            if (viewHeigh == 0) {
                viewHeigh = 182;
            }
            int widthItemCount = (int)viewWidth/176;
            int heighItemCount = (int)viewHeigh/182;
            int totalItemCount = widthItemCount * heighItemCount;
            
            if (totalItemCount > fileAry.count) {
                totalItemCount = (int)fileAry.count + 1;
            }
            if (totalItemCount != _oldItemCount2) {
                [_fileViewController loadDataAry:totalItemCount];
                _oldItemCount2 = totalItemCount;
            }
            _isChangingFile = NO;
        }else {
            [_bottomNoDataText setHidden:NO];
            [_bottomNoDataText setStringValue:CustomLocalizedString(@"AccountHomePage_NodataFV", nil)];
            [_bottomNoDataText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];

        }
    }
}

#pragma mark - action

- (void)goUpgradeBtnClick {
    
}

- (void)editPersonalBtnClick {
    
}

//文件访问历史  视图底部的四个按钮方法
- (void)fileHistoryButtonClick:(id)sender {
    IMBToolBarButton *bottomBtn = (IMBToolBarButton *)sender;
    if (_fileHistoryView) {
        [_fileHistoryView release];
        _fileHistoryView = nil;
    }
    _fileHistoryView = [(IMBFileHistoryView *)bottomBtn.superview.superview retain];
    if (_fileItemView) {
        [_fileItemView release];
        _fileItemView = nil;
    }
    _fileItemView = [(IMBFileItemView *)bottomBtn.superview retain];
    IMBCollectionItemView *itemView = (IMBCollectionItemView *)_fileHistoryView.superview;
    
    int buttonTag = (int)[bottomBtn tag];
    if (buttonTag == 1001) {//收藏
        
    } else if (buttonTag == 1002) {//分享
        
    } else if (buttonTag == 1003) {//同步
        
    } else if (buttonTag == 1004) {//点击更多
        
        [_fileItemView setIsOpenMenu:YES];
        [_fileHistoryView setIsOpenMenu:YES];
        
        NSArray *menuArr = [NSArray arrayWithObjects:@(syncAction),@(moveAction),@(copyAction),@(renameAction),@(deleteAction),nil];
        
//        if (model.isFolder) {
//            menuArr = [NSArray arrayWithObjects:@(downloadAction),@(moveAction),@(copyAction),@(renameAction),@(deleteAction),@(infoAction),nil];
//        }
        int menuHeight = (int)menuArr.count * 39 + 24;
        
        _moreMenu = [[IMBMoreMenuView alloc] initWithFrame:NSMakeRect(itemView.frame.origin.x + 139, _bottomBox.frame.size.height - itemView.frame.origin.y - itemView.frame.size.height + _bottomBox.frame.origin.y + 22, 180, menuHeight)];
        for (int itemTag = 1; itemTag <= menuArr.count; itemTag++) {
            IMBCustomView *bgView = [[IMBCustomView alloc] initWithFrame:NSMakeRect(5, menuHeight - 12 - itemTag*39, 170, 39)];
            IMBMoreItem *item = [[IMBMoreItem alloc] initWithFrame:NSMakeRect(-3, 0, 173, 39)];
            [item setItemTag:itemTag];
            [item setActionType:[[menuArr objectAtIndex:itemTag - 1] intValue]];
            [item setTarget:self];
            [item setAction:@selector(menuItemClick:)];
            [bgView addSubview:item];
            [_moreMenu addSubview:bgView];
            [item release];
            item = nil;
            [bgView release];
            bgView = nil;
        }
        
        [_moreMenu setFrameOrigin:NSMakePoint(itemView.frame.origin.x + 139, _bottomBox.frame.size.height - itemView.frame.origin.y - itemView.frame.size.height + _bottomBox.frame.origin.y + 22)];
        _isOpenMenu = YES;
        [_moreMenu setWantsLayer:YES];
        
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        transition.removedOnCompletion = NO;
        transition.fillMode = kCAFillModeForwards;
        [_moreMenu.layer addAnimation:transition forKey:@"animation"];
        [self.view addSubview:_moreMenu];
    }
}

//文件访问历史 最后一个更多按钮
- (void)fileHistoryItemClick:(id)sender {
    [_delegate gotoAddCloudView:sender];
}

- (void)menuItemClick:(id)sender {
    IMBMoreItem *moreItem = sender;
    ActionTypeEnum actionType = moreItem.actionType;
    if (actionType == downloadAction) {
        
    } else if (actionType == syncAction) {
        
    } else if (actionType == copyAction) {
        
    } else if (actionType == renameAction) {
        
    } else if (actionType == moveAction) {
        
    } else if (actionType == deleteAction) {
        
    }
    [self removeMoreMenuViewAnimation];
}

- (void)removeMoreMenuView:(NSNotification *)notifi {
    NSEvent *theEvent = notifi.object;
    NSPoint point = [_moreMenu convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [_moreMenu bounds], [_moreMenu isFlipped]);
    
    if (!inner && _isOpenMenu) {
        [self removeMoreMenuViewAnimation];
    }
}

- (void)removeMoreMenuViewAnimation {
    [_fileItemView setIsOpenMenu:NO];
    [_fileHistoryView setIsOpenMenu:NO];
    _isOpenMenu = NO;
    [_moreMenu removeFromSuperview];
    if (_moreMenu) {
        [_moreMenu release];
        _moreMenu = nil;
    }
}

//window大小变化
- (void)windowScreenChange:(NSNotification *)notification {
    [self configRecentlyVisitsView];
    [self configFrequentVisitsView];
}

//鼠标移动
- (void)itemViewMouseMove:(NSNotification *)notification {
    NSEvent *theEvent = notification.object;
    NSPoint point = [_fileHistoryView convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [_fileHistoryView bounds], [_fileHistoryView isFlipped]);
    
    NSPoint point1 = [_moreMenu convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner1 = NSMouseInRect(point1, [_moreMenu bounds], [_moreMenu isFlipped]);
    
    if (!inner && !inner1 && _isOpenMenu) {
        [self removeMoreMenuViewAnimation];
    }
}

//点击常用云盘按钮
- (void)homeClickCollectionEvent:(NSNotification *)notification {
    IMBCloudEntity *entity = notification.object;
    if (entity) {
        if ([entity.driveID isEqualToString:@"HomeAddID"]) {//点击增加云盘按钮
            [_delegate gotoAddCloudView:nil];
        }else {//点击到对应的云盘
            [_delegate gotoBindCloudView:entity.driveID];
        }
    }
}

//点击到history页面按钮
- (void)homeFileClickCollectionEvent:(NSNotification *)notification {
    IMBDriveModel *model = notification.object;
    if (model) {
        [_delegate gotoHistoryFileView];
    }
}

@end
