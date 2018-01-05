//
//  IMBMergeOrCloneViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-10.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBAndroidMergeViewController.h"
#import "IMBBackgroundBorderView.h"
#import "IMBAnimation.h"
#import "IMBDeviceConnection.h"
#import "IMBiPodMenuItem.h"
#import "NSString+Category.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBCategoryInfoModel.h"
#import "IMBToMacSelectionVeiw.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBDeviceConnection.h"
#import "SystemHelper.h"
#import "IMBAirSyncImportTransfer.h"
#import "StringHelper.h"
#import "NSColor+Category.h"
#import "ContactConversioniCloud.h"
#import "CalendarConversioniCloud.h"
#import "PhotoConversioniCloud.h"
#import "ContactConversioniOS.h"
#import "MessageConversioniOS.h"
#import "CallLogConversioniOS.h"
#import "CalendarConversioniOS.h"
#import "IMBTransferToiOS.h"
#import "IMBTransferToiCloud.h"
#import "IMBAndroidTransferToiTunes.h"
#import "ColorHelper.h"
#import "IMBAndroidMainPageViewController.h"
@implementation IMBAndroidMergeViewController
@synthesize bindcategoryArray = _bindcategoryArray;
@synthesize restoreiPodKey = _restoreiPodKey;
@synthesize hasPhotoBack = _hasPhotoBack;

#pragma mark - 初始化
//toDevice
- (id)initWithiPod:(IMBiPod *)iPod CategoryInfoModelArrary:(NSMutableArray *)categoryArray TransferType:(TransferType)transferType WithAndroid:(IMBAndroid *)android
{
    if (self = [super initWithNibName:@"IMBAndroidMergeViewController" bundle:nil]) {
        _bindcategoryArray = [[NSMutableArray array] retain];
//        _sourceiPod = [iPod retain];
        _categoryArray = [categoryArray retain];
        _transferType = transferType;
        _isCategorySelect = NO;
        _android = [android retain];
    }
    return self;
}
//toiCloud
- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager WithAndroid:(IMBAndroid *)android AccountDic:(NSDictionary *)accountDic CategoryInfoModelArrary:(NSMutableArray *)categoryArray
{
    if (self = [super initWithNibName:@"IMBAndroidMergeViewController" bundle:nil]) {
        _bindcategoryArray = [[NSMutableArray array] retain];
        _transferType = ToiCloudType;
        _isCategorySelect = NO;
        _accountDic = accountDic;
        _android = [android retain];
        _categoryArray = [categoryArray retain];
        _iCloudManager = iCloudManager;//弱引用
    }
    return self;
}
//toiTunes
- (id)initToiTunesAndroid:(IMBAndroid *)android CategoryInfoModelArrary:(NSMutableArray *)categoryArray
{
    if (self = [super initWithNibName:@"IMBAndroidMergeViewController" bundle:nil]) {
        _android = [android retain];
        _transferType = ToiTunesType;
        _categoryArray = [categoryArray retain];
        _isCategorySelect = NO;
    }
    return self;
}

- (void)awakeFromNib
{
    [_deviceSelectsubTitleField setHidden:YES];
    [((IMBBackgroundBorderView *)self.view) setIsGradientNoCornerPart4:YES];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:NO];
        [_roseProgressBgImageView setImage:[StringHelper imageNamed:@"rose_progress_bg"]];
    }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_bellImgView setHidden:NO];
        [_bellImgView setImage:[StringHelper imageNamed:@"christmas_bell"]];
        [_bellImgView setFrameOrigin:NSMakePoint(340, _bellImgView.frame.origin.y)];
        [_roseProgressBgImageView setHidden:YES];
        [_progressviewBar setDelegate:self];
    }else {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:YES];
    }
    [_arrowImageView setImage:[StringHelper imageNamed:@"clone_arrow"]];
    [_bgImageView setImage:[StringHelper imageNamed:@"clone_complete"]];
    _logManager = [IMBLogManager singleton];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    //TODO:屏蔽语言选择-----long
    NSString *str12 = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str12];
    _isTransferComplete = YES;
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    _mergeCloneAppVC = [[IMBMergeCloneAppViewController alloc]initWithNibName:@"IMBMergeCloneAppViewController" bundle:nil];
    [_connectionView setMaxNumberOfColumns:5];
    [_connectionView setMaxNumberOfRows:20];
    [_contentBox setWantsLayer:YES];
    if (_transferType == ToiCloudType) {
        [_arrowImageVIew setImage:[StringHelper imageNamed:@"iCloud_arrow"]];
        [_sourceDeviceImageView setFrame:NSMakeRect(65, 49, 164, 180)];
        [_sourceDeviceImageView setImage:[StringHelper imageNamed:@"androidphone"]];
        [_sourceDeviceNameField setStringValue:_android.deviceInfo.devName];
        [_sourceDeviceNameField setFrame:NSMakeRect(NSMinX(_sourceDeviceImageView.frame) + 82 - NSWidth(_sourceDeviceNameField.frame)/2.0, _sourceDeviceNameField.frame.origin.y+20, NSWidth(_sourceDeviceNameField.frame), NSHeight(_sourceDeviceNameField.frame))];
    }else if (_transferType == ToDeviceType){
        [_sourceDeviceImageView setImage:[StringHelper imageNamed:@"androidphone"]];
        [_sourceDeviceNameField setStringValue:_android.deviceInfo.devName?:@""];
        [_arrowImageVIew setImage:[StringHelper imageNamed:@"clone_arrow"]];
    }else{
        [_sourceDeviceImageView setFrame:NSMakeRect(5, 49, 164, 180)];
        [_sourceDeviceImageView setImage:[StringHelper imageNamed:@"androidphone"]];
    }
    [_sourceDeviceNameField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    NSArray *connectionarray = [connection getConnectedIPods];
    NSMutableArray *array = [NSMutableArray array];
    if (_transferType == ToiCloudType) {
        for (NSString *appleId in _accountDic.allKeys) {
            IMBiCloudManager *icloudManager = [[_accountDic objectForKey:appleId] iCloudManager];
            [array addObject:icloudManager];
        }
    }else{
        for (IMBiPod *ipod in connectionarray) {
            if (_transferType == ToDeviceType&&ipod.deviceInfo.isIOSDevice&&[ipod.deviceInfo.productVersion isVersionMajorEqual:@"6.0"]) {
                [array addObject:ipod];
            }else {
                if (ipod.deviceInfo.isIOSDevice&&[ipod.deviceInfo.productVersion isVersionMajorEqual:@"6.0"]) {
                    [array addObject:ipod];
                }
            }
        }
    }
    
    NSMenu *menu = [[NSMenu alloc] init];
    if (_transferType == ToiCloudType) {
        for (IMBiCloudManager *icloudManager in array) {
            IMBiPodMenuItem *item = [[IMBiPodMenuItem alloc] init];
            [item setTitle:icloudManager.netClient.loginInfo.loginInfoEntity.fullName];
            [item setIPodunique:icloudManager.netClient.loginInfo.appleID];
            [item setTarget:self];
            [item setAction:@selector(selectDevice:)];
            [menu addItem:item];
            [item release];
        }
    }else{
        for (IMBiPod *ipod in array) {
            if (ipod.infoLoadFinished&&ipod.deviceInfo.isIOSDevice) {
                IMBiPodMenuItem *item = [[IMBiPodMenuItem alloc] init];
                [item setTitle:ipod.deviceInfo.deviceName];
                [item setIPodunique:ipod.uniqueKey];
                [item setTarget:self];
                [item setAction:@selector(selectDevice:)];
                [menu addItem:item];
                [item release];
            }
        }
    }
    [_targetDevicePopButton setMaxWidth:NSWidth(_popUpButtonBgView.frame)];
    _targetDevicePopButton.menu = menu;
    [menu release];
    IMBiPodMenuItem *item = (IMBiPodMenuItem *)_targetDevicePopButton.selectedItem;
    _targetiPod = [[[IMBDeviceConnection singleton] getIPodByKey:item.iPodunique] retain];
    if (_transferType == ToiCloudType) {
        _selectedItem = item;
        [_targetDevicePopButton setTitle:item.title];
        [_targetDeviceImageView setFrameSize:NSMakeSize(164, 180)];
        [_targetDeviceImageView setImage:[StringHelper imageNamed:@"iCloud_transfer"]];
        [_completeDeviceImageView setFrame:NSMakeRect((NSWidth(_completeDeviceImageView.superview.frame) - 164)/2.0, _completeDeviceImageView.frame.origin.y - 12, 164, 180)];
        [_completeDeviceImageView setImage:[StringHelper imageNamed:@"iCloud_transfer"]];
        [_popUpButtonBgView setFrame:NSMakeRect(NSMinX(_targetDeviceImageView.frame) + 82 - NSWidth(_popUpButtonBgView.frame)/2.0, NSMinY(_popUpButtonBgView.frame) + 20, NSWidth(_popUpButtonBgView.frame), NSHeight(_popUpButtonBgView.frame))];
    }else if (_transferType == ToiTunesType){
        [_completeDeviceImageView setFrame:NSMakeRect((NSWidth(_completeDeviceImageView.superview.frame) - 164)/2.0, _completeDeviceImageView.frame.origin.y - 12, 164, 180)];
        [_completeDeviceImageView setImage:[StringHelper imageNamed:@"transfer_to_iTunes"]];
    }else{
        [_targetDevicePopButton setTitle:_targetiPod.deviceInfo.deviceName?:@""];
        [_targetDeviceImageView setImage:[self getipodImage:_targetiPod]];
        [_completeDeviceImageView setImage:[self getipodImage:_targetiPod]];
    }
    [_targetDevicePopButton setFrame:NSMakeRect(ceilf((NSWidth(_popUpButtonBgView.frame) - NSWidth(_targetDevicePopButton.frame))/2.0), 0, NSWidth(_targetDevicePopButton.frame), NSHeight(_targetDevicePopButton.frame))];
    [_popArrowImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [_occlusionView setFrameOrigin:NSMakePoint(_targetDevicePopButton.frame.size.width-_occlusionView.frame.size.width+2 - 4, 3)];
    [_occlusionView setBackgroundColor:[NSColor clearColor]];
    [_targetDevicePopButton addSubview:_occlusionView];
    [item setState:NSOnState];
    
    [((IMBBackgroundBorderView *)self.view) setCanScroll:NO];
    [((IMBBackgroundBorderView *)self.view) setCanClick:NO];
    [_titleView setHasBottomBorder:YES];
    [_titleView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(_titleView.frame) - 32)/2), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_titleView addSubview:_closebutton];
    
    [_nextbackBgView setWantsLayer:YES];
    _nextbackBgView.layer.frame = NSRectToCGRect(_nextbackBgView.frame);
    HoverButton *nextbutton = [[HoverButton alloc] initWithFrame:NSMakeRect(NSWidth(_nextbackBgView.frame) - 56 -15, ceil((NSHeight(_nextbackBgView.frame) - 56)/2), 56, 56)];
    nextbutton.tag = 120;
    [nextbutton setWantsLayer:YES];
    [nextbutton.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    nextbutton.layer.frame = NSRectToCGRect(nextbutton.frame);
    [nextbutton setAutoresizesSubviews:YES];
    [nextbutton setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin|NSViewMaxYMargin];
    [nextbutton setTarget:self];
    [nextbutton setAction:@selector(next:)];
    [nextbutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_next_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_next_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_next_down"]];
    [_nextbackBgView addSubview:nextbutton];
    [_nextbackBgView.layer addSublayer:nextbutton.layer];
    CABasicAnimation *animation = [IMBAnimation moveX:2.0 X:@(-15)];
    [nextbutton.layer addAnimation:animation forKey:@"comeback"];
    if (_transferType == ToiTunesType) {
        [self next:nil];
    }else{
        [_contentBox setContentView:_deviceSelectView];
    }
    
    [nextbutton release];
    
    HoverButton *backbutton = [[HoverButton alloc] initWithFrame:NSMakeRect(15, ceil((NSHeight(_nextbackBgView.frame) - 56)/2), 56, 56)];
    backbutton.tag = 121;
    [backbutton setAutoresizesSubviews:YES];
    [backbutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin];
    [backbutton setTarget:self];
    [backbutton setAction:@selector(back:)];
    [backbutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_back_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_back_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_back_down"]];
    [backbutton setHidden:YES];
    [_nextbackBgView addSubview:backbutton];
    [_connectionBgView setWantsLayer:YES];
    [_connectionBgView.layer setBorderWidth:1.0];
    [_connectionBgView.layer setCornerRadius:5];
    [_connectionBgView.layer setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)].toCGColor];
    [_connectionBgView setHasStrokeRadius:YES];
    [_connectionBgView setXRadius:5.0 YRadius:5.0];
    
    if (_transferType == ToiCloudType) {
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"icloud_TargetAccount_Tip", nil)]];
    }else if (_transferType == ToiTunesType){
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil)]];
    }else{
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"Clone_id_5", nil)]];
    }
    NSString *str = nil;
    if (_transferType == ToDeviceType) {
        [_tipScrollView setHidden:YES];
        [_deviceSelectTitleField setStringValue:CustomLocalizedString(@"MergeDevice_SelectTargetDevice_Title", nil)];
        [_deviceSelectsubTitleField setStringValue:CustomLocalizedString(@"ToDevice_SelectTargetDevice_Descript", nil)];
        str = CustomLocalizedString(@"TransferDevice_Message_Caution", nil);
        NSString *deviceName = _targetiPod.deviceInfo.deviceName;
        if (deviceName.length > 10) {
            deviceName = [[deviceName substringToIndex:10] stringByAppendingString:@"..."];
        }
        [_categorySelectsubTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToDeviceiTunes_SelectDeviceItem_Descript", nil),deviceName]];
    }else if (_transferType == ToiCloudType){
        str = CustomLocalizedString(@"TransferDevice_Message_Caution", nil);
        [_deviceSelectTitleField setStringValue:CustomLocalizedString(@"icloud_TargetAccount_Title", nil)];
        [_deviceSelectsubTitleField setStringValue:CustomLocalizedString(@"icloud_TargetAccount_Title", nil)];
        [_deviceSelectsubTitleField setStringValue:@""];
    }else if (_transferType == ToiTunesType){
        str = CustomLocalizedString(@"TransferDevice_Message_Caution", nil);
        [_deviceSelectTitleField setStringValue:CustomLocalizedString(@"icloud_TargetAccount_Title", nil)];
        [_deviceSelectsubTitleField setStringValue:@""];
    }
    [_categorySelectsubTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_deviceSelectTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_deviceSelectsubTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init] ;
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontNameAttribute,style,NSParagraphStyleAttributeName, nil];
    NSSize size = [str sizeWithAttributes:dic];
    [_warningImageView setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 - 5, _warningImageView.frame.origin.y)];
    [_warningImageView setImage:[StringHelper imageNamed:@"transfer_note"]];
    [_warningTipField setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 + 17, _warningTipField.frame.origin.y)];
    
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:str];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_warningColor", nil)] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as2.length)];
    [_warningTipField setAttributedStringValue:as2];
    [as2 release], as2 = nil;
    [style release], style = nil;
    
    [_categorySelectTitleField setStringValue:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Title", nil)];
    [_categorySelectTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_textView setDelegate:self];
}

#pragma mark - 辅助方法
- (NSMutableArray *)getfilePathInDir:(NSString *)dirPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *libraryArr = [NSMutableArray array];
    NSArray *arr = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *name in arr) {
        if ([name hasSuffix:@"DS_Store"]) {
            continue;
        }
        NSString *filePath = [dirPath stringByAppendingPathComponent:name];
        [libraryArr addObject:filePath];
    }
    return libraryArr;
}

- (NSImage *)getipodImage:(IMBiPod *)ipod
{
    NSImage *image = [StringHelper imageNamed:@"clone_iPhone"];
    if (ipod.deviceInfo.isiPhone) {
        if (ipod.deviceInfo.family == iPhone_X) {
            image = [StringHelper imageNamed:@"clone_iPhonex"];
        }else{
            image = [StringHelper imageNamed:@"clone_iPhone"];
        }
    }else if (ipod.deviceInfo.isiPad){
        image = [StringHelper imageNamed:@"clone_iPad"];
    }else if (ipod.deviceInfo.isiPod){
        image = [StringHelper imageNamed:@"clone_iPodTouch"];
    }
    return image;
}

- (NSImage *)getAnimationImage:(IMBiPod *)ipod
{
    NSImage *image = [StringHelper imageNamed:@"cloning_iPhone"];
    if (ipod.deviceInfo.isiPhone) {
        if (ipod.deviceInfo.family == iPhone_X) {
            image = [StringHelper imageNamed:@"clone_iPhonex"];
        }else{
            image = [StringHelper imageNamed:@"clone_iPhone"];
        }
    }else if (ipod.deviceInfo.isiPad){
        image = [StringHelper imageNamed:@"cloning_iPad"];
    }else if (ipod.deviceInfo.isiPod){
        image = [StringHelper imageNamed:@"cloning_iPodTouch"];
    }
    return image;
}

- (void)setTipText
{
    float fontSize = 12.0f;
    NSMutableAttributedString *tiptext = nil;
    tiptext = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Caution", nil)?:@""];
    [tiptext addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0, [tiptext length])];//StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)
    [tiptext addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:fontSize] range:NSMakeRange(0, tiptext.length)];
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Caution1", nil)?:@""];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:fontSize] range:NSMakeRange(0, attrTitle.length)];
    if (attrTitle) {
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"attrTitle:%@",attrTitle]];
        [tiptext appendAttributedString:attrTitle];
        [attrTitle release];
        attrTitle = nil;
    }
    
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_tipTextView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *attrlinkTitle = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Caution2", nil)?:@""];
    [attrlinkTitle addAttribute:NSLinkAttributeName value:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Caution2", nil)?:@"" range:NSMakeRange(0, attrlinkTitle.length)];
    [attrlinkTitle addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleNone] range:NSMakeRange(0, attrlinkTitle.length)];
    [attrlinkTitle addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:NSMakeRange(0, attrlinkTitle.length)];
    
    [attrlinkTitle addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:fontSize] range:NSMakeRange(0, attrlinkTitle.length)];
    [attrlinkTitle addAttribute:NSCursorAttributeName value:[NSCursor openHandCursor] range:NSMakeRange(0, attrlinkTitle.length)];
    if (attrlinkTitle) {
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"attrlinkTitle:%@",attrlinkTitle]];
        [tiptext appendAttributedString:attrlinkTitle];
        NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
        [textParagraph setAlignment:NSCenterTextAlignment];
        [textParagraph setLineSpacing:1];
        [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
        [tiptext addAttribute:NSParagraphStyleAttributeName value:textParagraph range:NSMakeRange(0, [tiptext length])];
        
        [attrlinkTitle release];
        attrlinkTitle = nil;
    }
    if (tiptext) {
        [[_tipTextView textStorage] setAttributedString:tiptext];
    }
    [tiptext release];
}

- (BOOL)checkBackupEncrypt:(IMBiPod *)ipod
{
    BOOL isEncrypt = [[ipod.deviceHandle deviceValueForKey:@"WillEncrypt" inDomain:@"com.apple.mobile.backup"] boolValue];
    return isEncrypt;
}

- (BOOL)isFindMyiCloud:(AMDevice *)device
{
    bool isFindMyDevice = false;
    @try {
        isFindMyDevice = [[device deviceValueForKey:@"IsAssociated" inDomain:@"com.apple.fmip"] boolValue];
    }
    @catch (NSException *exception) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"Get IsAssociated exception %@", exception.reason]];
    }
    return isFindMyDevice;
}

- (void)moveBellImageView:(int)moveX
{
    if (_bellImgView != nil) {
        [_bellImgView setFrameOrigin:NSMakePoint(340 + moveX, _bellImgView.frame.origin.y)];
    }
}

- (void)filterCategorysByTarIpod:(IMBiPod *)ipod
{
    NSMutableArray *newArr = [NSMutableArray array];
    for (IMBCategoryInfoModel *model in _categoryArray) {
        [newArr addObject:model];
    }
    if (_categoryArray != nil) {
        [_categoryArray release];
        _categoryArray = nil;
    }
    _categoryArray = [newArr retain];
}

- (NSString *)isaddMosaicTextStr:(NSString *)text
{
    if (text != nil) {
        int length = (int)text.length;//[self convertToInt:text];
        if (length > 40) {
            NSString *frontText = [text substringWithRange:NSMakeRange(0, 40)];
            frontText = [frontText stringByAppendingString:@"..."];
            return frontText;
        }else{
            return text;
        }
    }
    return nil;
}

- (BOOL)checkItemsValidWithIPod:(NSString *)itemKey
{
    BOOL isPass = YES;
    NSDictionary *dataSyncStr = [_targetiPod.deviceHandle deviceValueForKey:nil inDomain:@"com.apple.mobile.data_sync"];
    if (dataSyncStr != nil) {
        NSArray *allKey = [dataSyncStr allKeys];
        if ([allKey containsObject:itemKey]) {
            NSDictionary *contDic = [dataSyncStr objectForKey:itemKey];
            if (contDic != nil) {
                if (isPass) {
                    NSArray *sourcesInfoArray = [contDic objectForKey:@"Sources"];
                    if (sourcesInfoArray != nil && [sourcesInfoArray count] > 0) {
                        isPass = NO;
                    }
                }
            }
        }
    }
    return isPass;
}
#pragma mark - Actions
- (void)next:(id)sender
{
    if (_isCategorySelect) {
        if (_transferType == ToDeviceType) {
            IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
            NSMutableArray *baseInfoArr = [NSMutableArray array];
            NSArray *array = [connection getConnectedIPods];
            //判断是否是iOS设备 屏蔽非iOS 设备
            for (IMBiPod *ipod in array) {
                if (ipod.infoLoadFinished&&ipod.deviceInfo.isIOSDevice) {
                    IMBBaseInfo *baseInfo = [connection getDeviceByKey:ipod.uniqueKey];
                    [baseInfoArr addObject:baseInfo];
                }
            }
            //判断设备是否是iOS 设备 并弹出提示窗口
            if (array.count ==1) {
                IMBiPod *ipod = [array objectAtIndex:0];
                if (![ipod.deviceInfo isIOSDevice]) {
                    [self showAlertText:CustomLocalizedString(@"android_toDevices_NoIOSDeviceTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                    return;
                }
            }
            
            if (baseInfoArr.count == 0) {
                [self showAlertText:CustomLocalizedString(@"android_toDevices_NoIOSDeviceTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                _isNoDevice = YES;
                return;
            }
        }
        if ([[_connectionView selectionIndexes] count] == 0) {
            //需要提示 选择为空MergeDevice_Message_Title
            [self showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        if (_transferType == ToDeviceType){
            NSArray *selectCategoryArray = [_arrayController selectedObjects];
            NSMutableString *mutStr = [[NSMutableString alloc] init];
            for (IMBCategoryInfoModel *model in selectCategoryArray) {
                if (model.categoryNodes == Category_Message) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *messageResult = [_android getSMSContent];
                    NSArray *messageArray = messageResult.reslutArray;
                    if (messageArray.count>0) {
                        [dataDic setObject:messageArray forKey:@(Category_Message)];
                    }
                }
                if (model.categoryNodes == Category_Contacts) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *contactResult = [_android getContactContent];
                    NSArray *contactArray = contactResult.reslutArray;
                    if (contactArray.count>0) {
                        [dataDic setObject:contactArray forKey:@(Category_Contacts)];
                    }
                }
                if (model.categoryNodes == Category_CallHistory) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *callLogResult = [_android getCallHistoryContent];
                    NSArray *callLogArray = callLogResult.reslutArray;
                    if (callLogArray.count>0) {
                        [dataDic setObject:callLogArray forKey:@(Category_CallHistory)];
                    }
                }
                
                if (model.categoryNodes == Category_Calendar) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *calendarResult = [_android getCalendarContent];
                    NSArray *calendarArray = calendarResult.reslutArray;
                    if (calendarArray.count>0) {
                        [dataDic setObject:calendarArray forKey:@(Category_Calendar)];
                    }
                }
                
                if (model.categoryNodes == Category_Music) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *audioResult = [_android getAudioContent];
                    NSArray *audioArray = audioResult.reslutArray;
                    if (audioArray.count>0) {
                        [dataDic setObject:audioArray forKey:@(Category_Music)];
                    }
                }
                
                if (model.categoryNodes == Category_Movies) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *videoResult = [_android getVideoContent];
                    NSArray *videoArray = videoResult.reslutArray;
                    if (videoArray.count>0) {
                        [dataDic setObject:videoArray forKey:@(Category_Movies)];
                    }
                }
                
                if (model.categoryNodes == Category_Ringtone) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *ringtoneResult = [_android getRingtoneContent];
                    NSArray *ringtoneArray = ringtoneResult.reslutArray;
                    if (ringtoneArray.count>0) {
                        [dataDic setObject:ringtoneArray forKey:@(Category_Ringtone)];
                    }
                }
                if (model.categoryNodes == Category_Photo) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *photoResult = [_android getGalleryContent];
                    NSArray *photoArray = photoResult.reslutArray;
                    if (photoArray.count>0) {
                        [dataDic setObject:photoArray forKey:@(Category_MyAlbums)];
                    }
                }
                if (model.categoryNodes == Category_iBooks) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *iBooksResult = [_android getiBooksContent];
                    NSArray *iBooksArray = iBooksResult.reslutArray;
                    if (iBooksArray.count>0) {
                        [dataDic setObject:iBooksArray forKey:@(Category_iBooks)];
                    }
                }
                
                if (model.categoryNodes == Category_Compressed) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *compressedEntity = [_android getCompressedContent];
                    NSArray *comArray = compressedEntity.reslutArray;
                    if (comArray.count>0) {
                        [dataDic setObject:comArray forKey:@(Category_Compressed)];
                    }
                }
                if (model.categoryNodes == Category_Document) {
                    [mutStr appendString:model.categoryName];
                    [mutStr appendString:@", "];
                    IMBResultEntity *documentEntity = [_android getAppDoucmentContent];
                    NSArray *documentArray = documentEntity.reslutArray;
                    if (documentArray.count>0) {
                        [dataDic setObject:documentArray forKey:@(Category_Document)];
                    }
                }
            }
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:mutStr label:Click transferCount:1 screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            [mutStr release];
            mutStr = nil;
            
            if ([[dataDic allKeys] containsObject:@(Category_Message)] ||[[dataDic allKeys] containsObject:@(Category_CallHistory)]) {
                if ([self checkBackupEncrypt:_targetiPod]) {
                    [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Clone_id_24", nil),_targetiPod.deviceInfo.deviceName] OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                    return;
                }
                
                if ([self isFindMyiCloud:_targetiPod.deviceHandle]) {
                    NSView *view = nil;
                    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                            view = subView;
                            [view setHidden:NO];
                            break;
                        }
                    }
                    [_alertViewController showAlertTextSuperView:view withClosenodeEnum:0 withisIcloudClose:NO];
                    return;
                }
            }
            if ([[dataDic allKeys] containsObject:@(Category_Calendar)]) {
                BOOL open = [self checkItemsValidWithIPod:@"Calendars"];
                if (!open) {
                    //弹出提示框
                    NSView *view = nil;
                    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                            view = subView;
                            break;
                        }
                    }
                    
                    [view setHidden:NO];
                    [_alertViewController showAlertTextSuperView:view withClosenodeEnum:Category_Calendar withisIcloudClose:YES];
                    return;
                }
            }
            
            if ([[dataDic allKeys] containsObject:@(Category_Contacts)]) {
                BOOL open = [self checkItemsValidWithIPod:@"Contacts"];
                if (!open) {
                    //弹出提示框
                    NSView *view = nil;
                    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                            view = subView;
                            break;
                        }
                    }
                    [view setHidden:NO];
                    [_alertViewController showAlertTextSuperView:view withClosenodeEnum:Category_Contacts withisIcloudClose:YES];
                    return;
                }
            }
            if ([[dataDic allKeys] containsObject:@(Category_Message)] || [[dataDic allKeys] containsObject:@(Category_CallHistory)]) {
                [_alertViewController setIsStopPan:YES];
                [_alertViewController setIsStopPan:YES];
                NSString *str = [NSString stringWithFormat:@"'%@/%@'",CustomLocalizedString(@"MenuItem_CallLog", nil),CustomLocalizedString(@"MenuItem_id_19", nil)];
                int tag = [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Android_to_iOS_message_3", nil),str] OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
                [_alertViewController setIsStopPan:NO];
                if (tag != 1) {
                    return;
                }
            }
            
            NSArray *caArray = [NSArray arrayWithObjects:@(Category_Music),@(Category_Contacts),@(Category_Calendar),@(Category_Movies),@(Category_iBooks), nil];
            NSMutableArray *unAppArrray = [NSMutableArray array];
            NSString *appStr = @"";
            for (NSNumber *category in caArray) {
                switch (category.intValue) {
                    case Category_Music:
                    {
                        if ([[dataDic allKeys] containsObject:@(Category_Music)]&&[_targetiPod.deviceHandle installedApplicationWithId:@"com.apple.Music"] == nil){
                            [unAppArrray addObject:category];
                            appStr = [appStr stringByAppendingString:CustomLocalizedString(@"MenuItem_id_1", nil)];
                        }
                    }
                        
                        break;
                    case Category_Contacts:
                    {
                        if ([[dataDic allKeys] containsObject:@(Category_Contacts)]&&[_targetiPod.deviceHandle installedApplicationWithId:@"com.apple.MobileAddressBook"] == nil) {
                            [unAppArrray addObject:category];
                            if (appStr.length>0) {
                                appStr = [appStr stringByAppendingString:@", "];
                            }
                            appStr = [appStr stringByAppendingString:CustomLocalizedString(@"MenuItem_id_20", nil)];
                        }
                    }
                        
                        break;
                    case Category_Calendar:
                    {
                        if ([[dataDic allKeys] containsObject:@(Category_Calendar)]&&[_targetiPod.deviceHandle installedApplicationWithId:@"com.apple.mobilecal"] == nil) {
                            [unAppArrray addObject:category];
                            if (appStr.length>0) {
                                appStr = [appStr stringByAppendingString:@", "];
                            }
                            appStr = [appStr stringByAppendingString:CustomLocalizedString(@"MenuItem_id_62", nil)];
                        }
                    }
                        break;
                    case Category_Movies:
                    {
                        if ([[dataDic allKeys] containsObject:@(Category_Movies)]&&[_targetiPod.deviceHandle installedApplicationWithId:@"com.apple.videos"] == nil) {
                            [unAppArrray addObject:category];
                            if (appStr.length>0) {
                                appStr = [appStr stringByAppendingString:@", "];
                            }
                            appStr = [appStr stringByAppendingString:CustomLocalizedString(@"MenuItem_id_33", nil)];
                            
                        }
                    }
                        break;
                    case Category_iBooks:
                    {
                        if ([[dataDic allKeys] containsObject:@(Category_iBooks)]&&[_targetiPod.deviceHandle installedApplicationWithId:@"com.apple.iBooks"] == nil){
                            [unAppArrray addObject:category];
                            if (appStr.length>0) {
                                appStr = [appStr stringByAppendingString:@", "];
                            }
                            appStr = [appStr stringByAppendingString:CustomLocalizedString(@"iBook_id_3", nil)];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if (unAppArrray.count == 1) {
                NSString *tip = [NSString stringWithFormat:CustomLocalizedString(@"Android_to_iOS_message_2", nil),appStr];
                [self showAlertText:tip OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                return;
            }else if (unAppArrray.count >1){
                NSString *tip = [NSString stringWithFormat:CustomLocalizedString(@"Android_to_iOS_message_2_1", nil),appStr];
                [self showAlertText:tip OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                return;
            }
        }
        
        [_transferView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"push";
        transition.subtype = @"fromRight";
        [_contentBox.layer addAnimation:transition forKey:@"animation"];
        [_contentBox setContentView:_transferView];
        NSButton *nextbutton = [_nextbackBgView viewWithTag:120];
        [nextbutton setHidden:YES];
        NSButton *backbutton = [_nextbackBgView viewWithTag:121];
        [backbutton setHidden:YES];
        if (_transferType == ToiCloudType) {
            NSMutableString *mutStr = [[NSMutableString alloc] init];
            for (IMBCategoryInfoModel *entity in [_arrayController selectedObjects]) {
                [mutStr appendString:entity.categoryName];
                [mutStr appendString:@", "];
            }NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:Move_To_iOS action:ToiCloud actionParams:mutStr label:Click transferCount:1 screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            [mutStr release];
            mutStr = nil;
            [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"Clone_id_7", nil)]];
        }else if (_transferType == ToiTunesType){
            [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"Clone_id_7", nil)]];
        }else {
            [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"Clone_id_7", nil)]];
        }
        if (_transferType == ToiCloudType) {
            [_cloneAnimationView setBackupImage:nil sourceImage:[StringHelper imageNamed:@"android_mac"]targetImage:[StringHelper imageNamed:@"iCloud_transfer"]];
            [_cloneAnimationView setIsAndroid:YES];
            [_cloneAnimationView setTransfertype:_transferType];
            [_cloneAnimationView reLayerSize];
            
        }else if (_transferType == ToDeviceType){
            [_cloneAnimationView setBackupImage:[StringHelper imageNamed:@"android_mac"] sourceImage:[StringHelper imageNamed:@"android_mac"] targetImage:[self getipodImage:_targetiPod]];
            [_cloneAnimationView setTransfertype:_transferType];
            [_cloneAnimationView setIsAndroid:YES];
            [_cloneAnimationView reLayerSize];
        }else if (_transferType == ToiTunesType){
            [_cloneAnimationView setBackupImage:[StringHelper imageNamed:@"android_mac"] sourceImage:[StringHelper imageNamed:@"android_mac"] targetImage:[StringHelper imageNamed:@"transfer_to_iTunes"]];
            [_cloneAnimationView setTransfertype:_transferType];
            [_cloneAnimationView setIsAndroid:YES];
            [_cloneAnimationView reLayerSize];
        }
        
        [_cloneAnimationView startCloneDataAnimation];
        _isTransferComplete = NO;
        if (_transferType == ToDeviceType) {
            NSString *str = [NSString stringWithFormat:@"%@",_targetiPod.deviceInfo.deviceName];
            [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToDevice_Message_Title", nil),str]];
        }else if (_transferType == ToiCloudType){
            _condition = [[NSCondition alloc] init];
            if (![IMBSoftWareInfo singleton].isRegistered) {
                _alertViewController.isIcloudOneOpen = YES;
                _alertViewController.delegate = self;
            }
            [_closebutton setHidden:NO];
            NSString *str = [NSString stringWithFormat:@"%@",_targetDevicePopButton.title];
            [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToDevice_Message_Title", nil),str]];
        }
        else if (_transferType == ToiTunesType){
            _condition = [[NSCondition alloc] init];
            [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToPCiTunes_Transfer_Title", nil),@"iTunes"]];
        }
        [_transferTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        //等待动画
        [_progressviewBar setLoadAnimation];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool {
                if (_transferType == ToiTunesType) {
                    NSArray *selectCategoryArray = [_arrayController selectedObjects];
                    NSMutableString *mutStr = [[NSMutableString alloc] init];
                    for (IMBCategoryInfoModel *model in selectCategoryArray) {
                        if (model.categoryNodes == Category_Music) {
                            [mutStr appendString:model.categoryName];
                            [mutStr appendString:@", "];
                            NSArray *musicArray = [_android getAudioContent].reslutArray;
                            if (musicArray.count>0) {
                                [dataDic setObject:musicArray forKey:@(Category_Music)];
                            }
                        }else if (model.categoryNodes == Category_Movies){
                            [mutStr appendString:model.categoryName];
                            [mutStr appendString:@", "];
                            NSArray *videoArray = [_android getVideoContent].reslutArray;
                            if (videoArray.count>0) {
                                [dataDic setObject:videoArray forKey:@(Category_Movies)];
                            }
                        }else if (model.categoryNodes == Category_Ringtone){
                            [mutStr appendString:model.categoryName];
                            [mutStr appendString:@", "];
                            NSArray *ringtoneArray = [_android getRingtoneContent].reslutArray;
                            if (ringtoneArray.count>0) {
                                [dataDic setObject:ringtoneArray forKey:@(Category_Ringtone)];
                            }
                        }else if (model.categoryNodes == Category_iBooks){
                            [mutStr appendString:model.categoryName];
                            [mutStr appendString:@", "];
                            NSArray *bookArray = [_android getiBooksContent].reslutArray;
                            if (bookArray.count>0) {
                                [dataDic setObject:bookArray forKey:@(Category_iBooks)];
                            }
                        }else if (model.categoryNodes == Category_Photo){
                            [mutStr appendString:model.categoryName];
                            [mutStr appendString:@", "];
                            NSArray *photoArray = [_android getGalleryContent].reslutArray;
                            if (photoArray.count>0) {
                                [dataDic setObject:photoArray forKey:@(Category_Photo)];
                            }
                        }
                    }
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Move_To_iOS action:ToiTunes actionParams:mutStr label:Click transferCount:1 screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                    [mutStr release];
                    mutStr = nil;
                    _baseTransfer = [[IMBAndroidTransferToiTunes alloc] initWithAndroid:_android TransferDataDic:dataDic TransferDelegate:self];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self checkDeviceGreantedPermission];
                    });
                    //[_baseTransfer startTransfer];
                    [dataDic release];
                }else if (_transferType == ToiCloudType){
                    //传输代码逻辑
                    //模拟效果
                    [self transferPrepareFileEnd];
                    [self transferProgress:0];
                    //判断是否获取了相应数据
                    IMBResultEntity *contactResult = [_android getContactContent];
                    NSArray *contactArray = contactResult.reslutArray;
                    
                    IMBResultEntity *galleryResult = [_android getGalleryContent];
                    NSArray *galleryArray = galleryResult.reslutArray;
                    
                    IMBResultEntity *calendarResult = [_android getCalendarContent];
                    NSArray *calendarArray = calendarResult.reslutArray;
                    
                    NSArray *selectCategoryArray = [_arrayController selectedObjects];
                    
                    for (IMBCategoryInfoModel *model in selectCategoryArray) {
                        if (model.categoryNodes == Category_Photo) {
                            if (galleryArray.count>0) {
                                [dataDic setObject:galleryArray forKey:@(Category_Photo)];
                            }
                        }else if (model.categoryNodes == Category_Contacts){
                            if (contactArray.count>0) {
                                [dataDic setObject:contactArray forKey:@(Category_Contacts)];
                            }
                        }else if (model.categoryNodes == Category_Calendar){
                            if (calendarArray.count>0) {
                                [dataDic setObject:calendarArray forKey:@(Category_Calendar)];
                            }
                        }
                    }
                    
                    ContactConversioniCloud *contactConversion = [[ContactConversioniCloud alloc] init];
                    CalendarConversioniCloud *calendarConversion = [[CalendarConversioniCloud alloc] init];
                    PhotoConversioniCloud *photoConversion = [[PhotoConversioniCloud alloc] init];
                    _baseTransfer = [[IMBTransferToiCloud alloc] initWithTransferDataDic:dataDic TransferDelegate:self iCloudManager:_iCloudManager withAndroid:_android];
                    [(IMBTransferToiCloud*)_baseTransfer setContactConversion:contactConversion calendarConversion:calendarConversion photoConversion:photoConversion];
                    if ([dataDic.allKeys containsObject:@(Category_Photo)]) {
                        //有图片 to iCloud时需要检查权限
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self checkDeviceGreantedPermission];
                        });
                    }else {
                        [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iCloud"];
                        [_baseTransfer startTransfer];
                    }
                    [contactConversion release];
                    contactConversion = nil;
                    [calendarConversion release];
                    calendarConversion = nil;
                    [photoConversion release];
                    photoConversion = nil;
                    [dataDic release];
                }else {
                    _baseTransfer = [[IMBTransferToiOS alloc] initWithIPodkey:_targetiPod.uniqueKey Android:_android TransferDataDic:dataDic TransferDelegate:self];
                    ContactConversioniOS *contactConversion = [[ContactConversioniOS alloc] init];
                    MessageConversioniOS *messageConversion = [[MessageConversioniOS alloc] init];
                    messageConversion.android = _android;
                    CallLogConversioniOS *callLogConversion = [[CallLogConversioniOS alloc] init];
                    CalendarConversioniOS *calendarConversion = [[CalendarConversioniOS alloc] init];
                    [(IMBTransferToiOS *)_baseTransfer setMessagConversion:messageConversion ContactConversion:contactConversion CallHistoryConversion:callLogConversion CalendarConversion:calendarConversion];
                    if ([dataDic.allKeys containsObject:@(Category_Music)] || [dataDic.allKeys containsObject:@(Category_Movies)] || [dataDic.allKeys containsObject:@(Category_Ringtone)] || [dataDic.allKeys containsObject:@(Category_Photo)] || [dataDic.allKeys containsObject:@(Category_iBooks)] || [dataDic.allKeys containsObject:@(Category_Message)]) {
                        //有以上类型之一 to ios时需要检查权限
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self checkDeviceGreantedPermission];
                        });
                    }else {
                        if (_targetiPod.deviceInfo.isiPad) {
                            [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPad"];
                        }else if (_targetiPod.deviceInfo.isiPhone) {
                            [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPhone"];
                        }else {
                            [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPodTouch"];
                        }
                        [_baseTransfer startTransfer];
                    }
                    [contactConversion release];
                    [messageConversion release];
                    [callLogConversion release];
                    [calendarConversion release];
                    [dataDic release];
                }
            }
        });
    }else{
        if (_targetiPod.beingSynchronized) {
            [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
        [_categorySelectView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        if (_transferType != ToiTunesType) {
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"push";
            transition.subtype = @"fromRight";
            [_contentBox.layer addAnimation:transition forKey:@"animation"];
        }
        [_contentBox setContentView:_categorySelectView];
        if (_transferType != ToiTunesType) {
            if (_transferType != ToiCloudType ) {
                [self filterCategorysByTarIpod:_targetiPod];
            }else{
                NSString *deviceName = _targetDevicePopButton.title;
                if (deviceName.length > 10) {
                    deviceName = [[deviceName substringToIndex:10] stringByAppendingString:@"..."];
                }
                [_categorySelectsubTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToDeviceiTunes_SelectDeviceItem_Descript", nil),deviceName]];
            }
        }else{
            [_categorySelectsubTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToDeviceiTunes_SelectDeviceItem_Descript", nil),CustomLocalizedString(@"ToTransfer_Title_TOiTunes", nil)]];
        }
        [self setBindcategoryArray:_categoryArray];
        [_connectionView selectAll:nil];
        NSButton *backbutton = [_nextbackBgView viewWithTag:121];
        [backbutton setHidden:NO];
        _isCategorySelect = YES;
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil)]];
    }
}

- (void)back:(id)sender
{
    [_deviceSelectView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"push";
    transition.subtype = @"fromLeft";
    [_contentBox.layer addAnimation:transition forKey:@"animation"];
    [_contentBox setContentView:_deviceSelectView];
    NSButton *backbutton = [_nextbackBgView viewWithTag:121];
    [backbutton setHidden:YES];
    _isCategorySelect = NO;
    if (_transferType == ToiCloudType) {
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"icloud_TargetAccount_Tip", nil)]];
    }else if (_transferType == ToiTunesType){
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil)]];
    }else{
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"Clone_id_5", nil)]];
    }
}

- (void)selectDevice:(IMBiPodMenuItem *)item
{
    if (_targetiPod != nil) {
        [_targetiPod release];
    }
    _targetiPod = [[[IMBDeviceConnection singleton] getIPodByKey:item.iPodunique] retain];
    if (_transferType == ToiCloudType) {
        _selectedItem = item;
        [_targetDevicePopButton setTitle:item.title];
    }else{
        [_targetDevicePopButton setTitle:_targetiPod.deviceInfo.deviceName];
        [_targetDeviceImageView setImage:[self getipodImage:_targetiPod]];
        [_completeDeviceImageView setImage:[self getipodImage:_targetiPod]];
    }
    [_targetDevicePopButton setFrame:NSMakeRect(ceilf((NSWidth(_popUpButtonBgView.frame) - NSWidth(_targetDevicePopButton.frame))/2.0), 0, NSWidth(_targetDevicePopButton.frame), NSHeight(_targetDevicePopButton.frame))];
    [_occlusionView setFrameOrigin:NSMakePoint(_targetDevicePopButton.frame.size.width-_occlusionView.frame.size.width+2 - 4, 3)];
    [item setState:NSOnState];
    for (IMBiPodMenuItem *item1 in _targetDevicePopButton.menu.itemArray) {
        if (item1 != item) {
            [item1 setState:NSOffState];
        }
    }
}


- (void)setSelectedNavStr:(NSString *)str
{
    NSString *navStr = nil;
    if (_transferType == ToiCloudType){
        navStr = [NSString stringWithFormat:@"%@ > %@ > %@ > %@",CustomLocalizedString(@"icloud_TargetAccount_Tip", nil),CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil),CustomLocalizedString(@"Clone_id_7", nil),CustomLocalizedString(@"Clone_id_8", nil)];
    }else if (_transferType == ToiTunesType){
        navStr = [NSString stringWithFormat:@"%@ > %@ > %@",CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil),CustomLocalizedString(@"Clone_id_7", nil),CustomLocalizedString(@"Clone_id_8", nil)];
    }else {
        navStr = [NSString stringWithFormat:@"%@ > %@ > %@ > %@",CustomLocalizedString(@"Clone_id_5", nil),CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil),CustomLocalizedString(@"Clone_id_7", nil),CustomLocalizedString(@"Clone_id_8", nil)];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:navStr];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setAlignment:NSCenterTextAlignment];
    [text addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:14.0],NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, text.length)];
    NSRange range = [text.string rangeOfString:str];
    [text addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, range.location+range.length)];
    [_navigationField setAttributedStringValue:text];
    [text release];
    
}

- (IBAction)closeWindow:(id)sender
{
    if (!_isTransferComplete) {
        [_baseTransfer setIsPause:YES];
        [_alertViewController setIsStopPan:YES];
        int result = [self showAlertText:CustomLocalizedString(@"Main_Window_Stop_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
        [_alertViewController setIsStopPan:NO];
        if (result) {
            [_baseTransfer setIsStop:YES];
            [_baseTransfer setIsPause:NO];
            [_closebutton setEnabled:NO];
            [_transferTitleField setStringValue:CustomLocalizedString(@"ImportSync_id_5", nil)];
            [_transferTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        }else {
            [_baseTransfer setIsPause:NO];
        }
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        [self animationRemoveToDeviceVeiw];
    }
}

- (void)animationRemoveToDeviceVeiw
{
    //放开语言设置按钮-----long
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    NSMenu *menu = self.view.window.menu;
    NSMenuItem *item = [menu itemWithTag:205];
    [item setEnabled:YES];
    [_contentBox setAutoresizingMask:NSViewMinYMargin];
    [_nextbackBgView setAutoresizingMask:NSViewMinYMargin];
    [self.view setFrame: NSMakeRect(0, -20, NSWidth(self.view.frame), NSHeight(self.view.frame)+20)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(0) Y:@(20) repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.layer addAnimation:anima1 forKey:@"moveY"];
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(20) Y:@(-NSHeight(self.view.frame)) repeatCount:1];
            anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [self.view.layer addAnimation:anima1 forKey:@"moveY"];
            if (_delegate && [_delegate respondsToSelector:@selector(setShowTopLineView:)]) {
                [_delegate setShowTopLineView:NO];
            }
        } completionHandler:^{
            [self.view removeFromSuperview];
            [self release];
        }];
    }];
    //to do 需要结束正在传输的进程
    [_cloneAnimationView stopAnimation];
}

- (IBAction)clickCheckBox:(id)sender
{
    NSButton *button = (NSButton *)sender;
    NSView *superView = [sender superview];
    for (NSView *selView in superView.subviews) {
        if ([selView isKindOfClass:[NSTextField class]]) {
            NSTextField *field = (NSTextField *)selView;
            for (IMBCategoryInfoModel *model in _arrayController.content) {
                if ([field.stringValue isEqualToString:model.categoryName]) {
                    model.isSelected = button.state;
                    break;
                }
            }
        }
    }
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[(NSArray *)_arrayController.content count];i++) {
        IMBCategoryInfoModel *model = [_arrayController.content objectAtIndex:i];
        if (model.isSelected) {
            [set addIndex:i];
        }
    }
    [_connectionView setSelectionIndexes:set];
    
}

- (IBAction)transferMoreBtnDown:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
    [self animationRemoveToDeviceVeiw];
}

- (void)doOkBtnOperation:(id)sender
{
    if (_isNoDevice) {
        [self closeWindow:nil];
        _isNoDevice = NO;
    }
}

#pragma mark - NSTextViewDelegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex
{
    if (_successCount < _totalCount && [IMBTransferError singleton].errorArrayM.count > 0) {
        if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)]) {
            [self closeWindow:nil];
            
        } else if ([link isEqualToString:CustomLocalizedString(@"Show_ResultWindow_linkTips", nil)]) {
            //传输失败原因弹框
            NSView *view = nil;
            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                    view = subView;
                    break;
                }
            }
            if (view) {
                [view setHidden:NO];
                [_androidAlertViewController showATtransferFailAlertViewWithSuperView:view WithFailReasonArray:[IMBTransferError singleton].errorArrayM];
            }
        } else {
            NSURL *url = [NSURL URLWithString:CustomLocalizedString(@"url_guild_id_3", nil)];
            NSWorkspace *ws = [NSWorkspace sharedWorkspace];
            [ws openURL:url];
        }
    } else {
        if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)]|| [link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil)]) {
            NSLog(@"%@",CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil));
            [self closeWindow:nil];
        }else{
            NSURL *url = [NSURL URLWithString:CustomLocalizedString(@"url_guild_id_3", nil)];
            NSWorkspace *ws = [NSWorkspace sharedWorkspace];
            [ws openURL:url];
        }
    }
    
    return YES;
}

#pragma mark - Alert
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    return [_alertViewController showAlertText:alertText OKButton:OkText CancelButton:cancelText SuperView:view];
}

- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText
{
    IMBAlertViewController *vc = [[IMBAlertViewController alloc]initWithNibName:@"IMBAlertViewController" bundle:nil];
    vc.delegate = self;
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    return [vc showAlertText:alertText OKButton:OkText SuperView:view];
}

#pragma mark - TransferDelegate
//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([file isEqualToString:@"needDisClose"]) {
            [_closebutton setEnabled:NO];
            return;
        }else if ([file isEqualToString:@"needEnClose"]){
            [_closebutton setEnabled:YES];
            return;
        }
        NSMenu *menu = self.view.window.menu;
        NSMenuItem *item = [menu itemWithTag:205];
        [item setEnabled:NO];
        if (![TempHelper stringIsNilOrEmpty:file]) {
            if (_transferType != ToDeviceType && _transferType != ToiCloudType) {
                if ([file isEqualToString:@"backupphotolibrary"]) {
                    [_progressviewBar removeAnimationImgView];
                    [_progressviewBar reInit];
                }else if ([file isEqualToString:@"backupmyalbum"]){
                    [_progressviewBar removeAnimationImgView];
                    [_progressviewBar reInit];
                }else if ([file isEqualToString:@"backDevicesource"]){
                    [_progressviewBar removeAnimationImgView];
                    [_cloneAnimationView startBackupAnimation];
                    [_progressviewBar reInit];
                }else if ([file isEqualToString:@"backDevicetarget"]){
                    [_progressviewBar removeAnimationImgView];
                    [_progressviewBar reInit];
                }else if ([file isEqualToString:@"insertData"]){
                    [_cloneAnimationView startCloneDataAnimation];
                    [_progressviewBar removeAnimationImgView];
                    [_progressviewBar reInit];
                }else if ([file isEqualToString:@"restoreDevice"]){
                    [_progressviewBar removeAnimationImgView];
                    [_progressviewBar reInit];
                }else{
                    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:file];
                    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
                    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
                    [_fileNameField setAttributedStringValue:as];
                    [as release], as = nil;
                }
            }else{
                if (![TempHelper stringIsNilOrEmpty:file]) {
                    [_fileNameField setStringValue:file];
                    [_fileNameField setFrame:NSMakeRect(NSMinX(_fileNameField.frame), NSMinY(_fileNameField.frame), NSWidth(_fileNameField.frame), 30)];
                    [_fileNameField setFont:[NSFont fontWithName:@"Helvetica Neue" size:18]];
                    [_fileNameField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                }
                
            }
        }
    });
}
//传输准备进度结束
- (void)transferPrepareFileEnd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_transferType==MergeType||_transferType==CloneType) {
            [_closebutton setEnabled:NO];
        }
        [_progressviewBar removeAnimationImgView];
        [_progressviewBar startAnimation];
    });
}

//传输进度
- (void)transferProgress:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"android merge progress:%f",progress);
        if (progress == 100) {
            [_progressviewBar setProgressWithOutAnimation:100];
            if (_transferType != ToDeviceType) {
                [self performSelectorOnMainThread:@selector(progressBarWait) withObject:nil waitUntilDone:NO];
            }
        }else{
            [_progressviewBar setProgress:progress];
        }
    });
}
//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![TempHelper stringIsNilOrEmpty:file]) {
            NSString *str = @"";
            NSString *endStr = [self isaddMosaicTextStr:file];
            if (endStr != nil) {
                str = endStr;
            }else{
                str = file;
            }
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
            [_fileNameField setAttributedStringValue:as];
            [as release], as = nil;
        }
    });
}

-(void)parseProgress:(float)progress
{
}

-(void)parseFile:(NSString *)file
{
    
}

- (BOOL)transferOccurError:(NSString *)str
{
    BOOL tranferError = NO;
    [_alertViewController setIsStopPan:YES];
    if ([str isEqualToString:@"target-30"]) {
        if ([self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Clone_id_17", nil),_targetiPod.deviceInfo.deviceName?_targetiPod.deviceInfo.deviceName:@""] OKButton:CustomLocalizedString(@"Clone_id_23", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)] == 1) {
            tranferError = YES;
        }else{
            tranferError = NO;
        }
    }else if ([str isEqualToString:@"target-35"]){
        if ([self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Clone_id_27", nil),_targetiPod.deviceInfo.deviceName?_targetiPod.deviceInfo.deviceName:@""] OKButton:CustomLocalizedString(@"Button_Ok", nil)] == 1) {
            tranferError = YES;
        }else{
            tranferError = NO;
        }
    }else if ([str isEqualToString:@"restore-36"]){
        [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Clone_id_32", nil),_targetiPod.deviceInfo.deviceName?_targetiPod.deviceInfo.deviceName:@""] OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else{
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
    tranferError = NO;
    [_alertViewController setIsStopPan:NO];
    return tranferError;
}

- (void)transferComplete:(int)successCount TotalCount:(int)totalCount
{
    _successCount = successCount;
    _totalCount = totalCount;
    [_android sendAction:@"RecoveryFinished" ResultText:_successCount TargetWord:@"Defalut"];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        if (_transferType == TransferToiTunes) {
            if (successCount > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOAD_ITUNES_DATA object:nil];
            }
        }
        if (_annoyTimer != nil) {
            [_annoyTimer invalidate];
            _annoyTimer = nil;
        }
        if (_transferType == ToDeviceType || _transferType == ToiCloudType || _transferType == ToiTunesType) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
            _isTransferComplete = YES;
            [_closebutton setEnabled:YES];
            [_cloneAnimationView stopAnimation];
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"fade";
            [_contentBox.layer addAnimation:transition forKey:@"animation"];
            
            if (![IMBSoftWareInfo singleton].isRegistered && ![IMBSoftWareInfo singleton].isNOAdvertisement) {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
                    [self setSelectedNavStr:CustomLocalizedString(@"Clone_id_8", nil)];
                    [self configEnMoveToiOSCompleteView];
                    [_contentBox setContentView:_enmoveToiOSCompleteView];
                } else {
                    [self setSelectedNavStr:CustomLocalizedString(@"Clone_id_8", nil)];
                    [self configMoveToiOSCompleteView];
                    [_contentBox setContentView:_moveToiOSCompleteView];
                }
                
            } else {
                [_contentBox setContentView:_completeView];
                [self setSelectedNavStr:CustomLocalizedString(@"Clone_id_8", nil)];
                [_completetitleFieFld setStringValue:CustomLocalizedString(@"Transfer_text_Todevice_complete", nil)];
                
                if (_transferType == ToiCloudType) {
                    [_completetitleFieFld setStringValue:CustomLocalizedString(@"Sync_text_toicloud_complete", nil)];
                    NSString *transfercountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
                    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tip", nil),transfercountStr];
                    [_completeSubTitleField setStringValue:str];
                }else if (_transferType == ToDeviceType){
                    [_completetitleFieFld setStringValue:CustomLocalizedString(@"Transfer_text_Todevice_complete", nil)];
                    NSString *transfercountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
                    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tip", nil),transfercountStr];
                    [_completeSubTitleField setStringValue:str];
                }else{
                    [_completetitleFieFld setStringValue:CustomLocalizedString(@"Transfer_text_Todevice_complete", nil)];
                    NSString *transfercountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
                    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tip", nil),transfercountStr];
                    [_completeSubTitleField setStringValue:str];
                }
                
                if (_successCount < totalCount && [IMBTransferError singleton].errorArrayM.count > 0) {
                    
                    NSString *promptStr = @"";
                    NSString *overStr1 = @"";
                    NSString *overStr2 = @"";
                    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_viewfile", nil), CustomLocalizedString(@"Show_ResultWindow_linkTips", nil),CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)];
                    overStr1 = CustomLocalizedString(@"Show_ResultWindow_linkTips", nil);
                    overStr2 = CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil);
                    
                    
                    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
                    [_textView setLinkTextAttributes:linkAttributes];
                    
                    NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr?:@""];
                    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, promptAs.length)];
                    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
                    
                    NSRange infoRange1 = [promptStr rangeOfString:overStr1];
                    [promptAs addAttribute:NSLinkAttributeName value:overStr1 range:infoRange1];
                    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange1];
                    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange1];
                    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange1];
                    
                    NSRange infoRange2 = [promptStr rangeOfString:overStr2];
                    [promptAs addAttribute:NSLinkAttributeName value:overStr2 range:infoRange2];
                    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange2];
                    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange2];
                    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange2];
                    
                    
                    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
                    [mutParaStyle setAlignment:NSCenterTextAlignment];
                    [mutParaStyle setLineSpacing:5.0];
                    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
                    [[_textView textStorage] setAttributedString:promptAs];
                    [promptAs release], promptAs =nil;
                    [mutParaStyle release];
                    mutParaStyle = nil;
                    
                } else {
                    
                    NSString *promptStr = @"";
                    NSString *overStr1 = @"";
                    promptStr = CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil);
                    overStr1 = CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil);
                    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
                    [_textView setLinkTextAttributes:linkAttributes];
                    
                    NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr?:@""];
                    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, promptAs.length)];
                    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
                    
                    NSRange infoRange1 = [promptStr rangeOfString:overStr1];
                    [promptAs addAttribute:NSLinkAttributeName value:overStr1 range:infoRange1];
                    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange1];
                    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange1];
                    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange1];
                    
                    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
                    [mutParaStyle setAlignment:NSCenterTextAlignment];
                    [mutParaStyle setLineSpacing:5.0];
                    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
                    [[_textView textStorage] setAttributedString:promptAs];
                    [promptAs release], promptAs =nil;
                    [mutParaStyle release];
                    mutParaStyle = nil;
                    
                }

                [_completetitleFieFld setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                [_completeSubTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
            }
            [_baseTransfer setIsStop:NO];
            [_baseTransfer setIsPause:NO];
        }
    });
}

- (void)progressBarWait
{
    [_progressviewBar setLoadAnimation];
}

#pragma mark - 检查设备是否赋予权限
- (void)checkDeviceGreantedPermission {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_android != nil) {
            //判断apk是否启动,没有启动就重新启动；
            IMBAdbManager *adbManager = [IMBAdbManager singleton];
            NSString *runStr = [adbManager runADBCommand:[adbManager checkApkIsRunning:_android.deviceInfo.devSerialNumber]];
            BOOL isRet = YES;
            if ([runStr rangeOfString:@"android.imobie.com.anytransservice"].location == NSNotFound) {
                if (![_android checkIsInstallApk:_android.deviceInfo.devSerialNumber]) {
                    isRet = [_android installAPK:_android.deviceInfo.devSerialNumber];
                }
                if (isRet) {
                    [adbManager runADBCommand:[adbManager clearServiceLogcat:_android.deviceInfo.devSerialNumber]];
                    [adbManager runADBCommand:[adbManager startIntent:_android.deviceInfo.devSerialNumber]];
                    [adbManager runGrepCommand:[adbManager checkServiceIsRunning:_android.deviceInfo.devSerialNumber]];//检查apk服务是否启动成功，会阻塞等待
                    //与服务器进行3次握手操作
                    int i = 3;
                    BOOL isSuccess = NO;
                    while (i--) {
                        if ([_android.adPermisson shakehandApk]) {
                            isSuccess = YES;
                            break;
                        }
                    }
                }
            }
            if (isRet) {
                [self greantedPermission];
            }else {
                if (_transferType == ToiTunesType) {
                    [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iTunes"];
                }else if (_transferType == ToiCloudType) {
                    [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iCloud"];
                }else {
                    if (_targetiPod.deviceInfo.isiPad) {
                        [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPad"];
                    }else if (_targetiPod.deviceInfo.isiPhone) {
                        [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPhone"];
                    }else {
                        [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPodTouch"];
                    }
                }
                [_baseTransfer startTransfer];
            }
        }
    });
}
//判断读取设备权限是否足够
- (void)greantedPermission {
    BOOL isGreanted = [_android checkDevicePermisson];
    if (!isGreanted) {
        [self performSelectorOnMainThread:@selector(setGreantedPermission) withObject:nil waitUntilDone:0];
    }else {
        if (_transferType == ToiTunesType) {
            [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iTunes"];
        }else if (_transferType == ToiCloudType) {
            [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iCloud"];
        }else {
            if (_targetiPod.deviceInfo.isiPad) {
                [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPad"];
            }else if (_targetiPod.deviceInfo.isiPhone) {
                [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPhone"];
            }else {
                [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPodTouch"];
            }
        }
        [_baseTransfer startTransfer];
    }
}
//弹出窗口，提示用户到设备上进行权限允许
- (void)setGreantedPermission {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
            view = subView;
            break;
        }
    }
    if (view) {
        [view setHidden:NO];
        BOOL versionResult = [ _android.deviceInfo.devVersion isVersionMajorEqual:@"6.0"];
        [_androidAlertViewController setAndroid:_android];
        int result = [_androidAlertViewController showImproveAuthorityAlertView:view isVersionHighThan6:versionResult];
        if (result) {
            [self performSelector:@selector(checkDeviceGreantedPermission) withObject:nil afterDelay:0.6];
        }else {
            if (_transferType == ToiTunesType) {
                [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iTunes"];
            }else if (_transferType == ToiCloudType) {
                [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iCloud"];
            }else {
                if (_targetiPod.deviceInfo.isiPad) {
                    [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPad"];
                }else if (_targetiPod.deviceInfo.isiPhone) {
                    [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPhone"];
                }else {
                    [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPodTouch"];
                }
            }
            [_baseTransfer startTransfer];
        }
    }
}

#pragma mark - move to iOS 完成活动界面 - 其他语言
- (void)configMoveToiOSCompleteView {
    //配置文字和图片
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr];
        } else if (_successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
    } else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            if (_transferType == ToDeviceType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr];
            } else if (_transferType == ToiTunesType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_iTCompleteActivity_Titles", nil),overStr];
            } else if (_transferType == ToiCloudType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_iCCompleteActivity_Titles", nil),overStr];
            }
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
            
        } else if (_successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            if (_transferType == ToDeviceType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr];
            } else if (_transferType == ToiTunesType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_iTCompleteActivity_Title", nil),overStr];
            } else if (_transferType == ToiCloudType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_iCCompleteActivity_Title", nil),overStr];
            }
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
        
    } else {
        
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            if (_transferType == ToDeviceType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr,CustomLocalizedString(@"contact_id_4", nil)];
            } else if (_transferType == ToiTunesType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr,CustomLocalizedString(@"ToTransfer_Title_TOiTunes", nil)];
            } else if (_transferType == ToiCloudType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr,CustomLocalizedString(@"MenuItem_id_39", nil)];
            }
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
        } else if (_successCount == 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            if (_transferType == ToDeviceType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr,CustomLocalizedString(@"contact_id_4", nil)];
            } else if (_transferType == ToiTunesType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr,CustomLocalizedString(@"ToTransfer_Title_TOiTunes", nil)];
            } else if (_transferType == ToiCloudType) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr,CustomLocalizedString(@"MenuItem_id_39", nil)];
            }
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
    }
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_moveToiOSCompleteTitle textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    [_moveToiOSCompleteSubTitle setStringValue:CustomLocalizedString(@"MoveToiOS_CompleteActivity_SubTitle", nil)];
    [_moveToiOSCompleteSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    NSMutableAttributedString *promptAs1 = [StringHelper setSingleTextAttributedString:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Description", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle1 =[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle1 setAlignment:NSCenterTextAlignment];
    [mutParaStyle1 setLineSpacing:5.0];
    [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
    [[_moveToiOSCompleteDetailStr textStorage] setAttributedString:promptAs1];
    [mutParaStyle1 release], mutParaStyle1 = nil;
    
    [_moveToiOSCompleteImageView setImage:[StringHelper imageNamed:@"ad_toios_fr"]];
    
    //配置按钮
    [_moveToiOSCompleteBtn setButtonTitle:CustomLocalizedString(@"MoveToiOS_CompleteActivity_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_moveToiOSCompleteBtn setNormalFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_normalColor", nil)] WithEnterFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_enterColor", nil)] WithDownFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_downColor", nil)]];
    [_moveToiOSCompleteBtn setBgNormalFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_normalColor", nil)] WithBgEnterFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_enterColor", nil)] WithBgDownFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_downColor", nil)]];
    [_moveToiOSCompleteBtn setHasLeftImage:YES];
    [_moveToiOSCompleteBtn setLeftImage:[StringHelper imageNamed:@"toios_btngift_la"]];
    [_moveToiOSCompleteBtn setHasBorder:NO];
    [_moveToiOSCompleteBtn setIsMoveToiOSBtn:YES];
    [_moveToiOSCompleteBtn setTarget:self];
    [_moveToiOSCompleteBtn setAction:@selector(moveToiOSCompleteBtnClick)];
    [_moveToiOSCompleteBtn setNeedsDisplay:YES];
}

#pragma mark - move to iOS 完成活动界面 - 英语版
- (void)configEnMoveToiOSCompleteView {
    //配置文字和图片
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if (_successCount > 1) {//先暂时不修改，等文字确认之后在修改
        overStr = [NSString stringWithFormat:@"%d/%d",_successCount,_totalCount];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr];
        overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_items", nil)];
    } else if (_successCount == 1) {
        overStr = [NSString stringWithFormat:@"%d/%d",_successCount,_totalCount];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr];
        overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_item", nil)];
    } else {
        promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
    }
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_enmoveToiOSCompleteTitle textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *subTitle = CustomLocalizedString(@"MoveToiOS_CompleteActivity_SubTitle", nil);
    if (![StringHelper stringIsNilOrEmpty:soft.activityInfo.iosSubTitleWord]) {
        subTitle = soft.activityInfo.iosSubTitleWord;
    }
    [_enmoveToiOSCompleteSubTitle setStringValue:subTitle];
    [_enmoveToiOSCompleteSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    
    NSString *detailStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_Description", nil);
    if (![StringHelper stringIsNilOrEmpty:soft.activityInfo.iosDescriptionWord]) {
        detailStr = soft.activityInfo.iosDescriptionWord;
    }
    NSMutableAttributedString *promptAs1 = [StringHelper setSingleTextAttributedString:detailStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle1 =[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle1 setAlignment:NSCenterTextAlignment];
    [mutParaStyle1 setLineSpacing:5.0];
    [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
    [[_enmoveToiOSCompleteDetailStr textStorage] setAttributedString:promptAs1];
    [mutParaStyle1 release], mutParaStyle1 = nil;
    
    [_enmoveToiOSCompleteImageView setImage:[StringHelper imageNamed:@"ad_toios_en"]];
    
    //配置按钮
    NSString *btnStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_BtnTitle", nil);
    if (![StringHelper stringIsNilOrEmpty:soft.activityInfo.iosBtnWord]) {
        btnStr = soft.activityInfo.iosBtnWord;
    }
    [_enmoveToiOSCompleteBtn setButtonTitle:btnStr withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_enmoveToiOSCompleteBtn setNormalFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_normalColor", nil)] WithEnterFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_enterColor", nil)] WithDownFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_downColor", nil)]];
    [_enmoveToiOSCompleteBtn setBgNormalFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_normalColor", nil)] WithBgEnterFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_enterColor", nil)] WithBgDownFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_downColor", nil)]];
    [_enmoveToiOSCompleteBtn setHasLeftImage:YES];
    [_enmoveToiOSCompleteBtn setLeftImage:[StringHelper imageNamed:@"toios_btngift_la"]];
    [_enmoveToiOSCompleteBtn setHasBorder:NO];
    [_enmoveToiOSCompleteBtn setIsMoveToiOSBtn:YES];
    [_enmoveToiOSCompleteBtn setTarget:self];
    [_enmoveToiOSCompleteBtn setAction:@selector(moveToiOSCompleteBtnClick)];
    [_enmoveToiOSCompleteBtn setNeedsDisplay:YES];
}

#pragma mark - move to iOS 完成活动界面  - 按钮点击方法
- (void)moveToiOSCompleteBtnClick {
    if (!_hostUrl) {
        NSString *hoStr = nil;
        if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
            
            if ([IMBSoftWareInfo singleton].iosMoverDiscountUrl) {
                hoStr = [IMBSoftWareInfo singleton].iosMoverDiscountUrl;
            }else {
                NSMutableArray *hostArr = [IMBSoftWareInfo singleton].activityInfo.iosmoverArray;
                if (hostArr.count == 1) {
                    hoStr = [hostArr objectAtIndex:0];
                } else if (hostArr.count > 1) {
                    int r = arc4random() % [hostArr count];
                    NSLog(@"arc4random:%d",r);
                    hoStr = [hostArr objectAtIndex:r];
                } else {
                    int r = arc4random() % 3;
                    NSLog(@"arc4random:%d",r);
                    NSString *numberStr = [NSString stringWithFormat:@"%d",r];
                    NSString *keyStr = [@"MoveToiOS_CompleteActivity_Url" stringByAppendingString:numberStr];
                    hoStr = CustomLocalizedString(keyStr, nil);
                }
                [[IMBSoftWareInfo singleton] setIosMoverDiscountUrl:hoStr];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[IMBSoftWareInfo singleton] saveIosMoverUrl];
                });
            }
        } else {
            hoStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_Url", nil);
        }
        _hostUrl = [[NSURL URLWithString:hoStr] retain];
    }
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:_hostUrl];
}

- (void)dealloc
{
    if (_hostUrl) {
        [_hostUrl release];
        _hostUrl = nil;
    }
    [_betweenTransfer release],_betweenTransfer = nil;
    [_closebutton release],_closebutton = nil;
    [_restoreiPodKey release],_restoreiPodKey = nil;
    [_categoryArray release],_categoryArray = nil;
    [_baseTransfer release],_baseTransfer = nil;
    [_bindcategoryArray release],_bindcategoryArray = nil;
    [_android release],_android = nil;
    [super dealloc];
}

@end

