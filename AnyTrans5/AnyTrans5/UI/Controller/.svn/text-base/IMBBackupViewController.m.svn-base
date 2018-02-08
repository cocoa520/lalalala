//
//  IMBBackupViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackupViewController.h"
#import "IMBBackupManager.h"
#import "TempHelper.h"
#import "DateHelper.h"
#import "SystemHelper.h"
#import "StringHelper.h"
#import "IMBImageAndTextCell.h"
#import "IMBTableViewBtnCell.h"
#import "IMBBackupAllDataViewController.h"
#import "IMBBackupDecryptAbove4.h"
#import "IMBInformationManager.h"
#import "IMBDeviceConnection.h"
#import "IMBNotificationDefine.h"
#import "IMBCustomHeaderCell.h"
#import "IMBMenuItem.h"
#import "IMBAnimation.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBNavigationViewController.h"
#import "IMBMainWindowController.h"
@interface IMBBackupViewController ()

@end

@implementation IMBBackupViewController
@synthesize backupMainPageDic = _backupMainPageDic;
@synthesize isComeFormAirwifi = _isComeFormAirwifi;

-(void)dealloc  {
    [_navMainMenu release],_navMainMenu = nil;
    if (_jumpViewBtn != nil) {
        [_jumpViewBtn release];
        _jumpViewBtn = nil;
    }
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_ipod != nil) {
        [_ipod release];
        _ipod = nil;
    }
    if (_allDataController != nil) {
        [_allDataController release];
        _allDataController = nil;
    }
    if (_processingQueue != nil) {
        [_processingQueue release];
        _processingQueue = nil;
    }
    if (_backRestore != nil) {
        [_backRestore release];
        _backRestore = nil;
    }
    [self setBackupMainPageDic:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

- (instancetype)init
{
    if (self = [super init]) {
        _backupMainPageDic = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupDeviceConnected:) name:DeviceConnectedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupDeviceDisconnected:) name:DeviceDisConnectedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupDeviceIpodLoadComplete:) name:DeviceIpodLoadCompleteNotification object:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

-(id)initWithiPod:(IMBiPod *)ipod{
    if ([super initWithNibName:@"IMBBackupViewController" bundle:nil]) {
        if (ipod.deviceInfo.isIOSDevice) {
            _ipod = [ipod retain];
        }
    }
    return self;
}

-(void)repIpod:(IMBiPod *)ipod{
    if (ipod.deviceInfo.isIOSDevice) {
        if (_ipod != nil) {
            [_ipod release];
            _ipod = nil;
        }
        _ipod = [ipod retain];
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        _dataSourceArray = [[NSMutableArray alloc] initWithArray:[manager getBackupRootNode:_ipod withPath:[TempHelper getBackupFolderPath]]];
        [_itemTableView reloadData];
    }
}

-(void)loadViewBtn{
    [_itemTableView reloadData];
    if (_dataSourceArray != nil && _dataSourceArray.count >0&&[_itemTableView selectedRow] >=0) {
        SimpleNode *entity = [_dataSourceArray objectAtIndex:[_itemTableView selectedRow]];
        [entity.deleteBtn setNeedsDisplay:YES];
        [_jumpViewBtn setNeedsDisplay:YES];
//        [_tableView reloadData];
    }
}

-(void)getIpod:(NSNotification *)notification{
    IMBiPod *ipod = [notification object];
//    if (ipod != nil &&!ipod.deviceInfo.isIOSDevice) {
//        return;
//    }
    if (_ipod != nil) {
        [_ipod release];
        _ipod = nil;
    }
    _ipod = [ipod retain];

    int count = 0;
    if (_dataSourceArray != nil &&_dataSourceArray.count >0) {
        NSMutableArray *noteAyr = [NSMutableArray arrayWithArray:_dataSourceArray];
        for (SimpleNode *node in noteAyr) {
            if ([node.udid isEqualToString:_ipod.deviceHandle.udid]) {
                node.isDeviceNode = YES;
//                NSInteger teger = [_dataSourceArray indexOfObject:node];
                [_dataSourceArray exchangeObjectAtIndex:count withObjectAtIndex:[_dataSourceArray indexOfObject:node]];
                count ++;
            }else{
                node.isDeviceNode = NO;
            }
        }
    }
//    else{//暂时不加设备连接时去获取backup文件的列表
//        if (_dataSourceArray != nil) {
//            [_dataSourceArray release];
//            _dataSourceArray = nil;
//        }
//        IMBBackupManager *manager = [IMBBackupManager shareInstance];
//        _dataSourceArray = [[manager getBackupRootNode:_ipod withPath:[TempHelper getBackupFolderPath]] retain];
//    }
    [_itemTableView reloadData];
}

- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
         [_toolBar changeBtnTooltipStr];
        [_titleTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        if (_dataSourceArray.count > 1) {
            [_titleTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"backup_title_Complex", nil),(unsigned long)_dataSourceArray.count]];
        }else {
            [_titleTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"backup_title", nil),(unsigned long)_dataSourceArray.count]];
        }
        [_itemTableView reloadData];
        [_toBackupPathBtn setTitleName:CustomLocalizedString(@"Backup_id_4", nil)];
        [_backupCompleteViewTitel setStringValue:CustomLocalizedString(@"Transfer_text_Backup_complete", nil)];
        
        NSString *str = CustomLocalizedString(@"Backup_Default_Title", nil);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
        }else {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
        }
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
        
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_noDataBackupTitle setAttributedStringValue:as];
        
        if (_isConnectBackup) {
            _noDataBackupDescription.delegate = self;
            _noDataBackupDescription.linkTextAttributes = [NSDictionary dictionaryWithObject:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] forKey:NSForegroundColorAttributeName];
            NSString *str2 = CustomLocalizedString(@"Backup_Default_Backup_Describe", nil);
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str2];
            NSRange info = [str2 rangeOfString:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil)];
            [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, attriStr.length)];
            [attriStr addAttribute:NSForegroundColorAttributeName
                             value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]
                             range:NSMakeRange(0, attriStr.length)];
            
            [attriStr addAttribute:NSLinkAttributeName value:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil) range:info];
            [attriStr addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:info];
            [attriStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0, str2.length)];
            [[_noDataBackupDescription textStorage] setAttributedString:attriStr];
            [attriStr release];
        }else {
            _noDataBackupDescription.delegate = nil;
            NSString *str2 = CustomLocalizedString(@"Backup_Default_NoInstall_Describe", nil);
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str2];
            [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, attriStr.length)];
            [attriStr addAttribute:NSForegroundColorAttributeName
                             value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]
                             range:NSMakeRange(0, attriStr.length)];
            [attriStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0, str2.length)];
            [[_noDataBackupDescription textStorage] setAttributedString:attriStr];
            [attriStr release];
        }
    });

}

-(void)awakeFromNib{
    [super awakeFromNib];
    _isComeFormAirwifi = NO;
    [_noDataBackupImageView setImage:[StringHelper imageNamed:@"noconnect_backup"]];
    _connection = [IMBDeviceConnection singleton];
//    BOOL res = [self checkIsHasBackupData];
//    if (res) {
//        [self setIsShowLineView:YES];
    _itemTableViewcanDrag = NO;
    _itemTableViewcanDrop = NO;
    [self changeViewController:NO];
//    }else {
//        [self setIsShowLineView:NO];
//        [self changeViewController];
//    }
}

- (void)changeSkin:(NSNotification *)notification
{
    [_noteImageView setImage:[StringHelper imageNamed:@"transfer_note"]];
    [_backupCompleteViewTitel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_toBackupPathBtn WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_titleTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_jumpViewBtn WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [_jumpViewBtn WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    //填充的颜色
    [_jumpViewBtn WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [_toolBar changeBtnTooltipStr];
    [_itemTableView reloadData];
    [_loadingAnimationView setNeedsDisplay:YES];
    [self configNoDataView];
    [_noDataView setIsGradientColorNOCornerPart3:YES];
    [_noDataView setNeedsDisplay:YES];
//    [_backupDataView setIsGradientColorNOCornerPart4:YES];
//    [_backupDataView setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
    [_loadingView setNeedsDisplay:YES];
    
    NSString *str = CustomLocalizedString(@"Backup_Default_Title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_noDataBackupTitle setAttributedStringValue:as];
    
    if (_isConnectBackup) {
        _noDataBackupDescription.delegate = self;
        _noDataBackupDescription.linkTextAttributes = [NSDictionary dictionaryWithObject:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] forKey:NSForegroundColorAttributeName];
        NSString *str2 = CustomLocalizedString(@"Backup_Default_Backup_Describe", nil);
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str2];
        NSRange info = [str2 rangeOfString:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil)];
        [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, attriStr.length)];
        [attriStr addAttribute:NSForegroundColorAttributeName
                         value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]
                         range:NSMakeRange(0, attriStr.length)];
        
        [attriStr addAttribute:NSLinkAttributeName value:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil) range:info];
        [attriStr addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:info];
        [attriStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0, str2.length)];
        [[_noDataBackupDescription textStorage] setAttributedString:attriStr];
        [attriStr release];
    }else {
        _noDataBackupDescription.delegate = nil;
        NSString *str2 = CustomLocalizedString(@"Backup_Default_NoInstall_Describe", nil);
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str2];
        [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, attriStr.length)];
        [attriStr addAttribute:NSForegroundColorAttributeName
                         value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]
                         range:NSMakeRange(0, attriStr.length)];
        [attriStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0, str2.length)];
        [[_noDataBackupDescription textStorage] setAttributedString:attriStr];
        [attriStr release];
    }
    
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_box"]];
    [_noDataBackupImageView setImage:[StringHelper imageNamed:@"noconnect_backup"]];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        NSRect frame =  _noDataView.frame;
        frame.origin.y = self.view.frame.origin.y ;
        frame.size.width = self.view.frame.size.width;
        _noDataView.frame = frame;
        [_noDataImageView.cell setImageAlignment:NSImageAlignBottom];
    }else {
        NSRect frame =  _noDataView.frame;
        frame.origin.y = self.view.frame.origin.y + 5;
        frame.size.width = self.view.frame.size.width;
        _noDataView.frame = frame;
        [_noDataImageView.cell setImageAlignment: NSImageAlignCenter];
    }
    [_noDataView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
}

- (IBAction)gotoBackupPath:(id)sender {
    [[IMBLogManager singleton] writeInfoLog:@"open backupPath"];
    IMBBackupManager *manager = [IMBBackupManager shareInstance];
    SimpleNode *curNdoe = [manager getSingleBackupRootNode:_backRestore.deviceBackupPath];
    [self enterView:curNdoe];
    
    [_contentView setAutoresizingMask:NSViewMinYMargin];
    [_backupProView setFrame:NSMakeRect(0, -10, _backupProView.frame.size.width, _backupProView.frame.size.height + 10)];
    [_backupProView setWantsLayer:YES];
    //    [_backupProView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-_backupProView.frame.size.height] repeatCount:1] forKey:@"moveY"];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:10] repeatCount:1];
        [_backupProView.layer addAnimation:anima1 forKey:@"deviceImageView"];
    } completionHandler:^{
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:10] Y:[NSNumber numberWithInt:-_backupProView.frame.size.height] repeatCount:1];
        [_backupProView.layer addAnimation:anima1 forKey:@"deviceImageView"];
    }];
    
    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:0.6];
}

- (NSMenu *)createNavMenu
{
    //开始构建menu
    NSMutableArray *devceArr = [NSMutableArray array];   //得到所有的设备node
    NSMutableArray *devceudid = [NSMutableArray array];
    for (SimpleNode *node in _dataSourceArray) {
        if (![devceudid containsObject:node.udid]) {
            SimpleNode *nnode = [[SimpleNode alloc] init];
            nnode.deviceName = node.deviceName;
            nnode.udid = node.udid;
            nnode.fileName = node.deviceName;
            nnode.container = YES;
            nnode.isDeviceNode = YES;
            nnode.productType = node.productType;
            nnode.snapshotID = node.snapshotID;
            [devceArr addObject:nnode];
            [devceudid addObject:node.udid];
            [nnode release];
        }
    }
    NSMenu *mainMenu = [[NSMenu alloc] init];
    for (SimpleNode *devicenode in devceArr) {
        NSMenu *subMenu = [[NSMenu alloc] init];
        IMBMenuItem *item = [[IMBMenuItem alloc] init];
        [item setBackupnode:devicenode];
        [item setEnabled:YES];
        [item setSubmenu:subMenu];
        [mainMenu addItem:item];
        for (SimpleNode *node in _dataSourceArray){
            if ([devicenode.udid isEqualToString:node.udid]) {
                IMBMenuItem *subitem = [[IMBMenuItem alloc] init];
                [subitem setAction:@selector(navigateTo:)];
                [subitem setTarget:self];
                [subitem setBackupnode:node];
                [subitem setEnabled:YES];
                [subMenu addItem:subitem];
                [subitem release];
            }
        }
        [subMenu release];
        [item release];
    }
    return [mainMenu autorelease];
}

- (void)navigateTo:(IMBMenuItem *)item
{
    [((IMBMenuItemView *)item.view) setIsMouseEnter:NO];
    [item.menu cancelTracking];
    if (item.backupnode.isEncrypt) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:item waitUntilDone:NO];
        });
    }else{
        if (_allDataController != nil) {
            [_allDataController release];
            _allDataController = nil;
        }
        _allDataController = [[IMBBackupAllDataViewController alloc]initWithSimpleNode:item.backupnode withDelegate:self withAcove4:nil];
        _isSearch = NO;
        [_searchFieldBtn setStringValue:@""];
        [_box setContentView:_allDataController.view];
    }
}

- (void)showAlert:(IMBMenuItem *)item
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSInteger result = [_alertViewController showAlertText:CustomLocalizedString(@"backup_PasswordWindow_id_1", nil) WithSubTitleStr:CustomLocalizedString(@"backup_PasswordWindow_id_2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) canCelBtn:CustomLocalizedString(@"iCloudBackup_View_CancelBtn_Tips", nil) SuperView:view];
    if (result == 1) {
        _secrettnode = item.backupnode;
    }
}

#pragma mark - NSMenuDelegate
- (void)menuDidClose:(NSMenu *)menu
{
    for (IMBMenuItem *menuitem in menu.itemArray) {
        ((IMBMenuItemView *)menuitem.view).isMouseEnter = NO;
    }
}

- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item
{
    for (IMBMenuItem *menuitem in menu.itemArray) {
        if (menuitem == item) {
            ((IMBMenuItemView *)menuitem.view).isMouseEnter = YES;
        }else{
            ((IMBMenuItemView *)menuitem.view).isMouseEnter = NO;
        }
    }
}

- (void)configNoDataView {
    
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_box"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_3", nil);
    promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_85", nil)] stringByAppendingString:overStr];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 42;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_isSearch) {
        return _researchdataSourceArray.count;
    }else{
        return _dataSourceArray.count;
    }
    
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *disArray;
    if (_isSearch) {
        disArray = _researchdataSourceArray;
    }else{
        disArray = _dataSourceArray;
    }
    if (disArray.count <=0 || disArray.count <= row) {
        return nil;
    }
    if (row < 0) {
        return nil;
    }
    SimpleNode *entity = [disArray objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"DeviceType"]) {
        return entity.deviceName;
    }else if ([[tableColumn identifier] isEqualToString:@"Size"]) {
        return [StringHelper getFileSizeString:entity.itemSize reserved:2];
    }else if ([[tableColumn identifier] isEqualToString:@"TimeDate"]) {
        return entity.backupDate;
    }else if ([[tableColumn identifier] isEqualToString:@"SerialNub"]) {
        return entity.serialNumber;
    }else if ([[tableColumn identifier] isEqualToString:@"iOSNub"]) {
        if ([entity.productVersion isVersionMajorEqual:@"10"]&&[entity.productVersion isVersionLess:@"11"]) {
            entity.iosProductTye = [entity.productVersion stringByReplacingOccurrencesOfString:@"10" withString:@"9.4"];
        }else if ([entity.productVersion isVersionMajorEqual:@"11"]){
            entity.iosProductTye = [entity.productVersion stringByReplacingOccurrencesOfString:@"11" withString:@"9.5"];
        }else{
            entity.iosProductTye = entity.productVersion;
        }
        return entity.productVersion;
    }
    return @"";
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSMutableArray *disArray;
    if (_isSearch) {
        disArray = _researchdataSourceArray;
    }else{
        disArray = _dataSourceArray;
    }
    if (disArray.count <= 0 || disArray.count <= row) {
        return;
    }
    SimpleNode *entity = [disArray objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"headCell"]) {
           IMBImageAndTextCell *text = (IMBImageAndTextCell *)cell;
        if (entity.isDeviceNode) {
            [text setMarginX:10];
            [text setPaddingX:0];
            [text setImageSize:NSMakeSize(20, 20)];
            text.image = [StringHelper imageNamed:@"connect"];
            text.imageName = @"connect";
        }else{
            text.image = nil;
        }
    }else if ([tableColumn.identifier isEqualToString:@"DeviceType"]){
        IMBImageAndTextCell *text = (IMBImageAndTextCell *)cell;
        [text setMarginX:10];
        [text setPaddingX:0];
        [text setImageSize:NSMakeSize(20, 28)];
        if (entity.productType == iPhoneType) {
            text.image = [StringHelper imageNamed:@"iPhone"];
            text.imageName = @"iPhone";
        }else if (entity.productType == iPodTouchType){
            text.image = [StringHelper imageNamed:@"ipod_touch"];
            text.imageName = @"ipod_touch";
        }else if (entity.productType == iPadType){
            text.image = [StringHelper imageNamed:@"ipad"];
            text.imageName = @"ipad";
        }
        if (entity.isEncrypt){
            [text setLockImg:[StringHelper imageNamed:@"lock"]];
        }else{
            [text setLockImg:nil];
        }
    }else if ([tableColumn.identifier isEqualToString:@"Btn"]){
        IMBTableViewBtnCell *btnCell = (IMBTableViewBtnCell*)cell;
        btnCell.findBtn = entity.deleteBtn;
        NSInteger selectedRow = [_tableView selectedRow];
        if (selectedRow == row) {
            btnCell.isSelected = YES;
        }else{
            btnCell.isSelected = NO;
        }
    }
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    if ( [@"headCell" isEqualToString:identify] || [@"Btn" isEqualToString:identify]) {
        IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
        [customHeaderCell setIsShowTriangle:NO];
        return;
    }
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
	if ( [@"DeviceType" isEqualToString:identify] || [@"Size" isEqualToString:identify]|| [@"TimeDate" isEqualToString:identify]|| [@"SerialNub" isEqualToString:identify]|| [@"iOSNub" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
            if (_isSearch) {
                [self sort:customHeaderCell.ascending key:identify dataSource:_researchdataSourceArray];
            }else{
                [self sort:customHeaderCell.ascending key:identify dataSource:_dataSourceArray];
            }
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        if (_isSearch) {
            for (int i=0;i<[_researchdataSourceArray count]; i++) {
                IMBTrack *track = [_researchdataSourceArray objectAtIndex:i];
                if (track.checkState == NSOnState) {
                    [set addIndex:i];
                }
            }

        }else{
            for (int i=0;i<[_dataSourceArray count]; i++) {
                IMBTrack *track = [_dataSourceArray objectAtIndex:i];
                if (track.checkState == NSOnState) {
                    [set addIndex:i];
                }
            }
        }
    }
    
    [_tableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"DeviceType"]) {
        key = @"deviceName";
    } else if ([key isEqualToString:@"Size"]) {
        key = @"itemSize";
    } else if ([key isEqualToString:@"TimeDate"]) {
        key = @"backupDate";
    } else if ([key isEqualToString:@"SerialNub"]) {
        key = @"serialNumber";
    } else if ([key isEqualToString:@"iOSNub"]) {
        key = @"iosProductTye";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_tableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (void)loadButtonCell:(int)row withOutlineView:(IMBCustomHeaderTableView *)outlineView{
    NSMutableArray *disArray;
    if (_isSearch) {
        disArray = _researchdataSourceArray;
    }else{
        disArray = _dataSourceArray;
    }
    if (disArray.count <= 0) {
        return;
    }

    if (row >= 0) {
        if (_oldTagRow >=0) {
            SimpleNode *entity1 = [disArray objectAtIndex:_oldTagRow];
            [entity1.deleteBtn removeFromSuperview];
            entity1.deleteBtn = nil;
        }
        SimpleNode *entity = [disArray objectAtIndex:row];
        entity.deleteBtn = _jumpViewBtn;
//        [_jumpViewBtn setNeedsDisplay:YES];
//        [entity.deleteBtn setNeedsDisplay:YES];
    }else{
        if (_oldTagRow >=0) {
            SimpleNode *entity1 = [disArray objectAtIndex:_oldTagRow];
            [entity1.deleteBtn removeFromSuperview];
            entity1.deleteBtn = nil;
        }
//        for (SimpleNode *entity in disArray) {
//            [entity.deleteBtn removeFromSuperview];
//            entity.deleteBtn = nil;
//        }
    }
    _oldTagRow = row;
    [_tableView reloadData];
}

-(void)loadButtonMouseExitedCell:(int)row withOutlineView:(IMBCustomHeaderTableView *)outlineView{
    NSMutableArray *disArray;
    if (_isSearch) {
        disArray = _researchdataSourceArray;
    }else{
        disArray = _dataSourceArray;
    }
    if (disArray.count <= 0) {
        return;
    }
//    for (SimpleNode *entity in disArray) {
//        [entity.deleteBtn removeFromSuperview];
//        entity.deleteBtn = nil;
//    }
    if (_oldTagRow >=0) {
        SimpleNode *entity1 = [disArray objectAtIndex:_oldTagRow];
        [entity1.deleteBtn removeFromSuperview];
        entity1.deleteBtn = nil;
    }
    [_tableView  reloadData];
}

-(void)jumpViewBtn:(id)sender{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iTunes_Backup action:ActionNone actionParams:@"scan backup" label:Click transferCount:0 screenView:@"scan backup" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSInteger row =  [_tableView clikeRow];
    _selectedRow = (int)row;
    NSMutableArray *disArray;
    if (_isSearch) {
        disArray = _researchdataSourceArray;
    }else{
        disArray = _dataSourceArray;
    }
    if (disArray.count <= 0) {
        return;
    }
    
    SimpleNode *node = [disArray objectAtIndex:row];
    [self enterView:node];
}

- (void)enterView:(SimpleNode *)node {
    if (node.isEncrypt) {
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [_alertViewController showAlertText:CustomLocalizedString(@"backup_PasswordWindow_id_1", nil) WithSubTitleStr:CustomLocalizedString(@"backup_PasswordWindow_id_2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) canCelBtn:CustomLocalizedString(@"iCloudBackup_View_CancelBtn_Tips", nil) SuperView:view];
    }else{
        if (_allDataController != nil) {
            [_allDataController release];
            _allDataController = nil;
        }
        
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"fileName:%@ deviceName:%@ productVersion:%@ itemSize:%lld",node.fileName,node.deviceName,node.productVersion,node.itemSize]];
        _allDataController = [[IMBBackupAllDataViewController alloc]initWithSimpleNode:node withDelegate:self withAcove4:nil];
        _isSearch = NO;
        [_searchFieldBtn setStringValue:@""];
        _isView = YES;
        [_itemBox setContentView:_allDataController.view];
    }

}

-(void)secireOkBtnOperation:(id)sender with:(NSString *)pass{
    NSLog(@"passL1 :%@",pass);
    if ([IMBHelper stringIsNilOrEmpty:pass]) {
        return;
    }
    NSMutableArray *disArray;
    if (_isSearch) {
        disArray = _researchdataSourceArray;
    }else{
        disArray = _dataSourceArray;
    }
    if (disArray.count <= 0) {
        return;
    }
    if (_selectedRow < disArray.count &&_selectedRow >=0 ) {
        __block SimpleNode *node = [disArray objectAtIndex:_selectedRow];
        NSString *outputPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"decriptBackup"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        IMBBackupDecryptAbove4 *dAbove4 = [[IMBBackupDecryptAbove4 alloc] initWithPath:node.backupPath withOutputPath:outputPath withIOSProductVersion:node.productVersion];
            [dAbove4 setIosVersion:node.productVersion];
            
            //验证密码是否正确
            BOOL isRight = NO;
            if ([node.productVersion isVersionMajorEqual:@"10.0"]) {
                isRight = [dAbove4 decodeManifestDBFile:pass withPath:[node.backupPath stringByAppendingPathComponent:@"Manifest.plist"]];
                if (isRight) {
                    isRight = [dAbove4 againParseManifestDB:outputPath];
                    if (isRight) {
                        isRight = [dAbove4 verifyPasswordIsRight];
                        [node setDecryptPath:outputPath];
                    }
                }
            }else {
                isRight = [dAbove4 verifyPassword:pass withPath:[node.backupPath stringByAppendingPathComponent:@"Manifest.plist"]];
                [node setDecryptPath:outputPath];
            }
            
            if (isRight) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ITUNES_SIGNIN_SUCCESS object:self userInfo:nil];
               
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    if (_ipod != nil) {
                        IMBInformationManager *manager = [IMBInformationManager shareInstance];
                        IMBInformation *information = [manager.informationDic objectForKey:_ipod.uniqueKey];
                        if (node.backupPath != nil) {
                            [information.passwordDic setObject:dAbove4 forKey:node.backupPath];
                        }
                    }
                    if (_allDataController != nil) {
                        [_allDataController release];
                        _allDataController = nil;
                    }
                    if (_secrettnode) {
                        node = _secrettnode;
                    }
                    _allDataController = [[IMBBackupAllDataViewController alloc] initWithSimpleNode:node withDelegate:self withAcove4:dAbove4];
                    _isSearch = NO;
                    [_searchFieldBtn setStringValue:@""];
                    _isView = YES;
                    [_itemBox setContentView:_allDataController.view];
                    _secrettnode = nil;
                    [dAbove4 release];
                });
            }else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ITUNES_SIGNIN_FAIL object:self userInfo:nil];
                [dAbove4 release];
            }
        });
    }
}

-(void)backBackUpView{
    
    [_allDataController release],_allDataController = nil;
    [_noDataBoxView setContentView:nil];
    _isSearch = NO;
    [_tableView reloadData];
    if (_dataSourceArray &&  _dataSourceArray.count > 0) {
        [self setIsShowLineView:YES];
        _isView = NO;
        [_itemBox setContentView:_backupDataView];
        IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
        if (mainWindow.curFunctionType == BackupModule) {
            [mainWindow.searchView setHidden:NO];
        }
    }else {
        [self setIsShowLineView:NO];
        [self changeNoDataBackupView];
        _isView = NO;
        [_itemBox setContentView:_noBackupView];
        IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
        if (mainWindow.curFunctionType == BackupModule) {
            [mainWindow.searchView setHidden:YES];
        }
    }
}

- (void)reload:(id)sender {
//    [_progressIndicator setHidden:NO];
//    [_progressIndicator startAnimation:self];
    [_noDataBoxView setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_searchFieldBtn setHidden:YES];
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    [_toolBar toolBarButtonIsEnabled:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        IMBBackupManager *manager = [IMBBackupManager shareInstance];

        _dataSourceArray = [[NSMutableArray alloc] initWithArray:[manager getBackupRootNode:_ipod withPath:[TempHelper getBackupFolderPath]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolBar toolBarButtonIsEnabled:YES];
            [_titleTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            if (_dataSourceArray.count >= 1) {
                [_noDataBoxView setContentView:nil];
                [_titleTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"backup_title_Complex", nil),(unsigned long)_dataSourceArray.count]];
            }else {
                [_noDataBoxView setContentView:_noDataView];
                [self configNoDataView];
                [_titleTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"backup_title", nil),(unsigned long)_dataSourceArray.count]];
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
            [_loadingAnimationView endAnimation];
            _moveRow = 0;
            [_searchFieldBtn setHidden:NO];
            [_tableView  reloadData];
//            [_progressIndicator setHidden:YES];
        });
    });
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (_allDataController == nil) {
        if (searchStr != nil && ![searchStr isEqualToString:@""]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceName CONTAINS[cd] %@ ",searchStr];
            [_researchdataSourceArray removeAllObjects];
            [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray filteredArrayUsingPredicate:predicate]];
            if (_researchdataSourceArray.count <= 0 ||_oldTagRow >_researchdataSourceArray.count -1) {
                for (SimpleNode *entity in _dataSourceArray) {
                    [entity.deleteBtn removeFromSuperview];
                    entity.deleteBtn = nil;
                }
            }
          
        }else{
            _isSearch = NO;
            [_researchdataSourceArray removeAllObjects];
        }
    }else{
        [_allDataController doSearchBtn:searchStr withSearchBtn:searchBtn];
    }
    [_tableView reloadData];
}

- (void)deleteItems:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iTunes_Backup action:ActionNone actionParams:@"delete Backup Path" label:Click transferCount:0 screenView:@"delete Backup Path" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSInteger tagRow = [_tableView  selectedRow];

    if (tagRow <0) {
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_85", nil)];
        }else {
            str = CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil);
        }
        
        [_alertViewController showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)  SuperView:view];
    }else{
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [_alertViewController showAlertText:CustomLocalizedString(@"iCloudBackup_View_Delete_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"iCloudBackup_View_CancelBtn_Tips", nil) SuperView:view];
    }
}

- (void)deleteBackupSelectedItems:(id)sender{
    [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:0];
    [_alertViewController._removeprogressAnimationView setProgress:90];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *disArray;
        if (_isSearch) {
            disArray = _researchdataSourceArray;
        }else{
            disArray = _dataSourceArray;
        }
        if (disArray.count <= 0) {
            return;
        }
        NSFileManager *manager = [NSFileManager defaultManager];
        NSInteger tagRow = [_tableView selectedRow];
        SimpleNode *entity = [disArray objectAtIndex:tagRow];
        [entity.deleteBtn removeFromSuperview];
        [manager removeItemAtPath:entity.backupPath error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataSourceArray removeObject:entity];
            [_tableView reloadData];
            [_alertViewController._removeprogressAnimationView setProgress:100];
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:1];
                [_titleTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                if (_dataSourceArray.count > 1) {
                    [_titleTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"backup_title_Complex", nil),(unsigned long)_dataSourceArray.count]];
                }else {
                    [_titleTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"backup_title", nil),(unsigned long)_dataSourceArray.count]];
                }
                if (_dataSourceArray &&  _dataSourceArray.count > 0) {
                    [self setIsShowLineView:YES];
                    _isView = NO;
                    [_itemBox setContentView:_backupDataView];
                    IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                    if (mainWindow.curFunctionType == BackupModule) {
                        [mainWindow.searchView setHidden:NO];
                    }
                }else {
                    [self setIsShowLineView:NO];
                    [self changeNoDataBackupView];
                    _isView = NO;
                    [_itemBox setContentView:_noBackupView];
                    IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                    if (mainWindow.curFunctionType == BackupModule) {
                        [mainWindow.searchView setHidden:YES];
                    }
                }
            });
        });
    });
}

-(void)dofindPath:(id)sender{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iTunes_Backup action:ActionNone actionParams:@"find Backup Path" label:Click transferCount:0 screenView:@"find Backup Path" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    NSInteger tagRow = [_tableView  selectedRow];
    if (tagRow <0) {
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [_alertViewController showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) SuperView:view];
    }else{
        NSMutableArray *disArray;
        if (_isSearch) {
            disArray = _researchdataSourceArray;
        }else{
            disArray = _dataSourceArray;
        }
        if (disArray.count <= 0) {
            return;
        }
        SimpleNode *entity = [disArray objectAtIndex:tagRow];
        [workSpace openFile:entity.backupPath];
    }
}

- (void)doBackup:(id)sender {
    [[IMBLogManager singleton] writeInfoLog:@"start backup backupView"];
    _isBackupComplete = NO;
    [self setIsShowLineView:YES];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iTunes_Backup action:ActionNone actionParams:@"Backups device" label:Click transferCount:0 screenView:@"Backups device" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    if (_ipod != nil && _ipod.deviceInfo.isIOSDevice) {
        [_backupViewProgressView setContentView:_backupProgressView];
        if ([self checkBackupEncrypt]) {//设备备份在iTunes上设置的是加密的
            _isOkAction = NO;
            [self showAlertText:CustomLocalizedString(@"backup_id_text_10", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            [self setIsShowLineView:NO];
            return;
        }
        [self configTitle];
        [self animationAddTransferView:_backupProView];
        [self performSelector:@selector(startBackupDevice) withObject:nil afterDelay:0.5];
    }else {
        //弹出提示框
        _isOkAction = NO;
        [self showAlertText:CustomLocalizedString(@"iTunes_Nothave_toDevices", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

- (void)animationAddTransferView:(NSView *)view {
    [view setFrame:NSMakeRect(0, 0, [self view].frame.size.width, [self view].frame.size.height)];
    [[self view] addSubview:view];
    [view setWantsLayer:YES];
    [view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
//        [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//    } completionHandler:^{
//        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-40] repeatCount:1];
//            [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//        } completionHandler:^{
//            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:-40] Y:[NSNumber numberWithInt:0] repeatCount:1];
//            [view.layer addAnimation:anima1 forKey:@"deviceImageView"];
//        }];
//    }];
}

- (void)animationRemoveBackupView {
    [_contentView setAutoresizingMask:NSViewMinYMargin];
    [_backupProView setFrame:NSMakeRect(0, -10, _backupProView.frame.size.width, _backupProView.frame.size.height + 10)];
    [_backupProView setWantsLayer:YES];
//    [_backupProView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-_backupProView.frame.size.height] repeatCount:1] forKey:@"moveY"];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:10] repeatCount:1];
        [_backupProView.layer addAnimation:anima1 forKey:@"deviceImageView"];
    } completionHandler:^{
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:10] Y:[NSNumber numberWithInt:-_backupProView.frame.size.height] repeatCount:1];
        [_backupProView.layer addAnimation:anima1 forKey:@"deviceImageView"];
        if (_dataSourceArray &&  _dataSourceArray.count > 0) {
            [self setIsShowLineView:YES];
            _isView = NO;
            [_itemBox setContentView:_backupDataView];
            IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
            if (mainWindow.curFunctionType == BackupModule) {
                [mainWindow.searchView setHidden:NO];
            }
        }else {
            [self setIsShowLineView:NO];
            [self changeNoDataBackupView];
            _isView = NO;
            [_itemBox setContentView:_noBackupView];
            IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
            if (mainWindow.curFunctionType == BackupModule) {
                [mainWindow.searchView setHidden:YES];
            }
        }
    }];
    
    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:0.6];
}

- (void)removeAnimationView {
    [_backupProView removeFromSuperview];
}

- (void)closeWindow:(id)sender {
    if (_isBackupComplete) {
        [self animationRemoveBackupView];
    }else {
        if (_backRestore != nil) {
            [_backRestore pauseScan];
        }
        [_alertViewController setIsStopPan:YES];
        int result = [self showAlertText:CustomLocalizedString(@"Main_Window_Stop_WhileBackup", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
        [_alertViewController setIsStopPan:NO];
        if (result) {
            if (_backRestore != nil) {
                _isCanceled = YES;
                [_backRestore stopScan];
                [_backRestore resumeScan];
            }
            [self animationRemoveBackupView];
        }else {
            if (_backRestore != nil) {
                [_backRestore resumeScan];
            }
        }
    }
}


- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil)]) {
        NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
        [workSpace selectFile:nil inFileViewerRootedAtPath:_backRestore.deviceBackupPath];
    }else if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)]) {
        [self animationRemoveBackupView];
    }else if([link isEqualToString:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil)]){
        _isStartBackup = YES;
        [self doBackup:nil];
    }else{
        NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_3", nil);
        NSLog(@"%@",overStr);
        if ([link isEqualToString:overStr]) {
            [self doBackup:nil];
        }
    }
    return YES;
}

#pragma mark - Start Backup
//开始备份设备
- (void)startBackupDevice {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
//    [_closebutton setEnabled:NO];
    [self addAllObserver];
    [_animateProgressView startAnimation];
    [_backupAnimationView startAnimation];
    [_animateProgressView setLoadAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _backupProgress = 0.0;
        _isCanceled = NO;
        _isError = NO;
        _isProgressStard = NO;
        [ScanStatus shareInstance].stopScan = NO;
        [ScanStatus shareInstance].stopClean = NO;
        [ScanStatus shareInstance].isPause = NO;
        if (_backRestore != nil) {
            [_backRestore release];
            _backRestore = nil;
        }
        _backRestore = [[IMBBackAndRestore alloc] initWithIPod:_ipod];
        [_backRestore backUp];
    });
}

- (void)configTitle {
//    [self.view setAlphaValue:0.97];
    [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Backup_Message", nil),_ipod.deviceInfo.deviceName]];
    
    NSString *strla = CustomLocalizedString(@"CloneMerge_Analyse_Message", nil);
    [self setProgressLable:strla];
    
    NSString *str = CustomLocalizedString(@"BackupDevice_Message_Caution", nil);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init] ;
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontNameAttribute,style,NSParagraphStyleAttributeName, nil];
    NSSize size = [str sizeWithAttributes:dic];
    [_noteImageView setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 , _noteImageView.frame.origin.y)];
    [_promptLabel setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 + 22, _promptLabel.frame.origin.y)];
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:str];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_warningColor", nil)] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as2.length)];
    [_promptLabel setAttributedStringValue:as2];
    [as2 release], as2 = nil;
    [style release], style = nil;
}

- (void)setProgressLable:(NSString *)strla {
    if (![TempHelper stringIsNilOrEmpty:strla]) {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:strla];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_backUpProgressLable setAttributedStringValue:as];
        [as release], as = nil;
    }
}

#pragma mark -- 备份过程中的通知方法
- (void)doBackUpStart:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)doBackUpProgress:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_isProgressStard) {
            [_animateProgressView removeAnimationImgView];
            _isProgressStard = YES;
        }
        NSDictionary *dic = [notification userInfo];
        if (dic != nil) {
            double progress = [[dic objectForKey:@"BRProgress"] doubleValue];
            if (progress >=100){
                progress = 100.0;
            }
            if (progress < _backupProgress) {
                progress = _backupProgress;
            }else {
                _backupProgress = progress;
            }
            if (progress == 100.0) {
                [_animateProgressView setProgressWithOutAnimation:progress];
            }else {
                [_animateProgressView setProgress:progress];
            }
            [self setProgressLable:[NSString stringWithFormat:CustomLocalizedString(@"backup_id_text_9", nil),(int)progress]];
        }
    });
}

- (void)doBackUpComplete:(NSNotification *)notification {
    [[IMBLogManager singleton] writeInfoLog:@"Complete backup backupView"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        _isBackupComplete = YES;
        
        [_backupAnimationView stopAnimation];
        [_animateProgressView pauseTimer];
        [_animateProgressView removeAnimationImgView];
//        if ([notification object]) {
//            BOOL canStop = [[notification object] boolValue];
//            if (canStop) {
//                [[_delegate getBackBtn] setEnabled:YES];
//                return ;
//            }
//        }
        if (!_isCanceled) {
            if (!_isError) {//备份完成
                [_backupViewProgressView setContentView:_backupCompleteView];
                IMBBackupManager *manager = [IMBBackupManager shareInstance];
                SimpleNode *curNdoe = [manager getSingleBackupRootNode:_backRestore.deviceBackupPath];
                if (curNdoe != nil) {
                    if (_dataSourceArray == nil) {
                        _dataSourceArray = [[NSMutableArray alloc] init];
                    }
//                    [_dataSourceArray insertObject:curNdoe atIndex:0];
                    [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    [_tableView reloadData];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reload:nil];
                });
                
            }
        }else {//备份取消，删除备份文件及对应phoneclean下的备份,返回主界面;
            NSString *backupPath = _backRestore.deviceBackupPath;
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![StringHelper stringIsNilOrEmpty:_ipod.deviceInfo.serialNumberForHashing] && [fm fileExistsAtPath:backupPath]) {
                [fm removeItemAtPath:backupPath error:nil];
            }
            [_backRestore release];
            _backRestore = nil;
        }

        //移除进度界面;
//        [self animationRemoveBackupView];
        
//        [_closebutton setEnabled:YES];
        
        [self removeAllObserver];
    });
}

- (void)doBackUpError:(NSNotification *)notification {
    
    [self performSelectorOnMainThread:@selector(backupError:) withObject:notification waitUntilDone:YES];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _isError = YES;
//        NSDictionary *userInfo = [notification userInfo];
//        if (userInfo != nil) {
//            NSNumber *errorid = nil;
//            if ([userInfo.allKeys containsObject:@"errorId"]) {
//                errorid = [userInfo objectForKey:@"errorId"];
//            }
//            NSString *errorStr = nil;
//            if ([userInfo.allKeys containsObject:@"errorReason"]) {
//                errorStr = [userInfo objectForKey:@"errorReason"];
//            }
//            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"errorid:%d   errorReason:%@",errorid.intValue,errorStr]];
//            _isOkAction = YES;
//            if ((errorid.intValue == -36)) {
//                NSString *errMsg = CustomLocalizedString(@"Common_id_13", nil);
//                [self showAlertText:errMsg OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//            }else{
//                NSString *errMsg = [NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_3", nil),_ipod.deviceInfo.deviceName];
//                [self showAlertText:errMsg OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//            }
//        }
//    });
}

-(void)backupError:(id)sender
{
    _isError = YES;
    NSDictionary *userInfo = [sender userInfo];
    if (userInfo != nil) {
        NSNumber *errorid = nil;
        if ([userInfo.allKeys containsObject:@"errorId"]) {
            errorid = [userInfo objectForKey:@"errorId"];
        }
        NSString *errorStr = nil;
        if ([userInfo.allKeys containsObject:@"errorReason"]) {
            errorStr = [userInfo objectForKey:@"errorReason"];
        }
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"errorid:%d   errorReason:%@",errorid.intValue,errorStr]];
        _isOkAction = YES;
        if ((errorid.intValue == -36)) {
            NSString *errMsg = CustomLocalizedString(@"Common_id_13", nil);
            [self showAlertText:errMsg OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }else{
            NSString *errMsg = [NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_3", nil),_ipod.deviceInfo.deviceName];
            [self showAlertText:errMsg OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }
    }
}

- (void)doOkBtnOperation:(id)sender {
    if (_isOkAction) {
        //移除进度界面;
        if (_backRestore != nil) {
            NSString *backupPath = _backRestore.deviceBackupPath;
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![StringHelper stringIsNilOrEmpty:_ipod.deviceInfo.serialNumberForHashing] && [fm fileExistsAtPath:backupPath]) {
                [fm removeItemAtPath:backupPath error:nil];
            }
            [_backRestore release];
            _backRestore = nil;
        }
        [self animationRemoveBackupView];
        [self removeAllObserver];
        _isOkAction = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
    }
}

- (void)reloadTableView{
    _isSearch = NO;
    [_tableView  reloadData];
}

#pragma mark - 注册和删除通知
- (void)addAllObserver {
    [self removeAllObserver];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(doBackUpStart:) name:NOTIFY_BACKUP_START object:nil];
    [nc addObserver:self selector:@selector(doBackUpComplete:) name:NOTIFY_BACKUP_COMPLETE object:nil];
    [nc addObserver:self selector:@selector(doBackUpProgress:) name:NOTIFY_BACKUP_PROGRESS object:nil];
    [nc addObserver:self selector:@selector(doBackUpError:) name:NOTIFY_BACKUP_ERROR object:nil];
}

- (void)removeAllObserver {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:NOTIFY_BACKUP_START object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_PROGRESS object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_COMPLETE object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_ERROR object:nil];
}

- (void)moveBellImageView:(int)moveX {
    if (_bellImgView != nil) {
        [_bellImgView setFrameOrigin:NSMakePoint(340 + moveX, _bellImgView.frame.origin.y)];
    }
}

- (void)backupDeviceConnected:(NSNotification *)notification {
    
}

- (void)backupDeviceDisconnected:(NSNotification *)notification {
    _isConnectBackup = NO;
    _isOkAction = YES;
    _noDataBackupDescription.delegate = nil;
    NSString *str2 = CustomLocalizedString(@"Backup_Default_NoInstall_Describe", nil);
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str2];
    [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, attriStr.length)];
    [attriStr addAttribute:NSForegroundColorAttributeName
                     value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]
                     range:NSMakeRange(0, attriStr.length)];
    [attriStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0, str2.length)];
    [[_noDataBackupDescription textStorage] setAttributedString:attriStr];
    [attriStr release];
    if (_isStartBackup) {
        NSString *errMsg = [NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_3", nil),_ipod.deviceInfo.deviceName];
        [self showAlertText:errMsg OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
    _isStartBackup = NO;
}

- (void)backupDeviceIpodLoadComplete:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    IMBBaseInfo *baseInfo = [userInfo objectForKey:@"DeviceInfo"];
    NSString *uniqueKey = baseInfo.uniqueKey;
    _ipod = [[_connection getIPodByKey:uniqueKey] retain];
    dispatch_async(dispatch_get_main_queue(), ^{
        _isConnectBackup = YES;
        _noDataBackupDescription.delegate = self;
        
        _noDataBackupDescription.linkTextAttributes = [NSDictionary dictionaryWithObject:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] forKey:NSForegroundColorAttributeName];
        NSString *str2 = CustomLocalizedString(@"Backup_Default_Backup_Describe", nil);
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str2];
        NSRange info = [str2 rangeOfString:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil)];
        [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, attriStr.length)];
        [attriStr addAttribute:NSForegroundColorAttributeName
                         value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]
                         range:NSMakeRange(0, attriStr.length)];
        
        [attriStr addAttribute:NSLinkAttributeName value:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil) range:info];
        [attriStr addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:info];
        [attriStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0, str2.length)];
        [[_noDataBackupDescription textStorage] setAttributedString:attriStr];
        [attriStr release];
    });
}

- (void)changeNoDataBackupView {
    NSString *str = CustomLocalizedString(@"Backup_Default_Title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_noDataBackupTitle setAttributedStringValue:as];
    
    if (_isConnectBackup || _ipod) {
        _noDataBackupDescription.delegate = self;
        _noDataBackupDescription.linkTextAttributes = [NSDictionary dictionaryWithObject:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] forKey:NSForegroundColorAttributeName];
        NSString *str2 = CustomLocalizedString(@"Backup_Default_Backup_Describe", nil);
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str2];
        NSRange info = [str2 rangeOfString:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil)];
        [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, attriStr.length)];
        [attriStr addAttribute:NSForegroundColorAttributeName
                         value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]
                         range:NSMakeRange(0, attriStr.length)];
        
        [attriStr addAttribute:NSLinkAttributeName value:CustomLocalizedString(@"Backup_Default_Backup_Describe", nil) range:info];
        [attriStr addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:info];
        [attriStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0, str2.length)];
        [[_noDataBackupDescription textStorage] setAttributedString:attriStr];
        [attriStr release];
    }else {
        _noDataBackupDescription.delegate = nil;
        NSString *str2 = CustomLocalizedString(@"Backup_Default_NoInstall_Describe", nil);
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str2];
        [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, attriStr.length)];
        [attriStr addAttribute:NSForegroundColorAttributeName
                         value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]
                         range:NSMakeRange(0, attriStr.length)];
        [attriStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0, str2.length)];
        [[_noDataBackupDescription textStorage] setAttributedString:attriStr];
        [attriStr release];
    }
    
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        NSRect frame =  _noDataView.frame;
        frame.origin.y = self.view.frame.origin.y ;
        frame.size.width = self.view.frame.size.width;
        _noDataView.frame = frame;
        [_noDataImageView.cell setImageAlignment:NSImageAlignBottom];
    }else {
        NSRect frame =  _noDataView.frame;
        frame.origin.y = self.view.frame.origin.y + 5;
        frame.size.width = self.view.frame.size.width;
        _noDataView.frame = frame;
        [_noDataImageView.cell setImageAlignment: NSImageAlignCenter];
    }
    [_noDataView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
}

- (BOOL)checkIsHasBackupData {
    BOOL res = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isdir;
    isdir = NO;
    NSArray *backupFolderArr = [[NSMutableArray alloc] init];
    if ([fileManager fileExistsAtPath:[TempHelper getBackupFolderPath] isDirectory:&isdir]) {
        if (isdir) {
            NSURL *url = [[NSURL alloc ] initFileURLWithPath:[TempHelper getBackupFolderPath]];
            backupFolderArr = [fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:  NSDirectoryEnumerationSkipsHiddenFiles   error:nil];
        }
    }
    if ([backupFolderArr count] > 0) {
        res = YES;
    }else {
        res = NO;
    }
    return res;
}

- (void)changeViewController:(BOOL)isBool {
    if (_isView) {
        [self setIsShowLineView:YES];
        return;
    }
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:NO];
        [_roseProgressBgImageView setImage:[StringHelper imageNamed:@"rose_progress_bg"]];
    }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_bellImgView setHidden:NO];
        [_bellImgView setImage:[StringHelper imageNamed:@"christmas_bell"]];
        [_bellImgView setFrameOrigin:NSMakePoint(340, _bellImgView.frame.origin.y)];
        [_roseProgressBgImageView setHidden:YES];
        [_animateProgressView setDelegate:self];
    }else {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:YES];
    }
    [_toolBar setNeedsDisplay:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_noteImageView setImage:[StringHelper imageNamed:@"transfer_note"]];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
    
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_backupProView.frame.size.height - 40), 32, 32)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_backupProView addSubview:_closebutton];
    //    [_closebutton setEnabled:NO];
    
    [_searchFieldBtn setHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    _processingQueue = [[NSOperationQueue alloc] init];
    [_processingQueue setMaxConcurrentOperationCount:20];
    [_loadingAnimationView startAnimation];
    _isView = NO;
    [_itemBox setContentView:_loadingView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIpod:) name:NOTIFY_CHANGE_IPOD object:nil];
    IMBDeviceConnection *deviceConntection = [IMBDeviceConnection singleton];
    NSMutableArray *ary = [deviceConntection getAllDevice];
    NSString *uniqueKey = nil;
    for (IMBBaseInfo *baseInfo in ary) {
        if (baseInfo.isSelected) {
            uniqueKey = baseInfo.uniqueKey;
        }
    }
    [_backupCompleteViewTitel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_backupCompleteViewTitel setStringValue:CustomLocalizedString(@"Transfer_text_Backup_complete", nil)];
    [_completeTextView setDelegate:self];
    NSString *promptStr = CustomLocalizedString(@"Backup_id_4", nil);
    [_toBackupPathBtn WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    //线的颜色
    [_toBackupPathBtn WithMouseExitedLineColor:[NSColor clearColor] WithMouseUpLineColor:[NSColor clearColor] WithMouseDownLineColor:[NSColor clearColor] withMouseEnteredLineColor:[NSColor clearColor]];
    //填充的颜色
    [_toBackupPathBtn WithMouseExitedfillColor:[NSColor clearColor] WithMouseUpfillColor:[NSColor clearColor] WithMouseDownfillColor:[NSColor clearColor] withMouseEnteredfillColor:[NSColor clearColor]];
    [_toBackupPathBtn setTitleName:promptStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    if (uniqueKey != nil) {
        IMBiPod *ipod = [deviceConntection getIPodByKey:uniqueKey];
        if (ipod.deviceInfo.isIOSDevice) {
            if (_ipod != nil) {
                [_ipod release];
                _ipod = nil;
            }
            _ipod = [ipod retain];
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        if (!isBool) {
            IMBBackupManager *manager = [IMBBackupManager shareInstance];
            if (_dataSourceArray) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [[NSMutableArray alloc] initWithArray:[manager getBackupRootNode:_ipod withPath:[TempHelper getBackupFolderPath]]];
        }else {
            if (_dataSourceArray == nil || _dataSourceArray.count <= 0) {
                IMBBackupManager *manager = [IMBBackupManager shareInstance];
                if (_dataSourceArray) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [[NSMutableArray alloc] initWithArray:[manager getBackupRootNode:_ipod withPath:[TempHelper getBackupFolderPath]]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_dataSourceArray &&  _dataSourceArray.count > 0) {
                [self setIsShowLineView:YES];
                [_noDataBoxView setContentView:nil];
                _isView = NO;
                if (!_isComeFormAirwifi) {
                    [_itemBox setContentView:_backupDataView];
                }
                IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                if (mainWindow.curFunctionType == BackupModule) {
                    [mainWindow.searchView setHidden:NO];
                }
            }else {
                [self setIsShowLineView:NO];
                [self changeNoDataBackupView];
                _isView = NO;
                if (!_isComeFormAirwifi) {
                    [_itemBox setContentView:_noBackupView];
                }
                IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                if (mainWindow.curFunctionType == BackupModule) {
                    [mainWindow.searchView setHidden:YES];
                }
            }
            [_titleTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            if (_dataSourceArray.count > 1) {
                [_titleTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"backup_title_Complex", nil),(unsigned long)_dataSourceArray.count]];
            }else {
                [_titleTextStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"backup_title", nil),(unsigned long)_dataSourceArray.count]];
            }
            
            [_tableView setListener:self];
            [_tableView setDelegate:self];
            [_tableView setDataSource:self];
            _moveRow = 0;
            //            [_progressIndicator setHidden:YES];
            _jumpViewBtn = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(0, 0, 100, 22)];
            [_jumpViewBtn WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            //线的颜色
            [_jumpViewBtn WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
            //填充的颜色
            [_jumpViewBtn WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
            [_jumpViewBtn setTitleName:CustomLocalizedString(@"backup_id_text_7", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
            [_jumpViewBtn setTarget:self];
            [_jumpViewBtn setAction:@selector(jumpViewBtn:)];
            _navMainMenu = [[self createNavMenu] retain];
            _navMainMenu.delegate = self;
            
            NSArray *array = [_tableView tableColumns];
            for (NSTableColumn  *column in array) {
                if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
                    IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
                    if ([column.identifier isEqualToString:@"headCell"] || [column.identifier isEqualToString:@"Btn"]) {
                        [columnHeadercell setStringValue:@""];
                    }
                }
            }
            [_noDataView setIsGradientColorNOCornerPart3:YES];
        });
    });
    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(7),@(14),@(2),@(10), nil] Target:self DisplayMode:NO];
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    [_tableView setBackgroundColor:[NSColor clearColor]];
    [_titleTextStr setAlignment:NSLeftTextAlignment];
}

@end
