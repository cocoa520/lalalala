//
//  IMBMainViewController.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBMainViewController.h"
#import "TempHelper.h"
#import "NSString+Category.h"
#import "IMBCloudEntity.h"
#import "IMBSVGButton.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "AppDelegate.h"
#import "IMBAnimation.h"
#import "IMBBoxManager.h"
#import "IMBiCloudDriveLogInWindowController.h"
#import "IMBLowAddCloudViewController.h"

@interface IMBMainViewController ()

@end

@implementation IMBMainViewController
@synthesize navigationView = _navigationView;

- (void)dealloc {
    [_nc removeObserver:self name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc removeObserver:self name:NOTIEY_CHOOSE_CLOUD_BTN object:nil];
    [_cloudViewDic release], _cloudViewDic = nil;
    if (_devPopover != nil) {
        [_devPopover release];
        _devPopover = nil;
    }
    if (_mainPageMenuView) {
        [_mainPageMenuView removeFromSuperview];
        [_mainPageMenuView release];
        _mainPageMenuView = nil;
    }
    if (_toolTopShadowsView != nil) {
        [_toolTopShadowsView removeFromSuperview];
        [_toolTopShadowsView release];
        _toolTopShadowsView = nil;
    }
    if (_alertViewController) {
        [_alertViewController release];
        _alertViewController = nil;
    }
    [super dealloc];
}

- (id)initWithDelegate:(id)delegate {
    self = [super initWithNibName:@"IMBMainViewController" bundle:nil];
    if (self) {
        _delegate = delegate;
        //添加监听
        _nc = [NSNotificationCenter defaultCenter];
        [self addNotification];
    }
    return self;
}

- (void)awakeFromNib {
    //配置headButton
    [self configHeadButton];
    
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    
    _cloudViewDic = [[NSMutableDictionary alloc] init];
    
    [_lockBtn setBordered:NO];
    [_lockBtn setImagePosition:NSImageOnly];
    [_lockBtn setAllowsExpansionToolTips:NO];
    [_lockBtn setSvgFileName:@"menu_lock"];
    [_lockBtn setToolTipStr:CustomLocalizedString(@"Menu_LockCloud_Tips", nil)];
    [_lockBtn setDelegate:self];
    [_lockBtn setTarget:self];
    [_lockBtn setAction:@selector(lockWindow:)];
    [_lockBtn setIsUnlockBtn:YES];
    
    [_navigationView setDelegate:self];
    [_rightView setFrameOrigin:NSMakePoint(0, 0)];
    [_rightView setLuCorner:YES LbCorner:YES RuCorner:NO RbConer:NO CornerRadius:5];
    
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    NSArray *array = [cloudManager.driveManager driveArray];
    if (array.count > 0) {
        IMBCloudEntity *entity = [[IMBCloudEntity alloc] init];
        entity.categoryCloudEnum = AccountBtnEnum;
        IMBMainPageViewController *mainPageViewController = [[IMBMainPageViewController alloc] initWithDelegate:self CloudEntity:entity];
        [_contentBox setContentView:mainPageViewController.view];
        [_cloudViewDic setObject:mainPageViewController forKey:ACCOUNT_MAIN_PAGE];
        [mainPageViewController cloudDriveDetailSwitch:entity];
        [mainPageViewController release];
        [entity release];
        
        for (BaseDrive *drive in array) {
            IMBCloudManager *cloudManager = [IMBCloudManager singleton];
            [cloudManager saveCloudManager:drive];
            IMBBaseManager *baseManager = [cloudManager getCloudManager:drive];
            [baseManager getAccount];
            [self addCloudBtn:drive animate:NO];
        }
        
    }else {
        [_navigationView.addBtn setIsClick:YES];
        [[_navigationView.addBtn cloudEntity] setIsClick:YES];
        [_navigationView.addBtn setWantsLayer:YES];
        
        NSViewController *addCloudViewController = nil;
        if ([[TempHelper getSystemLastNumberString] isVersionMajorEqual:@"11"]) {
            addCloudViewController = [[IMBAddCloudViewController alloc] initWithDelegate:self];
        }else {
            addCloudViewController = [[IMBLowAddCloudViewController alloc] initWithDelegate:self];
        }
        [_contentBox setContentView:addCloudViewController.view];
        [_cloudViewDic setObject:addCloudViewController forKey:ACCOUNT_ADDCLOUD_PAGE];
        [addCloudViewController release];
    }
}

- (void)addNotification {
    [_nc addObserver:self selector:@selector(removeMainPageMenuView:) name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc addObserver:self selector:@selector(chooseCloudBtnShowPopBtn:) name:NOTIEY_CHOOSE_CLOUD_BTN object:nil];
}

#pragma mark - config headbutton and head Menu
- (void)configHeadButton {
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
    [_headButton setMouseNormalColor:[NSColor clearColor] WithMouseEnterColor:[StringHelper getColorFromString:CustomColor(@"mouse_enter_bgColor", nil)] WithMouseDownColor:[StringHelper getColorFromString:CustomColor(@"mouse_down_bgColor", nil)] WithHeadImage:headImage WithSubscriptImage:[NSImage imageNamed:@"menu_personarrow"]];
    [headImage release];
    
    //配置菜单
    _mainPageMenuView = [[IMBMainPageMenuView alloc] initWithFrame:NSMakeRect(_headButton.frame.origin.x, _headButton.frame.origin.y - 382, 238, 380)];
    
    for (int itemTag = 1; itemTag <= 8; itemTag++) {
        if (itemTag == 1) {
            IMBMainPageItem *item1 = [[IMBMainPageItem alloc] initWithFrame:NSMakeRect(5, 292, 228, 78)];
            [item1 setItemTag:itemTag];
            [item1 setTarget:self];
            [item1 setAction:@selector(menuItemClick:)];
            [_mainPageMenuView addSubview:item1];
            [item1 release];
            item1 = nil;
        } else {
            IMBMainPageItem *item1 = [[IMBMainPageItem alloc] initWithFrame:NSMakeRect(5, 292 - (itemTag - 1)*40, 228, 40)];
            [item1 setItemTag:itemTag];
            [item1 setTarget:self];
            [item1 setAction:@selector(menuItemClick:)];
            [_mainPageMenuView addSubview:item1];
            [item1 release];
            item1 = nil;
        }
    }
}

#pragma mark - 切换云盘类别方式
- (void)cloudNavigationSwitch:(IMBCloudEntity *)cloudEnity withAddBtn:(NSButton *)btn{
    if (cloudEnity.categoryCloudEnum == AddBtnEnum) {//_addBtn
        NSViewController *addCloudViewController = nil;
        if ([_cloudViewDic.allKeys containsObject:ACCOUNT_ADDCLOUD_PAGE]) {
            addCloudViewController = [_cloudViewDic objectForKey:ACCOUNT_ADDCLOUD_PAGE];
            [_contentBox setContentView:addCloudViewController.view];
        }else {
            if ([[TempHelper getSystemLastNumberString] isVersionMajorEqual:@"11"]) {
                addCloudViewController = [[IMBAddCloudViewController alloc] initWithDelegate:self];
            }else {
                addCloudViewController = [[IMBLowAddCloudViewController alloc] initWithDelegate:self];
            }
            [_contentBox setContentView:addCloudViewController.view];
            [_cloudViewDic setObject:addCloudViewController forKey:ACCOUNT_ADDCLOUD_PAGE];
            [addCloudViewController release];
        }
    }else if (cloudEnity.categoryCloudEnum == MoreBtnEnum) {//_moreBtn
        [self moreCloudBtnDown:cloudEnity withAddBtn:btn];
    }else {
        IMBMainPageViewController *mainPageViewController = nil;
        if ([_cloudViewDic.allKeys containsObject:ACCOUNT_MAIN_PAGE]) {
            mainPageViewController = [_cloudViewDic objectForKey:ACCOUNT_MAIN_PAGE];
            [_contentBox setContentView:mainPageViewController.view];
            [mainPageViewController cloudDriveDetailSwitch:cloudEnity];
        }else {
            mainPageViewController = [[IMBMainPageViewController alloc] initWithDelegate:self CloudEntity:cloudEnity];
            [_contentBox setContentView:mainPageViewController.view];
            [_cloudViewDic setObject:mainPageViewController forKey:ACCOUNT_MAIN_PAGE];
            [mainPageViewController cloudDriveDetailSwitch:cloudEnity];
            [mainPageViewController release];
        }
    }
}

- (void)moreCloudBtnDown:(IMBCloudEntity *)icloudEnity withAddBtn:(NSButton *)btn{
    if (_devPopover.isShown) {
        return;
    }
    
    if (_devPopover != nil) {
        [_devPopover release];
        _devPopover = nil;
    }
    _devPopover = [[NSPopover alloc] init];
    
    if ([[TempHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _devPopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    _devPopover.animates = YES;
    _devPopover.behavior = NSPopoverBehaviorTransient;
    _devPopover.delegate = self;
    NSMutableArray *ary = [NSMutableArray array];
    for (IMBDrawOneImageBtn *drawOneBtn in [icloudEnity cloudAry]) {
        if (drawOneBtn.cloudEntity) {
            BaseDrive *baseDrive = [[IMBCloudManager singleton] getBindDrive:drawOneBtn.cloudEntity.driveID];
            if (baseDrive && ![StringHelper stringIsNilOrEmpty:baseDrive.displayName]) {
                drawOneBtn.cloudEntity.name = baseDrive.displayName;
            }
        }
        [ary addObject:drawOneBtn.cloudEntity];
    }
    
    _popoverViewController = [[IMBPopoverViewController alloc] initWithNibName:@"IMBPopoverViewController" bundle:nil WithAllAry:ary];
    [_popoverViewController setDelegate:self];
    if (_devPopover != nil) {
        _devPopover.contentViewController = _popoverViewController;
    }
    [_popoverViewController setTarget:self];
    [_popoverViewController setAction:@selector(chooseDeviceClick:)];
    [_popoverViewController release];
    NSRectEdge prefEdge = NSMaxXEdge;
    NSRect rect = NSMakeRect(btn.bounds.origin.x - 10, btn.bounds.origin.y, btn.bounds.size.width, btn.bounds.size.height);
    [_devPopover showRelativeToRect:rect ofView:btn preferredEdge:prefEdge];
}

- (void)chooseDeviceClick:(id)sender {
    [_devPopover close];
    IMBCloudEntity *cloudEntity = (IMBCloudEntity *)sender;
    for (IMBDrawOneImageBtn *drawOneBtn in [_navigationView.moreBtn cloudAry]) {
        if ([drawOneBtn isKindOfClass:[IMBDrawOneImageBtn class]]) {
            [drawOneBtn setIsDownOtherBtn:NO];
        }else {
            [(IMBSVGButton *)drawOneBtn setIsClick:NO];
        }
        [drawOneBtn.cloudEntity setIsClick:NO];
        [drawOneBtn setNeedsDisplay:YES];
    }
    [_navigationView setBottomViewButton:NO];
    for (IMBDrawOneImageBtn *drawOneBtn in _navigationView.showBtnArray) {
        [drawOneBtn setLongTimeDown:NO];
        [drawOneBtn.cloudEntity setIsClick:NO];
        [drawOneBtn setIsDownOtherBtn:YES];
        [drawOneBtn setNeedsDisplay:YES];
    }
    for (IMBDrawOneImageBtn *oneImageBtn in _navigationView.popBtnArray) {
        if ([oneImageBtn isKindOfClass:[IMBDrawOneImageBtn class]]) {
            [oneImageBtn setLongTimeDown:NO];
            [oneImageBtn.cloudEntity setIsClick:NO];
            if ([[oneImageBtn cloudEntity] isEqual:cloudEntity]) {
                [oneImageBtn setLongTimeDown:YES];
            }
        }else {
            [(IMBSVGButton *)oneImageBtn setIsClick:NO];
            [[(IMBSVGButton *)oneImageBtn cloudEntity] setIsClick:NO];
            if ([[(IMBSVGButton *)oneImageBtn cloudEntity] isEqual:cloudEntity]) {
                [(IMBSVGButton *)oneImageBtn setIsClick:YES];
            }
        }
        
        [oneImageBtn setNeedsDisplay:YES];
    }

    [cloudEntity setIsClick:YES];
    [self cloudNavigationSwitch:cloudEntity withAddBtn:nil];
}

- (void)gotoAddCloudView:(id)sender {
//    [_navigationView.addBtn setIsClick:YES];
//    [_navigationView.addBtn.cloudEntity setIsClick:YES];
//    [_navigationView.addBtn setNeedsDisplay:YES];
//    [self cloudNavigationSwitch:_navigationView.addBtn.cloudEntity withAddBtn:nil];
    [_navigationView switchView:_navigationView.addBtn];
}

- (void)gotoHistoryFileView {
    [_navigationView switchView:_navigationView.historyBtn];
}

- (void)gotoBindCloudView:(NSString *)driveID {
    if (_navigationView.allBtnArray) {
        for (NSButton *btn in _navigationView.allBtnArray) {
            if ([btn isKindOfClass:[IMBDrawOneImageBtn class]]) {
                IMBDrawOneImageBtn *curBtn = (IMBDrawOneImageBtn *)btn;
                if ([curBtn.cloudEntity.driveID isEqualToString:driveID]) {
                    [_navigationView switchView:curBtn];
                    break;
                }
            }
        }
    }
}

//pop按钮的箭头，只置顶
- (void)choosePopCloudBtnDown:(IMBCloudEntity *)cloudEntity {
    [_devPopover close];
    [_navigationView changeCloudButton:cloudEntity];
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    BaseDrive *drive = [cloudManager getBindDrive:cloudEntity.driveID];
    [cloudManager driveTopIndexWithDrive:drive];
}

#pragma mark - Action
- (void)lockWindow:(id)sender {
    NSLog(@"lock Window");
    [(AppDelegate *)_delegate backLoginView:NO];
}

//点击打开账户菜单
- (IBAction)enterPersonalMainView:(id)sender {
    if ([_mainPageMenuView superview]) {
        _isOpenMenu = NO;
        [_mainPageMenuView removeFromSuperview];
    } else {
        [_mainPageMenuView setFrameOrigin:NSMakePoint(_headButton.frame.origin.x, _headButton.frame.origin.y - 382)];
        _isOpenMenu = YES;
        [_mainPageMenuView setWantsLayer:YES];
        [self.view addSubview:_mainPageMenuView];
    }
}

//点击菜单menu
- (void)menuItemClick:(id)sender {
    int itemTag = [(IMBMainPageItem *)sender itemTag];
    if (itemTag == 1) {//主页
        //取消按钮所有的选中
        [_navigationView setBottomViewButton:NO];
        for (IMBDrawOneImageBtn *drawOneBtn in _navigationView.showBtnArray) {
            [drawOneBtn setLongTimeDown:NO];
            [drawOneBtn.cloudEntity setIsClick:NO];
            [drawOneBtn setIsDownOtherBtn:YES];
            [drawOneBtn setNeedsDisplay:YES];
        }
        for (IMBDrawOneImageBtn *oneImageBtn in _navigationView.popBtnArray) {
            if ([oneImageBtn isKindOfClass:[IMBDrawOneImageBtn class]]) {
                [oneImageBtn setLongTimeDown:NO];
                [oneImageBtn.cloudEntity setIsClick:NO];
            }else {
                [(IMBSVGButton *)oneImageBtn setIsClick:NO];
                [[(IMBSVGButton *)oneImageBtn cloudEntity] setIsClick:NO];
            }
            
            [oneImageBtn setNeedsDisplay:YES];
        }
        
        IMBCloudEntity *cloudEnity = [[IMBCloudEntity alloc] init];
        cloudEnity.categoryCloudEnum = AccountBtnEnum;
        IMBMainPageViewController *mainPageViewController = nil;
        if ([_cloudViewDic.allKeys containsObject:ACCOUNT_MAIN_PAGE]) {
            mainPageViewController = [_cloudViewDic objectForKey:ACCOUNT_MAIN_PAGE];
            [_contentBox setContentView:mainPageViewController.view];
            [mainPageViewController cloudDriveDetailSwitch:cloudEnity];
        }else {
            mainPageViewController = [[IMBMainPageViewController alloc] initWithDelegate:self CloudEntity:cloudEnity];
            [_contentBox setContentView:mainPageViewController.view];
            [_cloudViewDic setObject:mainPageViewController forKey:ACCOUNT_MAIN_PAGE];
            [mainPageViewController cloudDriveDetailSwitch:cloudEnity];
            [mainPageViewController release];
        }
        [cloudEnity release];
    } else if (itemTag == 2) {//主页
        
    } else if (itemTag == 3) {//Go Upgrade
        
    } else if (itemTag == 4) {//设置
        
    } else if (itemTag == 5) {//更改密码
        
    } else if (itemTag == 6) {//帮助
        
    } else if (itemTag == 7) {//关于
        
    } else if (itemTag == 8) {//登出
        
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSuperView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        
        int result = [_alertViewController showAlertText:CustomLocalizedString(@"CWTip_ExitCloud", nil) withCancelButton:CustomLocalizedString(@"Button_Cancel", nil) withOKButton:CustomLocalizedString(@"Button_Yes", nil) withSuperView:view];
        if (result) {
            [[IMBCloudManager singleton] logoutAccount];
            [(AppDelegate *)_delegate backLoginView:YES];
        }
    }
    [self removeMainPageMenuViewAnimation];
}

- (IBAction)dotestBtn:(id)sender {
    BaseDrive * drive = [[IMBCloudManager singleton].driveManager.driveArray objectAtIndex:0];
    drive.driveID = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [self addCloudBtn:drive animate:YES];
}

- (IBAction)removeBtn:(id)sender {
    BaseDrive * drive = [[IMBCloudManager singleton].driveManager.driveArray objectAtIndex:0];
    [_navigationView removeRelationCloudButton:drive.driveID];
}

//增加云盘按钮
- (void)addCloudBtn:(BaseDrive *)drive animate:(BOOL)isAnimate {
    IMBCloudEntity *cloudEntity = [[IMBCloudEntity alloc]init];
    [TempHelper setDriveDefultImage:drive CloudEntity:cloudEntity];
    if (isAnimate) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [_navigationView addRelationCloudButton:cloudEntity animate:YES];
            [cloudEntity release];
        });
    }else {
        [_navigationView addRelationCloudButton:cloudEntity animate:NO];
        [cloudEntity release];
    }
}

#pragma mark - 左边按钮 tooltip
- (void)showToolTip:(NSButton *)sender withToolTip:(NSString *)toolTip {
    if (_isOpenMenu) {
        return;
    }
    if ([StringHelper stringIsNilOrEmpty:toolTip]) {
        return;
    }
    if (_toolTopShadowsView != nil) {
        [_toolTopShadowsView removeFromSuperview];
        [_toolTopShadowsView release];
        _toolTopShadowsView = nil;
    }
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    [style setLineSpacing:10];
    int viewWidth = 140;
    if (_isNewAddBtn) {
        viewWidth = 140;
    }else {
        NSRect rect = [StringHelper calcuTextBounds:toolTip font:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        if (rect.size.width > 60) {
            viewWidth = rect.size.width + 40;
        }else {
            viewWidth = 74;
        }
    }
    CGFloat height = [self getHeightLineWithString:toolTip withWidth:viewWidth - 10 -10 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
//    int viewWidth = 0;
    int viewHeigt = 0;
    if (height < 32) {
        viewHeigt = 38;
    }else {
        viewHeigt = height;
    }
    if ([sender isKindOfClass:[IMBDrawOneImageBtn class]]) {

        _isNewAddBtn = NO;
        _toolTopShadowsView = [[IMBToolTipShadowsView alloc] initWithFrame:NSMakeRect(_headButton.frame.origin.x, _headButton.frame.origin.y - 382, viewWidth, viewHeigt)];
        NSTextField *textfield = [[NSTextField alloc]initWithFrame:NSMakeRect(5, 5, viewWidth -10, viewHeigt -13)];
        [textfield setEditable:NO];
        [textfield setBordered:NO];
        [textfield setAlignment:NSCenterTextAlignment];
        [textfield setFocusRingType:NSFocusRingTypeNone];
        [textfield setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [textfield setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [textfield setStringValue:toolTip];
        [_toolTopShadowsView addSubview:textfield];
        [textfield release];
        textfield = nil;
        [_toolTopShadowsView setFrameOrigin:NSMakePoint(sender.frame.origin.x + 60, (sender.frame.origin.y + _navigationView.frame.origin.y + sender.frame.size.height/2) - viewHeigt/2)];
        [_toolTopShadowsView setWantsLayer:YES];
        [self.view addSubview:_toolTopShadowsView];
    }else {
        _toolTopShadowsView = [[IMBToolTipShadowsView alloc] initWithFrame:NSMakeRect(_headButton.frame.origin.x, _headButton.frame.origin.y - 382, 74, viewHeigt)];
        NSTextField *textfield = [[NSTextField alloc]initWithFrame:NSMakeRect(5, 5, 64, viewHeigt -13)];
        [textfield setEditable:NO];
        [textfield setBordered:NO];
        [textfield setAlignment:NSCenterTextAlignment];
        [textfield setFocusRingType:NSFocusRingTypeNone];
        [textfield setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [textfield setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [textfield setStringValue:toolTip];
        [_toolTopShadowsView addSubview:textfield];
        [textfield release];
        textfield = nil;
        if ([sender isKindOfClass:[IMBSVGButton class]]) {
            IMBSVGButton *btn = (IMBSVGButton *)sender;
            if (btn.isUnlockBtn) {
                [_toolTopShadowsView setFrameOrigin:NSMakePoint(sender.frame.origin.x + 30, (sender.frame.origin.y + sender.frame.size.height/2 ) - viewHeigt/2)];
            }else {
                [_toolTopShadowsView setFrameOrigin:NSMakePoint(sender.frame.origin.x + 60, (sender.frame.origin.y + _navigationView.fixedBtnView.frame.origin.y +_navigationView.frame.origin.y + sender.frame.size.height/2 ) - viewHeigt/2)];
            }
        }else {
            [_toolTopShadowsView setFrameOrigin:NSMakePoint(sender.frame.origin.x + 60, (sender.frame.origin.y + _navigationView.fixedBtnView.frame.origin.y +_navigationView.frame.origin.y + sender.frame.size.height/2 ) - viewHeigt/2)];
        }
        [_toolTopShadowsView setWantsLayer:YES];
        [self.view addSubview:_toolTopShadowsView];
    }
}

#pragma mark - 根据字符串计算label高度
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(NSFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    [style release];
    style = nil;
    return height;
}

- (void)toolTipViewClose {
    if (_toolTopShadowsView != nil) {
        [_toolTopShadowsView removeFromSuperview];
        [_toolTopShadowsView release];
        _toolTopShadowsView = nil;
    }
}

#pragma mark - Notification
- (void)chooseCloudBtnShowPopBtn:(NSNotification *)sender {
    _isNewAddBtn = YES;
    IMBDrawOneImageBtn *btn = (IMBDrawOneImageBtn *)sender.object;
    [self showToolTip:btn withToolTip:[NSString stringWithFormat:CustomLocalizedString(@"AddCloud_PopoverView_Title", nil),btn.cloudEntity.name]];
}

//点击其他地方 关闭账户菜单
- (void)removeMainPageMenuView:(NSNotification *)sender {
    NSEvent *theEvent = sender.object;
    NSPoint point = [_mainPageMenuView convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [_mainPageMenuView bounds], [_mainPageMenuView isFlipped]);
    
    NSPoint point1 = [_headButton convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner1 = NSMouseInRect(point1, [_headButton bounds], [_headButton isFlipped]);
    
    if (_isOpenMenu) {
        if (!inner && !inner1) {
            [self removeMainPageMenuViewAnimation];
        }
    }
    if (_toolTopShadowsView != nil) {
        [_toolTopShadowsView removeFromSuperview];
        [_toolTopShadowsView release];
        _toolTopShadowsView = nil;
    }
}

- (void)removeMainPageMenuViewAnimation {
    _isOpenMenu = NO;
    [_mainPageMenuView removeFromSuperview];
}

//- (void)loadiCloudDriveView:(IMBiCloudDriveManager *) iCloudManager WithDataAry:(NSMutableArray *)dataAry {
// }
//
//- (void)loadDriveDataFail:(ActionTypeEnum)typeEnum {
//    
//}
//
//- (void)loadDriveComplete:(NSMutableArray *_Nonnull)ary WithEvent:(ActionTypeEnum)typeEnum {
//    //    IMBAllCloudViewController *allCloudController = [[IMBAllCloudViewController alloc]initWithDelegate:self withCloudEntity:_iCloudDriveManager];
//    //    [allCloudController loadDriveComplete:ary WithEvent:typeEnum];
//    if (typeEnum == loadAction) {
//        IMBCloudEntity *cloudEntity = [[IMBCloudEntity alloc]init];
//        cloudEntity.categoryCloudEnum = iCloudDriveEnum;
//        cloudEntity.cloudAry = ary;
//        cloudEntity.driveID = @"1212";
//        IMBMainPageViewController *mainPageViewController = nil;
//        if ([_cloudViewDic.allKeys containsObject:ACCOUNT_MAIN_PAGE]) {
//            mainPageViewController = [_cloudViewDic objectForKey:ACCOUNT_MAIN_PAGE];
//            [_contentBox setContentView:mainPageViewController.view];
//            [mainPageViewController cloudDriveDetailSwitch:cloudEntity];
//        }else {
//            mainPageViewController = [[IMBMainPageViewController alloc] initWithDelegate:self CloudEntity:cloudEntity];
//            [_contentBox setContentView:mainPageViewController.view];
//            [_cloudViewDic setObject:mainPageViewController forKey:ACCOUNT_MAIN_PAGE];
//            [mainPageViewController cloudDriveDetailSwitch:cloudEntity];
//            [mainPageViewController release];
//        }
//        [cloudEntity release];
//        cloudEntity = nil;
//    }
//}
//
////测试
//- (IBAction)jsdlfjlsad:(id)sender {
//    IMBiCloudDriveLogInWindowController *iCloudDriveWindow = [[IMBiCloudDriveLogInWindowController alloc] initWithDelegate:self];
//    [iCloudDriveWindow showWindow:self];
////    [iCloudDriveWindow release];
////    iCloudDriveWindow = nil;
//}

@end
