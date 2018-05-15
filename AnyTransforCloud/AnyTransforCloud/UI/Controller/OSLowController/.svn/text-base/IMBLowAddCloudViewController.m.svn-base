//
//  IMBLowAddCloudViewController.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBLowAddCloudViewController.h"
#import "StringHelper.h"
#import "IMBCloudEntity.h"
#import "IMBCloudCollectionViewItem.h"
#import "IMBAnimation.h"
#import "IMBCloudManager.h"
#import "IMBCloudTableCellView.h"
#import "IMBMainViewController.h"

@implementation IMBLowAddCloudViewController
@synthesize dataSourceAryM = _dataSourceAryM;

- (id)initWithDelegate:(id)delegate {
    self = [super initWithNibName:@"IMBLowAddCloudViewController" bundle:nil];
    if (self) {
        _dataSourceAryM  = [[NSMutableArray alloc] init];
        _personCloudAryM = [[NSMutableArray alloc] init];
        _delegate = delegate;
        _nc = [NSNotificationCenter defaultCenter];
        [_nc addObserver:self selector:@selector(bindDriveSeccussed:) name:BindDriveSuccessedNotification object:nil];
        [_nc addObserver:self selector:@selector(bindDriveErrored:) name:BindDriveErroredNotification object:nil];
        [_nc addObserver:self selector:@selector(deleteDriveSeccussed:) name:DeleteDriveSuccessedNotification object:nil];
        [_nc addObserver:self selector:@selector(deleteDriveErrored:) name:DeleteDriveErroredNotification object:nil];
        [_nc addObserver:self selector:@selector(refreshCloudSuccessed:) name:RefreshDriveSuccessedNotification object:nil];
        [_nc addObserver:self selector:@selector(refreshCloudFailed:) name:RefreshDriveErroredNotification object:nil];
        [_nc addObserver:self selector:@selector(refreshLoginCloud) name:REFRESH_LOGIN_CLOUD object:nil];
        [_nc addObserver:self selector:@selector(clickCollectionEvent:) name:ClickCollectionEvent object:nil];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self configNoDataView];
    
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    
    [_cloudCategoryView setDelegate:self];
    
    NSMutableAttributedString *titleAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"AddCloud_Title", nil) withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26] withLineSpacing:0.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_titleTextField setAttributedStringValue:titleAs];
    
    NSMutableAttributedString *subTitleAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"AddCloud_SubTitle", nil) withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:14] withLineSpacing:5.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_subtitleTextField setAttributedStringValue:subTitleAs];
    [_iCloudCategoryLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    _collectionView.delegate = self;
    [_collectionView setSelectable:YES];
    [_collectionView setAllowsMultipleSelection:YES];

    NSArray *cateArr = [IMBCloudManager singleton].categroyAryM;
    NSString *key = @"";
    if ([cateArr containsObject:@"popular"]) {
        key = @"popular";
    }else if ([cateArr containsObject:@"personal"]) {
        key = @"personal";
    }else if ([cateArr containsObject:@"application"]) {
        key = @"application";
    }else if ([cateArr containsObject:@"business"]) {
        key = @"business";
    }else if ([cateArr containsObject:@"other"]) {
        key = @"other";
    }
    [_itemTableView setDelegate:self];
    [_itemTableView setDataSource:self];
    [_itemTableView reloadData];
    [self cloudCategory:[_cloudCategoryView.titleBtnDic objectForKey:key]];
    _itemTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
}

#pragma mark - nodataView
- (void)configNoDataView {
    [_noDataImage setImage:[NSImage imageNamed:@"nodata_addcloud"]];
    NSString *promptStr = [[CustomLocalizedString(@"AddCloud_Others_Button_Content", nil) stringByAppendingString:@" "]stringByAppendingString:CustomLocalizedString(@"NoData_CloudAdd", nil)];
    [_noDataText setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"AddCloud_Others_Button_Content", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_noDataText setAlignment:NSCenterTextAlignment];
    [_noDataText setDelegate:self];
    [_noDataText setSelectable:YES];
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    if ([link isEqualToString:CustomLocalizedString(@"AddCloud_Others_Button_Content", nil)]) {
        [self performSelector:@selector(showPopularView) withObject:nil afterDelay:0.1];
    }
    return YES;
}

- (void)showPopularView {
    [_cloudCategoryView setSelectBtn:[_cloudCategoryView.titleBtnDic objectForKey:@"popular"]];
}

#pragma mark - 切换云盘类别方式
- (void)cloudCategory:(IMBSelectedButton *)titleBtn {
    if (titleBtn.tag == 106) {
        if ([[IMBCloudManager singleton].driveManager driveArray].count > 0) {
            [_personCloudAryM removeAllObjects];
            [_personCloudAryM addObjectsFromArray:[[IMBCloudManager singleton].driveManager driveArray]];
            [_contentBox setContentView:_tableViewScrollView];
            [_itemTableView reloadData];
        } else {
            [_contentBox setContentView:_noDataView];
        }
    }else {
        NSDictionary *dic = [IMBCloudManager singleton].contentCloudDicM;
        NSString *key = @"";
        [_collectionScrollView removeFromSuperview];
        [_dataSourceAryM removeAllObjects];
        if (titleBtn.tag == 101) {
            key = @"popular";
        }else if (titleBtn.tag == 102) {
            key = @"personal";
        }else if (titleBtn.tag == 103) {
            key = @"application";
        }else if (titleBtn.tag == 104) {
            key = @"business";
        }else if (titleBtn.tag == 105) {
            key = @"other";
        }
        NSArray *array = [dic objectForKey:key];
        [_arrayController addObjects:array];
        [_contentBox setContentView:_collectionScrollView];
    }
    [_contentBox setWantsLayer:YES];
    [_contentBox.layer removeAllAnimations];
    CATransition *animation = [IMBAnimation verticalAnimationWithdurTimes:0.6 isFromBottom:YES];
    [_contentBox.layer addAnimation:animation forKey:@"1"];
}

- (void)chooseCloud:(IMBCloudEntity *)cloud {
    NSLog(@"choose Cloud");
    IMBCloudManager *cloudmanager = [IMBCloudManager singleton];
    if (cloud.categoryCloudEnum == GoogleEnum) {
        [cloudmanager addCloud:GoogleDriveCSEndPointURL];
    }else if (cloud.categoryCloudEnum == DropBoxEnum) {
        [cloudmanager addCloud:DropboxCSEndPointURL];
    }else if (cloud.categoryCloudEnum == OneDriveEnum) {
        [cloudmanager addCloud:OneDriveCSEndPointURL];
    }else if (cloud.categoryCloudEnum == BoxEnum) {
        [cloudmanager addCloud:BoxCSEndPointURL];
    }else if (cloud.categoryCloudEnum == PCloudEnum) {
        [cloudmanager addCloud:PCloudCSEndPointURL];
    }else if (cloud.categoryCloudEnum == iCloudDriveEnum) {
        
    }
    [self showAuthorizeWindowWithCloud:cloud];
}

#pragma mark - 授权弹窗
- (void)showAuthorizeWindowWithCloud:(IMBCloudEntity *)cloud {
    if (_authorizeWindow) {
        [_authorizeWindow release];
        _authorizeWindow = nil;
    }
    _authorizeWindow = [[IMBCloudAuthorizeWindowController alloc] initWithCloudEntity:cloud withDelegate:self];
    NSWindow *mainWindow = [NSApp mainWindow];
    NSRect rect = mainWindow.frame;
    NSPoint point = mainWindow.frame.origin;
    float height = _authorizeWindow.window.frame.size.height;
    float width = _authorizeWindow.window.frame.size.width;
    [_authorizeWindow.window setFrameOrigin:NSMakePoint(point.x+(rect.size.width-width)/2, point.y+(rect.size.height-height)/2)];
    [NSApp runModalForWindow:[_authorizeWindow window]];
}

#pragma mark - NSTableView Datasource and Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 80;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _personCloudAryM.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (_personCloudAryM > 0) {
        IMBCloudTableCellView *cellView = [tableView makeViewWithIdentifier:@"cloudTabCell" owner:self];
        BaseDrive *drive = [_personCloudAryM objectAtIndex:row];
        [cellView.cloudImageView setImage:[TempHelper getCloudImage:drive.driveType]];
        [cellView.cloudPerson setStringValue:drive.driveEmail];
        [cellView.cloudName setStringValue:drive.displayName];
        [cellView setDelegate:self];
        [cellView setDriveID:drive.driveID];
        
        NSString *useStr = @"--";
        if (drive.usedCapacity > 0) {
            useStr = [StringHelper getFileSizeString:drive.usedCapacity reserved:2];
        }
        NSString *totalStr = @"--";
        if (drive.totalCapacity > 0) {
            totalStr = [StringHelper getFileSizeString:drive.totalCapacity reserved:2];
        }
        [cellView.cloudSize setStringValue:[NSString stringWithFormat:@"%@/%@",useStr,totalStr]];
        if (drive.expirationDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *stringFromDate = [formatter stringFromDate:drive.expirationDate];
            [cellView.cloudTime setStringValue:stringFromDate];
            [formatter release];
        }else {
            [cellView.cloudTime setStringValue:@"--"];
        }
//        [cellView.editBtn setAction:@selector(editCloudName:)];
//        [cellView.editBtn setTarget:self];
        [cellView.deleteBtn setAction:@selector(deleteCloud:)];
        [cellView.deleteBtn setTarget:self];
        
        return cellView;
    }else {
        return nil;
    }
}

//- (void)editCloudName:(id)sender {
//    NSView *v = [sender superview];//获取父类view
//    IMBCloudTableCellView *cell = (IMBCloudTableCellView *)v;//获取cell
//    NSTextField *textfile = cell.cloudName;
//    [cell.cloudName setEditable:YES];
//    [cell.cloudName setSelectable:YES];
//    [cell.cloudName becomeFirstResponder];
//    [cell.cloudName mouseDown:nil];
////    NSInteger row  = [_itemTableView rowForView:cell];
////    IMBCloudEntity *cloud = [_personCloudAryM objectAtIndex:row];
//}

- (void)deleteCloud:(id)sender {
    NSView *v = [sender superview];//获取父类view
    IMBCloudTableCellView *cell = (IMBCloudTableCellView *)[v superview];//获取cell
    NSInteger row  = [_itemTableView rowForView:cell];
    BaseDrive *drive = [_personCloudAryM objectAtIndex:row];
    
    NSString *alertText = [NSString stringWithFormat:CustomLocalizedString(@"CWTitle_RemoveCloud", nil),drive.displayName];
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSuperView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    
    int result = [_alertViewController showAlertText:alertText withCancelButton:CustomLocalizedString(@"Button_Cancel", nil) withOKButton:CustomLocalizedString(@"Button_Yes", nil) withSuperView:view];
    if (result) {
        
        IMBCloudManager *cloudManager = [IMBCloudManager singleton];
        [cloudManager deleteCloud:drive];
    }
}

- (void)jumpCloudView:(NSString *)driveID {
    [_delegate gotoBindCloudView:driveID];
}

#pragma mark - 绑定云盘通知消息
- (void)bindDriveSeccussed:(NSNotification *)notification {
    NSLog(@"bind Drive Seccussed");
    NSDictionary *obj = notification.object;
    if (obj) {
        IMBCloudManager *cloudManager = [IMBCloudManager singleton];
        BOOL ret = [cloudManager.driveManager createDrive:obj];
        if (ret) {
            NSLog(@"该云盘已经绑定");
        }else {
            NSString *driveID = [obj objectForKey:@"id"];
            BaseDrive *drive = [cloudManager getBindDrive:driveID];
            [cloudManager saveCloudManager:drive];
            IMBBaseManager *baseManager = [cloudManager getCloudManager:drive];
            [baseManager getAccount];
            [(IMBMainViewController *)_delegate addCloudBtn:drive animate:YES];
            [_cloudCategoryView setSelectBtn:[_cloudCategoryView.titleBtnDic objectForKey:@"mycloud"]];
        }
        if (_authorizeWindow) {
            [_authorizeWindow onlyCloseWindow:nil];
        }
    }else {
        NSLog(@"绑定云盘时返回字典为空");
    }
}

- (void)bindDriveErrored:(NSNotification *)notification {
    NSLog(@"bind Drive Errored");
    if (_authorizeWindow) {
        [_authorizeWindow configAuthorizedFailedView];
    }
}

- (void)deleteDriveSeccussed:(NSNotification *)notification {
    NSLog(@"delete Drive successed");
    NSDictionary *obj = notification.object;
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    if (obj) {
        NSString *driveID = [obj objectForKey:@"id"];
        BaseDrive *drive = [cloudManager getBindDrive:driveID];
        if (drive) {
            if ([_personCloudAryM containsObject:drive]) {
                NSUInteger row = [_personCloudAryM indexOfObject:drive];
                [_personCloudAryM removeObject:drive];
                [_itemTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
                [[(IMBMainViewController *)_delegate navigationView] removeRelationCloudButton:drive.driveID];
                [[NSFileManager defaultManager] removeItemAtPath:[TempHelper getPhotoSqliteConfigPath:driveID] error:nil];
            }
            [cloudManager removeCloudManager:drive];
            if (_personCloudAryM.count == 0) {
                [_contentBox setContentView:_noDataView];
            }
        }
    }
}

- (void)deleteDriveErrored:(NSNotification *)notification {
    NSLog(@"delete Drive Errored");
}

- (void)refreshCloudSuccessed:(NSNotification *)notification {
    NSDictionary *obj = notification.object;
    if (obj) {
        if ([obj.allKeys containsObject:@"newAddCloudAry"]) {
            NSArray *newArr = [obj objectForKey:@"newAddCloudAry"];
            if (newArr.count > 0) {
                IMBCloudManager *cloudManager = [IMBCloudManager singleton];
                for (NSString *driveID in newArr) {
                    BaseDrive *drive = [cloudManager getBindDrive:driveID];
                    [cloudManager saveCloudManager:drive];
                    IMBBaseManager *baseManager = [cloudManager getCloudManager:drive];
                    [baseManager getAccount];
                    [(IMBMainViewController *)_delegate addCloudBtn:drive animate:YES];
                    [_cloudCategoryView setSelectBtn:[_cloudCategoryView.titleBtnDic objectForKey:@"mycloud"]];
                }
            }
        }
    }
}

- (void)refreshCloudFailed:(NSNotification *)notification {
    
}

- (void)refreshLoginCloud {
    [_itemTableView reloadData];
}

- (void)clickCollectionEvent:(NSNotification *)notification {
    IMBCloudEntity *cloudEntity = notification.object;
    if (cloudEntity) {
        [self chooseCloud:cloudEntity];
    }
}

- (void)dealloc {
    [_nc removeObserver:self name:BindDriveSuccessedNotification object:nil];
    [_nc removeObserver:self name:BindDriveErroredNotification object:nil];
    [_nc removeObserver:self name:DeleteDriveSuccessedNotification object:nil];
    [_nc removeObserver:self name:DeleteDriveErroredNotification object:nil];
    [_nc removeObserver:self name:REFRESH_LOGIN_CLOUD object:nil];
    [_nc removeObserver:self name:ClickCollectionEvent object:nil];
    [_nc removeObserver:self name:RefreshDriveSuccessedNotification object:nil];
    [_nc removeObserver:self name:RefreshDriveErroredNotification object:nil];
    if (_dataSourceAryM) {
        [_dataSourceAryM release];
        _dataSourceAryM = nil;
    }
    if (_personCloudAryM) {
        [_personCloudAryM release];
        _personCloudAryM = nil;
    }
    if (_alertViewController) {
        [_alertViewController release];
        _alertViewController = nil;
    }
    [super dealloc];
}

@end


@implementation IMBCollectionViewItem

@end


