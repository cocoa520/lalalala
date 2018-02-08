//
//  IMBMergeOrCloneViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-10.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMergeOrCloneViewController.h"
#import "IMBBackgroundBorderView.h"
#import "IMBAnimation.h"
#import "IMBDeviceConnection.h"
#import "IMBiPodMenuItem.h"
#import "NSString+Category.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBCategoryInfoModel.h"
#import "IMBToMacSelectionVeiw.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBCloneOrMergeManager.h"
#import "IMBNotificationDefine.h"
#import "IMBDeviceConnection.h"
#import "SystemHelper.h"
#import "IMBAirSyncImportTransfer.h"
#import "StringHelper.h"
#import "NSColor+Category.h"
#import "CloneAnimationView.h"

@implementation IMBMergeOrCloneViewController
@synthesize bindcategoryArray = _bindcategoryArray;
@synthesize restoreiPodKey = _restoreiPodKey;
@synthesize hasPhotoBack = _hasPhotoBack;
- (id)initWithiPod:(IMBiPod *)iPod CategoryInfoModelArrary:(NSMutableArray *)categoryArray TransferType:(TransferType)transferType
{
    if (self = [super initWithNibName:@"IMBMergeOrCloneViewController" bundle:nil]) {
        _bindcategoryArray = [[NSMutableArray array] retain];
        _sourceiPod = [iPod retain];
        _categoryArray = [categoryArray retain];
        _transferType = transferType;
        _isCategorySelect = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadFinish:) name:NOTIFY_INFORMATIONDATA_LOADFINISH object:nil];
    }
    return self;
}

- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager CategoryInfoModelArrary:(NSMutableArray *)categoryArray TransferType:(TransferType)transferType AccountDic:(NSDictionary *)accountDic;
{
    if (self = [super initWithNibName:@"IMBMergeOrCloneViewController" bundle:nil]) {
        _bindcategoryArray = [[NSMutableArray array] retain];
        _categoryArray = [categoryArray retain];
        _transferType = transferType;
        _isCategorySelect = NO;
        _iCloudManager = iCloudManager;//弱引用
        _accountDic = accountDic; //弱引用
        _isiCloudView = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadFinish:) name:NOTIFY_INFORMATIONDATA_LOADFINISH object:nil];
    }
    return self;

}

- (void)awakeFromNib
{
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
    [_alertViewController setDelegate:self];
    _androidAlertViewController = [[IMBAndroidAlertViewController alloc] initWithNibName:@"IMBAndroidAlertViewController" bundle:nil];
    [_androidAlertViewController setDelegate:self];
    _mergeCloneAppVC = [[IMBMergeCloneAppViewController alloc]initWithNibName:@"IMBMergeCloneAppViewController" bundle:nil];
    [_connectionView setMaxNumberOfColumns:5];
    [_connectionView setMaxNumberOfRows:20];
    [_contentBox setWantsLayer:YES];
    if (_transferType == ToiCloudType) {
        [_arrowImageVIew setImage:[StringHelper imageNamed:@"iCloud_arrow"]];
        [_sourceDeviceImageView setFrame:NSMakeRect(5, 49, 164, 180)];
        [_sourceDeviceImageView setImage:[StringHelper imageNamed:@"iCloud_transfer"]];
        [_sourceDeviceNameField setStringValue:_iCloudManager.netClient.loginInfo.loginInfoEntity.fullName];
        [_sourceDeviceNameField setFrame:NSMakeRect(NSMinX(_sourceDeviceImageView.frame) + 82 - NSWidth(_sourceDeviceNameField.frame)/2.0, _sourceDeviceNameField.frame.origin.y+20, NSWidth(_sourceDeviceNameField.frame), NSHeight(_sourceDeviceNameField.frame))];
    }else{
        [_sourceDeviceImageView setImage:[self getipodImage:_sourceiPod]];
        [_sourceDeviceNameField setStringValue:_sourceiPod.deviceInfo.deviceName?:@""];
        [_arrowImageVIew setImage:[StringHelper imageNamed:@"clone_arrow"]];

    }
    [_sourceDeviceNameField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    NSArray *connectionarray = [connection getConnectedIPods];
    NSMutableArray *array = [NSMutableArray array];
    if (_transferType == ToiCloudType) {
        for (NSString *appleId in _accountDic.allKeys) {
            if (![appleId isEqualToString:_iCloudManager.netClient.loginInfo.appleID]) {
                IMBiCloudManager *icloudManager = [[_accountDic objectForKey:appleId] iCloudManager];
                [array addObject:icloudManager];
            }
        }
    }else{
        for (IMBiPod *ipod in connectionarray) {
            if (_transferType == ToDeviceType) {
                
                if (![ipod.uniqueKey isEqualToString:_sourceiPod.uniqueKey]) {
                    [array addObject:ipod];
                }
            }else {
                if (ipod.deviceInfo.isIOSDevice&&[ipod.deviceInfo.productVersion isVersionMajorEqual:@"6.0"]&&![ipod.uniqueKey isEqualToString:_sourceiPod.uniqueKey]) {
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
            IMBiPodMenuItem *item = [[IMBiPodMenuItem alloc] init];
            [item setTitle:ipod.deviceInfo.deviceName];
            [item setIPodunique:ipod.uniqueKey];
            [item setTarget:self];
            [item setAction:@selector(selectDevice:)];
            [menu addItem:item];
            [item release];
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
        
    }else{
        [_targetDevicePopButton setTitle:_targetiPod.deviceInfo.deviceName?:@""];
        [_targetDeviceImageView setImage:[self getipodImage:_targetiPod]];
        [_completeDeviceImageView setImage:[self getipodImage:_targetiPod]];
    }
     [_targetDevicePopButton setFrame:NSMakeRect(ceilf((NSWidth(_popUpButtonBgView.frame) - NSWidth(_targetDevicePopButton.frame))/2.0), 0, NSWidth(_targetDevicePopButton.frame), NSHeight(_targetDevicePopButton.frame))];
    [_popArrowImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [_occlusionView setFrameOrigin:NSMakePoint(_targetDevicePopButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
    [_occlusionView setBackgroundColor:[NSColor clearColor]];
    [_targetDevicePopButton addSubview:_occlusionView];
    
    [item setState:NSOnState];
   

//    [((IMBBackgroundBorderView *)self.view) setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
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
    [_contentBox setContentView:_deviceSelectView];
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
//    [_connectionBgView setBackgroundColor:IMBLINE_GENERALITY_COLOR];
    [_connectionBgView setWantsLayer:YES];
    [_connectionBgView.layer setBorderWidth:1.0];
    [_connectionBgView.layer setCornerRadius:5];
    [_connectionBgView.layer setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)].toCGColor];
    [_connectionBgView setHasStrokeRadius:YES];
    [_connectionBgView setXRadius:5.0 YRadius:5.0];
    
    if (_transferType == ToiCloudType) {
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"icloud_TargetAccount_Tip", nil)]];

    }else{
        [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"Clone_id_5", nil)]];
    }
    NSString *str = nil;
    if (_transferType == CloneType) {
        [_tipScrollView setHidden:NO];
        _tipTextView.delegate = self;
        [self setTipText];
        [_deviceSelectTitleField setStringValue:CustomLocalizedString(@"MergeDevice_SelectTargetDevice_Title", nil)];
        [_deviceSelectsubTitleField setStringValue:CustomLocalizedString(@"CloneDevice_SelectTargetDevice_Descript", nil)];
        str = CustomLocalizedString(@"Clone_Message_Caution", nil);
        
        
        NSString *str1 = [NSString stringWithFormat:CustomLocalizedString(@"ToTransfer_Descript_TODevice", nil),_targetiPod.deviceInfo.deviceName];
        [_categorySelectsubTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloneDevice_SelectDeviceItem_Descript", nil),str1]];
        
        
//                [_categorySelectsubTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloneDevice_SelectDeviceItem_Descript", nil),_targetiPod.deviceInfo.deviceName] ];
    }else if (_transferType == MergeType){
        [_tipScrollView setHidden:YES];
        [_deviceSelectTitleField setStringValue:CustomLocalizedString(@"MergeDevice_SelectTargetDevice_Title", nil)];
        [_deviceSelectsubTitleField setStringValue:CustomLocalizedString(@"MergeDevice_SelectTargetDevice_Descript", nil)];
        str = CustomLocalizedString(@"MergeDevice_Message_Caution", nil);
        
        NSString *str1 = [NSString stringWithFormat:CustomLocalizedString(@"ToTransfer_Descript_TODevice", nil),_targetiPod.deviceInfo.deviceName];
        [_categorySelectsubTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Descript", nil),str1]];
//
//        
//        [_categorySelectsubTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"MergeDevice_SelectDeviceItem_Descript", nil),_targetiPod.deviceInfo.deviceName] ];
    }else if (_transferType == ToDeviceType) {
        [_tipScrollView setHidden:YES];
        [_deviceSelectTitleField setStringValue:CustomLocalizedString(@"MergeDevice_SelectTargetDevice_Title", nil)];
        [_deviceSelectsubTitleField setStringValue:CustomLocalizedString(@"ToDevice_SelectTargetDevice_Descript", nil)];
        str = CustomLocalizedString(@"TransferDevice_Message_Caution", nil);

        NSString *str1 = [NSString stringWithFormat:CustomLocalizedString(@"ToTransfer_Descript_TODevice", nil),_targetiPod.deviceInfo.deviceName];
         [_categorySelectsubTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToDeviceiTunes_SelectDeviceItem_Descript", nil),str1]];
    }else if (_transferType == ToiCloudType){
        str = CustomLocalizedString(@"icloud_upWarning_message", nil);
        [_deviceSelectTitleField setStringValue:CustomLocalizedString(@"icloud_TargetAccount_Title", nil)];
        [_deviceSelectsubTitleField setStringValue:CustomLocalizedString(@"icloud_TargetAccount_subTitle", nil)];
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

#pragma mark - deviceIpodLoadComplete
- (void)dataLoadFinish:(NSNotification *)notification
{
    IMBiPod *ipod = notification.object;
    if ([ipod.uniqueKey isEqualToString:_targetiPod.uniqueKey] && ipod.deviceInfo.isIOSDevice) {
        [self cloneMedia:ipod];
    }
}

- (void)cloneMedia:(IMBiPod *)ipod
{
    [MediaHelper killiTunes];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            BOOL readySync = NO;
            for (int i=0;i<3;i++) {
                if ([self readySync:_targetiPod]) {
                    readySync= YES;
                    break;
                }
            }
            NSMutableArray *arr = [NSMutableArray array];
            for (IMBCategoryInfoModel *model in [_arrayController selectedObjects]) {
                if (!(model.categoryNodes == Category_Bookmarks||model.categoryNodes == Category_Calendar||model.categoryNodes == Category_Contacts||model.categoryNodes == Category_CallHistory||model.categoryNodes == Category_Notes||model.categoryNodes == Category_Message||model.categoryNodes == Category_Applications)) {
                    [arr addObject:model];
                }
                if (model.categoryNodes == Category_Applications) {
                    if ([_sourceiPod.deviceInfo.getDeviceFloatVersionNumber isVersionLess:@"8.3"]&&[_targetiPod.deviceInfo.getDeviceFloatVersionNumber isVersionLess:@"8.3"]) {//原设备iOS小于8.3，就通过传输的方式clone；
                        [arr addObject:model];
                    }
                }
            }
            if (_hasPhotoBack) {
                //首先检测photolibrary
                NSMutableDictionary *allDic = [NSMutableDictionary dictionary];
                //没有在相册中的photo library图片
                NSString *photoBackupPath = [[SystemHelper userPicturePath] stringByAppendingPathComponent:@"AnytransPhotoBackup"];
                NSString *libraryPath = [photoBackupPath stringByAppendingPathComponent:@"myPicture"];
                NSMutableArray *photoLibraryArr = [self getfilePathInDir:libraryPath];
                if ([photoLibraryArr count]>0) {
                    [allDic setObject:photoLibraryArr forKey:[NSNumber numberWithInt:Category_PhotoLibrary]];
                }
                //相册中的photo library图片
                NSMutableDictionary *albumDic = [NSMutableDictionary dictionary];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray *contentArray = [fileManager contentsOfDirectoryAtPath:photoBackupPath error:nil];
                for (NSString *name in contentArray) {
                    if (![name isEqualToString:@"myPicture"]&&![name isEqualToString:@".DS_Store"]) {
                        NSString *filePath = [photoBackupPath stringByAppendingPathComponent:name];
                        NSMutableArray *filePathArray = [self getfilePathInDir:filePath];
                        if ([filePathArray count]>0) {
                            [albumDic setObject:filePathArray forKey:name];
                        }
                    }
                }
                if (albumDic.allKeys.count > 0) {
                    [allDic setObject:albumDic forKey:[NSNumber numberWithInt:Category_MyAlbums]];
                }
                
                if (allDic.allKeys.count > 0) {
                    IMBAirSyncImportTransfer *baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:_targetiPod.uniqueKey TransferDic:allDic delegate:self];
                    [baseTransfer setIsRestore:YES];
                    baseTransfer.isStop = _isStop;
                    [baseTransfer startTransfer];
                    [baseTransfer release];
                    baseTransfer = nil;
                    
                }
            }
            if ([self respondsToSelector:@selector(transferProgress:)]) {
                [self transferProgress:100];
            }
            //直接进行to device
            IMBBetweenDeviceHandler *betweenTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedModels:arr srcIpodKey:_sourceiPod.uniqueKey desIpodKey:_targetiPod.uniqueKey Delegate:self];
            betweenTransfer.isClone = YES;
            [betweenTransfer startTransfer];
            [betweenTransfer release];
            if ([self respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                [self cloneOrMergeComplete:YES];
            }
        }
    });
}

- (BOOL)readySync:(IMBiPod *)ipod
{
    BOOL readySync = NO;
    IMBATHSync * athSync = [[IMBATHSync alloc] initWithiPod:ipod SyncNodes:nil syncCtrType:SyncAddFile photoAlbum:nil];
    [athSync setCurrentThread:[NSThread currentThread]];
    if ([athSync createAirSyncService]) {
        if ([athSync sendRequestSync]) {
            [athSync waitSyncFinished];
            readySync = YES;
        }
    }
    [athSync release];
    return readySync;
}

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
#pragma mark - method
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
            image = [StringHelper imageNamed:@"clone_iPhonex_def"];
        }else{
            image = [StringHelper imageNamed:@"cloning_iPhone"];
        }
    }else if (ipod.deviceInfo.isiPad){
        image = [StringHelper imageNamed:@"cloning_iPad"];
    }else if (ipod.deviceInfo.isiPod){
        image = [StringHelper imageNamed:@"cloning_iPodTouch"];
    }
    return image;
}

- (void)setSelectedNavStr:(NSString *)str
{
    NSString *navStr = nil;
    
    if (_transferType == MergeType) {
        navStr = [NSString stringWithFormat:@"%@ > %@ > %@ > %@",CustomLocalizedString(@"Clone_id_5", nil),CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil),CustomLocalizedString(@"MergeDevice_step_selectMergeContentTip", nil),CustomLocalizedString(@"Clone_id_8", nil)];
    }else if (_transferType == CloneType){
        navStr = [NSString stringWithFormat:@"%@ > %@ > %@ > %@",CustomLocalizedString(@"Clone_id_5", nil),CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil),CustomLocalizedString(@"CloneDevice_step_selectContentTip", nil),CustomLocalizedString(@"Clone_id_8", nil)];
    }else if (_transferType == ToiCloudType){
        navStr = [NSString stringWithFormat:@"%@ > %@ > %@ > %@",CustomLocalizedString(@"icloud_TargetAccount_Tip", nil),CustomLocalizedString(@"ToPCiTunes_Step_Id_1", nil),CustomLocalizedString(@"Clone_id_7", nil),CustomLocalizedString(@"Clone_id_8", nil)];
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

- (BOOL)checkBackupEncrypt:(IMBiPod *)ipod {
    BOOL isEncrypt = [[ipod.deviceHandle deviceValueForKey:@"WillEncrypt" inDomain:@"com.apple.mobile.backup"] boolValue];
    return isEncrypt;
}

- (BOOL)isFindMyiCloud:(AMDevice *)device {
    bool isFindMyDevice = false;
    @try {
        isFindMyDevice = [[device deviceValueForKey:@"IsAssociated" inDomain:@"com.apple.fmip"] boolValue];
    }
    @catch (NSException *exception) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"Get IsAssociated exception %@", exception.reason]];
    }
    return isFindMyDevice;
}

#pragma mark - Actions
- (void)next:(id)sender
{
    if (_isCategorySelect) {
        //检测是否已有两个设备准备好
        if (_transferType == MergeType && _transferType == CloneType) {
            if (![self checkDeviceReady:NO]) {
                return;
            }
        }
        if ([[_connectionView selectionIndexes] count] == 0) {
            //需要提示 选择为空MergeDevice_Message_Title
            [self showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
        if (_transferType != ToDeviceType && _transferType != ToiCloudType) {
            if ([self checkBackupEncrypt:_sourceiPod]) {
                [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Clone_id_24", nil),_sourceiPod.deviceInfo.deviceName] OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                return;
            }
            if ([self checkBackupEncrypt:_targetiPod]) {
                [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Clone_id_24", nil),_targetiPod.deviceInfo.deviceName] OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                return;
            }
            if (_transferType == MergeType) {
                if (!_targetiPod.deviceInfo.isiPhone&&_targetiPod.deviceInfo.getDeviceVersionNumber<8) {
                    [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Merge_id_3", nil),_sourceiPod.deviceInfo.deviceName?_sourceiPod.deviceInfo.deviceName:@"",_targetiPod.deviceInfo.deviceName?_targetiPod.deviceInfo.deviceName:@""] OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                }
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
        if (_transferType != ToiCloudType) {
            //判断选择的分类中是否包含App
            NSArray *sourceAppArray = _sourceiPod.applicationManager.appEntityArray;
            NSArray *targetAppArray = _targetiPod.applicationManager.appEntityArray;
            NSMutableArray *downAppM = [[NSMutableArray alloc]init];
            for (IMBAppEntity *app in sourceAppArray) {
                int i = 0;
                for (IMBAppEntity *targetApp in targetAppArray) {
                    if ([targetApp.appKey isEqualToString:app.appKey]) {
                        i = 1;
                        break;
                    }
                }
                if (i == 0) {
                    [downAppM addObject:app];
                }
            }
            BOOL version = NO;
            if ([_targetiPod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"] || [_sourceiPod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"]) {
                version = YES;
            }
            NSArray *selectCategoryArray = [_arrayController selectedObjects];
            for (IMBCategoryInfoModel *model in selectCategoryArray) {
                if (model.categoryNodes == Category_Applications && downAppM.count > 0 && version) {
                    NSView *view = nil;
                    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                            view = subView;
                            break;
                        }
                    }
                    [view setHidden:NO];
                    NSString *str = nil;
                    if (downAppM.count <= 1) {
                        str = [NSString stringWithFormat:CustomLocalizedString(@"Above9AppToDeviceTipsSin", nil),_targetiPod.deviceInfo.deviceName,_targetiPod.deviceInfo.deviceName];
                    }else {
                        str = [NSString stringWithFormat:CustomLocalizedString(@"Above9AppToDeviceTipsDou", nil),_targetiPod.deviceInfo.deviceName,_targetiPod.deviceInfo.deviceName];
                    }
                    int i = [_mergeCloneAppVC showTitleString:str OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) TargetiPod:_targetiPod sourceiPod:_sourceiPod SuperView:view];
                    if (i == 0) {
                        return;
                    }
                    break;
                }
            }
        }

        //开始备份merge或者clone操作
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
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (_transferType == MergeType) {
            [ATTracker event:Merge_Device action:ToDevice actionParams:@"Merge Device" label:Start transferCount:0 screenView:@"Merge Device" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"MergeDevice_step_selectMergeContentTip", nil)]];
        }else if (_transferType == CloneType){
            [ATTracker event:Clone_Device action:ToDevice actionParams:@"Clone Device" label:Start transferCount:0 screenView:@"Clone Device" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"CloneDevice_step_selectContentTip", nil)]];
        }else if (_transferType == ToiCloudType) {
            for (IMBCategoryInfoModel *entity in [_arrayController selectedObjects]) {
                [ATTracker event:iCloud_Content action:iCloud_Sync actionParams:entity.categoryName label:LabelNone transferCount:0 screenView:@"iCloud Sync View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }
            [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"Clone_id_7", nil)]];
        }else {
            [ATTracker event:Content_To_Device action:ToDevice actionParams:@"Content" label:Start transferCount:0 screenView:@"Content To Device" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [self setSelectedNavStr:[NSString stringWithFormat:@"%@ >",CustomLocalizedString(@"Clone_id_7", nil)]];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        if (_transferType == ToiCloudType) {
            [_cloneAnimationView setBackupImage:nil sourceImage:[StringHelper imageNamed:@"iCloud_transfer"]targetImage:[StringHelper imageNamed:@"iCloud_transfer"]];
            [_cloneAnimationView setTransfertype:ToiCloudType];
            [_cloneAnimationView reLayerSize];

        }else{
            [_cloneAnimationView setBackupImage:[self getAnimationImage:_sourceiPod] sourceImage:[self getipodImage:_sourceiPod] targetImage:[self getipodImage:_targetiPod]];
        }
        
        if (_transferType != ToDeviceType && _transferType != ToiCloudType) {
            //模拟效果
            [_cloneAnimationView startPrepareBackupAnimation];
            if (_transferType == CloneType) {
                [_logManager writeInfoLog:[NSString stringWithFormat:@"Clone Start:source:%@ target:%@",_sourceiPod.uniqueKey,_targetiPod.uniqueKey]];
            }else if (_transferType == MergeType){
                 [_logManager writeInfoLog:[NSString stringWithFormat:@"Merge Start:source:%@ target:%@",_sourceiPod.uniqueKey,_targetiPod.uniqueKey]];
            }
            
        }else {
            [_cloneAnimationView startCloneDataAnimation];
        }
        
        if (_transferType == ToDeviceType) {
            _isTransferComplete = NO;
            NSString *str = [NSString stringWithFormat:@"%@",_targetiPod.deviceInfo.deviceName];
            [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToDevice_Message_Title", nil),str]];
        }else if (_transferType == MergeType) {
            [_closebutton setHidden:NO];
            [_closebutton setEnabled:NO];
            NSString *str = [NSString stringWithFormat:@"%@",_targetiPod.deviceInfo.deviceName];
            [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"MergeDevice_Message_Title", nil),str]];
        }else if (_transferType == CloneType) {
            [_closebutton setHidden:NO];
            [_closebutton setEnabled:NO];
            NSString *str = [NSString stringWithFormat:@"%@",_targetiPod.deviceInfo.deviceName];
            [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloneDevice_Message_Title", nil),str]];
        }else if (_transferType == ToiCloudType){
            _condition = [[NSCondition alloc] init];
            if (![IMBSoftWareInfo singleton].isRegistered) {
//                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
                _alertViewController.isIcloudOneOpen = YES;
                _alertViewController.delegate = self;
            }
            [_closebutton setHidden:NO];
            [_closebutton setEnabled:NO];
            NSString *str = [NSString stringWithFormat:@"%@",_targetDevicePopButton.title];
            [_transferTitleField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"ToDevice_Message_Title", nil),str]];
        }
        [_transferTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        //等待动画
        [_progressviewBar setLoadAnimation];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool {
                if (_transferType != ToDeviceType && _transferType != ToiCloudType) {
                    IMBCloneOrMergeManager *cloneOrmerge = [[IMBCloneOrMergeManager alloc] initWithiPod:_sourceiPod targetPod:_targetiPod categoryArray:(NSMutableArray *)[_arrayController selectedObjects] transferDelegate:self];
                    if (_transferType == CloneType) {
                        [cloneOrmerge clone];
                    }else if (_transferType == MergeType) {
                        [cloneOrmerge merge];
                    }
                    [cloneOrmerge release];
                }else if (_transferType == ToiCloudType){
                    //传输代码逻辑
                    //模拟效果
                    [self transferPrepareFileEnd];
                    [self transferProgress:0];

                    NSArray *selectedArray = [_arrayController selectedObjects];
                    
                    
                    //计算进度 contact和note是一次性传输 为1 calender和reminder是一个一个传输 为自身的个数
                    long totalCount = 0;
                    for (IMBCategoryInfoModel *model in selectedArray) {
                        switch (model.categoryNodes) {
                            case Category_Photo:
                                for (IMBToiCloudPhotoEntity *entity in _iCloudManager.albumArray) {
                                    if ([entity.iCloudAlbumType isEqualToString:@"CPLAssetAndMasterByAddedDate"]) {
                                        [_iCloudManager getPhotoDetail:entity];
                                        break;
                                    }
                                }
                                totalCount += [[_iCloudManager photoArray] count];
                                break;
                            case Category_Contacts:
                            {
                                if ([[_iCloudManager contactArray] count]>0) {
                                    totalCount += 1;
                                }
                            }
                                break;
                            case Category_Notes:
                                if ([[_iCloudManager noteArray] count]>0) {
                                    totalCount += 1;
                                }
                                break;
                            case Category_Calendar:
                                totalCount += [[_iCloudManager calendarArray] count];
                                
                                break;
                            case Category_Reminder:
                                totalCount += [[_iCloudManager reminderArray] count];

                                break;
                                
                            default:
                                break;
                        }
                    }
                    long currentCount = 0;
                    
                    IMBiCloudManager *targetManager = nil;
                    if (_selectedItem.iPodunique != nil) {
                        targetManager = [[_accountDic objectForKey:_selectedItem.iPodunique] iCloudManager];
                    }
                    if (targetManager != nil) {
                        for (IMBCategoryInfoModel *model in selectedArray) {
                            [_condition lock];
                            if (_isPause) {
                                [_condition wait];
                            }
                            [_condition unlock];
                            switch (model.categoryNodes) {
                                case Category_Photo:
                                {
                                    [self transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_9", nil)]];
//                                    [targetManager getPhotosContent];
                                    for (IMBToiCloudPhotoEntity *entity in [_iCloudManager photoArray]) {
                                        [_condition lock];
                                        if (_isPause) {
                                            [_condition wait];
                                        }
                                        [_condition unlock];
                                        NSData *data = [_iCloudManager getPhotoThumbnilDetail:entity.oriDownloadUrl];
                                        entity.photoImageData = data;
                                        [targetManager syncTransferPhoto:entity];
                                        currentCount += 1;
                                        [self transferProgress:currentCount/(totalCount * 1.0)*100];
                                    }

                                }
                                    break;
                                case Category_Contacts:
                                {
                                    [targetManager getContactContent];
                                    NSMutableArray *arrayM = [NSMutableArray array];
                                    for (IMBiCloudNoteModelEntity *entity in [_iCloudManager contactArray]) {
                                        IMBiCloudContactEntity *transEntity = [entity mutableCopy];
                                        CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                                        NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                                        [transEntity setContactId:guid];
                                        [transEntity setEtag:@""];
                                        [arrayM addObject:transEntity];
                                        [transEntity release];
                                    }
                                    [self transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_20", nil)]];
                                    [targetManager importContact:arrayM];
                                    currentCount += 1;
                                    [self transferProgress:currentCount/(totalCount * 1.0)*100];
                                }
                                    break;
                                case Category_Notes:
                                {
                                    [targetManager getNoteContent];
                                    NSMutableArray *noteStringArray = [NSMutableArray array];
                                    for (IMBiCloudNoteModelEntity *entity in [_iCloudManager noteArray]) {
                                        if (entity.content != nil) {
//                                            [noteStringArray addObject:entity.content];
                                            IMBUpdateNoteEntity *noteEntity = [[IMBUpdateNoteEntity alloc] init];
                                            noteEntity.noteContent = [entity.content stringByReplacingOccurrencesOfString:@"Ôøº" withString:@""];
                                            noteEntity.timeStamp = entity.modifyDate;
                                            [noteStringArray addObject:noteEntity];
                                            [noteEntity release];
                                        }
                                    }
                                    [self transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_17", nil)]];
                                    [targetManager addNoteData:noteStringArray];
                                    currentCount += 1;
                                    [self transferProgress:currentCount/(totalCount * 1.0)*100];
                                }
                                    break;
                                case Category_Calendar:
                                {
                                    [targetManager getCalendarContent];
                                    NSArray *calendarArray = [targetManager calendarCollectionArray];
                                    if ([calendarArray count]>0) {
                                        IMBiCloudCalendarCollectionEntity *collection = [calendarArray objectAtIndex:0];
                                        [self transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_22", nil)]];
                                        for (IMBiCloudCalendarEventEntity *entity in [_iCloudManager calendarArray]) {
                                            entity.pGuid = collection.guid;
                                            CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                                            NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                                            entity.guid = guid;
                                            [_condition lock];
                                            if (_isPause) {
                                                [_condition wait];
                                            }
                                            [_condition unlock];
                                            [targetManager addCalender:entity];
                                            currentCount += 1;
                                            [self transferProgress:currentCount/(totalCount * 1.0)*100];
                                        }
                                    }
                                }
                                    break;
                                case Category_Reminder:
                                {
                                    [targetManager getReminderContent];
                                    NSArray *reminderArray = [targetManager reminderCollectionArray];
                                    if ([reminderArray count]>0) {
                                        IMBiCloudCalendarCollectionEntity *collection = [reminderArray objectAtIndex:0];
                                        [self transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"Reminders_id", nil)]];
                                        for (ReminderAddModel *entity in [_iCloudManager reminderArray]) {
                                            [self transferFile:entity.summary];
                                            [_condition lock];
                                            if (_isPause) {
                                                [_condition wait];
                                            }
                                            [_condition unlock];
                                            [targetManager addReminder:entity withPguid:collection.guid];
                                            currentCount += 1;
                                            [self transferProgress:currentCount/(totalCount * 1.0)*100];
                                        }
                                    }
                                }
                                    break;
                                    
                                default:
                                    break;
                            }
                        }

                    }
                    sleep(1);
                    [self transferComplete:(int)currentCount TotalCount:(int)totalCount];
                }else {
                    _betweenTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedModels:[_arrayController selectedObjects] srcIpodKey:_sourceiPod.uniqueKey desIpodKey:_targetiPod.uniqueKey Delegate:self];
                    [_betweenTransfer startTransfer];
                }
            }
        });
    }else{
        if (_targetiPod.beingSynchronized) {
            [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
        [_categorySelectView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"push";
        transition.subtype = @"fromRight";
        [_contentBox.layer addAnimation:transition forKey:@"animation"];
        [_contentBox setContentView:_categorySelectView];
        if (!_targetiPod&&_transferType != ToiCloudType) {
            return;
        }
        if (_transferType != ToiCloudType) {
            [self filterCategorysByTarIpod:_targetiPod];
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
    [item setState:NSOnState];
    for (IMBiPodMenuItem *item1 in _targetDevicePopButton.menu.itemArray) {
        if (item1 != item) {
           [item1 setState:NSOffState];
        }
    }
}

- (IBAction)closeWindow:(id)sender {
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }

    if (!_isTransferComplete) {
        if (_isCategorySelect) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        }
        if (_betweenTransfer != nil) {
            [_betweenTransfer pauseScan];
        }
        [_alertViewController setIsStopPan:YES];
        int result = [self showAlertText:CustomLocalizedString(@"Main_Window_Stop_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
        [_alertViewController setIsStopPan:NO];
        if (result) {
            if (_betweenTransfer != nil) {
                [_closebutton setEnabled:NO];
                [_betweenTransfer stopScan];
                [_betweenTransfer resumeScan];
                [_transferTitleField setStringValue:CustomLocalizedString(@"ImportSync_id_5", nil)];
                [_transferTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            }
        }else {
            if (_betweenTransfer != nil) {
                [_betweenTransfer resumeScan];
            }
        }
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        [self animationRemoveToDeviceVeiw];
    }
}

- (void)animationRemoveToDeviceVeiw {
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
            if (_delegate && [_delegate respondsToSelector:@selector(setTrackingAreaEnable:)]) {
                [_delegate setTrackingAreaEnable:YES];
            }
        } completionHandler:^{
            [self.view removeFromSuperview];
            [self release];
        }];
    }];
    //to do 需要结束正在传输的进程
    [_cloneAnimationView stopAnimation];
}

- (IBAction)clickCheckBox:(id)sender {
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
    for (int i=0;i<[_arrayController.content count];i++) {
        IMBCategoryInfoModel *model = [_arrayController.content objectAtIndex:i];
        if (model.isSelected) {
            [set addIndex:i];
        }
    }
    [_connectionView setSelectionIndexes:set];

}

- (void)filterCategorysByTarIpod:(IMBiPod *)ipod{
    NSMutableArray *newArr = [NSMutableArray array];
    for (IMBCategoryInfoModel *model in _categoryArray) {
        if (![ipod.deviceInfo airSync]) {
            if (model.categoryNodes == Category_Contacts || model.categoryNodes == Category_Notes || model.categoryNodes == Category_Message || model.categoryNodes == Category_Bookmarks || model.categoryNodes == Category_Calendar) {
                continue;
            }
        }
        if ((_transferType == CloneType||_transferType == MergeType) && model.categoryNodes == Category_VoiceMemos && ipod.deviceInfo.isiPad) {
            continue;
        }
        if (_sourceiPod.deviceInfo.getDeviceVersionNumber<=ipod.deviceInfo.getDeviceVersionNumber) {
            if (((_transferType == CloneType||_transferType == MergeType)&&model.categoryNodes == Category_VoiceMemos)&&!([_sourceiPod.deviceInfo.getDeviceFloatVersionNumber isVersionMajor:ipod.deviceInfo.getDeviceFloatVersionNumber])) {
                continue;
            }
            
            if (((_transferType == CloneType||_transferType == MergeType)&&model.categoryNodes == Category_CameraRoll)||((_transferType == CloneType||_transferType == MergeType)&&model.categoryNodes == Category_Panoramas)) {
                continue;
            }
        }else
        {
            if ((_transferType == CloneType||_transferType == MergeType)&&model.categoryNodes == Category_Photos) {
                continue;
            }
        }
        if ((_transferType == CloneType||_transferType == MergeType)&&(model.categoryNodes == Category_CameraRoll || model.categoryNodes == Category_PhotoStream || model.categoryNodes == Category_PhotoLibrary || model.categoryNodes == Category_PhotoShare || model.categoryNodes == Category_PhotoVideo||model.categoryNodes==Category_Panoramas||model.categoryNodes == Category_ContinuousShooting||model.categoryNodes == Category_LivePhoto||model.categoryNodes == Category_Screenshot||model.categoryNodes == Category_PhotoSelfies||model.categoryNodes == Category_Location||model.categoryNodes == Category_Favorite)) {
            continue;
        }
        
        if (!ipod.deviceInfo.isSupportHomeVideo && model.categoryNodes == Category_HomeVideo) {
            continue;
        }
        
        if (!ipod.deviceInfo.isSupportiTunesU && model.categoryNodes == Category_iTunes_iTunesU) {
            continue;
        }
        if (!ipod.deviceInfo.isSupportAudioBook && model.categoryNodes == Category_iTunes_Audiobook) {
            continue;
        }
        if (!ipod.deviceInfo.isSupportiBook && (model.categoryNodes == Category_iBooks)) {
            continue;
        }
        
        if (!ipod.deviceInfo.isSupportMovie && (model.categoryNodes == Category_Movies)) {
            continue;
        }
        if (!ipod.deviceInfo.isSupportMV && (model.categoryNodes == MusicVideo)) {
            continue;
        }
        if (!ipod.deviceInfo.isSupportPhoto && (model.categoryNodes == Category_CameraRoll || model.categoryNodes == Category_PhotoStream || model.categoryNodes == Category_PhotoLibrary || model.categoryNodes == Category_PhotoShare || model.categoryNodes == Category_PhotoVideo||model.categoryNodes==Category_Panoramas||model.categoryNodes == Category_ContinuousShooting||model.categoryNodes == Category_LivePhoto||model.categoryNodes == Category_Screenshot||model.categoryNodes == Category_PhotoSelfies||model.categoryNodes == Category_Location||model.categoryNodes == Category_Favorite)) {
            continue;
        }
        if (!ipod.deviceInfo.isSupportPodcast && (model.categoryNodes == Category_PodCasts)) {
            continue;
        }
        if (!ipod.deviceInfo.isSupportRingtone && (model.categoryNodes == Category_Ringtone)) {
            continue;
        }
        if (!ipod.deviceInfo.isSupportTVShow && (model.categoryNodes == Category_TVShow)) {
            continue;
        }
        if (!(ipod.deviceInfo.isiPhone&&_sourceiPod.deviceInfo.isiPhone)&& (model.categoryNodes == Category_Voicemail)){
            continue;
        }
        if (!(ipod.deviceInfo.isiPhone&&_sourceiPod.deviceInfo.isiPhone)&&model.categoryNodes == Category_CallHistory) {
            continue;
        }
        if (!((_sourceiPod.deviceInfo.isiPad&&_targetiPod.deviceInfo.isiPad)||(!(_sourceiPod.deviceInfo.isiPad)&&!(_targetiPod.deviceInfo.isiPad)))&&model.categoryNodes == Category_Applications) {
            continue;
        }
        if ((_transferType == CloneType||_transferType == MergeType)&&model.categoryNodes == Category_Voicemail&&(_targetiPod.deviceInfo.isiPad||_sourceiPod.deviceInfo.isiPad) ) {
            continue;
        }
        
        [newArr addObject:model];
    }
    if (_categoryArray != nil) {
        [_categoryArray release];
        _categoryArray = nil;
    }
    _categoryArray = [newArr retain];
}
#pragma mark - NSTextViewDelegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    
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
        }else {
            NSURL *url = [NSURL URLWithString:CustomLocalizedString(@"url_guild_id_3", nil)];
            NSWorkspace *ws = [NSWorkspace sharedWorkspace];
            [ws openURL:url];
        }
    }
    if ([link isEqualToString: CustomLocalizedString(@"completeActivity_LinkTip", nil)]) {
        NSString *hoStr = nil;
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.gatherUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.gatherUrl;
        } else {
            hoStr = CustomLocalizedString(@"iCloudComplete_Url", nil);
        }
        hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:hoStr];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
        
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
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    return [_alertViewController showAlertText:alertText OKButton:OkText SuperView:view];
}
#pragma mark - TransferDelegate
//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([file isEqualToString:@"needDisClose"]) {
            return;
        }else if ([file isEqualToString:@"needEnClose"]){
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
                    [_fileNameField setFrame:NSMakeRect(NSMinX(_fileNameField.frame), NSMinY(_fileNameField.frame)+10, NSWidth(_fileNameField.frame), 30)];
                    [_fileNameField setFont:[NSFont fontWithName:@"Helvetica Neue" size:18]];
                    [_fileNameField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                }
            
            }
        }
    });
}
//传输准备进度结束
- (void)transferPrepareFileEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_transferType==MergeType||_transferType==CloneType) {
            [_closebutton setEnabled:NO];
        }
        [_progressviewBar removeAnimationImgView];
        [_progressviewBar startAnimation];
    });
}

//传输进度
- (void)transferProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
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
- (void)transferFile:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![TempHelper stringIsNilOrEmpty:file]) {
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:file];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
            [_fileNameField setAttributedStringValue:as];
            [as release], as = nil;
        }
    });
}

- (BOOL)transferOccurError:(NSString *)str
{
    BOOL tranferError = NO;
    [_alertViewController setIsStopPan:YES];
    if ([str isEqualToString:@"source-30"]) {
        if ([self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Clone_id_17", nil),_sourceiPod.deviceInfo.deviceName?_sourceiPod.deviceInfo.deviceName:@""] OKButton:CustomLocalizedString(@"Clone_id_23", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)] == 1) {
            tranferError = YES;
        }else{
            tranferError = NO;
        }
    }else if ([str isEqualToString:@"source-35"]){
        if ([self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"Clone_id_27", nil),_sourceiPod.deviceInfo.deviceName?_sourceiPod.deviceInfo.deviceName:@""] OKButton:CustomLocalizedString(@"Button_Ok", nil)] == 1) {
            tranferError = YES;
        }else{
            tranferError = NO;
        }
    }else if ([str isEqualToString:@"target-30"]) {
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

- (void)cloneOrMergeComplete:(BOOL)success
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        _isTransferComplete = YES;
        [_closebutton setEnabled:YES];
        
        [_cloneAnimationView stopAnimation];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"fade";
        [_contentBox.layer addAnimation:transition forKey:@"animation"];
        [_contentBox setContentView:_completeView];
        [self setSelectedNavStr:CustomLocalizedString(@"Clone_id_8", nil)];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (_transferType == MergeType ) {
            [ATTracker event:Merge_Device action:ToDevice actionParams:@"Merge Device" label:Finish transferCount:0 screenView:@"Merge Device" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [_completetitleFieFld setStringValue:CustomLocalizedString(@"Transfer_text_merge_complete", nil)];
            [_completeSubTitleField setStringValue:CustomLocalizedString(@"Transfer_text_mergeDescription_complete",nil )];
        }else if (_transferType == CloneType) {
            [ATTracker event:Clone_Device action:ToDevice actionParams:@"Clone Device" label:Finish transferCount:0 screenView:@"Clone Device" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [_completetitleFieFld setStringValue:CustomLocalizedString(@"Transfer_text_clone_complete", nil)];
            [_completeSubTitleField setStringValue:CustomLocalizedString(@"Transfer_text_cloneDescription_complete",nil )];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [_completetitleFieFld setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_completeSubTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    });
}

- (IBAction)transferMoreBtnDown:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
    [self animationRemoveToDeviceVeiw];
}
//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    _successCount = successCount;
    _totalCount = totalCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_annoyTimer != nil) {
            [_annoyTimer invalidate];
            _annoyTimer = nil;
        }
        if (_transferType == ToDeviceType || _transferType == ToiCloudType) {
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
            
            if (![IMBSoftWareInfo singleton].isRegistered && _isiCloudView && ![IMBSoftWareInfo singleton].isNOAdvertisement) {
                [self setSelectedNavStr:CustomLocalizedString(@"Clone_id_8", nil)];
                if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
                    [self configEniCloudCompleteView];
                    [_contentBox setContentView:_resultView];
                } else {
                    [self configMuiCloudCompleteView];
                    [_contentBox setContentView:_muicloudCompleteView];
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
            
            
            if (_transferType == ToDeviceType) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Content_To_Device action:ToDevice actionParams:@"Content" label:Finish transferCount:successCount screenView:@"Content To Device Type" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
            }
        }
    });
}

- (void)progressBarWait
{
    [_progressviewBar setLoadAnimation];
}

- (void)moveBellImageView:(int)moveX {
    if (_bellImgView != nil) {
        [_bellImgView setFrameOrigin:NSMakePoint(340 + moveX, _bellImgView.frame.origin.y)];
    }
}

#pragma mark - iCloud完成活动界面 - 英语版
- (void)configEniCloudCompleteView {
    //配置文字和图片
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if (_successCount > 1) {
        overStr = [NSString stringWithFormat:@"%d/%d",_successCount,_totalCount];
        overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_items", nil)];
        promptStr = [NSString stringWithFormat: CustomLocalizedString(@"icloudUSCompleteActivity_Tip", nil),overStr];
    } else if (_successCount == 1){
        overStr = [NSString stringWithFormat:@"%d/%d",_successCount,_totalCount];
        overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_item", nil)];
        promptStr = [NSString stringWithFormat: CustomLocalizedString(@"icloudUSCompleteActivity_Tip", nil),overStr];
        
    } else {
        promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
    }
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:26.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_resultTitle textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    //副标题
    [_resultSubTitle setStringValue:CustomLocalizedString(@"icloudUSCompleteActivity_Title", nil)];
    [_resultSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    
    [_imageViewOne setImage:[StringHelper imageNamed:@"icloud_icon1"]];
    [_imageViewTwo setImage:[StringHelper imageNamed:@"icloud_icon4"]];
    [_imageViewThree setImage:[StringHelper imageNamed:@"icloud_icon3"]];
    [_imageViewFour setImage:[StringHelper imageNamed:@"icloud_icon2"]];
    
    //四个子标题
    [self setSubTitle:_imageTitleOne WithTextString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer1", nil)];
    [self setSubTitle:_imageTitleTwo WithTextString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer2", nil)];
    [self setSubTitle:_imageTitleThree WithTextString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer3", nil)];
    [self setSubTitle:_imageTitleFour WithTextString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer4", nil)];
    
    
    //textview
    [self setTextViewAttribute:_imageSubTitleOne WithString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer1_description",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
    [self setTextViewAttribute:_imageSubTitleTwo WithString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer2_description",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
    [self setTextViewAttribute:_imageSubTitleThree WithString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer3_description",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
    [self setTextViewAttribute:_imageSubTitleFour WithString:CustomLocalizedString(@"icloudUSCompleteActivity_Transfer4_description",nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] WithAlignment:0 WithFontSize:12.0 WithIsClick:NO];
    [self setTextViewAttribute:_bottomTitle WithString:CustomLocalizedString(@"completeActivity_LinkTip", nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithAlignment:2 WithFontSize:14.0 WithIsClick:YES];
    [_bottomTitle setDelegate:self];
    [_bottomTitle setSelectable:YES];
    
    
    //按钮加载
    [self setLearnMoreButton:_buttonOne];
    [_buttonOne setAction:@selector(iCloudCompleteOneClick)];
    [self setLearnMoreButton:_buttonTwo];
    [_buttonTwo setAction:@selector(iCloudCompleteTwoClick)];
    [self setLearnMoreButton:_buttonThree];
    [_buttonThree setAction:@selector(iCloudCompleteThreeClick)];
    [self setLearnMoreButton:_buttonFour];
    [_buttonFour setAction:@selector(iCloudCompleteFourClick)];
    
    //分割线
    [_lineViewOne setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineViewTwo setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineViewThree setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineViewFour setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineViewFive setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
}
- (void)setSubTitle:(NSTextField *)subTitle WithTextString:(NSString *)textString {
    [subTitle setStringValue:textString];
    [subTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [subTitle setFont:[NSFont fontWithName:@"Helvetica Neue Medium" size:14.0]];
}
- (void)setLearnMoreButton:(IMBGridientButton *)button {
    [button setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_enter_Color", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_enter_Color", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_down_Color", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_down_Color", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [button setButtonBorder:YES withNormalBorderColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_border_normalColor", nil)] withEnterBorderColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_border_Color", nil)] withDownBorderColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_border_Color", nil)] withForbiddenBorderColor:[StringHelper getColorFromString:CustomColor(@"learnMoreBtn_border_normalColor", nil)] withBorderLineWidth:2.0];
    
    [button setButtonTitle:CustomLocalizedString(@"DownLoad_LearnMore", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [button setHasRightImage:YES];
    [button setRightImage:[StringHelper imageNamed:@"media_arrow"]];
    [button setTarget:self];
    [button setEnabled:YES];
}
- (void)setTextViewAttribute:(NSTextView *)textView WithString:(NSString *)promptStr WithTextColor:(NSColor *)textColor WithAlignment:(NSUInteger)alignment WithFontSize:(int)fontSize WithIsClick:(BOOL)isClick {
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:fontSize] withColor:textColor];
    if (isClick) {
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]};
        [textView setLinkTextAttributes:linkAttributes];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
        NSRange infoRange = [promptStr rangeOfString:promptStr];
        [promptAs addAttribute:NSLinkAttributeName value:promptStr range:infoRange];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:alignment];
    [mutParaStyle setLineSpacing:3.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [textView setSelectable:NO];
    [[textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
}

#pragma mark - iCloud完成活动界面 - 其它语言版
- (void)configMuiCloudCompleteView {
    
    //配置文字和图片
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Transfer_text_complete_ActivityTitles", nil),overStr];
            overStr = [overStr stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
        } else if (_successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Transfer_text_complete_ActivityTitle", nil),overStr];
            overStr = [overStr stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
    } else {
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Transfer_text_complete_ActivityTitles", nil),overStr];
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
        } else if (_successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Transfer_text_complete_ActivityTitle", nil),overStr];
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
    }
    
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_muicloudCompleteMainTitle textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    [_muicloudCompleteSubTitle setStringValue:CustomLocalizedString(@"Transfer_text_complete_ActivitySubTitle",nil)];
    [_muicloudCompleteMiddleTitle setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_Tips", nil)];
    
    [_muicloudCompleteLable1 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_1", nil)];
    [_muicloudCompleteLable2 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_2", nil)];
    [_muicloudCompleteLable3 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_3", nil)];
    [_muicloudCompleteLable4 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_4", nil)];
    [_muicloudCompleteLable5 setStringValue:CustomLocalizedString(@"TransferComplete_iCloudActivity_5", nil)];
    [_muicloudCompleteBtnView1 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon1"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon1"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon1"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon1"]];
    [_muicloudCompleteBtnView1 setTarget:self];
    [_muicloudCompleteBtnView1 setIsEnble:YES];
    [_muicloudCompleteBtnView1 setAction:@selector(iCloudCompleteOneClick)];
    
    [_muicloudCompleteBtnView2 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon2"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon2"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon2"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon2"]];
    [_muicloudCompleteBtnView2 setTarget:self];
    [_muicloudCompleteBtnView2 setIsEnble:YES];
    [_muicloudCompleteBtnView2 setAction:@selector(iCloudCompleteTwoClick)];
    
    [_muicloudCompleteBtnView3 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon3"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon3"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon3"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon3"]];
    [_muicloudCompleteBtnView3 setTarget:self];
    [_muicloudCompleteBtnView3 setIsEnble:YES];
    [_muicloudCompleteBtnView3 setAction:@selector(iCloudCompleteThreeClick)];
    
    [_muicloudCompleteBtnView4 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon4"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon4"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon4"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon4"]];
    [_muicloudCompleteBtnView4 setTarget:self];
    [_muicloudCompleteBtnView4 setIsEnble:YES];
    [_muicloudCompleteBtnView4 setAction:@selector(iCloudCompleteFourClick)];
    
    [_muicloudCompleteBtnView5 mouseDownImage:[StringHelper imageNamed:@"mu_icloud_icon5"] withMouseUpImg:[StringHelper imageNamed:@"mu_icloud_icon5"] withMouseExitedImg:[StringHelper imageNamed:@"mu_icloud_icon5"] mouseEnterImg:[StringHelper imageNamed:@"mu_icloud_icon5"]];
    [_muicloudCompleteBtnView5 setTarget:self];
    [_muicloudCompleteBtnView5 setIsEnble:YES];
    [_muicloudCompleteBtnView5 setAction:@selector(iCloudCompleteFiveClick)];
    
    //配置颜色
    [_muicloudCompleteSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    [_muicloudCompleteMiddleTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable1 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable2 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable3 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable4 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteLable5 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_muicloudCompleteDetailView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_muicloudCompleteDetailView setIsHaveCorner:NO];
    
    //配置按钮
    [_muicloudCompleteButton setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_enter_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"completeButton_enter_rightColor", nil)]];
    [_muicloudCompleteButton setButtonTitle:CustomLocalizedString(@"TransferComplete_iCloudActivity_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:18.0 WithLightAnimation:NO];
    [_muicloudCompleteButton setHasRightImage:YES];
    [_muicloudCompleteButton setRightImage:[StringHelper imageNamed:@"media_btnarrow"]];
    [_muicloudCompleteButton setHasBorder:NO];
    [_muicloudCompleteButton setIsiCloudCompleteBtn:YES];
    [_muicloudCompleteButton setTarget:self];
    [_muicloudCompleteButton setAction:@selector(iCloudCompleteButtonClick)];
    [_muicloudCompleteButton setNeedsDisplay:YES];
    
}

#pragma mark - iCloud传输完成界面 按钮点击方法
- (void)iCloudCompleteButtonClick {
    NSString *hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteOneClick {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.moveVideoUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.moveVideoUrl;
        } else {
            hoStr = CustomLocalizedString(@"iCloudComplete_moveVideoUrl", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteTwoClick {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.convertVideoUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.convertVideoUrl;
        } else {
            hoStr = CustomLocalizedString(@"iCloudComplete_convertVideoUrl", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteThreeClick {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.migrateMediaUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.migrateMediaUrl;
        }else {
            hoStr = CustomLocalizedString(@"iCloudComplete_migrateMediaUrl", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteFourClick {
    NSString *hoStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        if (![StringHelper stringIsNilOrEmpty:[IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.transferUrl]) {
            hoStr = [IMBSoftWareInfo singleton].activityInfo.icloudUrlInfo.transferUrl;
        } else {
            hoStr = CustomLocalizedString(@"iCloudComplete_transferUrl", nil);
        }
    } else {
        hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    }
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)iCloudCompleteFiveClick {
    NSString *hoStr = CustomLocalizedString(@"TransferComplete_iCloudActivity_Url", nil);
    hoStr = [hoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)dealloc
{
    [_alertViewController release],_alertViewController = nil;
    [_androidAlertViewController release],_androidAlertViewController = nil;
    [_betweenTransfer release],_betweenTransfer = nil;
    [_closebutton release],_closebutton = nil;
    [_restoreiPodKey release],_restoreiPodKey = nil;
    [_sourceiPod release],_sourceiPod = nil;
    [_categoryArray release],_categoryArray = nil;
    [_bindcategoryArray release],_bindcategoryArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_INFORMATIONDATA_LOADFINISH object:nil];
    [super dealloc];
}

@end

@implementation IMBToMacCollectionViewItem

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    IMBBlankDraggableCollectionView *blankCollectionView = (IMBBlankDraggableCollectionView *)[self.view superview];
    NSArray *allArray = [blankCollectionView content];
    NSView *itemView = self.view;
    [(IMBToMacCollectionItemView *)itemView setIsSelected:selected];
    for (NSView *subview in [itemView subviews]) {
        if ([subview isKindOfClass:[IMBToMacSelectionVeiw class]]) {
            [((IMBToMacSelectionVeiw *)subview) setIsClicked:selected];
            for (NSView *selView in subview.subviews) {
                if ([selView isKindOfClass:[NSTextField class]]) {
                    NSTextField *field = (NSTextField *)selView;
                    for (IMBCategoryInfoModel *model in allArray) {
                        if ([field.stringValue isEqualToString:model.categoryName]) {
                            model.isSelected = selected;
                            break;
                        }
                    }
                }
            }
        }
    }
}
@end

@implementation IMBToMacCollectionItemView
@synthesize done = _done;
@synthesize isSelected = _isSelected;

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyDone:) name:@"notify_done" object:nil];

}

- (void)mouseDown:(NSEvent *)theEvent
{
    IMBToMacSelectionVeiw *selectView = nil;
    for (NSView *subview in [self subviews]) {
        if ([subview isKindOfClass:[IMBToMacSelectionVeiw class]]) {
            selectView = (IMBToMacSelectionVeiw *)subview;
        }
    }
    NSPoint mouseselectionPt = [selectView convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL viewInner = NSMouseInRect(mouseselectionPt, [selectView bounds], [self isFlipped]);
    if (viewInner) {
        _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
        NSPoint initialLocation = [theEvent locationInWindow];
        NSPoint location = [_blankDraggableView convertPoint:initialLocation fromView:nil];
        NSInteger index = [_blankDraggableView _indexAtPoint:location];
        NSArray *views = [_blankDraggableView subviews];
        
        NSMutableIndexSet *sets = [[NSMutableIndexSet alloc] init];
        for (int i = 0;i < views.count; i++) {
            IMBToMacCollectionItemView *collectionView = [views objectAtIndex:i];
            if (i == index) {
                if (collectionView.isSelected) {
                    collectionView.isSelected = NO;
                }else {
                    collectionView.isSelected = YES;
                }
            }
            if (collectionView.isSelected) {
                [sets addIndex:i];
            }
        }
        [_blankDraggableView setSelectionIndexes:sets];
        [sets release];
    }
    else{
        _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
//        [_blankDraggableView setSelectionIndexes:[NSIndexSet indexSetWithIndex:-1]];
        [_blankDraggableView setSelectionIndexes:nil];
        NSArray *views = [_blankDraggableView subviews];
        for (int i = 0;i < views.count; i++) {
            IMBToMacCollectionItemView *collectionView = [views objectAtIndex:i];
            [collectionView setIsSelected:NO];
        }
        NSPoint initialLocation = [theEvent locationInWindow];
        _done = NO;
        NSUInteger eventMask = (NSLeftMouseUpMask | NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSPeriodicMask);
        NSEvent *lastEvent = theEvent;
        while (!_done) {
            lastEvent = [NSApp nextEventMatchingMask:eventMask untilDate:[NSDate date] inMode:NSEventTrackingRunLoopMode dequeue:YES];
            NSEventType eventType = [lastEvent type];
            NSPoint mouseLocationWin = [lastEvent locationInWindow];
            switch (eventType)
            {
                case NSLeftMouseDown:
                    break;
                case NSLeftMouseDragged:
                    if (fabs(mouseLocationWin.x - initialLocation.x) >= 2
                        || fabs(mouseLocationWin.y - initialLocation.y) >= 2)
                    {
                        [super mouseDown:theEvent];
                    }
                    break;
                case NSLeftMouseUp:
                    _done = YES;
                    break;
                default:
                    _done = NO;
                    break;
            }
        }
    }
    int i = [[_blankDraggableView selectionIndexes] count];
}

- (void)notifyDone:(NSNotification *)notification{
    NSNumber *number = [notification object];
    BOOL isDone = [number boolValue];
    [self setDone:isDone];
}

- (void)mouseUp:(NSEvent *)theEvent{
    [super mouseUp:theEvent];
    _done = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notify_done" object:nil];
    [super dealloc];
}
@end
