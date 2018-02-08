//
//  IMBiCloudBackUpViewController.m
//  AnyTrans
//
//  Created by long on 16-7-29.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBiCloudBackUpViewController.h"
#import "IMBiCloudBackupBindingEntity.h"
#import "IMBiCloudClient.h"
#import "iCloudClientManager.h"
#import "IMBLogManager.h"
#import "Device.h"
#import "SnapshotEx.h"
#import "DateHelper.h"
#import "IMBImageAndTextCell.h"
#import "IMBiCloudTableCell.h"
#import "IMBNotificationDefine.h"
#import "TempHelper.h"
#import "SimpleNode.h"
#import "IMBiCloudViewController.h"
#import "IMBBackupAllDataViewController.h"
#import "IMBCustomHeaderCell.h"
#import "IMBiCloudDataModle.h"
#import <ServiceManager/ServiceManager.h>
#import "IMBiCloudMainPageViewController.h"
#define icloudDownloadView @"downloadView"
#define downloadManagerPlist @"downloadManager.plist"
#define downLoadMaxNumber 5
@interface IMBiCloudBackUpViewController ()

@end

@implementation IMBiCloudBackUpViewController
@synthesize itemIcloudTableView = _itemIcloudTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (id)initWithClient:(IMBiCloudClient *)icloudClient withDownloadComplete:(BOOL)isComplete withDelegate:(id)delegate withIpod:(IMBiPod *)ipod with:(NSString*)nibName withappleId:(IMBiCloudNetLoginInfo *)loginInfo{
    if ([self initWithNibName:nibName bundle:nil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkFaultInterrupt) name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
        if (icloudClient != nil) {
            _iCloudClient = [icloudClient retain];
        }
        _icloudLogInfo = [loginInfo retain];
        _ipod = [ipod retain];
        _isComplete = isComplete;
        _delegate = delegate;
        fm = [NSFileManager defaultManager];
        nc = [NSNotificationCenter defaultCenter];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self loadingData];
        });
    }
    return self;
}

- (void)dealloc {
    
//    [nc removeObserver:self name:NOTIFY_ICLOUD_DOWNLOAD_START object:nil];
    [nc removeObserver:self name:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:nil];
    [nc removeObserver:self name:NOTIFY_ICLOUD_DOWNLOAD_PROGRESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    //    if (_iOS9iCloudClient != nil) {
    //        [_iOS9iCloudClient release];
    //        _iOS9iCloudClient = nil;
    //    }
    if (_ipod != nil) {
        [_ipod release];
        _ipod = nil;
    }
    if (_iCloudClient != nil) {
        [_iCloudClient release];
        _iCloudClient = nil;
    }
    
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_downLoadQueue != nil) {
        [_downLoadQueue release];
        _downLoadQueue = nil;
    }
    if (_downloadAtrribute != nil) {
        [_downloadAtrribute release];
        _downloadAtrribute = nil;
    }
    if (_processingQueue != nil) {
        [_processingQueue release];
        _processingQueue = nil;
    }
    
    if (_icloudLogInfo != nil) {
        [_icloudLogInfo release];
        _icloudLogInfo = nil;
    }
    if (bindingSource != nil) {
        [bindingSource release];
        bindingSource = nil;
    }

    [super dealloc];
}

- (void)doChangeLanguage:(NSNotification *)notification{
    [super doChangeLanguage:notification];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_toolBar changeBtnTooltipStr];
        if (_dataSourceArray.count > 1) {
            [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"iCloudBackup_View_Tips8_Complex", nil),(int)_dataSourceArray.count]];
        }else {
            [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"iCloudBackup_View_Tips8", nil),(int)_dataSourceArray.count]];
        }
        [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor",nil)]];
        
        NSString *promptStr = @"";
        promptStr = CustomLocalizedString(@"MenuItem_id_69", nil);
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
        [_textView setLinkTextAttributes:linkAttributes];
        [_textView setSelectable:NO];
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:5.0];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_textView textStorage] setAttributedString:promptAs];
        [mutParaStyle release];
        mutParaStyle = nil;
        [_titleStr setFrame:NSMakeRect([_delegate popUpButton].frame.origin.x + [_delegate popUpButton].frame.size.width +10, _titleStr.frame.origin.y, _titleStr.frame.size.width, _titleStr.frame.size.height)];

    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_noDataView setIsGradientColorNOCornerPart3:YES];
    [_itemIcloudTableView setBackgroundColor:[NSColor clearColor]];
    [self configNoDataView];
    [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor",nil)]];
    NSArray *array = [_itemIcloudTableView tableColumns];
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            if ([column.identifier isEqualToString:@"headCell"] || [column.identifier isEqualToString:@"Btn"]) {
                [columnHeadercell setStringValue:@""];
            }
        }
    }
    [_loadingAnimationView setNeedsDisplay:YES];
    [self configNoDataView];
    [_itemIcloudTableView reloadData];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
}

- (void)addobserverNotification{
    //登陆
    [nc addObserver:self selector:@selector(downloadiCloudProgress:) name:NOTIFY_ICLOUD_DOWNLOAD_PROGRESS object:nil];
    [nc addObserver:self selector:@selector(downloadiCloudFailed:) name:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:nil];

}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_toolBar loadButtons:[NSArray arrayWithObjects:@(0),@(2),@(7),@(14),@(13), nil] Target:self DisplayMode:NO];
    [(IMBiCloudMainPageViewController*)_delegate setIsFail:NO];
    [self addobserverNotification];
    [_noDataView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setIsMove:YES];
    bindingSource = [[NSMutableArray alloc] init];
    [_iCloudBox setContentView:_loadingView];
    [_toolBar addSubview:[_delegate popUpButton]];
    [_titleStr setFrame:NSMakeRect([_delegate popUpButton].frame.origin.x + [_delegate popUpButton].frame.size.width +10, _titleStr.frame.origin.y, _titleStr.frame.size.width, _titleStr.frame.size.height)];
    [_loadingAnimationView startAnimation];
    [_toolBar toolBarButtonIsEnabled:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadIcloudBackup];
    });
}

- (void)loadingData {
    if (bindingSource != nil) {
        [bindingSource removeAllObjects];
    }
    _downLoadQueue = [[IMBQueue alloc] initWithQueueNumber:downLoadMaxNumber withDelegate:self];
    BOOL result = [_downLoadQueue loginAuth:_icloudLogInfo.appleID withPassword:_icloudLogInfo.password];
    if (result) {
        [self loginNotification:[NSString stringWithFormat:@"%d", result]];
        IMBiCloudDataModle *iCloudDataModle = [IMBiCloudDataModle singleton];
        [iCloudDataModle.allIcloudDataAry removeAllObjects];
        [[IMBLogManager singleton] writeInfoLog:@"start icloud read information"];
        NSString *appTempPath;
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *homeDocumentsPath = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
        appTempPath =[[[homeDocumentsPath  stringByAppendingPathComponent:@"com.imobie.AnyTrans"] stringByAppendingPathComponent:@"AnyTrans"] stringByAppendingPathComponent:@"iCloud"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:appTempPath]) {
            [fileManager createDirectoryAtPath:appTempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [_downLoadQueue iCloudClient9].outputFolder = appTempPath;
        NSMutableDictionary *deviceSnapshotDict = nil;
        @try {
            deviceSnapshotDict = [[_downLoadQueue iCloudClient9] queryBackupInfo];
        }
        @catch (NSException *exception) {
        }
        _downLoadQueue.deviceSnapshotDict = deviceSnapshotDict;
        if (deviceSnapshotDict != nil && deviceSnapshotDict.count > 0) {
            NSEnumerator *iter = [deviceSnapshotDict keyEnumerator];
            Device *dev = nil;
            while (dev = [iter nextObject]) {
                NSArray *snapshots = [deviceSnapshotDict objectForKey:dev];
                for (int i = 0; i < snapshots.count; i++) {
                    @autoreleasepool {
                        if (_isStop) {
                            return;
                        }
                        SnapshotEx *snapshot = [snapshots objectAtIndex:i];
                        NSString *deviceType = [dev deviceClass];
                        NSString *deviceName = [snapshot deviceName];
                        int64_t backupSize = [snapshot quotaUsed];
                        NSString *serialNumber = [dev serialNumber];
                        NSString *iOSVersion = [snapshot deviceIOSVersion];
                        
                      
                        NSString *uuid = [dev uuid];
                        NSString *backUpPath = [snapshot relativePath];
                        CFTimeInterval timestamp;
                        @autoreleasepool {
                            NSMutableDictionary *snapshotTimestamp = [[[NSMutableDictionary alloc] init] autorelease];
                            NSMutableArray *snapshotIDs = [dev getSnapshots];
                            NSEnumerator *iterator = [snapshotIDs objectEnumerator];
                            SnapshotID *snapshotID = nil;
                            while (snapshotID = [iterator nextObject]) {
                                [snapshotTimestamp setObject:@([snapshotID timestamp]) forKey:[snapshotID iD]];
                            }
                            
                            timestamp = [snapshotTimestamp.allKeys containsObject:[snapshot name]] ? [[snapshotTimestamp objectForKey:[snapshot name]] doubleValue] : [snapshot modification];
                        }
                        [[_downLoadQueue dataDic] setObject:dev forKey:backUpPath];
                        
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"downDataSuccess", @"MsgType",deviceType, @"deviceType",deviceName,@"deviceName",[NSNumber numberWithLongLong:backupSize],@"backupSize",serialNumber,@"serialNumber",iOSVersion,@"iOSVersion",[NSNumber numberWithLongLong:timestamp],@"lastModified",[NSNumber numberWithInt:i],@"count",uuid,@"uuid",backUpPath,@"relativePath", nil];
                        [iCloudDataModle.allIcloudDataAry addObject:dic];
                    }
                }
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadICloudDataComple];
//            });
        }
        [[IMBLogManager singleton] writeInfoLog:@"end icloud read information"];
    }
}

- (void)loadToolbar{
   [_toolBar addSubview:[_delegate popUpButton]];
    [_titleStr setFrame:NSMakeRect([_delegate popUpButton].frame.origin.x + [_delegate popUpButton].frame.size.width +10, _titleStr.frame.origin.y, _titleStr.frame.size.width, _titleStr.frame.size.height)];
}
//刷新
- (void)roladData{
//    [_noDataBoxView setContentView:_loadingView];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setIsMove:YES];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadIcloudBackup];
    });
}
/****************加载备份数据****************/
- (void)loadIcloudTableViewData{
    _downLoadQueue.iCloudClient = _iCloudClient;
    NSString *iCloudDownloadPath = [TempHelper getiCloudLocalPath];
    NSString *userID = _iCloudClient.loginInfo.appleID;
    NSString *userFilePath = [iCloudDownloadPath stringByAppendingPathComponent:userID];
    _downLoadQueue.outputPath = userFilePath;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_isComplete) {
            [self getDownloadCompleteData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_dataSourceArray.count > 0) {
                    [_iCloudBox setContentView:_icloudView];
//                    [_noDataBoxView setContentView:nil];
                    [_itemIcloudTableView reloadData];
                }else {
                    [_iCloudBox setContentView:_noDataView];
                }
                [self configNoDataView];
                [_itemIcloudTableView reloadData];
            });
        }
    });
    
    NSArray *array = [_itemIcloudTableView tableColumns];
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            if ([column.identifier isEqualToString:@"headCell"] || [column.identifier isEqualToString:@"Btn"]) {
                [columnHeadercell setStringValue:@""];
            }
        }
    }
    
    [_itemIcloudTableView setBackgroundColor:[NSColor clearColor]];
    [_titleStr setAlignment:NSLeftTextAlignment];
}

/****************icloud 登陆****************/
- (void)loadIcloudBackup{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:Login actionParams:@"iCloud Backup Login" label:LabelNone transferCount:0 screenView:@"iCloud Backup Login" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (void)loginNotification:(NSString *)islogin{
    if (_iCloudClient!= nil) {
        [_iCloudClient release];
        _iCloudClient = nil;
    }
    _iCloudClient = [[IMBiCloudClient alloc] init];
    BOOL ret = [_iCloudClient iCloudLoginWithAppleID:[_icloudLogInfo appleID] withPassword:[_icloudLogInfo password]];
//    NSString *islogin = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        _processingQueue = [[NSOperationQueue alloc] init];
        [_processingQueue setMaxConcurrentOperationCount:20];
        [_itemIcloudTableView setDelegate:self];
        [_itemIcloudTableView setDataSource:self];
        [_itemIcloudTableView setMouseDelegate:self];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (ret || [islogin isEqualToString:@"1"]) {
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup Login Successfully" label:Click transferCount:0 screenView:@"iCloud Backup Login Successfully" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [self loadIcloudTableViewData];
        }else{
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup Login Failed" label:Click transferCount:0 screenView:@"iCloud Backup Login Failed" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [self performSelectorOnMainThread:@selector(netWorkFail) withObject:nil waitUntilDone:NO];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    });
}


/************************登陆错误处理**********************/
//登陆失败
- (void)loginFail
{
    _isError = YES;
    [(IMBiCloudMainPageViewController*)_delegate setIsFail:YES];
    [self showAlertText:CustomLocalizedString(@"iCloud_id_4", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}
//网络失败
- (void)loadicloudnetWorkFail{
    [self performSelectorOnMainThread:@selector(netWorkFail) withObject:nil waitUntilDone:NO];
}

-(void)netWorkFail{
    _isError = YES;
    [_delegate setIsFail:YES];
    [self showAlertText:CustomLocalizedString(@"Clone_id_9", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)netWorkFaultInterrupt {
    dispatch_async(dispatch_get_main_queue(), ^{
        _isError = YES;
        [_delegate setIsFail:YES];
        [self showAlertText:CustomLocalizedString(@"iCloudLogin_View_Tips2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    });
}

- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText
{
    if (_alertViewController == nil) {
        return 0;
    }
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

-(void)secireOkBtnOperation:(id)sender with:(NSString *)pass{
    
}

- (void)doOkBtnOperation:(id)sender {
    if (_isError) {
        [self doBack:nil];
        _isError = NO;
    }
    
    [(IMBiCloudMainPageViewController*)_delegate setIsFail:YES];
}

//- (void)sendMesToclient{
//    [self performSelectorOnMainThread:@selector(sendMesFail) withObject:nil waitUntilDone:NO];
//}
//-(void)sendMesFail{
//    _isError = YES;
//    [(IMBiCloudMainPageViewController*)_delegate setIsFail:YES];
//    [self showAlertText:CustomLocalizedString(@"Clone_id_9", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//}
//二次验证处理
- (void)isTwoStepAuth{
    _isError = YES;
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

-(void)updateUI{
    [(IMBiCloudMainPageViewController*)_delegate setIsFail:YES];
    _alertViewController.isTwoICloud = YES;
    [self showAlertText:CustomLocalizedString(@"iCloud_DoubleCheck_Error", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iCloudbackup"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"iCloudBackup_View_Title", nil)];
    //    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", CustomLocalizedString(@"",nil)];
    //    promptStr = CustomLocalizedString(@"MenuItem_id_69", nil);//
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    [_textView setSelectable:NO];
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}
- (void)loadICloudDataComple{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [self getloadData];
    NSLog(@"loadICloudDataComple");
    NSString *iCloudDownloadPath = [TempHelper getiCloudLocalPath];
    NSString *userFilePath = [iCloudDownloadPath stringByAppendingPathComponent:[_icloudLogInfo appleID]];
    IMBiCloudDataModle *iCloudDataModle = [IMBiCloudDataModle singleton];
    NSMutableDictionary *dic1 = nil;
    NSString *userDownloadPlistFilePath1 = [iCloudDownloadPath stringByAppendingPathComponent:downloadManagerPlist];
    
    if ([fm fileExistsAtPath:userDownloadPlistFilePath1]) {
        dic1 = [[NSMutableDictionary alloc] initWithContentsOfFile:userDownloadPlistFilePath1];
    }
    if (dic1 != nil) {
        if (_downloadAtrribute != nil) {
            [_downloadAtrribute release];
            _downloadAtrribute = nil;
        }
        _downloadAtrribute = [dic1 retain];
    } else {
        if (_downloadAtrribute != nil) {
            [_downloadAtrribute release];
            _downloadAtrribute = nil;
        }
        _downloadAtrribute = [[NSMutableDictionary alloc] init];
    }
    for (NSDictionary *dic in iCloudDataModle.allIcloudDataAry) {
        //        NSDictionary *dic = notification.object;
        IMBiCloudBackupBindingEntity *icloudBinding = [[IMBiCloudBackupBindingEntity alloc] init];
        IMBiCloudBackup *icloudBackup = [[IMBiCloudBackup alloc]init];
        icloudBackup.deviceName = [dic objectForKey:@"deviceName"];
        icloudBackup.lastModified = [[dic objectForKey:@"lastModified"] longLongValue];
        icloudBackup.serialNumber = [dic objectForKey:@"serialNumber"];
        icloudBackup.backupSize = [[dic objectForKey:@"backupSize"] longLongValue];
        icloudBackup.iOSVersion = [dic objectForKey:@"iOSVersion"];
        if ([icloudBackup.iOSVersion isVersionMajorEqual:@"10"]&&[icloudBackup.iOSVersion isVersionLess:@"11"]) {
            icloudBackup.iosProductTye = [icloudBackup.iOSVersion stringByReplacingOccurrencesOfString:@"10" withString:@"9.4"];
        }else if ([icloudBackup.iOSVersion isVersionMajorEqual:@"11"]){
            icloudBackup.iosProductTye = [icloudBackup.iOSVersion stringByReplacingOccurrencesOfString:@"11" withString:@"9.5"];
        }else{
            icloudBackup.iosProductTye = icloudBackup.iOSVersion;
        }
        icloudBackup.deviceType = [dic objectForKey:@"deviceType"];
        icloudBackup.downCount = [[dic objectForKey:@"count"] intValue];
        icloudBackup.uuid = [dic objectForKey:@"uuid"];
        icloudBackup.iCloudAccount = [_icloudLogInfo appleID];
        icloudBackup.relativePath = [dic objectForKey:@"relativePath"];
        icloudBackup.downloadFolderPath = [userFilePath stringByAppendingPathComponent:icloudBackup.relativePath];
        [icloudBinding setLoadType:iCloudDataDownLoad];
        if (dic1 != nil) {
            NSDictionary *dataDic = [dic1 objectForKey:icloudBackup.downloadFolderPath];
            [icloudBinding setLoadType:[[dataDic valueForKey:@"loadState"] intValue]];
        }
      
        icloudBinding.userPtath = userFilePath;
        [icloudBinding setBackupItem:icloudBackup];
        [icloudBackup release];
        
        [icloudBinding setDelegate:self];
        [bindingSource addObject:icloudBinding];
        [icloudBinding release];
        icloudBinding = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        _dataSourceArray = [bindingSource retain];
        [_loadingAnimationView endAnimation];
        [_toolBar toolBarButtonIsEnabled:YES];
        if (_dataSourceArray.count > 1) {
            [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"iCloudBackup_View_Tips8_Complex", nil),(int)_dataSourceArray.count]];
        }else {
            [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"iCloudBackup_View_Tips8", nil),(int)_dataSourceArray.count]];
        }
        [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor",nil)]];
        [_delegate loadicloudCount:(int)_dataSourceArray.count];
        if (_dataSourceArray.count > 0) {
            [_iCloudBox setContentView:_icloudView];
            [_itemIcloudTableView reloadData];
        }else {
            [_iCloudBox setContentView:_noDataView];
        }
        [self configNoDataView];
        NSLog(@"loadICloudDataComple end");
        [_itemIcloudTableView reloadData];
    });
}
- (void)loadICloudData:(NSNotification *)notification{
//    NSDictionary *dic1 = notification.object;
//    NSString *iCloudDownloadPath = [TempHelper getiCloudLocalPath];
//    NSString *userFilePath = [iCloudDownloadPath stringByAppendingPathComponent:_appleId];
//
//    IMBiCloudBackupBindingEntity *icloudBinding = [[IMBiCloudBackupBindingEntity alloc] init];
//    IMBiCloudBackup *icloudBackup = [[IMBiCloudBackup alloc]init];
//    icloudBackup.deviceName = [dic1 objectForKey:@"deviceName"];
//    icloudBackup.lastModified = [[dic1 objectForKey:@"lastModified"] longLongValue];
//    icloudBackup.serialNumber = [dic1 objectForKey:@"serialNumber"];
//    icloudBackup.backupSize = [[dic1 objectForKey:@"backupSize"] longLongValue];
//    icloudBackup.iOSVersion = [dic1 objectForKey:@"iOSVersion"];
//    icloudBackup.deviceType = [dic1 objectForKey:@"deviceType"];
//    icloudBackup.uuid = [dic1 objectForKey:@"uuid"];
//
//    NSString *fileName = [icloudBackup.uuid stringByAppendingPathComponent:[DateHelper dateFrom1970ToString:(long)(icloudBackup.lastModified) withMode:5]];
//    [icloudBackup setDownloadFolderPath:[userFilePath stringByAppendingPathComponent:fileName]];
//    //    icloudBackup.lastTime = backup.backupTime;
////    icloudBackup.deviceBackup = backup;
//
//    //    [icloudBackup setDownloadFolderPath:[userFilePath stringByAppendingPathComponent:fileName]];
////    NSDictionary *fileDic = [dic valueForKey:fileName];
////    if (fileDic){
////        [icloudBinding setLoadType:[[fileDic valueForKey:@"loadState"] intValue]];
////        icloudBinding.progressView.totalSize = [[fileDic valueForKey:@"totalSize"] longValue];
////        icloudBinding.progressView.downloadedTotalSize = [[fileDic valueForKey:@"downloadedTotalSize"] longValue];
////    }else{
////        //        icloudBinding.progressView.totalSize = backup.backupSize;
////        icloudBinding.progressView.downloadedTotalSize = 1;
////        [icloudBinding setLoadType:iCloudDataDownLoad];
////    }
//    //    icloudBinding.userPtath = userFilePath;
//    [icloudBinding setBackupItem:icloudBackup];
//    [icloudBackup release];
//    //            icloudBinding.userPtath = userFilePath;
////    NSString *fileName = [NSString stringWithFormat:@"%@_%d",icloudBackup.uuid,backup.snapshotID];
////    [icloudBackup setDownloadFolderPath:[userFilePath stringByAppendingPathComponent:fileName]];
//    //            NSDictionary *fileDic = [dic valueForKey:fileName];
//    //            if (fileDic){
//    //                [icloudBinding setLoadType:[[fileDic valueForKey:@"loadState"] intValue]];
//    //                icloudBinding.progressView.totalSize = [[fileDic valueForKey:@"totalSize"] longValue];
//    //                icloudBinding.progressView.downloadedTotalSize = [[fileDic valueForKey:@"downloadedTotalSize"] longValue];
//    //                [icloudBinding setLoadType:iCloudDataDownLoad];
//    //            }else{
//    //                icloudBinding.progressView.totalSize = backup.backupSize;
//    //                icloudBinding.progressView.downloadedTotalSize = 1;
//    //                [icloudBinding setLoadType:iCloudDataDownLoad];
//    //            }
//    //            //            [icloudBinding setLoadType:iCloudDataFail];
//    //    [icloudBinding setSize:[StringHelper getFileSizeString:backup.backupSize reserved:2]];
//    [icloudBinding setDelegate:self];
//    [bindingSource addObject:icloudBinding];
//    [icloudBinding release];
//    icloudBinding = nil;
    
}

//加载iCloud上的备份列表
- (void)getloadData{
    NSArray *backups = [[_iCloudClient getBackupList] retain];
    NSString *iCloudDownloadPath = [TempHelper getiCloudLocalPath];
    NSString *userFilePath = [iCloudDownloadPath stringByAppendingPathComponent:[_icloudLogInfo appleID]];
    NSMutableDictionary *dic = nil;
    NSString *userDownloadPlistFilePath1 = [iCloudDownloadPath stringByAppendingPathComponent:downloadManagerPlist];
    IMBiCloudBackupBindingEntity *icloudBinding = nil;
    if ([fm fileExistsAtPath:userDownloadPlistFilePath1]) {
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:userDownloadPlistFilePath1];
    }
    //    if (dic != nil) {
    //        if (_downloadAtrribute != nil) {
    //            [_downloadAtrribute release];
    //            _downloadAtrribute = nil;
    //        }
    //        _downloadAtrribute = [dic retain];
    //    } else {
    //        if (_downloadAtrribute != nil) {
    //            [_downloadAtrribute release];
    //            _downloadAtrribute = nil;
    //        }
    //        _downloadAtrribute = [[NSMutableDictionary alloc] init];
    //    }
    //    下面是创建对应得实体，显示到tableview列表中去；
//    NSString *iCloudDownloadPath = [TempHelper getiCloudLocalPath];
//    NSString *userFilePath = [iCloudDownloadPath stringByAppendingPathComponent:userID];
    if (backups != nil && backups.count >0) {
        for (IMBiCloudBackup *backup in backups) {
            if (_loadEnd) {
                break;
            }
            icloudBinding = [[IMBiCloudBackupBindingEntity alloc] init];
            [icloudBinding setBackupItem:backup];
            icloudBinding.userPtath = userFilePath;
            //            NSString *fileName = [NSString stringWithFormat:@"%@_%@",backup.uuid,[DateHelper dateFrom1970ToString:(long)(backup.lastModified) withMode:3]];
            NSString *fileName = [NSString stringWithFormat:@"%@_%d",backup.uuid,backup.snapshotID];
            [backup setDownloadFolderPath:[userFilePath stringByAppendingPathComponent:fileName]];
            NSDictionary *fileDic = [dic valueForKey:backup.downloadFolderPath];
            if (fileDic){
                [icloudBinding setLoadType:[[fileDic valueForKey:@"loadState"] intValue]];
                icloudBinding.progressView.totalSize = [[fileDic valueForKey:@"totalSize"] longValue];
                icloudBinding.progressView.downloadedTotalSize = [[fileDic valueForKey:@"downloadedTotalSize"] longValue];
                [icloudBinding setLoadType:[[fileDic valueForKey:@"loadState"] intValue]];
            }else{
                icloudBinding.progressView.totalSize = backup.backupSize;
                icloudBinding.progressView.downloadedTotalSize = 1;
                [icloudBinding setLoadType:iCloudDataDownLoad];
            }
            //            [icloudBinding setLoadType:iCloudDataFail];
            [icloudBinding setSize:[StringHelper getFileSizeString:backup.backupSize reserved:2]];
            [icloudBinding setDelegate:self];
            [bindingSource addObject:icloudBinding];
            [icloudBinding release];
            icloudBinding = nil;
            [NSColor colorWithDeviceRed:50.0/255 green:177.0/255 blue:250.0/255 alpha:1];
        }
    }
    [dic release];
    dic = nil;
    [backups release];
}

- (void)changeFromBindingData:(id)fromBindingData toBindingData:(id)toBindingData withControlView:(NSView *)controlView {
    if (controlView != nil) {
        if (fromBindingData != nil) {
            IMBiCloudBackupBindingEntity *bindingEntity = (IMBiCloudBackupBindingEntity*)fromBindingData;
            bindingEntity.isMouseEntered = NO;
            switch (bindingEntity.loadType) {
                case iCloudDataDownLoad:
                case iCLoudDataContinue: {
                    [bindingEntity removeAllView];
                    break;
                }
                case iCloudDataDelete: {
                    [bindingEntity removeAllView];
                    bindingEntity.loadType = iCloudDataComplete;
                    break;
                }
                case iCloudDataCancelDownLoad:{
                    [bindingEntity removeAllView];
                    bindingEntity.loadType = iCloudDataWaitingDownLoad;
                    break;
                }
                default:
                    [bindingEntity removeAllView];
                    break;
            }
        }
        
        if (toBindingData != nil) {
            IMBiCloudBackupBindingEntity *bindingEntity = (IMBiCloudBackupBindingEntity*)toBindingData;
            bindingEntity.isMouseEntered = YES;
            switch (bindingEntity.loadType) {
                case iCloudDataComplete: {
                    //                    bindingEntity.loadType = iCloudDataComplete;
                    //                    [bindingEntity removeAllView];
                    break;
                }
                case iCloudDataWaitingDownLoad:{
                    bindingEntity.loadType = iCloudDataCancelDownLoad;
                    [bindingEntity removeAllView];
                    break;
                }
                case iCloudDataFail:{
                    bindingEntity.loadType = iCLoudDataContinue;
                    [bindingEntity removeAllView];
                    
                }
                default:
                    [bindingEntity removeAllView];
                    break;
            }
        }
        [controlView setNeedsDisplay:YES];
    }
}

//加载已经下载到电脑上的备份列表
- (void)getDownloadCompleteData {
    
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    _dataSourceArray = [[NSMutableArray alloc] init];
    IMBiCloudBackupBindingEntity *icloudBinding = nil;
    NSString *iCloudDownloadPath = [TempHelper getiCloudLocalPath];
    NSString *pathStr = [iCloudDownloadPath stringByAppendingPathComponent:downloadManagerPlist];
    if ([fm fileExistsAtPath:pathStr]) {
        NSMutableDictionary *dic = nil;
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:pathStr];
        if (dic != nil) {
            if (_downloadAtrribute != nil) {
                [_downloadAtrribute release];
                _downloadAtrribute = nil;
            }
            _downloadAtrribute = [dic retain];
        } else {
            if (_downloadAtrribute != nil) {
                [_downloadAtrribute release];
                _downloadAtrribute = nil;
            }
            _downloadAtrribute = [[NSMutableDictionary alloc] init];
        }
        
        NSArray *keyArr = [dic allKeys];
        if (keyArr != nil && keyArr.count > 0) {
            for (NSString *key in keyArr) {
                if (_loadEnd) {
                    break;
                }
                NSDictionary *fileDic = [dic valueForKey:key];
                iCLoudLoadType downloadType = (iCLoudLoadType)[[fileDic valueForKey:@"loadState"] intValue];
                if (downloadType == iCloudDataComplete) {
                    NSDictionary *backupDic = [fileDic valueForKey:@"backupItem"];
                    if (backupDic == nil) {
                        continue;
                    }
                    icloudBinding = [[IMBiCloudBackupBindingEntity alloc] init];
                    IMBiCloudBackup *backupItem = [[IMBiCloudBackup alloc] init];
                    [backupItem setDeviceName:[backupDic valueForKey:@"deviceName"]];
                    [backupItem setSerialNumber:[backupDic valueForKey:@"serialNumber"]];
                    [backupItem setUuid:[backupDic valueForKey:@"uuid"]];
                    [backupItem setShortProductType:[backupDic valueForKey:@"shortProductType"]];
                    [backupItem setProductType:[backupDic valueForKey:@"productType"]];
                    [backupItem setModel:[backupDic valueForKey:@"model"]];
                    [backupItem setBuild:[backupDic valueForKey:@"build"]];
                    [backupItem setICloudAccount:[backupDic valueForKey:@"iCloudAccount"]];
                    [backupItem setDeviceType:[backupDic valueForKey:@"deviceType"]];
                    [backupItem setDeviceColor:[backupDic valueForKey:@"deviceColor"]];
                    [backupItem setIOSVersion:[backupDic valueForKey:@"iOSVersion"]];
                    [backupItem setLastModified:[[backupDic valueForKey:@"lastModified"] longLongValue]];
                    [backupItem setIncrSize:[[backupDic valueForKey:@"incrSize"] longLongValue]];
                    [backupItem setBackupSize:[[backupDic valueForKey:@"backupSize"] longLongValue]];
                    [backupItem setSnapshotID:[[backupDic valueForKey:@"snapshotID"] intValue]];
                    [backupItem setDownloadFolderPath:[backupDic valueForKey:@"downloadFolderPath"]];
                    
                    
                    if ([backupItem.iOSVersion isVersionMajorEqual:@"10"]&&[backupItem.iOSVersion isVersionLess:@"11"]) {
                        backupItem.iosProductTye = [backupItem.iOSVersion stringByReplacingOccurrencesOfString:@"10" withString:@"9.4"];
                    }else if ([backupItem.iOSVersion isVersionMajorEqual:@"11"]){
                        backupItem.iosProductTye = [backupItem.iOSVersion stringByReplacingOccurrencesOfString:@"11" withString:@"9.5"];
                    }else{
                        backupItem.iosProductTye = backupItem.iOSVersion;
                    }
                    [IMBiCloudClient getNoLoginBackupFiles:backupItem];
                    if ([backupItem.iOSVersion isVersionMajorEqual:@"9"]){
                        [icloudBinding setBackupItem:backupItem];
                        icloudBinding.userPtath = [iCloudDownloadPath stringByAppendingPathComponent:backupItem.iCloudAccount];
                        [icloudBinding setLoadType:downloadType];
                        icloudBinding.progressView.totalSize = [[fileDic valueForKey:@"totalSize"] longValue];
                        icloudBinding.progressView.downloadedTotalSize = [[fileDic valueForKey:@"downloadedTotalSize"] longValue];
                        [icloudBinding setSize:[StringHelper getFileSizeString:backupItem.backupSize reserved:2]];
                        [icloudBinding setDelegate:self];
                        [_dataSourceArray addObject:icloudBinding];
                        
                    }else{
                        if (backupItem.fileInfoArray != nil && backupItem.fileInfoArray.count > 0) {
                            [icloudBinding setBackupItem:backupItem];
                            icloudBinding.userPtath = [iCloudDownloadPath stringByAppendingPathComponent:backupItem.iCloudAccount];
                            [icloudBinding setLoadType:downloadType];
                            icloudBinding.progressView.totalSize = [[fileDic valueForKey:@"totalSize"] longValue];
                            icloudBinding.progressView.downloadedTotalSize = [[fileDic valueForKey:@"downloadedTotalSize"] longValue];
                            [icloudBinding setSize:[StringHelper getFileSizeString:backupItem.backupSize reserved:2]];
                            [icloudBinding setDelegate:self];
                            [_dataSourceArray addObject:icloudBinding];
                            
                        }
                    }
                    [icloudBinding release];
                    icloudBinding = nil;
                    [backupItem release];
                    backupItem = nil;
                }
            }
        }
        if (dic != nil) {
            [dic release];
            dic = nil;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_titleStr setWantsLayer:YES];
        if (_dataSourceArray.count > 1) {
            
            [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"iCloudBackup_View_Tips8_Complex", nil),(int)_dataSourceArray.count]];
        }else {
            
            [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"iCloudBackup_View_Tips8", nil),(int)_dataSourceArray.count]];
        }
        [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor",nil)]];
    });
}

#pragma tableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *disPlayAry = nil;
    if (_isSearch) {
        disPlayAry = _researchdataSourceArray;
    }else{
        disPlayAry = _dataSourceArray;
    }
    if (disPlayAry != nil && disPlayAry.count > 0) {
        return disPlayAry.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 42;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *disPlayAry = nil;
    if (_isSearch) {
        disPlayAry = _researchdataSourceArray;
    }else{
        disPlayAry = _dataSourceArray;
    }
    if (disPlayAry.count <= 0) {
        return nil;
    }
    if (row < 0||row > disPlayAry.count -1) {
        return nil;
    }
    NSString *identifier = tableColumn.identifier;
    IMBiCloudBackupBindingEntity *icloudBackupEntityitem = [disPlayAry objectAtIndex:row];
    IMBiCloudBackup *item = icloudBackupEntityitem.backupItem;
    
    if ([identifier isEqualToString:@"CheckCol"]) {
        return [NSNumber numberWithBool:item.checkState];
    }else if ([identifier isEqualToString:@"DeviceType"]) {
        return  item.deviceName;
    }else if ([identifier isEqualToString:@"TimeDate"]) {
        if ([item.iOSVersion isVersionMajorEqual:@"9.0"]) {
            return [DateHelper dateFrom2001ToString:(long)(item.lastModified) withMode:3];
        }
        return  [DateHelper dateFrom1970ToString:(long)(item.lastModified) withMode:3];
    }else if ([identifier isEqualToString:@"SerialNumber"]) {
        if ([StringHelper stringIsNilOrEmpty:item.serialNumber] ) {
            return @"";
        }else{
            
            return [NSString stringWithFormat:@"%@",item.serialNumber];
        }
    }
    
    //    return
    else if ([identifier isEqualToString:@"Size"]) {
//        if ([item.iOSVersion isVersionMajorEqual:@"8.4"]) {
             return  [StringHelper getFileSizeString:item.backupSize reserved:2];
//        }else{
//             return  [StringHelper getFileSizeString:item.incrSize reserved:2];
//        }
    }
    else if ([identifier isEqualToString:@"NoData"]){
        return @"";
    }else if ([identifier isEqualToString:@"iOSNub"]){
   
        return [NSString stringWithFormat:@"iOS %@",item.iOSVersion];;
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *disPlayAry = nil;
    if (_isSearch) {
        disPlayAry = _researchdataSourceArray;
    }else{
        disPlayAry = _dataSourceArray;
    }
    
    if ((int)disPlayAry.count < 0||row >disPlayAry.count -1) {
        return ;
    }
    NSString *identifier = tableColumn.identifier;
    IMBiCloudBackupBindingEntity *icloudBackupEntityitem = [disPlayAry objectAtIndex:row];
    IMBiCloudBackup *item = icloudBackupEntityitem.backupItem;
    if([identifier isEqualToString:@"DeviceType"]){
        NSImage *image  = nil;
        if([item.deviceType rangeOfString:@"iPod"].location != NSNotFound){
            image =[StringHelper imageNamed:@"backup_ipod"];
              ((IMBImageAndTextCell*)cell).imageName = @"backup_ipod";
        }else if ([item.deviceType rangeOfString:@"iPad"].location != NSNotFound){
            image =[StringHelper imageNamed:@"backup_ipad"];
            ((IMBImageAndTextCell*)cell).imageName = @"backup_ipad";
        }else if ([item.deviceType rangeOfString:@"iPhone"].location != NSNotFound){
            image =[StringHelper imageNamed:@"backup_iphone"];
            ((IMBImageAndTextCell*)cell).imageName = @"backup_iphone";
        }
        
        [(IMBImageAndTextCell*)cell setMarginX:6];
        [(IMBImageAndTextCell*)cell setPaddingX:0];
        [(IMBImageAndTextCell*)cell setImageSize:NSMakeSize(20, 28)];
        ((IMBImageAndTextCell*)cell).image = image;
        
    }else if ([identifier isEqualToString:@"Btn"]){
        ((IMBiCloudTableCell *)cell).isDisable = _isDisable;
        NSIndexSet *index = [_itemIcloudTableView selectedRowIndexes];
        if ([index count] > 0) {
            int selectedRow = (int)[index firstIndex];
            if (row == selectedRow) {
                ((IMBiCloudTableCell *)cell).isSelected = YES;
            }else{
                ((IMBiCloudTableCell *)cell).isSelected = NO;
            }
        }else{
            ((IMBiCloudTableCell *)cell).isSelected = NO;
        }
        if (icloudBackupEntityitem.loadType == iCloudDataComplete) {
            ((IMBiCloudTableCell *)cell).isDisable = _isDisable;
        }
        int row  = (int)[index firstIndex];
        float progress = ((float)_downloadedTotalSize)/_totalSize;
        if (progress <0 ) {
            progress = 0;
        }else if (progress >1){
            progress = 0.99;
        }
        if (_totalSize == 0) {
            progress = 0;
        }
        //        _downloadedTotalSize)/_totalSize
        //        ((IMBiCloudTableCell *)cell).bindingEntity.progressView.downloadedTotalSize = _downloadedTotalSize;
        //        ((IMBiCloudTableCell *)cell).bindingEntity.progressView.totalSize = _totalSize;
        NSString *str = @"";
        if (progress >0.01) {
            str= [NSString stringWithFormat:@"%d%@",(int)(progress*100),@"%"];
        }else{
            str= [NSString stringWithFormat:@"%.1f%@",(progress*100),@"%"];
        }
//        NSString *str= [NSString stringWithFormat:@"%d%@",(int)(progress*100),@"%"];
        [(IMBiCloudTableCell *)cell setProessStr:str];
        ((IMBiCloudTableCell *)cell).bindingEntity = icloudBackupEntityitem;
        if (row == [_dataSourceArray count] - 1) {
            _isFirstLoad = NO;
        }
    }else if ([identifier isEqualToString:@"CheckCol"]){
        
        if (icloudBackupEntityitem.loadType == iCloudDataComplete||icloudBackupEntityitem.loadType == iCloudDataDelete) {
            NSButtonCell *textCell = cell;
            textCell.image = [StringHelper imageNamed:@"itu_default1"];
            textCell.alternateImage = [StringHelper imageNamed:@"itu_select1"];
        }else{
            NSButtonCell *textCell = cell;
            textCell.image = [StringHelper imageNamed:@""];
            textCell.alternateImage = [StringHelper imageNamed:@""];
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
	if ( [@"DeviceType" isEqualToString:identify] || [@"Size" isEqualToString:identify]|| [@"TimeDate" isEqualToString:identify]|| [@"SerialNumber" isEqualToString:identify]|| [@"Size" isEqualToString:identify]|| [@"NoData" isEqualToString:identify]|| [@"iOSNub" isEqualToString:identify]) {
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
    }
    
    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"DeviceType"]) {
        key = @"backupItem.deviceName";
    } else if ([key isEqualToString:@"Size"]) {
        key = @"backupItem.backupSize";
    } else if ([key isEqualToString:@"TimeDate"]) {
        key = @"backupItem.lastModified";
    } else if ([key isEqualToString:@"SerialNumber"]) {
        key = @"backupItem.serialNumber";
    } else if ([key isEqualToString:@"iOSNub"]) {
        key = @"backupItem.iosProductTye";
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    
    
    [sortDescriptor release];
    [sortDescriptors release];
    [_itemIcloudTableView reloadData];
}

- (void)downloadiCloudStart:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [notification userInfo];
        _totalSize = [[dic valueForKey:@"totalSize"] longValue];
        _downloadedTotalSize = 0;
        
    });
}

- (void)downloadiCloudProgress:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [notification userInfo];
        long totalsize = [[dic valueForKey:@"totalSize"] longValue];
        long downloadsize = [[dic valueForKey:@"DownloadedTotalSize"] longValue];
        if (downloadsize > _downloadedTotalSize) {
            _downloadedTotalSize = downloadsize;
        }
        _totalSize = totalsize;
        [_itemIcloudTableView reloadData];
    });
}

- (void)downloadiCloudSucess:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)downloadiCloudFailed:(int)downloadError {
    dispatch_async(dispatch_get_main_queue(), ^{
        _isDisable = YES;
        [_downLoadQueue setCancel:YES];
//        DownloadErrorEnum downloadError = [[notification object] intValue];
        if (downloadError == DownloadExpiredError) {//登录超时
            [self performSelectorOnMainThread:@selector(downLoadLogInTime) withObject:nil waitUntilDone:NO];
        }else if (downloadError == DownloadNetworkError) {//网络断开;
            [self performSelectorOnMainThread:@selector(downLoadcat) withObject:nil waitUntilDone:NO];
        }
        _isDisable = NO;
    });
}

- (void)loadicloudDownProess:(uint64_t)totalSize withCompleteSize:(uint64_t)completeSize{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        IMBiCloudBackupBindingEntity *bindingEntity = [_dataSourceArray objectAtIndex:[_itemIcloudTableView selectedRow]];

        long downloadsize = completeSize;
        if (totalSize == _downloadedTotalSize) {
            downloadsize = totalSize;
        }else if (totalSize > downloadsize) {
            downloadsize += _downloadedTotalSize;
            _downloadedTotalSize = downloadsize;
        }
        _totalSize = totalSize;
//        if (downloadSize > _downloadedTotalSize) {
//            _downloadedTotalSize = downloadSize;
//        }
//        _totalSize = downloadTotalsize;
        [_itemIcloudTableView reloadData];
        NSDictionary *info = nil;
        info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_downloadedTotalSize], @"DownloadedTotalSize",  [NSNumber numberWithLong:_totalSize], @"totalSize", nil];
        [nc postNotificationName:NOTIFY_ICLOUD_IOS9DOWNLOAD_PROGRESS object:nil userInfo:info];
    });
}

- (void)loadicloudDownProessComplete{
    dispatch_async(dispatch_get_main_queue(), ^{
        _downloadedTotalSize = 0;
        _totalSize = 0;
        IMBiCloudBackupBindingEntity *bindingEntity = [_downLoadQueue getQueueHeadObject];
        bindingEntity.progressView.timer = nil;
        [bindingEntity removeAllView];
        if (bindingEntity.loadType == iCloudDataDownLoading) {
            bindingEntity.loadType = iCloudDataComplete;
            //写入download.Plist
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self setDownloadPlistAtrributeAndWriteFile:bindingEntity];
            });
        }
        bindingEntity.progressView.isDownloadSucess = YES;
        bindingEntity.backupItem.isDownload = NO;
        bindingEntity.backupItem.isDownloadSucess = YES;

        
        [_downLoadQueue removeHeadObject];
        if ([_downLoadQueue getQueueCount] > 0) {
            bindingEntity = [_downLoadQueue getQueueHeadObject];
            bindingEntity.progressView.isDownloadSucess = NO;
            [self setDownloadTotalSizeAndDownloadedTotalSize:bindingEntity];
            [bindingEntity removeAllView];
            bindingEntity.loadType = iCloudDataDownLoading;
            bindingEntity.backupItem.isDownload = YES;
            [_itemIcloudTableView setNeedsDisplay:YES];
            _itemIcloudTableView.dataAry = _dataSourceArray;
            [_itemIcloudTableView reloadData];
            dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(newThread, ^{
                if ([bindingEntity.backupItem.iOSVersion isVersionMajorEqual:@"9"]){
                    [_downLoadQueue iOS9StartDownload];
                }else{
                    [self performSelector:@selector(downloadBackup:) withObject:[NSArray arrayWithObjects:bindingEntity.backupItem,[bindingEntity.backupItem.downloadFolderPath stringByDeletingLastPathComponent], nil]];
                }
            });
        }
        [_itemIcloudTableView setNeedsDisplay:YES];
    });
    
}

- (void)downloadComplete {
    dispatch_async(dispatch_get_main_queue(), ^{
       
        _downloadedTotalSize = 0;
        _totalSize = 0;
        IMBiCloudBackupBindingEntity *bindingEntity = [_downLoadQueue getQueueHeadObject];
        if (!bindingEntity) {
            return;
        }
        bindingEntity.progressView.timer = nil;
        [bindingEntity removeAllView];
        
        bindingEntity.loadType = iCloudDataComplete;
        bindingEntity.progressView.isDownloadSucess = YES;
        bindingEntity.backupItem.isDownload = NO;
        bindingEntity.backupItem.isDownloadSucess = YES;
        //写入download.Plist
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self setDownloadPlistAtrributeAndWriteFile:bindingEntity];
        });
    
        [_downLoadQueue removeHeadObject];
        if ([_downLoadQueue getQueueCount] > 0) {
            bindingEntity = [_downLoadQueue getQueueHeadObject];
            bindingEntity.progressView.isDownloadSucess = NO;
            [self setDownloadTotalSizeAndDownloadedTotalSize:bindingEntity];
            [bindingEntity removeAllView];
            bindingEntity.loadType = iCloudDataDownLoading;
            bindingEntity.backupItem.isDownload = YES;
            [_itemIcloudTableView setNeedsDisplay:YES];
            _itemIcloudTableView.dataAry = _dataSourceArray;
            [_itemIcloudTableView reloadData];
            dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(newThread, ^{
                if ([bindingEntity.backupItem.iOSVersion isVersionMajorEqual:@"9"]){
                    [_downLoadQueue iOS9StartDownload];
                }else{
                    [self performSelector:@selector(downloadBackup:) withObject:[NSArray arrayWithObjects:bindingEntity.backupItem,bindingEntity.backupItem.downloadFolderPath, nil]];
                }
            });
        }
        [_itemIcloudTableView setNeedsDisplay:YES];
    });
}

- (void)downLoadLogInTime
{
    [(IMBiCloudMainPageViewController*)_delegate setIsFail:YES];
    [self showAlertText:CustomLocalizedString(@"iCloudBackup_View_Tips4", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)downInTime{
//    [self doBack:nil];
    [(IMBiCloudMainPageViewController*)_delegate setIsFail:YES];
//    [self performSelectorOnMainThread:@selector(downInTime) withObject:nil waitUntilDone:NO];
    [self showAlertText:CustomLocalizedString(@"iCloud_id_5", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    [_downLoadQueue setCancel:YES];
    [_delegate cleanTextField];
    [_searchFieldBtn setHidden:YES];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [(IMBiCloudViewController *)_delegate setIsLoginIng:NO];
//    [_icloud setContentView:_icloudView];
    _loadEnd = YES;
    [_iCloudBox setContentView:[(IMBiCloudViewController *)_delegate icloudLogView]];
}

- (void)analysisFail{
    [self performSelectorOnMainThread:@selector(downInTime) withObject:nil waitUntilDone:NO];
}

- (void)downLoadcat
{
    [(IMBiCloudMainPageViewController*)_delegate setIsFail:YES];
    [self showAlertText:CustomLocalizedString(@"iCloudLogin_View_Tips2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)downLoadFail
{
    _isError = YES;
    [self showAlertText:CustomLocalizedString(@"iCloudBackup_View_Tips1", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    [self doBack:nil];
    [(IMBiCloudMainPageViewController*)_delegate setIsFail:YES];
    [_iCloudBox setContentView:[(IMBiCloudViewController *)_delegate icloudLogView]];
    _isDisable = NO;
}

//download
- (void)handleBackup:(IMBiCloudBackupBindingEntity*)bindingEntity withUserPath:(NSString *)userPath{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup Download" label:Click transferCount:0 screenView:@"iCloud Backup Download" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [bindingEntity.closeDownBtn setHidden:NO];
    [bindingEntity.progressView setHidden:NO];
    [self setDownloadTotalSizeAndDownloadedTotalSize:bindingEntity];
    if ([_downLoadQueue addOject:bindingEntity]){
        [bindingEntity removeAllView];
        if ([_downLoadQueue getQueueCount] == 1) {
            bindingEntity.backupItem.isDownload = YES;
            NSString *version = bindingEntity.backupItem.iOSVersion;
            NSString *str = [NSString stringWithFormat:@"iCloudiOSversion:%@ downSize:%lld",version,bindingEntity.backupItem.backupSize];
            [[IMBLogManager singleton] writeInfoLog:str];
            if ([version isVersionMajorEqual:@"9.0"]) {
                [_downLoadQueue setDelegate:self];
                [_downLoadQueue iOS9StartDownload];
            }else{
                _downLoadQueue.iCloudClient = _iCloudClient;
                _downLoadQueue.outputPath = userPath;
                _downloadedTotalSize = 0;
                _totalSize = 0;
                [_downLoadQueue startDownload];
            }
        }else{
            bindingEntity.loadType = iCloudDataWaitingDownLoad;
        }
    }
    [_itemIcloudTableView reloadData];
    
}
//   }

//下载成功
- (void)sucessDownloadWithOutputpath:(NSString *)outputPath{
    dispatch_sync(dispatch_get_main_queue(), ^{
        _downloadedTotalSize = 0;
        _totalSize = 0;
        IMBiCloudBackupBindingEntity *bindingEntity = [_downLoadQueue getQueueHeadObject];
        if (!bindingEntity.backupItem.isDownloadSucess) {
            return;
        }
        bindingEntity.progressView.timer = nil;
        [bindingEntity removeAllView];
        
        bindingEntity.loadType = iCloudDataComplete;
        bindingEntity.progressView.isDownloadSucess = YES;
        bindingEntity.backupItem.isDownload = NO;
        bindingEntity.backupItem.isDownloadSucess = YES;
        //写入download.Plist
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self setDownloadPlistAtrributeAndWriteFile:bindingEntity];
        });
        [_downLoadQueue removeHeadObject];
        if ([_downLoadQueue getQueueCount] > 0) {
            bindingEntity = [_downLoadQueue getQueueHeadObject];
            bindingEntity.progressView.isDownloadSucess = NO;
            [self setDownloadTotalSizeAndDownloadedTotalSize:bindingEntity];
            [bindingEntity removeAllView];
            bindingEntity.loadType = iCloudDataDownLoading;
            bindingEntity.backupItem.isDownload = YES;
            [_itemIcloudTableView setNeedsDisplay:YES];
            _itemIcloudTableView.dataAry = _dataSourceArray;
            [_itemIcloudTableView reloadData];
            dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(newThread, ^{
                if ([bindingEntity.backupItem.iOSVersion isVersionMajorEqual:@"9"]){
                    [_downLoadQueue iOS9StartDownload];
                }else{
                    [self performSelector:@selector(downloadBackup:) withObject:[NSArray arrayWithObjects:bindingEntity.backupItem,outputPath, nil]];
                }
            });
        }
        [_itemIcloudTableView setNeedsDisplay:YES];
    });
}

- (void)downloadBackup:(NSArray *)array{
    IMBiCloudBackup *backupItem = [array objectAtIndex:0];
    if ([backupItem.iOSVersion isLessThan:@"9.0"]) {
        [_iCloudClient downloadBackup:[array objectAtIndex:0] withFilter:nil withOutputPath:[array objectAtIndex:1]];
    }
}
//下载失败
- (void)downloadFailedWithOutputPath:(NSString *)outputPath{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_downLoadQueue setCancel:YES];
        [self performSelectorOnMainThread:@selector(downLoadFail) withObject:nil waitUntilDone:NO];
    });
}

//停止下载
- (void)stopDownloadWithUserpath:(NSString *)userPath{
    [_downLoadQueue setCancel:YES];
    IMBiCloudBackupBindingEntity *bindingEntity = [_downLoadQueue getQueueHeadObject];
    bindingEntity.progressView.timer = nil;
    _downloadedTotalSize = 0;
    _totalSize = 0;
    bindingEntity.backupItem.isDownload = NO;
    bindingEntity.loadType = iCLoudDataContinue;
    //设置属性
//    [self setDownloadPlistAtrributeAndWriteFile:bindingEntity];
    dispatch_async(dispatch_get_main_queue(), ^{
        [bindingEntity.progressView removeFromSuperview];
        [bindingEntity.closeDownBtn removeFromSuperview];
        [_itemIcloudTableView setNeedsDisplay:YES];
    });
    if ([_downLoadQueue getQueueCount] > 1) {
        bindingEntity = [_downLoadQueue getQueueHeadObject];
        [self setDownloadTotalSizeAndDownloadedTotalSize:bindingEntity];
        [bindingEntity removeAllView];
        bindingEntity.loadType = iCloudDataDownLoading;
        bindingEntity.backupItem.isDownload = YES;
        [_itemIcloudTableView reloadData];
        dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newThread, ^{
            if ([bindingEntity.backupItem.iOSVersion isVersionMajorEqual:@"9"]){
                [_downLoadQueue iOS9StartDownload];
            }else{
                [self performSelector:@selector(downloadBackup:) withObject:[NSArray arrayWithObjects:bindingEntity.backupItem,userPath, nil]];
            }
        });
    }
}

//取消下载
- (void)cancelDownload:(IMBiCloudBackupBindingEntity*)bindingEntity WithUserPath:(NSString *)userPath{
    _downloadedTotalSize = 0;
    _totalSize = 0;
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup Download Cancel" label:Click transferCount:0 screenView:@"iCloud Backup Download Cancel" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    if ([bindingEntity.backupItem.iOSVersion isVersionMajorEqual:@"9"]) {
        [_downLoadQueue setCancel:YES];
    }
    [_downLoadQueue removeObject:bindingEntity];
    bindingEntity.progressView.timer = nil;
    bindingEntity.loadType = iCLoudDataContinue;
    
    bindingEntity.backupItem.isDownload = NO;
    [_itemIcloudTableView setNeedsDisplay:YES];
}
//跳转页面
-(void)jumpScanView:(IMBiCloudBackupBindingEntity*)bindingEntity WithuserPath:(NSString *)userPath{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup Preview" label:Click transferCount:0 screenView:@"iCloud Backup Preview" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    SimpleNode *node = [SimpleNode alloc];
    node.backupPath = bindingEntity.backupItem.downloadFolderPath;
    node.productVersion = bindingEntity.backupItem.iOSVersion;
    IMBBackupAllDataViewController *allDataViewController = [[IMBBackupAllDataViewController alloc]initWithIMBiCloudBackup:bindingEntity.backupItem WithDelegate:self];
    [_iCloudBox setContentView:allDataViewController.view];
}


- (void)findDownloadFile:(IMBiCloudBackupBindingEntity*)bindingEntity WithUserPath:(NSString *)userPath{
    NSString *fileName = [NSString stringWithFormat:@"%@_%d",bindingEntity.backupItem.uuid,bindingEntity.backupItem.snapshotID];
    NSString *path = [userPath stringByAppendingPathComponent:fileName];
    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    [workSpace openFile:path];
}

//删除文件
- (void)deleteDownloadFile:(IMBiCloudBackupBindingEntity*)bindingEntity WithUserPath:(NSString *)userPath{
    //    _isDeleteItem = YES;
    //    [_iCloudBlowView.conButton setEnabled:NO];
    //    _deleteBindEntity = bindingEntity;
    //    [_operationController loadViewController:self WithType:Clean_TwoBtnStatus];
    //    [_operationController loadconfirmBtnViewDataTitle:CustomLocalizedString(@"iCloudBackup_View_Tips7", nil) WithCancelBtnName:CustomLocalizedString(@"button_id_5", nil)  WithOkBtnName:CustomLocalizedString(@"button_id_1", nil) WithImageName:@"guide_app"];
}

- (void)setDownloadTotalSizeAndDownloadedTotalSize:(IMBiCloudBackupBindingEntity *)bindingEntity {
    IMBiCloudBackup *backupItem = bindingEntity.backupItem;
    NSString *fileName = [self getDownloadFileName:backupItem];
    NSDictionary *dic = [_downloadAtrribute valueForKey:fileName];
    if (dic != nil) {
        bindingEntity.progressView.totalSize = [[dic valueForKey:@"totalSize"] longValue];
        bindingEntity.progressView.downloadedTotalSize = [[dic valueForKey:@"downloadedTotalSize"] longValue];
    }else{
        bindingEntity.progressView.totalSize = backupItem.backupSize;
        bindingEntity.progressView.downloadedTotalSize = 1;
    }
}

- (NSString *)getDownloadFileName:(IMBiCloudBackup *)backupItem{
    if ([backupItem.iOSVersion isVersionMajorEqual:@"9"]) {
        return backupItem.relativePath;
    }else {
        return [NSString stringWithFormat:@"%@_%d",backupItem.uuid,backupItem.snapshotID];
    }
}

//设置download.plist属性
- (void)setDownloadPlistAtrributeAndWriteFile:(IMBiCloudBackupBindingEntity *)bindingEntity{
    IMBiCloudBackup *backupItem = bindingEntity.backupItem;
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    [tmpDic setObject:[self getDownloadFileName:backupItem] forKey:@"dowloadFilename"];
    IMBiCloudDownloadProgressView*progressView = bindingEntity.progressView;
    [tmpDic setObject:[NSNumber numberWithLong:progressView.downloadedTotalSize] forKey:@"downloadedTotalSize"];
    [tmpDic setObject:[NSNumber numberWithLong:progressView.totalSize] forKey:@"totalSize"];
    [tmpDic setObject:[NSNumber numberWithInt:bindingEntity.loadType] forKey:@"loadState"];
    if (bindingEntity.loadType == iCloudDataComplete) {
        if (backupItem != nil) {
            NSMutableDictionary *backupDic = [[NSMutableDictionary alloc] init];
            [backupDic setObject:backupItem.deviceName forKey:@"deviceName"];
            [backupDic setObject:backupItem.serialNumber forKey:@"serialNumber"];
            [backupDic setObject:backupItem.uuid forKey:@"uuid"];
            [backupDic setObject:backupItem.shortProductType forKey:@"shortProductType"];
            [backupDic setObject:backupItem.productType forKey:@"productType"];
            [backupDic setObject:backupItem.model forKey:@"model"];
            [backupDic setObject:backupItem.build forKey:@"build"];
            [backupDic setObject:backupItem.iCloudAccount forKey:@"iCloudAccount"];
            [backupDic setObject:backupItem.deviceType forKey:@"deviceType"];
            [backupDic setObject:backupItem.deviceColor forKey:@"deviceColor"];
            [backupDic setObject:backupItem.iOSVersion forKey:@"iOSVersion"];
            [backupDic setObject:[NSNumber numberWithLongLong:backupItem.lastModified] forKey:@"lastModified"];
            [backupDic setObject:[NSNumber numberWithLongLong:backupItem.incrSize] forKey:@"incrSize"];
            [backupDic setObject:[NSNumber numberWithLongLong:backupItem.backupSize] forKey:@"backupSize"];
            [backupDic setObject:[NSNumber numberWithInt:backupItem.snapshotID] forKey:@"snapshotID"];
            [backupDic setObject:backupItem.downloadFolderPath forKey:@"downloadFolderPath"];
            [tmpDic setObject:backupDic forKey:@"backupItem"];
            [backupDic release];
        }
    }else if (bindingEntity.loadType == iCloudDataWaitingDownLoad || bindingEntity.loadType == iCloudDataDownLoading || bindingEntity.loadType == iCloudDataFail) {
        [tmpDic setObject:[NSNumber numberWithInt:iCLoudDataContinue] forKey:@"loadState"];
    }
    
    NSString *iCloudDownloadPath = [TempHelper getiCloudLocalPath];
    NSString *userDownloadPlistFilePath1 = [iCloudDownloadPath stringByAppendingPathComponent:downloadManagerPlist];
//    if ([bindingEntity.backupItem.iOSVersion isVersionMajorEqual:@"9"]) {
        [_downloadAtrribute setObject:tmpDic forKey:backupItem.downloadFolderPath];
        [_downloadAtrribute writeToFile:userDownloadPlistFilePath1 atomically:YES];
        [tmpDic release];
//    }else{
//        [_downloadAtrribute setObject:tmpDic forKey:[NSString stringWithFormat:@"%@_%d",backupItem.uuid,backupItem.snapshotID]];
//        [_downloadAtrribute writeToFile:userDownloadPlistFilePath1 atomically:YES];
//        [tmpDic release];
//    }
}

-(void)backBackUpView{
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_itemTableView reloadData];
    [_iCloudBox setContentView:_icloudView];
}

-(void)doBack:(id)sender{
    [_downLoadQueue setCancel:YES];
    [_searchFieldBtn setHidden:YES];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
//    [_noDataBoxView setContentView:_icloudView];
    _loadEnd = YES;
    if ([_delegate respondsToSelector:@selector(doBack:)]) {
        [_delegate doBack:nil];
    }
}

- (void)deleteItems:(id)sender
{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup Delete" label:Click transferCount:0 screenView:@"iCloud Backup Delete" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSMutableArray *disPlayAry = nil;
    if (_isSearch) {
        disPlayAry = _researchdataSourceArray;
    }else{
        disPlayAry = _dataSourceArray;
    }
    NSInteger tagRow = [_itemIcloudTableView  selectedRow];
  
    if (tagRow <0) {
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_85", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else{
        
        
        NSMutableArray *disPlayAry = nil;
        if (_isSearch) {
            disPlayAry = _researchdataSourceArray;
        }else{
            disPlayAry = _dataSourceArray;
        }
        NSInteger tagRow = [_itemIcloudTableView  selectedRow];
        IMBiCloudBackupBindingEntity *icloudBackupEntityitem = [disPlayAry objectAtIndex:tagRow];
        if (icloudBackupEntityitem.loadType == iCloudDataComplete) {
            [self showAlertText:CustomLocalizedString(@"icloud_backup_delete_complete", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
//            [self showAlertText:CustomLocalizedString(@"icloud_backup_delete_complete", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }else{
            [self showAlertText:CustomLocalizedString(@"icloud_backup_delete_noComplete", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }

    }
}

-(void)deleteBackupSelectedItems:(id)sender{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:Delete actionParams:@"iCloud Backup Delete" label:Click transferCount:0 screenView:@"iCloud Backup Delete" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:0];
   
 
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger tagRow = [_itemIcloudTableView  selectedRow];
        NSMutableArray *disPlayAry = nil;
        if (_isSearch) {
            disPlayAry = _researchdataSourceArray;
        }else{
            disPlayAry = _dataSourceArray;
        }
        IMBiCloudBackupBindingEntity *icloudBackupEntityitem = [disPlayAry objectAtIndex:tagRow];
        IMBiCloudBackup *item = icloudBackupEntityitem.backupItem;
        
        [[icloudBackupEntityitem btniCloudCommon] removeFromSuperview];
        NSString *userDownloadPlistFilePath1 = [[icloudBackupEntityitem.userPtath stringByDeletingLastPathComponent] stringByAppendingPathComponent:downloadManagerPlist];
        if ([fm fileExistsAtPath:userDownloadPlistFilePath1]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:userDownloadPlistFilePath1];
            if ([dic.allKeys containsObject:item.downloadFolderPath]) {
                [dic removeObjectForKey:item.downloadFolderPath];
                [dic writeToFile:userDownloadPlistFilePath1 atomically:YES];
            }
//            for (NSString *key in dic.allKeys) {
//                if ([item.iOSVersion isVersionMajorEqual:@"9"]) {
//                    NSString *downLastPath = [item.downloadFolderPath lastPathComponent];
//                    NSString *downPath = [item.downloadFolderPath stringByDeletingLastPathComponent];
//                    NSString *pathKey =  [NSString stringWithFormat:@"%@/%@",downPath,downLastPath];
//                    if ([pathKey isEqualToString:key]) {
//                        [dic removeObjectForKey:key];
//                        [dic writeToFile:userDownloadPlistFilePath1 atomically:YES];
//                    }
//                }else if ([key isEqualToString:[item.downloadFolderPath lastPathComponent]]) {
//                    [dic removeObjectForKey:key];
//                    [dic writeToFile:userDownloadPlistFilePath1 atomically:YES];
//                }
//            }
            NSLog(@"kjf");
        }
        [icloudBackupEntityitem removeAllView];
        if ([icloudBackupEntityitem.backupItem.iOSVersion isVersionMajorEqual:@"9"]) {
            [_downLoadQueue setCancel:YES];
        }
        [_downLoadQueue removeObject:icloudBackupEntityitem];
        icloudBackupEntityitem.progressView.timer = nil;
        icloudBackupEntityitem.loadType = iCLoudDataContinue;
        
        icloudBackupEntityitem.backupItem.isDownload = NO;
        [_itemIcloudTableView setNeedsDisplay:YES];
        [fm removeItemAtPath:item.downloadFolderPath error:nil];
//        [disPlayAry removeObject:icloudBackupEntityitem];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_alertViewController._removeprogressAnimationView setProgress:100];
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showRemoveSuccessAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:1];
                if (_dataSourceArray.count > 1) {
                    [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"iCloudBackup_View_Tips8_Complex", nil),(int)_dataSourceArray.count]];
                }else {
                    [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"iCloudBackup_View_Tips8", nil),(int)_dataSourceArray.count]];
                }
                [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor",nil)]];
                [_itemIcloudTableView reloadData];
            });
        });
    });
}

-(void)dofindPath:(id)sender{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup Find" label:Click transferCount:0 screenView:@"iCloud Backup Find" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    NSInteger tagRow = [_itemIcloudTableView  selectedRow];
    if (tagRow <0) {
        [self showAlertText:CustomLocalizedString(@"MSG_COM_No_Item_Selected", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else{
        NSMutableArray *disPlayAry = nil;
        if (_isSearch) {
            disPlayAry = _researchdataSourceArray;
        }else{
            disPlayAry = _dataSourceArray;
        }
        IMBiCloudBackupBindingEntity *icloudBackupEntityitem = [disPlayAry objectAtIndex:tagRow];
        if (icloudBackupEntityitem.loadType == iCloudDataComplete) {
            IMBiCloudBackup *item = icloudBackupEntityitem.backupItem;
            [workSpace openFile:item.downloadFolderPath];
        }else{
            [self showAlertText:CustomLocalizedString(@"icloud_backup_find_noComplete", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }
    }
}

-(void)reload:(id)sender{
    
    _isSearch = NO;
    _isDisable = YES;
    [_iCloudBox setContentView:_loadingView];
    [_downLoadQueue setCancel:YES];
    [_searchFieldBtn setStringValue:@""];
    for (IMBiCloudBackupBindingEntity *icloudBackupEntityitem in _dataSourceArray) {
        [icloudBackupEntityitem removeAllView];
        //        [icloudBackupEntityitem.progressView removeFromSuperview];
    }
    [_loadingAnimationView startAnimation];
   
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (_isComplete) {
            [self getDownloadCompleteData];
        }else{
            [self loadingData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_dataSourceArray.count > 0) {
                [_iCloudBox setContentView:_icloudView];
            }else {
                [_iCloudBox setContentView:_noDataView];
                [self configNoDataView];
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
            _isDisable = NO;
            [_loadingAnimationView endAnimation];
            [_itemIcloudTableView reloadData];
        });
    });
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"backupItem.deviceName CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        for (IMBiCloudBackupBindingEntity *icloudBackupEntityitem in _dataSourceArray) {
            [[icloudBackupEntityitem btniCloudCommon] removeFromSuperview];
        }
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    [_itemIcloudTableView reloadData];
}
@end
