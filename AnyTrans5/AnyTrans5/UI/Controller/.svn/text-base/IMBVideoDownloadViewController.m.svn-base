//
//  IMBVideoDownloadViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBVideoDownloadViewController.h"
#import "IMBDownloadListViewController.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
#import "ObjectTableRowView.h"
#import "DownloadCellView.h"
#import "VideoBaseInfoEntity.h"
#import "IMBDeviceConnection.h"
#import "IMBLogManager.h"
#import "TempHelper.h"
#import "SystemHelper.h"
#define OringinalPropertityX 150
#define OringinalPropertityY 13
@interface IMBVideoDownloadViewController ()

@end

@implementation IMBVideoDownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    _downloadSuccessCount = 0;
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    [_urlTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)loadView
{
    [super loadView];
    [_downloadButton setLeftnormalFillColor:[StringHelper getColorFromString:CustomColor(@"download_normal_leftcolor", nil)]];
    [_downloadButton setLeftenterFillColor:[StringHelper getColorFromString:CustomColor(@"download_enter_leftcolor", nil)]];
    [_downloadButton setLeftdownFillColor:[StringHelper getColorFromString:CustomColor(@"download_down_leftcolor", nil)]];
    [_downloadButton setRightnormalFillColor:[StringHelper getColorFromString:CustomColor(@"download_normal_rightcolor", nil)]];
    [_downloadButton setRightenterFillColor:[StringHelper getColorFromString:CustomColor(@"download_enter_rightcolor", nil)]];
    [_downloadButton setRightdownFillColor:[StringHelper getColorFromString:CustomColor(@"download_down_rightcolor", nil)]];
    _downloadButton.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _downloadButton.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _downloadButton.fontColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceIpodLoadComplete:) name:DeviceIpodLoadCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconnected:) name:DeviceDisConnectedNotification object:nil];
    _vdlManager = [[VDLManager alloc] init];
    _vdlManager.vFetchDelegate = self;
    _vdlManager->_delegate = self;
    _preViewDataSource = [[NSMutableArray alloc] init];
    [_downloadButton setIconImage:[StringHelper imageNamed:@"download_btn"]];
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"downloadVideoInputURLTips", nil)];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)] range:NSMakeRange(0, as1.length)];
    [as1 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as1.length)];
    [as1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, as1.length)];
    [_urlTextField.cell setPlaceholderAttributedString:as1];
    [as1 release], as1 = nil;
    [_urlTextField.cell setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_wheretosaveText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_wheretosaveText setStringValue:CustomLocalizedString(@"DownLoadPage_ChoosePath_Tips", nil)];
    [_urlBorderView setBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_urlBorderView setHasStrokeRadius:YES];
    [_urlBorderView setXRadius:5.0 YRadius:5.0];
    if ([IMBSoftWareInfo singleton].isNoYouToBePhoto) {
        [_bgImageView setImage:[StringHelper imageNamed:@"noconnect_no_media"]];
    }else {
        [_bgImageView setImage:[StringHelper imageNamed:@"noconnect_media"]];
    }
    [self createMenuItems];
    [_contentBox setContentView:_urlView];
    [preView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [preView setXRadius:5 YRadius:5];
    [preView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [preView setHasStrokeRadiusAndBgColor:YES];

    [_downloadButton setTitle:CustomLocalizedString(@"downloadpagebtntooltip_id", nil)];
    _cancelButton.font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    _cancelButton.fontColor = [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)];
    _cancelButton.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)];
    _cancelButton.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)];
    [_cancelButton setTitle:CustomLocalizedString(@"Button_Cancel", nil)];
    [_cancelButton setFrameOrigin:NSMakePoint(NSMaxX(_downloadButton.frame) + 20, NSMinY(_cancelButton.frame))];
    [_cancelButton setTarget:self];
    [_cancelButton setAction:@selector(cancelParse:)];
    [_cancelButton setHidden:YES];
    _downloadlist = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
    [_downloadlist setDelegate:self];
    _downloadlist->_rightUpDownbgView = _rightUpDownbgView;
    _downloadlist->_popUpButton = _popUpButton;
    _downloadlist->_vdlManager = _vdlManager;
    [_mainView addSubview:_downloadlist.view];
    [_downloadlist.view setFrameOrigin:NSMakePoint(0, 0)];
    [_downloadlist.view setWantsLayer:YES];
    [_downloadlist.view removeFromSuperview];
    preViewTableView.dataSource = self;
    preViewTableView.delegate = self;
    [preViewTableView reloadData];
    NSButton *rightUpDownloadButton = [_rightUpDownbgView viewWithTag:100];
    [rightUpDownloadButton setTarget:self];
    [rightUpDownloadButton setAction:@selector(popUpDetail:)];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    _urlTextField.needPasteboardContent = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self parseDownloadPlist];
    });
    
    NSString *str = CustomLocalizedString(@"MediaDownloader_Default_Title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_downloadTitle setAttributedStringValue:as];
    [_downloadButton setVariableWidth:YES];
}

- (void)createMenuItems
{
    [_popUpButton removeAllItems];
    NSString *path = NSHomeDirectory();
    NSMenuItem *itemPic = [[NSMenuItem alloc] init];
    [itemPic setTag:100];
    [itemPic setTitle:CustomLocalizedString(@"VideoDownload_Pop_Music", nil)];
    [itemPic setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Pop_Music", nil)]];
    [itemPic setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Pop_Music", nil)]];
    [_popUpButton.menu addItem:itemPic];
    [itemPic setState:NSOnState];
    [itemPic release];
    
    NSMenuItem *itemDesktop = [[NSMenuItem alloc] init];
    [itemDesktop setTag:101];
    [itemDesktop setTitle:CustomLocalizedString(@"downloadVideoPath_Desk", nil)];
    [itemDesktop setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Desk", nil)]];
    [itemDesktop setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Desk", nil)]];
    [_popUpButton.menu addItem:itemDesktop];
    [itemDesktop release];
    
    NSMenuItem *itemDocument = [[NSMenuItem alloc] init];
    [itemDocument setTag:102];
    [itemDocument setTitle:CustomLocalizedString(@"downloadVideoPath_Document", nil)];
    [itemDocument setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Document", nil)]];
    [itemDocument setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Document", nil)]];
    [_popUpButton.menu addItem:itemDocument];
    [itemDocument release];
    
    NSMenuItem *itemMovies = [[NSMenuItem alloc] init];
    [itemMovies setTag:103];
    [itemMovies setTitle:CustomLocalizedString(@"VideoDownload_Pop_Movies", nil)];
    [itemMovies setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Pop_Movies", nil)]];
    [itemMovies setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Pop_Movies", nil)]];
    
    [_popUpButton.menu addItem:itemMovies];
    [itemMovies release];
    
    NSMenuItem *itemDownload = [[NSMenuItem alloc] init];
    [itemDownload setTag:104];
    [itemDownload setTitle:CustomLocalizedString(@"downloadVideoPath_Download", nil)];
    [itemDownload setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Download", nil)]];
    [itemDownload setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Download", nil)]];
    [_popUpButton.menu addItem:itemDownload];
    [_popUpButton selectItem:itemDownload];
    [itemDownload release];
    
    NSMenuItem *other = [[NSMenuItem alloc] init];
    [other setTag:105];
    [other setTitle:CustomLocalizedString(@"contact_id_8", nil)];
    [_popUpButton.menu addItem:other];
    [other release];
    [self clickPopupButton:_popUpButton];
//    [_popUpButton setTitle:@""];
}

#pragma mark - NSTableView Datasource and Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_preViewDataSource count];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    ObjectTableRowView *result = [[ObjectTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 613, 80)];
    result.objectValue = [_preViewDataSource objectAtIndex:row];
    return [result autorelease];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    DownloadCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    VideoBaseInfoEntity *entity = [_preViewDataSource objectAtIndex:row];
    [cellView.propertityViewArray removeAllObjects];
    if (entity.vSize.length>0) {
        [cellView.sizeTextField setStringValue:[StringHelper getFileSizeString:entity.vSize.longLongValue reserved:2]];
        [cellView.propertityViewArray addObject:cellView.sizeTextField];
        [cellView.sizeTextField setHidden:NO];
    }
    if (entity.vResolutionMode.length>0) {
        [cellView.resolutionTextField setStringValue:entity.vResolutionMode];
        [cellView.propertityViewArray addObject:cellView.resolutionTextField];
        [cellView.resolutionTextField setHidden:NO];
    }
    if (entity.vType.length>0) {
        [cellView.TypeTextField setStringValue:[entity.vType uppercaseString]];
        [cellView.propertityViewArray addObject:cellView.TypeTextField];
        [cellView.TypeTextField setHidden:NO];
    }
    if (entity.vDuration.length>0) {
        [cellView.DurationTextField setStringValue:entity.vDuration];
        [cellView.propertityViewArray addObject:cellView.DurationTextField];
        [cellView.DurationTextField setHidden:NO];
    }
    if (entity.vName.length>0) {
        [cellView.titleField setStringValue:entity.vName];
    }
    if (entity.vThumbnail == nil) {
        [cellView.icon setImage:[StringHelper imageNamed:@"download_def"]];
    }else{
        [cellView.icon setImage:entity.vThumbnail];
    }
    [cellView adjustSpaceX:OringinalPropertityX Y:OringinalPropertityY];
    [cellView.downloadButton setTarget:self];
    [cellView.downloadButton setAction:@selector(preViewDownload:)];
    return cellView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 80;
}

- (void)preViewDownload:(id)sender
{
    if (_rightUpDownbgView.badgeCount>=9) {
        [self showAlertText:CustomLocalizedString(@"DownLoadVideo_LimitTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
    VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
    VideoBaseInfoEntity *copyEntity = [entity copy];
    [_downloadlist addDataSource:[NSMutableArray arrayWithObject:copyEntity]];
    [copyEntity release];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([_vdlManager.VideoEntityDataSource count] > 0) {
            NSMenuItem *item = [_popUpButton selectedItem];
            if (copyEntity.isMuitlVideo) {
                NSString *copyEntityID = [TempHelper getCurrentTimeStamp];
                NSFileManager *fm = [NSFileManager defaultManager];
                NSString *resCopyEntityPKL = [NSString stringWithFormat:@"%@.pkl", copyEntity.vVideoID];
                NSString *resCopyEntityPKLPath = [[[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:copyEntity.vID] stringByAppendingPathComponent:resCopyEntityPKL];
                NSString *desCopyEntityPKLPath = [[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:copyEntityID];
                NSString *desCopyEntityPKL = [[[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:copyEntityID] stringByAppendingPathComponent:resCopyEntityPKL];
                if (![fm fileExistsAtPath:desCopyEntityPKLPath]) {
                    [fm createDirectoryAtPath:desCopyEntityPKLPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                if ([fm fileExistsAtPath:resCopyEntityPKLPath]) {
                    [fm copyItemAtPath:resCopyEntityPKLPath toPath:desCopyEntityPKL error:nil];
                }
                copyEntity.vID = copyEntityID;
            }
            [self writeDownloadPlist:copyEntity];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            if ([item.representedObject isKindOfClass:[IMBiPod class]]) {
                copyEntity.isToMac = NO;
                [ATTracker event:Video_Download action:Manual_Download actionParams:@"1" label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                [_vdlManager downloadVideoLocation:[TempHelper getAppDownloadDefaultPath] withVideoEntity:copyEntity withDelegate:self];
            }else
            {
                copyEntity.isToMac = YES;
                [ATTracker event:Video_Download action:Manual_Download actionParams:@"1" label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                [_vdlManager downloadVideoLocation:item.representedObject withVideoEntity:copyEntity withDelegate:self];
            }
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        }
    });
    NSButton *downloadButton = (NSButton *)sender;
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [view setWantsLayer:YES];
    CALayer *layer = [CALayer layer];
    [layer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"download_circle_bgColor", nil)].CGColor];
    NSPoint point = [view convertPoint:downloadButton.frame.origin fromView:downloadButton.superview];
    [layer setFrame:CGRectMake(point.x+(NSWidth(downloadButton.frame) - 24)/2.0, point.y+(NSHeight(downloadButton.frame) - 24)/2.0, 24, 24)];
    [layer setCornerRadius:12.0];
    [view.layer addSublayer:layer];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [self downloadAnimation:layer View:view];
    } completionHandler:^{
        [layer removeFromSuperlayer];
        [_rightUpDownbgView setBadgeCount:_rightUpDownbgView.badgeCount+1];
        if ([view.subviews count] == 0) {
            [view setHidden:YES];
        }
    }];
}

- (IBAction)clickPopupButton:(id)sender {
    NSMenuItem *item = [_popUpButton selectedItem];
    if ([item.representedObject isKindOfClass:[IMBiPod class]]) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Video_Download action:Manual_Import actionParams:@"Import" label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }
    [_popUpButton resizeSize:item.title];
    if ([_popUpButton.menu itemWithTag:105] == item) {
        NSOpenPanel *openPanel = [IMBOpenPanel openPanel];
        [openPanel setAllowsMultipleSelection:NO];
        [openPanel setCanChooseFiles:NO];
        [openPanel setCanChooseDirectories:YES];
        [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
            if (result== NSFileHandlingPanelOKButton) {
                NSString *folderDir = [[openPanel URL] path];
                NSPredicate *cate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    NSMenuItem *item = (NSMenuItem *)evaluatedObject;
                    if (![item.representedObject isKindOfClass:[IMBiPod class]]&&[item.representedObject isEqualToString:folderDir]) {
                        return YES;
                    }else{
                        return NO;
                    }
                }];
                NSArray *resultArray = [_popUpButton.itemArray filteredArrayUsingPredicate:cate];
                if ([resultArray count] == 0) {
                    NSMenuItem *item = [[NSMenuItem alloc] init];
                    [item setTitle:[folderDir lastPathComponent]];
                    [item setToolTip:folderDir];
                    [item setRepresentedObject:folderDir];
                    [_popUpButton.menu addItem:item];
                    [_popUpButton selectItem:item];
                    [item release];
                    [self clickPopupButton:_popUpButton];
                }else{
                    NSMenuItem *item = [resultArray lastObject];
                    [_popUpButton selectItem:item];
                    [self clickPopupButton:_popUpButton];
                }
                [_popUpButton resizeSize:[folderDir lastPathComponent]];
            }else{
                NSMenuItem *item = [_popUpButton.menu itemWithTag:100];
                [_popUpButton selectItem:item];
                [self clickPopupButton:_popUpButton];
            }
        }];
    }
    [_popUpButton setTransparent:YES];

    NSRect textRect = [IMBHelper calcuTextBounds:_wheretosaveText.stringValue fontSize:14.0];
    NSRect whereRect = NSMakeRect(0, 0, textRect.size.width + _popUpButton.frame.size.width, textRect.size.height);
    if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [_wheretosaveText setFrame:NSMakeRect((430 - whereRect.size.width)/2 + 7, _wheretosaveText.frame.origin.y, textRect.size.width, _wheretosaveText.frame.size.height)];
        [_popUpButton setFrame:NSMakeRect(_wheretosaveText.frame.origin.x + textRect.size.width - 14, _popUpButton.frame.origin.y, _popUpButton.frame.size.width, _popUpButton.frame.size.height)];
    } else {
        [_wheretosaveText setFrame:NSMakeRect((430 - whereRect.size.width)/2 + 8, _wheretosaveText.frame.origin.y, textRect.size.width, _wheretosaveText.frame.size.height)];
        [_popUpButton setFrame:NSMakeRect(_wheretosaveText.frame.origin.x + textRect.size.width - 16, _popUpButton.frame.origin.y, _popUpButton.frame.size.width, _popUpButton.frame.size.height)];
    }
    [_popUpButton setNeedsDisplay:YES];
    [_wheretosaveText setNeedsDisplay:YES];
    
}

- (IBAction)clickUrl:(id)sender {
    NSString *url = CustomLocalizedString(@"DownLoadWebYoutubeURL", nil);
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    NSURL *weburl = [NSURL URLWithString:url];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:weburl];
}

- (void)cancelParse:(id)sender
{
    [_vdlManager stopFetchURL];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:Stop_Analysis actionParams:@"Stop" label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (IBAction)downLoad:(id)sender {
    //先分析
    if (_urlTextField.stringValue.length==0) {
        return;
    }
    if (_rightUpDownbgView.badgeCount>=9) {
        [self showAlertText:CustomLocalizedString(@"DownLoadVideo_LimitTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    for (VideoBaseInfoEntity *entity in _preViewDataSource) {
        [[NSFileManager defaultManager] removeItemAtPath:entity.vCachePKLBeforePath error:nil];
        break;
    }
    [_preViewDataSource removeAllObjects];
    [preViewTableView reloadData];
    [_contentBox setContentView:_urlView];
    [_urlTextField setEditable:NO];
    [_urlTextField setSelectable:NO];
    [_urlTextField setEnabled:NO];
    _downloadButton.iconImage = nil;
    [_downloadButton setVariableWidth:NO];
    [_downloadButton setTitle:CustomLocalizedString(@"downloadpagebtnAnalyze_id", nil)];
    [_downloadButton setVariableWidth:YES];
    [_downloadButton startParseAnimation];
    __block BOOL parseFinish = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!parseFinish) {
            [_cancelButton setHidden:NO];
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Video_Download action:Analyze actionParams:_urlTextField.stringValue label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [_vdlManager fetchURL:_urlTextField.stringValue];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"fetchURL: %@", _urlTextField.stringValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downloadButton setVariableWidth:YES];
            parseFinish = YES;
            [_cancelButton setHidden:YES];
            [_downloadButton stopParseAnimation];
            [_downloadButton setIconImage:[StringHelper imageNamed:@"download_btn"]];
            [_downloadButton setTitle:CustomLocalizedString(@"downloadpagebtntooltip_id", nil)];
            [_urlTextField setEditable:YES];
            [_urlTextField setSelectable:YES];
            [_urlTextField setEnabled:YES];
            if ([_vdlManager.VideoEntityDataSource count] == 1) {
                [_downloadlist addDataSource:_vdlManager.VideoEntityDataSource];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if ([_vdlManager.VideoEntityDataSource count] > 0) {
                        NSMenuItem *item = [_popUpButton selectedItem];
                        VideoBaseInfoEntity *entity = [_vdlManager.VideoEntityDataSource objectAtIndex:0];
                        [self writeDownloadPlist:entity];
                        NSDictionary *dimensionDict = nil;
                        @autoreleasepool {
                            dimensionDict = [[TempHelper customDimension] copy];
                        }
                        [ATTracker event:Video_Download action:Analyze_Success actionParams:_urlTextField.stringValue label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        if ([item.representedObject isKindOfClass:[IMBiPod class]]) {
                            entity.isToMac = NO;
                            [ATTracker event:Video_Download action:Automatic_Download actionParams:@"1" label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                            [_vdlManager downloadVideoLocation:[TempHelper getAppDownloadDefaultPath] withVideoEntity:entity withDelegate:self];
                        }else
                        {
                            entity.isToMac = YES;
                            [ATTracker event:Video_Download action:Automatic_Download actionParams:@"1" label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                            [_vdlManager downloadVideoLocation:item.representedObject withVideoEntity:entity withDelegate:self];
                        }
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
                    }
                });
                NSView *view = nil;
                for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                    if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                        view = subView;
                        break;
                    }
                }
                [view setHidden:NO];
                [view setWantsLayer:YES];
                CALayer *layer = [CALayer layer];
                [layer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"download_circle_bgColor", nil)].CGColor];
                NSPoint point = [view convertPoint:_downloadButton.frame.origin fromView:_downloadButton.superview];
                [layer setFrame:CGRectMake(point.x+(NSWidth(_downloadButton.frame) - 24)/2.0, point.y+(NSHeight(_downloadButton.frame) - 24)/2.0, 24, 24)];
                [layer setCornerRadius:12.0];
                [view.layer addSublayer:layer];
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    [self downloadAnimation:layer View:view];
                } completionHandler:^{
                    [layer removeFromSuperlayer];
                    [_rightUpDownbgView setBadgeCount:_rightUpDownbgView.badgeCount+1];
                    [view setHidden:YES];
                }];
            }else if ([_vdlManager.VideoEntityDataSource count] >= 2){
                [_preViewDataSource addObjectsFromArray:_vdlManager.VideoEntityDataSource];
                [_contentBox setContentView:preView];
                [preViewTableView reloadData];
            }else if ([_vdlManager.VideoEntityDataSource count] == 0){
            
            }
        });
    });
}

- (void)downloadAnimation:(CALayer *)layer View:(NSView *)view
{
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, &transform, layer.frame.origin.x , layer.frame.origin.y);
    CGPathAddQuadCurveToPoint(path1, &transform, layer.frame.origin.x, layer.frame.origin.y+150, NSWidth(view.frame) - 35, NSHeight(view.frame) -20);
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation1.duration = 1.0;
    animation1.fillMode = kCAFillModeForwards;
    animation1.repeatCount = 1;
    animation1.removedOnCompletion = NO;
    animation1.autoreverses = NO;
    animation1.path = path1;
    CGPathRelease(path1);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation2.duration = 1.0;
    animation2.autoreverses = NO;
    animation2.removedOnCompletion = NO;
    animation2.repeatCount = 1;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = YES;
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation3.fromValue = @(1.0);
    animation3.toValue = @(0.5);
    [animation3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation3.duration = 1.0;
    animation3.autoreverses = NO;
    animation3.removedOnCompletion = NO;
    animation3.repeatCount = 1;
    animation3.fillMode = kCAFillModeForwards;
    animation3.removedOnCompletion = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group.duration = 1.0;
    group.autoreverses = NO;
    group.removedOnCompletion = NO;
    group.repeatCount = 1;
    group.animations = [NSArray arrayWithObjects:animation1,animation2,animation3,nil];
    [layer addAnimation:group forKey:@"animation"];
}

- (void)popUpDetail:(id)sender
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:ActionNone actionParams:@"Download List View" label:Switch transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_downloadlist.view setFrameOrigin:NSMakePoint(0, 0)];
    [_downloadlist.view setFrameSize:NSMakeSize(NSWidth(self.view.frame), NSHeight(self.view.frame))];
    [_mainView addSubview:_downloadlist.view];
    [[_downloadlist.view viewWithTag:10] mouseExited:nil];
    [[_downloadlist.view viewWithTag:10] setNeedsDisplay:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
         [_downloadlist.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-_downloadlist.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
        if (!sender) {
            [_downloadlist reloadData:NO];
        }else {
            [_downloadlist reloadData:YES];
        }
        [_rightUpDownbgView setEnable:NO];
    } completionHandler:^{
        [self setIsShowLineView:YES];
        [_downloadlist.view setFrameOrigin:NSMakePoint(0, 0)];
    }];
}

//分析download Plist文件
- (void)parseDownloadPlist {
    _downloadSuccessCount = 0;
    NSString *plistPath = [[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:@"videodownload.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSMutableDictionary *allDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        for (NSString *vid in allDic.allKeys) {
            if ([vid isEqualToString:@"DownloadSuccessCount"]) {
                NSDictionary *countDic = [allDic objectForKey:@"DownloadSuccessCount"];
                if ([countDic isKindOfClass:[NSDictionary class]] && [countDic.allKeys containsObject:@"Count"]) {
                    _downloadSuccessCount = [[countDic objectForKey:@"Count"] intValue];
                }
//                _downloadSuccessCount = [[allDic objectForKey:@"DownloadSuccessCount"] intValue];
                continue;
            }
            BOOL isCreat = YES;
            for (VideoBaseInfoEntity *entity in _downloadlist.downloadDataSource) {
                if ([[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID] isEqualToString:vid]) {
                    isCreat = NO;
                    break;
                }
            }
            if (!isCreat) {
                continue;
            }
            NSMutableDictionary *dic = [allDic objectForKey:vid];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                VideoBaseInfoEntity *entity = [[VideoBaseInfoEntity alloc] init];
                if ([dic.allKeys containsObject:@"vThumbnailPath"]) {
                    entity.vThumbnailPath = [dic objectForKey:@"vThumbnailPath"];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:entity.vThumbnailPath]) {
                        NSImage *image = [[NSImage alloc] initWithContentsOfFile:entity.vThumbnailPath];
                        [entity setVThumbnail:image];
                        [image release];
                        image = nil;
                    }
                }
                if ([dic.allKeys containsObject:@"vCachePKLPath"]) {
                    entity.vCachePKLPath = [dic objectForKey:@"vCachePKLPath"];
                }
                if ([dic.allKeys containsObject:@"vDownloadPath"]) {
                    entity.vDownloadPath = [dic objectForKey:@"vDownloadPath"];
                }
                if ([dic.allKeys containsObject:@"downloadState"]) {
                    entity.downloadState = [[dic objectForKey:@"downloadState"] intValue];
                }
                if ([dic.allKeys containsObject:@"isMuitlVideo"]) {
                    entity.isMuitlVideo = [[dic objectForKey:@"isMuitlVideo"] intValue];
                }
                if ([dic.allKeys containsObject:@"vID"]) {
                    entity.vID = [dic objectForKey:@"vID"];
                }
                if ([dic.allKeys containsObject:@"vFormatID"]) {
                    entity.vFormatID = [dic objectForKey:@"vFormatID"];
                }
                if ([dic.allKeys containsObject:@"vVideoID"]) {
                    entity.vVideoID = [dic objectForKey:@"vVideoID"];
                }
                if ([dic.allKeys containsObject:@"vName"]) {
                    entity.vName = [dic objectForKey:@"vName"];
                }
                if ([dic.allKeys containsObject:@"vType"]) {
                    entity.vType = [dic objectForKey:@"vType"];
                }
                if ([dic.allKeys containsObject:@"vSize"]) {
                    entity.vSize = [dic objectForKey:@"vSize"];
                }
                if ([dic.allKeys containsObject:@"vDuration"]) {
                    entity.vDuration = [dic objectForKey:@"vDuration"];
                }
                if ([dic.allKeys containsObject:@"vCachePKLBeforePath"]) {
                    entity.vCachePKLBeforePath = [dic objectForKey:@"vCachePKLBeforePath"];
                }
                if ([dic.allKeys containsObject:@"vResolution"]) {
                    entity.vResolution = [dic objectForKey:@"vResolution"];
                }
                if ([dic.allKeys containsObject:@"vResolutionMode"]) {
                    entity.vResolutionMode = [dic objectForKey:@"vResolutionMode"];
                }
                if ([dic.allKeys containsObject:@"parseURL"]) {
                    entity.parseURL = [dic objectForKey:@"parseURL"];
                }
                if (entity.downloadState == DownloadFinish) {
                    if ([[NSFileManager defaultManager] fileExistsAtPath:entity.vDownloadPath]) {
                        entity.isFileExist = YES;
                    }else {
                        entity.isFileExist = NO;
                    }
                }else {
                    entity.isFileExist = YES;
                }
                [_downloadlist addDataSource:[NSMutableArray arrayWithObject:entity]];
                [entity release];
            }
        }
    }
}

#pragma mark - VideoFetchProgressCallBack
- (void)VDLFetchException:(NSString *)errorStr
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:Analyze_Error actionParams:[NSString stringWithFormat:@"%@:%@", _urlTextField.stringValue, errorStr] label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [self performSelectorOnMainThread:@selector(parseError:) withObject:errorStr waitUntilDone:NO];
}

- (void)parseError:(NSString *)errorStr
{
    NSString *parseError = nil;
    if ([errorStr rangeOfString:@"Unsupported URL"].location != NSNotFound) {
        parseError = [NSString stringWithFormat:CustomLocalizedString(@"VideoDownload_parse_Error_Unsupported_URL", nil), errorStr];
    }else if([errorStr rangeOfString:@"HTTP Error 403"].location != NSNotFound) {
        parseError = CustomLocalizedString(@"VideoDownload_parse_Error_Forbidden_URL", nil);
    }else if([errorStr rangeOfString:@"HTTP Error 404"].location != NSNotFound) {
        parseError = CustomLocalizedString(@"VideoDownload_parse_Error_NotFound_URL", nil);
    }else {
        parseError = CustomLocalizedString(@"downloadAnalyzeFailTips", nil);
    }
    [self showAlertText:parseError OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    [[IMBLogManager singleton] writeErrorLog:parseError];
}

#pragma mark - VideoDownloadProgressCallBack
- (void)VDLProgressComplete:(NSString *)complete  Video:(VideoBaseInfoEntity *)video
{
    video.downloadState = DownloadFinish;
    if ([[NSFileManager defaultManager] fileExistsAtPath:video.vDownloadPath]) {
        video.isFileExist = YES;
    }else {
        video.isFileExist = NO;
    }
    _downloadSuccessCount ++;
    [self writeDownloadPlist:video];
    [_downloadlist adSuccessCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Video_Download action:Download_Success actionParams:video.parseURL label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [_rightUpDownbgView setBadgeCount:[_rightUpDownbgView setBadgeCountDecrease]];
//        if (_rightUpDownbgView.badgeCount == 0) {
        [self showReslutView];
        //判断如果当前选择了设备 就直接进行传输
        if (!video.isToMac) {
            NSMenuItem *item = [_popUpButton selectedItem];
            if ([item.representedObject isKindOfClass:[IMBiPod class]]) {
                IMBiPod *ipod = (IMBiPod *)item.representedObject;
                if (!ipod.beingSynchronized) {
                    [_downloadlist transferDownload:item.representedObject Video:video];
                }
            }
        }
        [_downloadlist reloadData:YES];
    });
}

- (void)writeDownloadPlist:(VideoBaseInfoEntity *)entity {
    NSString *plistPath = [[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:@"videodownload.plist"];
    NSMutableDictionary *allDic = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        allDic = [[NSMutableDictionary dictionaryWithContentsOfFile:plistPath] retain];
    }else {
        allDic = [[NSMutableDictionary alloc] init];
    }
    NSMutableDictionary *dic = nil;
    if (entity) {
        if ([allDic.allKeys containsObject:[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID]]) {
            dic = [[allDic objectForKey:[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID]] retain];
            if (entity.vThumbnailPath != nil) {
                [dic setObject:entity.vThumbnailPath forKey:@"vThumbnailPath"];
            }else {
                [dic setObject:@"" forKey:@"vThumbnailPath"];
            }
            if (entity.vCachePKLPath != nil) {
                [dic setObject:entity.vCachePKLPath forKey:@"vCachePKLPath"];
            }else {
                [dic setObject:@"" forKey:@"vCachePKLPath"];
            }
            if (entity.vCachePKLBeforePath != nil) {
                [dic setObject:entity.vCachePKLBeforePath forKey:@"vCachePKLBeforePath"];
            }else {
                [dic setObject:@"" forKey:@"vCachePKLBeforePath"];
            }
            if (entity.vDownloadPath != nil) {
                [dic setObject:entity.vDownloadPath forKey:@"vDownloadPath"];
            }else {
                [dic setObject:@"" forKey:@"vDownloadPath"];
            }
            if (entity.downloadState == Downloading) {
                [dic setObject:[NSNumber numberWithInt:DownloadFaild] forKey:@"downloadState"];
            }else {
                [dic setObject:[NSNumber numberWithInt:entity.downloadState] forKey:@"downloadState"];
            }
        }else {
            dic = [[NSMutableDictionary alloc] init];
            if (entity.vID != nil) {
                [dic setObject:entity.vID forKey:@"vID"];
            }else {
                [dic setObject:@"" forKey:@"vID"];
            }
            if (entity.vFormatID != nil) {
                [dic setObject:entity.vFormatID forKey:@"vFormatID"];
            }else {
                [dic setObject:@"" forKey:@"vFormatID"];
            }
            if (entity.vVideoID != nil) {
                [dic setObject:entity.vVideoID forKey:@"vVideoID"];
            }else {
                [dic setObject:@"" forKey:@"vVideoID"];
            }
            if (entity.vName != nil) {
                [dic setObject:entity.vName forKey:@"vName"];
            }else {
                [dic setObject:@"" forKey:@"vName"];
            }
            if (entity.vType != nil) {
                [dic setObject:entity.vType forKey:@"vType"];
            }else {
                [dic setObject:@"" forKey:@"vType"];
            }
            if (entity.vSize != nil) {
                [dic setObject:entity.vSize forKey:@"vSize"];
            }else {
                [dic setObject:@"" forKey:@"vSize"];
            }
            if (entity.vDuration != nil) {
                [dic setObject:entity.vDuration forKey:@"vDuration"];
            }else {
                [dic setObject:@"" forKey:@"vDuration"];
            }
            if (entity.vResolution != nil) {
                [dic setObject:entity.vResolution forKey:@"vResolution"];
            }else {
                [dic setObject:@"" forKey:@"vResolution"];
            }
            if (entity.vResolutionMode != nil) {
                [dic setObject:entity.vResolutionMode forKey:@"vResolutionMode"];
            }else {
                [dic setObject:@"" forKey:@"vResolutionMode"];
            }
            if (entity.vThumbnailPath != nil) {
                [dic setObject:entity.vThumbnailPath forKey:@"vThumbnailPath"];
            }else {
                [dic setObject:@"" forKey:@"vThumbnailPath"];
            }
            if (entity.vCachePKLPath != nil) {
                [dic setObject:entity.vCachePKLPath forKey:@"vCachePKLPath"];
            }else {
                [dic setObject:@"" forKey:@"vCachePKLPath"];
            }
            if (entity.vDownloadPath != nil) {
                [dic setObject:entity.vDownloadPath forKey:@"vDownloadPath"];
            }else {
                [dic setObject:@"" forKey:@"vDownloadPath"];
            }
            if (entity.vCachePKLBeforePath != nil) {
                [dic setObject:entity.vCachePKLBeforePath forKey:@"vCachePKLBeforePath"];
            }else {
                [dic setObject:@"" forKey:@"vCachePKLBeforePath"];
            }
            if (entity.parseURL != nil) {
                [dic setObject:entity.parseURL forKey:@"parseURL"];
            }else {
                [dic setObject:@"" forKey:@"parseURL"];
            }
            [dic setObject:[NSNumber numberWithInt:entity.isMuitlVideo] forKey:@"isMuitlVideo"];
            if (entity.downloadState == Downloading) {
                [dic setObject:[NSNumber numberWithInt:DownloadFaild] forKey:@"downloadState"];
            }else {
                [dic setObject:[NSNumber numberWithInt:entity.downloadState] forKey:@"downloadState"];
            }
            [allDic setObject:dic forKey:[NSString stringWithFormat:@"%@-%@",entity.vID,entity.vVideoID]];
        }
    }
    [allDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_downloadSuccessCount], @"Count", nil] forKey:@"DownloadSuccessCount"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
    }
    [allDic writeToFile:plistPath atomically:YES];
    [allDic release];
    [dic release];
}

- (void)VDLDownloadException:(NSString *)errorStr  Video:(VideoBaseInfoEntity *)video
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:Download_Error actionParams:[NSString stringWithFormat:@"%@:%@", video.parseURL, errorStr] label:LabelNone transferCount:1 screenView:@"Analyze View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    video.downloadState = DownloadFaild;
    if (video.isMuitlVideo) {
        video.vID = [TempHelper getCurrentTimeStamp];
    }
    [self writeDownloadPlist:video];
    if ([[NSFileManager defaultManager] fileExistsAtPath:video.vDownloadPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:video.vDownloadPath error:nil];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_rightUpDownbgView setBadgeCount:[_rightUpDownbgView setBadgeCountDecrease]];
        [_downloadlist reloadData:YES];
//        if (_rightUpDownbgView.badgeCount == 0) {
//            [_downloadlist addResultView];
//        }
    });
}

#pragma mark - TextDidChangenotification
- (void)textDidChange:(NSNotification *)notification
{
    if ([_urlTextField.stringValue isEqualToString:@""]) {
        for (VideoBaseInfoEntity *entity in _preViewDataSource) {
            [[NSFileManager defaultManager] removeItemAtPath:entity.vCachePKLBeforePath error:nil];
            break;
        }
        [_preViewDataSource removeAllObjects];
        [preViewTableView reloadData];
        [_contentBox setContentView:_urlView];
    }
}

#pragma mark - DeviceIpodLoadCompleteNotification
- (void)deviceIpodLoadComplete:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [notification userInfo];
        IMBBaseInfo *baseInfo = [userInfo objectForKey:@"DeviceInfo"];
        NSString *uniqueKey = baseInfo.uniqueKey;
        IMBiPod *iPod = [[IMBDeviceConnection singleton] getIPodByKey:uniqueKey];
        if (iPod != nil&&[[iPod deviceInfo] isSupportMovie]) {
            NSPredicate *cate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                NSMenuItem *item = (NSMenuItem *)evaluatedObject;
                if ([item.representedObject isKindOfClass:[IMBiPod class]]) {
                    return YES;
                }else{
                    return NO;
                }
            }];
            NSArray *podArr = [_popUpButton.itemArray filteredArrayUsingPredicate:cate];
            if ([podArr count] == 0) {
                NSMenuItem *parseItem = [NSMenuItem separatorItem];
                parseItem.representedObject = iPod.uniqueKey;
                [_popUpButton.menu insertItem:parseItem atIndex:0];
            }
            NSMenuItem *itemDocument = [[NSMenuItem alloc] init];
            [itemDocument setTitle:iPod.deviceInfo.deviceName?:@""];
            [itemDocument setRepresentedObject:iPod];
            [_popUpButton.menu insertItem:itemDocument atIndex:0];
            [itemDocument release];
        }
    });
}

#pragma mark - DeviceIpodLoadCompleteNotification
- (void)deviceDisconnected:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *uniqueKey = [notification object];
        NSArray *itemArray = [_popUpButton.menu.itemArray copy];
        for (NSMenuItem *item in itemArray) {
            if ([item.representedObject isKindOfClass:[IMBiPod class]]) {
                IMBiPod *ipod = [item representedObject];
                if ([ipod.uniqueKey isEqualToString:uniqueKey]) {
                    [_popUpButton.menu removeItem:item];
                }
            }else if ([item.representedObject isEqualToString:uniqueKey])
            {
                [_popUpButton.menu removeItem:item];
            }
        }
        [itemArray release];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [preView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [preView setXRadius:5 YRadius:5];
    [preView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [preView setHasStrokeRadiusAndBgColor:YES];
    
    [_downloadButton setLeftnormalFillColor:[StringHelper getColorFromString:CustomColor(@"download_normal_leftcolor", nil)]];
    [_downloadButton setLeftenterFillColor:[StringHelper getColorFromString:CustomColor(@"download_enter_leftcolor", nil)]];
    [_downloadButton setLeftdownFillColor:[StringHelper getColorFromString:CustomColor(@"download_down_leftcolor", nil)]];
    [_downloadButton setRightnormalFillColor:[StringHelper getColorFromString:CustomColor(@"download_normal_rightcolor", nil)]];
    [_downloadButton setRightenterFillColor:[StringHelper getColorFromString:CustomColor(@"download_enter_rightcolor", nil)]];
    [_downloadButton setRightdownFillColor:[StringHelper getColorFromString:CustomColor(@"download_down_rightcolor", nil)]];
    _downloadButton.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _downloadButton.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _downloadButton.fontColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    [(IMBWhiteView *)self.view setNeedsDisplay:YES];
    
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"downloadVideoInputURLTips", nil)];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)] range:NSMakeRange(0, as1.length)];
    [as1 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as1.length)];
    [as1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, as1.length)];
    [_urlTextField.cell setPlaceholderAttributedString:as1];
    [as1 release], as1 = nil;
    
    [_urlTextField.cell setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_wheretosaveText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_popUpButton setNeedsDisplay:YES];
    [_urlBorderView setBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_urlBorderView setNeedsDisplay:YES];
    [_urlTextField.cell setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_downloadButton setIconImage:[StringHelper imageNamed:@"download_btn"]];
    [_downloadButton setNeedsDisplay:YES];
    [_urlTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    if ([IMBSoftWareInfo singleton].isNoYouToBePhoto) {
        [_bgImageView setImage:[StringHelper imageNamed:@"noconnect_no_media"]];
    }else {
        [_bgImageView setImage:[StringHelper imageNamed:@"noconnect_media"]];
    }
    [preViewTableView reloadData];
    
    _cancelButton.font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    _cancelButton.fontColor = [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)];
    _cancelButton.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)];
    _cancelButton.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)];
    [_cancelButton setTitle:CustomLocalizedString(@"Button_Cancel", nil)];
    [_cancelButton setNeedsDisplay:YES];
    
    NSString *str = CustomLocalizedString(@"MediaDownloader_Default_Title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_downloadTitle setAttributedStringValue:as];
}

- (void)doChangeLanguage:(NSNotification *)notification{
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"downloadVideoInputURLTips", nil)];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)] range:NSMakeRange(0, as1.length)];
    [as1 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as1.length)];
    [as1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, as1.length)];
    [_urlTextField.cell setPlaceholderAttributedString:as1];
    [as1 release], as1 = nil;
    
    [_wheretosaveText setStringValue:CustomLocalizedString(@"DownLoadPage_ChoosePath_Tips", nil)];
    [_downloadButton setTitle:CustomLocalizedString(@"downloadpagebtntooltip_id", nil)];
    [_cancelButton setTitle:CustomLocalizedString(@"Button_Cancel", nil)];
    {
        NSString *str = CustomLocalizedString(@"MediaDownloader_Default_Title", nil);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
        }else {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
        }
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
        
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_downloadTitle setAttributedStringValue:as];
    }
    
    NSString *str2 = CustomLocalizedString(@"MediaDownloader_Default_NoInstall_Describe", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:18] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
    [_downloadsubTitle setAttributedStringValue:as2];
    [_downloadButton setVariableWidth:YES];

     NSString *path = NSHomeDirectory();
    for (NSMenuItem *item in _popUpButton.itemArray) {
        if (item.tag == 100) {
            [item setTitle:CustomLocalizedString(@"VideoDownload_Pop_Music", nil)];
            [item setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Pop_Music", nil)]];
            [item setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Pop_Music", nil)]];
        }else if (item.tag == 101) {
            [item setTitle:CustomLocalizedString(@"downloadVideoPath_Desk", nil)];
            [item setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Desk", nil)]];
            [item setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Desk", nil)]];
        }else if (item.tag == 102) {
            [item setTitle:CustomLocalizedString(@"downloadVideoPath_Document", nil)];
            [item setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Document", nil)]];
            [item setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Document", nil)]];
        }else if (item.tag == 103) {
            [item setTitle:CustomLocalizedString(@"VideoDownload_Pop_Movies", nil)];
            [item setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Pop_Movies", nil)]];
            [item setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Pop_Movies", nil)]];
        }else if (item.tag == 104) {
            [item setTitle:CustomLocalizedString(@"downloadVideoPath_Download", nil)];
            [item setToolTip:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Download", nil)]];
            [item setRepresentedObject:[path stringByAppendingPathComponent:CustomLocalizedString(@"downloadVideoPath_Download", nil)]];
        }else if (item.tag == 105) {
            [item setTitle:CustomLocalizedString(@"contact_id_8", nil)];
        }
    }
    NSString *str = [_popUpButton selectedItem].title;
    [_popUpButton resizeSize:str];
    [_popUpButton setNeedsDisplay:YES];
    NSRect textRect = [IMBHelper calcuTextBounds:_wheretosaveText.stringValue fontSize:14.0];
    NSRect whereRect = NSMakeRect(0, 0, textRect.size.width + _popUpButton.frame.size.width, textRect.size.height);
    
    if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [_wheretosaveText setFrame:NSMakeRect((430 - whereRect.size.width)/2 + 7, _wheretosaveText.frame.origin.y, textRect.size.width, _wheretosaveText.frame.size.height)];
        [_popUpButton setFrame:NSMakeRect(_wheretosaveText.frame.origin.x + textRect.size.width - 14, _popUpButton.frame.origin.y, _popUpButton.frame.size.width, _popUpButton.frame.size.height)];
    } else {
        [_wheretosaveText setFrame:NSMakeRect((430 - whereRect.size.width)/2 + 8, _wheretosaveText.frame.origin.y, textRect.size.width, _wheretosaveText.frame.size.height)];
        [_popUpButton setFrame:NSMakeRect(_wheretosaveText.frame.origin.x + textRect.size.width - 16, _popUpButton.frame.origin.y, _popUpButton.frame.size.width, _popUpButton.frame.size.height)];
    }
    [_popUpButton setNeedsDisplay:YES];
    [_wheretosaveText setNeedsDisplay:YES];
}

- (void)viewShow:(NSNotification *) noti {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_bgImageView setHidden:NO];
        [_contentView setHidden:NO];
    });
}

- (void)showReslutView {
    if (![IMBSoftWareInfo singleton].isRegistered && _downloadSuccessCount >= [IMBSoftWareInfo singleton].activityInfo.downloadUrlInfo.downloadCount && ![IMBSoftWareInfo singleton].isNOAdvertisement) {
        if (![_downloadlist.view superview]) {
            _downloadSuccessCount = 0;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self writeDownloadPlist:nil];
            });
            NSString *str12 = @"close";
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str12];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
                [_downloadlist addResultView];
            } else {
                [_downloadlist addMuResultView];
            }
            
            [self popUpDetail:nil];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceIpodLoadCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [_vdlManager release],_vdlManager = nil;
    [_downloadlist release],_downloadlist = nil;
    [_preViewDataSource release],_preViewDataSource = nil;
    [super dealloc];
}
@end
