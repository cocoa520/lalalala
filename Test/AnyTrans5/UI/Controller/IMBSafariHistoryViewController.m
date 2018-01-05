//
//  IMBSafariHistoryViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/27.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBSafariHistoryViewController.h"
#import "IMBSafariHistoryEntity.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCheckBoxCell.h"
#import "IMBBackAndRestore.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "IMBDeviceMainPageViewController.h"
@implementation IMBSafariHistoryViewController

@synthesize isBackup = _isBackup;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4{
    if ([super initWithNibName:@"IMBSafariHistoryViewController" bundle:nil]) {
        _category = Category_SafariHistory;
        _delegate = delegate;
        _node = node;
        _isBackup = YES;
        _decryptAbove4 = abve4;
    }
    return self;
}

-(id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBSafariHistoryViewController" bundle:nil]) {
        _category = Category_SafariHistory;
        _delegate = delegate;
         _isBackup = YES;
        _iCloudBackup = icloudBackup;
        _isiCloud = YES;
        _isiCloudView = YES;
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate]) {
        _isBackup = NO;
        _dataSourceArray = [_information.safariHistoryArray retain];
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        if (_isBackup) {
            NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_37", nil)];
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
            [_backupNodataTextStr setAttributedStringValue:as];
            [_backupNodataTextStr setSelectable:NO];
        }else{
            [self configNoDataView];
            [self configRefreshView];
        }
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    _nc = [NSNotificationCenter defaultCenter];
    [_backupNodataImageView setImage:[StringHelper imageNamed:@"noData_safari"]];
    [_nc addObserver:self selector:@selector(backupCompleteReload:) name:NOTIFY_BACKUP_COMPELTE object:nil];
    [_nc addObserver:self selector:@selector(backupErrorReload:) name:NOTIFY_BACKUP_ERROE object:nil];
    if (_isBackup) {
//        [_noDataView setFrame:NSMakeRect(0, 0, 800, 534)];
        [_containTableView setFrame:NSMakeRect(0, 0, 800, 540)];
        [_scrollView setFrame:NSMakeRect(0, 0, 800, 540)];
        [_noDataScrollView setFrameOrigin:NSMakePoint(_noDataScrollView.frame.origin.x - 100, _noDataScrollView.frame.origin.y)];
        [_noDataImageView setFrameOrigin:NSMakePoint(_noDataImageView.frame.origin.x - 100, _noDataImageView.frame.origin.y)];
        [_mainBox setContentView:_loadingView];
        [_loadingAnmationView startAnimation];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            IMBHistorySqliteManager *bookMarkManager = nil;
            if (_isiCloud) {
                bookMarkManager = [[IMBHistorySqliteManager alloc] initWithiCloudBackup:_iCloudBackup withType:_iCloudBackup.iOSVersion];
            }else{
                bookMarkManager = [[IMBHistorySqliteManager alloc] initWithAMDevice:nil backupfilePath:_node.backupPath withDBType:_node.productVersion WithisEncrypted:_node.isEncrypt withBackUpDecrypt:_decryptAbove4];
            }
            [bookMarkManager querySqliteDBContent] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                _dataSourceArray = [bookMarkManager.dataAry retain];
                if (_dataSourceArray != nil && _dataSourceArray.count >0) {
                   [_mainBox setContentView:_containTableView];
                    [_itemTableView reloadData];
                }else{
                    [self configNoDataView];
                    [_mainBox setContentView:_backupNodataView];
                    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_37", nil)];
                    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
                    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
                    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
                    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
                    [_backupNodataTextStr setAttributedStringValue:as];
                    [_backupNodataTextStr setSelectable:NO];
                }
            });
        });
    }else {
        if (_dataSourceArray.count == 0) {
            [_mainBox setContentView:_noDataView];
//            [self configNoDataView];
        }else {
            [_mainBox setContentView:_containTableView];
        }
        [self configRefreshView];

        [_nc addObserver:self selector:@selector(hideRefreshView) name:NOTITY_HIDE_REFRESHVIEW object:nil];
    }
    [self configNoDataView];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeSkin:(NSNotification *)notification
{
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_backupNodataImageView setImage:[StringHelper imageNamed:@"noData_safari"]];
    if (_isBackup) {
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_37", nil)];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_backupNodataTextStr setAttributedStringValue:as];
        [_backupNodataTextStr setSelectable:NO];
    }else{
        [self configNoDataView];
        [self configRefreshView];
    }
    [_loadingAnmationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

-(void)loadData:(NSMutableArray *)ary{
    _dataSourceArray = [ary retain];
    if (_dataSourceArray != nil && _dataSourceArray.count >0) {
//        [_mainBox setContentView:_containTableView];
        [_itemTableView reloadData];
    }else{
        [self configNoDataView];
        [_mainBox setContentView:_backupNodataView];
        [_backupNodataTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_37", nil)]];
    }
}

#pragma mark - NSTextView
- (void)configNoDataView {
    if (_isBackup) {
//        [_containTableView setFrame:NSMakeRect(0, 0, 790, 538)];
//        [_scrollView setFrame:NSMakeRect(0, 0, 790, 538)];
//        [self.view setFrame:NSMakeRect(0, 0, 800, 538)];
//        [_mainBox setFrame:NSMakeRect(0, 0, 800, 538)];
//        [_noDataView setFrame:NSMakeRect(0, 0, 800, 538)];
    }else{
        [_noDataImageView setImage:[StringHelper imageNamed:@"noData_safari"]];
        [_textView setDelegate:self];
        [_textView setSelectable:NO];
        NSString *promptStr = @"";
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_37", nil)];
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
        [_textView setLinkTextAttributes:linkAttributes];
        

        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
        
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:5.0];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_textView textStorage] setAttributedString:promptAs];
        [mutParaStyle release];
        mutParaStyle = nil;
    }
}

#pragma mark - NSTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <=0) {
        return 0;
    }
    return disAry.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <=0) {
        return nil;
    }
    if (row < disAry.count) {
        NSArray *displayArray = nil;
        displayArray = disAry;
        IMBSafariHistoryEntity *entity = [displayArray objectAtIndex:row];
        if ([@"Name" isEqualToString:tableColumn.identifier] ) {
            return entity.title;
        }else if ([@"URL" isEqualToString:tableColumn.identifier]) {
            return entity.forwardURL;
        }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:entity.checkState];
        }
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    IMBSafariHistoryEntity *entity = [disAry objectAtIndex:index];
    entity.checkState = !entity.checkState;
    //点击checkBox 实现选中行
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[_dataSourceArray count]; i++) {
        IMBSafariHistoryEntity *entity = [disAry objectAtIndex:i];
        if (entity.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    
    if (entity.checkState == NSOnState) {
        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }else if (entity.checkState == NSOffState)
    {
        [_itemTableView deselectRow:index];
    }
    
    if (set.count == disAry.count) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else{
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
}

#pragma mark - NSTableViewdelegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *atableView = [notification object];
    if (atableView == _itemTableView) {
//        NSIndexSet *set = [_itemTableView selectedRowIndexes];
//        for (int i=0; i<[_dataSourceArray count]; i++) {
//            IMBSafariHistoryEntity *entity = [_dataSourceArray objectAtIndex:i];
//            if ([set containsIndex:i]) {
//                [entity setCheckState:NSOnState];
//            }else{
//                [entity setCheckState:NSOffState];
//            }
//        }
//        if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
//            [_itemTableView changeHeaderCheckState:NSOnState];
//        }else if ([set count] == 0) {
//            [_itemTableView changeHeaderCheckState:NSOffState];
//        }else {
//            [_itemTableView changeHeaderCheckState:NSMixedState];
//        }
    }
    [_itemTableView reloadData];
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            if ([column.identifier isEqualToString:identify]) {
                [columnHeadercell setIsShowTriangle:YES];
            }else {
                [columnHeadercell setIsShowTriangle:NO];
            }
        }
        
    }
	if ( [@"Name" isEqualToString:identify] || [@"URL" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:_dataSourceArray];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_dataSourceArray count]; i++) {
            IMBTrack *track = [_dataSourceArray objectAtIndex:i];
            if (track.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }

    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        key = @"title";
    } else if ([key isEqualToString:@"URL"]) {
        key = @"forwardURL";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (void)setAllselectState:(CheckStateEnum)checkState {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
//    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disAry count]; i++) {
        IMBSafariHistoryEntity *entity = [disAry objectAtIndex:i];
        [entity setCheckState:checkState];
//        if (entity.checkState == NSOnState) {
//            [set addIndex:i];
//        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 32;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return NSDragOperationNone;
}

- (void)reload:(id)sender {
    [self refreshBackup:NO];
}

-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    int checkCount = 0;
    for (int i=0; i<[disAry count]; i++) {
        IMBSafariHistoryEntity *track = [disAry objectAtIndex:i];
        if (track.checkState == NSOnState) {
            checkCount ++;
        }
    }
    if (checkCount == [disAry count]&&[disAry count]>0) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if (checkCount  == 0)
    {
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else
    {
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    [_itemTableView reloadData];
}

- (void)configRefreshView {
    //检测是否备份
    NSString *textString = nil;
    NSString *btnString = nil;
    if (_dataSourceArray.count > 0 || _information.safariManager.lastBackupScoend != 0) {
        textString =  [NSString stringWithFormat:CustomLocalizedString(@"NoticeBackup_id_1", nil),[DateHelper dateFrom1970ToString:_information.safariManager.lastBackupScoend withMode:2]];
        btnString = CustomLocalizedString(@"Common_id_1", nil);
    }else
    {
        textString = CustomLocalizedString(@"Backup_id_2", nil);
        btnString = CustomLocalizedString(@"Backup_id_3", nil);
    }
    
    NSRect btnRect = [StringHelper calcuTextBounds:btnString fontSize:14];
    NSRect textRect = [StringHelper calcuTextBounds:textString fontSize:14];
    
    [_refreshView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [(IMBLackCornerView *)_refreshView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"refreshView_bgColor", nil)]];
    _refreshTitle = [[NSTextField alloc] init];
    [_refreshTitle setSelectable:NO];
    [_refreshTitle setFrame:NSMakeRect(30, 2, textRect.size.width + 20, 24)];
    [_refreshTitle setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_refreshTitle setBordered:NO];
    [_refreshTitle setFocusRingType:NSFocusRingTypeNone];
    [_refreshTitle setDrawsBackground:NO];
    [_refreshTitle setAlignment:NSCenterTextAlignment];
    [_refreshTitle setStringValue:textString];
    [_refreshTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"refreshView_titleColor", nil)]];
    [_refreshView setFrame:NSMakeRect(((self.view.bounds.size.width) - (textRect.size.width + btnRect.size.width + 100))/2, 0, (textRect.size.width + btnRect.size.width + 100), 30)];
    [_refreshView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewNotSizable];
    for (NSView *view in _refreshView.subviews) {
        if ([view isKindOfClass:[NSTextField class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    [_refreshView addSubview:_refreshTitle];
    [_refreshTitle release];

    [self.view addSubview:_refreshView];

    
    for (NSView *view in _refreshView.subviews) {
        if ([view isKindOfClass:[IMBRefreshButton class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    if (_refreshBtn != nil) {
        [_refreshBtn release];
        _refreshBtn = nil;
    }
    _refreshBtn = [[IMBRefreshButton alloc] initWithFrame:NSMakeRect(_refreshTitle.frame.size.width + 40, _refreshTitle.frame.origin.y + 4 , btnRect.size.width + 6, btnRect.size.height) withName:btnString];
    [_refreshBtn setTarget:self];
    [_refreshBtn setAction:@selector(doRefreshView:)];
    [_refreshView addSubview:_refreshBtn];
    [_refreshView setNeedsDisplay:YES];
}

- (void)doRefreshView:(id)sender {
    [_loadingView removeFromSuperview];
    [_containTableView removeFromSuperview];
    if ([self checkBackupEncrypt]) {//设备备份在iTunes上设置的是加密的
        [self showAlertText:CustomLocalizedString(@"backup_id_text_10", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    if (_backupAnimationVC) {
        [_backupAnimationVC release];
        _backupAnimationVC = nil;
    }
    _backupAnimationVC = [[IMBBackupAnimationViewController alloc]initWithNibName:@"IMBBackupAnimationViewController" bundle:nil Withipod:_ipod withViewTag:1];
    
    [_mainBox setContentView:_backupAnimationVC.view];
    [self animationAddTransferView:_backupAnimationVC.view];
    [_backupAnimationVC startBackupDevice];
}

- (void)refreshBackup:(BOOL)refresh {
    if ([self checkBackupEncrypt]) {
        [self showAlertText:CustomLocalizedString(@"backup_id_text_10", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    [self disableFunctionBtn:NO];
    [_backupAnimationVC.view removeFromSuperview];
    [_mainBox setContentView:_loadingView];
    [_loadingAnmationView startAnimation];

    //开启线程加载数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            [_information.safariManager setIsRefresh:refresh];
            [_information loadSafariHistory:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                [_loadingAnmationView endAnimation];
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [_information.safariHistoryArray retain];
                if (_dataSourceArray.count == 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    [_mainBox setContentView:_containTableView];
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [(IMBDeviceMainPageViewController *)_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
                }
                [_loadingAnmationView endAnimation];
                [_itemTableView deselectAll:nil];
                [_itemTableView reloadData];
            });
        }
    });
}

- (void)hideRefreshView {
    [_refreshView setHidden:YES];
}

- (void)animationAddTransferView:(NSView *)view {
//    [view setFrame:NSMakeRect(0, 0, [self view].frame.size.width, [self view].frame.size.height)];
//    [[self view] addSubview:view];
    [view setFrame:NSMakeRect(0, 0, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.width, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.height)];
    [[(IMBDeviceMainPageViewController *)_delegate view] addSubview:view];
    [view setWantsLayer:YES];
    [view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
}

- (void)backupCompleteReload:(NSNotification *)notification {
    int i  =  [notification.object intValue];
    if (i == 1) {
        [self reload:nil];
    }
    [_refreshView setHidden:YES];
    [_nc postNotificationName:NOTITY_HIDE_REFRESHVIEW object:nil];
}

- (void)backupErrorReload:(NSNotification *)notification {
    int i  =  [notification.object intValue];
    if (i == 1) {
        if (_dataSourceArray.count == 0) {
            [_mainBox setContentView:_noDataView];
            [self configNoDataView];
        }else {
            [_mainBox setContentView:_containTableView];
        }
    }
}

- (void)dealloc {
    [_nc removeObserver:self name:NOTIFY_BACKUP_COMPELTE object:nil];
    [_nc removeObserver:self name:NOTITY_HIDE_REFRESHVIEW object:nil];
    [_nc removeObserver:self name:NOTIFY_BACKUP_ERROE object:nil];
    if (_backupAnimationVC) {
        [_backupAnimationVC release];
        _backupAnimationVC = nil;
    }
    [super dealloc];
}
@end
