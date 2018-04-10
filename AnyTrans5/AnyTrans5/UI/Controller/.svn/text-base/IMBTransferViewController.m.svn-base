//
//  IMBTransferViewController.m
//  AnyTrans
//
//  Created by iMobie on 8/1/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBTransferViewController.h"
#import "IMBMediaFileExport.h"
#import "IMBPhotoFileExport.h"
#import "IMBAnimation.h"
#import "IMBRecordingExport.h"
#import "IMBFileSystemExport.h"
#import "IMBiBooksExport.h"
#import "IMBAppExport.h"
#import "IMBVoicemailExport.h"
#import "IMBNoteExport.h"
#import "IMBMessageExport.h"
#import "IMBContactExport.h"
#import "IMBCalenderExport.h"
#import "IMBBookMarkExport.h"
#import "IMBCallHistoryExport.h"
#import "IMBSafariHistoryExport.h"
#import "IMBiTunesFileExport.h"
#import "IMBBackupExplorerExport.h"
//#import "IMBColorDefine.h"
#import "SystemHelper.h"
#import "IMBTransferToiTunes.h"
#import "IMBAirSyncImportTransfer.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBBaseViewController.h"
#import "IMBNotAirSyncImportTransfer.h"
#import "IMBNotificationDefine.h"
#import "ATTracker.h"
#import "CommonEnum.h"
#import "IMBiCloudDriverViewController.h"
#import "IMBPhotoToiCloud.h"
#import "IMBCalendarsToDevice.h"
#import "IMBiCloudMainPageViewController.h"
@interface IMBTransferViewController ()

@end

@implementation IMBTransferViewController
@synthesize delegate = _delegate;
@synthesize isiTunesImport = _isiTunesImport;
@synthesize isStop = _isStop;
@synthesize icloudManager = _icloudManager;
@synthesize isicloudView = _isicloudView;
@synthesize exportType = _exportType;
@synthesize isNoExecute = _isNoExecute;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        _exportType = 0;
    }
    return self;
}

//media、photo、audio等导出初始化
- (id)initWithIPodkey:(NSString *)ipodKey Type:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems ExportFolder:(NSString *)exportFolder {
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _transferType = TransferExport;
        _ipodKey = ipodKey;
        _category = category;
        _exportFolder = exportFolder;
        _selectedItems = [selectedItems retain];
        _isicloudView = NO;
    }
    return self;
}

- (id)initWithIPodkey:(NSString *)ipodKey Type:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems iCloudManager:(IMBiCloudManager *)iCloudManager
{
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _transferType = TransferToiCloud;
        _ipodKey = ipodKey;
        _category = category;
        _icloudManager = iCloudManager;
        _selectedItems = [selectedItems retain];
        _isicloudView = NO;
    }
    return self;

}

//message、note、callhistory、contact、calendar等导出初始化
- (id)initWithType:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems ExportFolder:(NSString *)exportFolder Mode:(NSString *)mode {
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _transferType = TransferExport;
        _category = category;
        _exportFolder = exportFolder;
        _selectedItems = [selectedItems retain];
        _mode = mode;
        _eventCategory = Device_Content;
        _isicloudView = NO;
    }
    return self;
}

- (id)initWithType:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems ExportFolder:(NSString *)exportFolder Mode:(NSString *)mode IsicloudView:(BOOL)isicloudView {
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _transferType = TransferExport;
        _category = category;
        _exportFolder = exportFolder;
        _selectedItems = [selectedItems retain];
        _mode = mode;
        _eventCategory = Device_Content;
        _isicloudView = isicloudView;
    }
    return self;
}

//backup目录结构导出初始化
- (id)initWithType:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems ExportFolder:(NSString *)exportFolder BackupPath:(NSString *)backupPath BackUpDecrypt:(IMBBackupDecryptAbove4 *)backUpDecrypt {
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _transferType = TransferExport;
        _category = category;
        _exportFolder = exportFolder;
        _selectedItems = [selectedItems retain];
        _backupPath = backupPath;
        _backUpDecrypt = backUpDecrypt;
        _eventCategory = iTunes_Backup;
        _isicloudView = NO;
    }
    return self;
}
- (id)initWithType:(CategoryNodesEnum)category withDelegate:(id)delegate withTransfertype:(TransferModeType)transferModeType{
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _category = category;
        _transferType = transferModeType;
        _delegate = delegate;
        _isicloudView = NO;
    }
    return self;
}

- (id)initWithType:(CategoryNodesEnum)category withDelegate:(id)delegate withTransfertype:(TransferModeType)transferModeType withIsicloudView:(BOOL)isicloudView {
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _category = category;
        _transferType = transferModeType;
        _delegate = delegate;
        _isicloudView = isicloudView;
    }
    return self;
}

//mac到设备初始化
- (id)initWithIPodkey:(NSString *)ipodKey Type:(CategoryNodesEnum)category importFiles:(NSMutableArray *)importFiles photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(int64_t)playlistID {
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _transferType = TransferImport;
        _ipodKey = ipodKey;
        _category = category;
        _selectedItems = [importFiles retain];
        if (photoAlbum != nil) {
            _photoAlbum = [photoAlbum retain];
        }
        _playlistID = playlistID;
        _eventCategory = Device_Content;
        _isicloudView = NO;
    }
    return self;
}

//导入file system
- (id)initWithIPodkey:(NSString *)ipodKey Type:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems curFolder:(NSString *)curFolder {
    self = [super initWithNibName:@"IMBTransferViewController" bundle:nil];
    if (self) {
        _ipodKey = ipodKey;
        _transferType = TransferImport;
        _category = category;
        _exportFolder = curFolder;
        _selectedItems = [selectedItems retain];
        _eventCategory = Device_Content;
        _isicloudView = NO;
    }
    return self;
}

//to iTunes初始化
- (id)initWithIPodkey:(NSString *)ipodKey SelectDic:(NSDictionary *)selectedDic {
    if (self = [super initWithNibName:@"IMBTransferViewController" bundle:nil]) {
        _transferType = TransferToiTunes;
        _category = 0;
        _ipodKey = ipodKey;
        _selectDic = [selectedDic retain];
        _eventCategory = Device_Content;
        _isicloudView = NO;
    }
    return self;
}

//设备到设备初始化
- (id)initWithIPodkey:(NSString *)srcIpodKey DesIpodKey:(NSString *)desIpodKey SelectDic:(NSDictionary *)selectedDic {
    if (self = [super initWithNibName:@"IMBTransferViewController" bundle:nil]) {
        _transferType = TransferToDevice;
        _ipodKey = srcIpodKey;
        _desIpodKey = desIpodKey;
        _selectDic = [selectedDic retain];
        _category = [[_selectDic objectForKey:@"category"] categoryNodes];
        _eventCategory = Device_Content;
        _isicloudView = NO;
    }
    return self;
}

//contact操作;
- (id)initWithContactManager:(IMBContactManager *)contactManager SelectFiles:(NSMutableArray *)selectFiles TransferModeType:(TransferModeType)type {
    if (self = [super initWithNibName:@"IMBTransferViewController" bundle:nil]) {
        _transferType = type;
        _selectedItems = [selectFiles retain];
        _contactManager = contactManager;
        _eventCategory = Device_Content;
        _isicloudView = NO;
    }
    return self;
}

- (void)setExprtPath:(NSString *)path {
    _downPath = [path retain];
    _isicloud = YES;
}

- (void)awakeFromNib {
    if (_transferType == TransferExport) {
        if (_exportType == 1) {
            _eventCategory = Device_Content;
        }else if (_exportType == 2) {
            _eventCategory = iTunes_Backup;
        }else if (_exportType == 3) {
            _eventCategory = iCloud_Content;
        }else {
            _eventCategory = iTunes_Library;
        }
    }

    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_bellImgView setHidden:NO];
        [_bellImgView setImage:[StringHelper imageNamed:@"christmas_bell"]];
        [_bellImgView setFrameOrigin:NSMakePoint(340, _bellImgView.frame.origin.y)];
        [_roseProgressBgImageView setHidden:YES];
        [_animateProgressView setDelegate:self];
    }else {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:YES];
    }
    //TODO:屏蔽语言选择-----long
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
    _androidAlertViewController = [[IMBAndroidAlertViewController alloc] initWithNibName:@"IMBAndroidAlertViewController" bundle:nil];
    [_androidAlertViewController setDelegate:self];
    
    _isTransferComplete = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_contentView.frame.origin.y + _contentView.frame.size.height - 12), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_contentProView addSubview:_closebutton];
    [_contentProView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor_top", nil)]];
    _textView.delegate = self;
    [_contentView addSubview:_proContentView];
    [_contentBox setContentView:_contentProView];
    [self addAnimationView];
    [self configTitle];
    [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    if (_transferType == TransferToiTunes) {
        [_titleStr setStringValue:CustomLocalizedString(@"Device_Main_id_3", nil)];
        _baseTransfer = [[IMBTransferToiTunes alloc] initWithIPodkey:_ipodKey exportDic:_selectDic withDelegate:self];
    }else if (_transferType == TransferExport) {
        [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[IMBCommonEnum categoryNodesEnumToName:_category]]];
        if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_Movies||_category == Category_TVShow||_category == Category_MusicVideo||_category == Category_PodCasts||_category == Category_iTunesU||_category == Category_Audiobook||_category == Category_Ringtone||_category == Category_Playlist||_category == Category_HomeVideo) {
            _baseTransfer = [[IMBMediaFileExport alloc] initWithIPodkey:_ipodKey exportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
        }else if (_category == Category_PhotoLibrary || _category == Category_PhotoStream || _category == Category_PhotoVideo || _category == Category_CameraRoll||_category==Category_TimeLapse||_category==Category_SlowMove||_category==Category_Panoramas||_category == Category_MyAlbums||_category == Category_PhotoShare||_category == Category_ContinuousShooting||_category == Category_LivePhoto||_category == Category_Screenshot||_category == Category_PhotoSelfies||_category == Category_Location||_category == Category_Favorite) {
            _baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:_ipodKey exportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
            [(IMBPhotoFileExport *)_baseTransfer setExportType:_exportType];
        }else if (_category == Category_VoiceMemos) {
            _baseTransfer = [[IMBRecordingExport alloc] initWithIPodkey:_ipodKey exportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
        }else if (_category == Category_System || _category == Category_Storage) {
            _baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:_ipodKey exportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
        }else if (_category == Category_iBooks) {
            _baseTransfer = [[IMBiBooksExport alloc] initWithIPodkey:_ipodKey exportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
        }else if (_category == Category_Applications) {
            _baseTransfer = [[IMBAppExport alloc] initWithIPodkey:_ipodKey exportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
        }else if (_category == Category_Voicemail) {
            _baseTransfer = [[IMBVoicemailExport alloc] initWithIPodkey:_ipodKey exportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
        }else if (_category == Category_Notes) {
            _baseTransfer = [[IMBNoteExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
        }else if (_category == Category_Message) {
            _baseTransfer = [[IMBMessageExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
        }else if (_category == Category_Calendar || _category == Category_Reminder){
            _baseTransfer = [[IMBCalenderExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
            if(_category == Category_Reminder ) {
                _baseTransfer.isReminder = YES;
            }else {
                _baseTransfer.isReminder = NO;
            }
        }else if (_category == Category_Bookmarks) {
            _baseTransfer = [[IMBBookMarkExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
        }else if (_category == Category_Contacts){
            _baseTransfer = [[IMBContactExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
        }else if (_category == Category_CallHistory){
            _baseTransfer = [[IMBCallHistoryExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
        }else if (_category == Category_SafariHistory){
            _baseTransfer = [[IMBSafariHistoryExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
        }else if (_category == Category_Explorer) {
            _baseTransfer = [[IMBBackupExplorerExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withDelegate:self backupPath:_backupPath backUpDecrypt:_backUpDecrypt];
        }else {
            _baseTransfer = [[IMBiTunesFileExport alloc] initWithExportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
        }
    } else if (_transferType == TransferImport) {
        if (_category == Category_Summary || _category == category_iCloudUp) {
             [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_86", nil)]];
        }else if (_category == Category_System || _category == Category_Storage) {
            [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_81", nil)]];
        }else {
            [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[IMBCommonEnum categoryNodesEnumToName:_category]]];
        }
        if (_category == Category_System || _category == Category_Storage) {
            _baseTransfer = [[IMBBaseTransfer alloc] initWithIPodkey:_ipodKey importTracks:_selectedItems withCurrentPath:_exportFolder withDelegate:self];
        }else if (_category != category_iCloudUp){
            IMBiPod *ipod = [[IMBDeviceConnection singleton] getIPodByKey:_ipodKey];
            if (ipod.deviceInfo.airSync) {
                _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:_ipodKey importFiles:_selectedItems CategoryNodesEnum:_category photoAlbum:_photoAlbum playlistID:_playlistID delegate:self];
                ((IMBAirSyncImportTransfer *)_baseTransfer)->_isiTunesImport = _isiTunesImport;
            }else{
               _baseTransfer = [[IMBNotAirSyncImportTransfer alloc] initWithIPodkey:_ipodKey importFiles:_selectedItems CategoryNodesEnum:_category photoAlbum:_photoAlbum playlistID:_playlistID delegate:self];
                ((IMBAirSyncImportTransfer *)_baseTransfer)->_isiTunesImport = _isiTunesImport;
            }
        }
    }else if (_transferType == TransferToDevice) {
        [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[IMBCommonEnum categoryNodesEnumToName:_category]]];
        NSArray *selectAry = [_selectDic objectForKey:@"selectArr"];
        IMBCategoryInfoModel *model = [_selectDic objectForKey:@"category"];
        NSArray *playlistAry = nil;
        if ([_selectDic.allKeys containsObject:@"playlists"]) {
            playlistAry = [_selectDic objectForKey:@"playlists"];
        }
        IMBPhotoEntity *photoEntity = nil;
        if ([_selectDic.allKeys containsObject:@"albumentity"]) {
            photoEntity = [_selectDic objectForKey:@"albumentity"];
        }
        if (_category == Category_Calendar) {
            _baseTransfer = [[IMBCalendarsToDevice alloc] initWithCalendarID:[_selectDic objectForKey:@"calendarID"] selectedArray:selectAry desiPodKey:_desIpodKey delegate:self];
        }else {
            _baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:_ipodKey desIpodKey:_desIpodKey withPlaylistArray:playlistAry albumEntity:photoEntity Delegate:self];
        }
    }else if (_transferType == TransferToContact) {
        [_titleStr setStringValue:CustomLocalizedString(@"MSG_COM_Send_To_Contact", nil)];
        _baseTransfer = [[IMBContactExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
    }else if (_transferType == TransferImportContacts) {
        [_titleStr setStringValue:CustomLocalizedString(@"MSG_COM_Import_Contact", nil)];
        _baseTransfer = [[IMBContactExport alloc] initWithPath:_exportFolder exportTracks:_selectedItems withMode:_mode withDelegate:self];
        [(IMBContactExport *)_baseTransfer setContactManager:_contactManager];
    }else if (_transferType == TransferDownLoad||_transferType == TransferUpLoading||_transferType == TransferSync){
        [_animateProgressView setDelegate:self];
        NSString *titStr = @"";
        if (_category == Category_PhotoLibrary) {
            titStr = CustomLocalizedString(@"DeviceView_id_6", nil);
        }else if (_category == Category_Notes) {
            titStr = CustomLocalizedString(@"Calendar_id_11", nil);
        }else if (_category == Category_Calendar ){
            titStr = CustomLocalizedString(@"MenuItem_id_62", nil);
        }else if (_category == Category_Reminder){
            titStr = CustomLocalizedString(@"Reminders_id", nil);
        }else if (_category == Category_Contacts){
            titStr = CustomLocalizedString(@"MenuItem_id_20", nil);
        }else if (_category == Category_iCloudDriver) {
          titStr = CustomLocalizedString(@"icloud_drive", nil);
        }else if (_category == Category_Photo) {
            titStr = CustomLocalizedString(@"DeviceView_id_6", nil);
        }
        [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),titStr]];
        [_titleStr setStringValue:titStr];
    }else if (_transferType == TransferToiCloud){
        [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[IMBCommonEnum categoryNodesEnumToName:_category]]];
        if (_category == Category_Photo|| _category == Category_CameraRoll || _category ==Category_PhotoStream ||_category ==Category_PhotoLibrary ||_category == Category_PhotoShare || _category ==Category_Panoramas || _category == Category_ContinuousShooting || _category == Category_LivePhoto || _category == Category_Screenshot || _category == Category_PhotoSelfies || _category == Category_Location || _category == Category_Favorite) {
            _baseTransfer = [[IMBPhotoToiCloud alloc] initWithIPodkey:_ipodKey importTracks:_selectedItems withiCloudManager:_icloudManager CategoryNodesEnum:_category  withDelegate:self];
        }
    }
    if (!_isNoExecute) {
        [self performSelector:@selector(startTransfer) withObject:nil afterDelay:0.5];
    }
}

- (void)addAnimationView {
    if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_Movies||_category == Category_TVShow||_category == Category_MusicVideo||_category == Category_PodCasts||_category == Category_iTunesU||_category == Category_Audiobook||_category == Category_Ringtone||_category == Category_Playlist||_category == Category_HomeVideo) {
        _animationType = MediaAnimation;
        [_mediaAnimationView setFrameOrigin:NSMakePoint(50, 188)];
        [_contentView addSubview:_mediaAnimationView];
    }else {
        int value = arc4random() % 3;
        if (value == 0) {
            _animationType = CustomAnimation;
            [self setBoatAnimationImage:_customAnimationView];
            [_customAnimationView setFrameOrigin:NSMakePoint(50, 188)];
            [_contentView addSubview:_customAnimationView];
        }else if (value == 1) {
            _animationType = CarAnimation;
            [self setBoatAnimationImage:_carAnimationView];
            if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
                [_carAnimationView setFrameOrigin:NSMakePoint(50, 238)];
            }else {
                [_carAnimationView setFrameOrigin:NSMakePoint(50, 198)];
            }
            [_contentView addSubview:_carAnimationView];
        }else if (value == 2) {
            _animationType = BoatAnimation;
            [self setBoatAnimationImage:_boatAnimationView];
            if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
                [_boatAnimationView setFrameOrigin:NSMakePoint(50, 238)];
            }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
                [_boatAnimationView setFrameOrigin:NSMakePoint(50, 214)];
            }else {
                [_boatAnimationView setFrameOrigin:NSMakePoint(50, 198)];
            }
            [_contentView addSubview:_boatAnimationView];
        }else {
            _animationType = CustomAnimation;
            [self setBoatAnimationImage:_carAnimationView];
            [_customAnimationView setFrameOrigin:NSMakePoint(50, 188)];
            [_contentView addSubview:_customAnimationView];
        }
    }
}

- (void)setBoatAnimationImage:(NSView *)animationView {
    if (_animationType == CarAnimation) {
        if (_transferType == TransferToiTunes) {
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_iTunes1"]];
        }else {
            if (_category == Category_PhotoLibrary) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photolibrarynew1"]];
            }if (_category == Category_Photo) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_iCloud_photoNew1"]];
            }else if (_category == Category_PhotoStream) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_streamnew1"]];
            }else if (_category == Category_PhotoVideo) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_videosnew1"]];
            }else if (_category == Category_CameraRoll) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_camera_rollnew1"]];
            }else if (_category == Category_TimeLapse) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_delaynew1"]];
            }else if (_category == Category_SlowMove) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_slo_monew1"]];
            }else if (_category == Category_Panoramas) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_panoramicnew1"]];
            }else if (_category == Category_MyAlbums) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_myalbumsnew1"]];
            }else if (_category == Category_PhotoShare) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_sharenew1"]];
            }else if (_category == Category_ContinuousShooting) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_burstnew1"]];
            }else if (_category == Category_VoiceMemos) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_voice_memosnew1"]];
            }else if (_category == Category_System) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_systemnew1"]];
            }else if (_category == Category_Storage) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_storage1"]];
            }else if (_category == Category_iBooks) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_ibooknew1"]];
            }else if (_category == Category_Applications) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_appsnew1"]];
            }else if (_category == Category_Voicemail) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_voicemailnew1"]];
            }else if (_category == Category_Notes) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_notenew1"]];
            }else if (_category == Category_Message) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_messagenew1"]];
            }else if (_category == Category_Calendar){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_calendarnew1"]];
            }else if (_category == Category_Bookmarks) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_bookmarksnew1"]];
            }else if (_category == Category_Contacts){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_contactsnew1"]];
            }else if (_category == Category_CallHistory){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_callhistory1"]];
            }else if (_category == Category_SafariHistory){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_safari_historynew1"]];
            }else if (_category == Category_Explorer) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_explore1"]];
            }else if (_category == Category_iCloudDriver) {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"iCloud_iClouddriver"]];
            }else if (_category == Category_Reminder){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_remindernew1"]];
            }else if (_category == Category_LivePhoto){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_livephotonew1"]];
            }else if (_category == Category_Screenshot){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_screenshootnew1"]];
            }else if (_category == Category_PhotoSelfies){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_selfnew1"]];
            }else if (_category == Category_Favorite){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_favoritenew1"]];
            }else if (_category == Category_Location){
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_locationnew1"]];
            }else {
                [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photolibrarynew1"]];
            }
        }
    }else {
        if (_transferType == TransferToiTunes) {
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_iTunes1"]];
        }else {
            if (_category == Category_PhotoLibrary) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photolibrarynew1"]];
            }if (_category == Category_Photo) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_iCloud_photoNew1"]];
            }else if (_category == Category_PhotoStream) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_streamnew1"]];
            }else if (_category == Category_PhotoVideo) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_videosnew1"]];
            }else if (_category == Category_CameraRoll) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_camera_rollnew1"]];
            }else if (_category == Category_TimeLapse) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_delaynew1"]];
            }else if (_category == Category_SlowMove) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_slo_monew1"]];
            }else if (_category == Category_Panoramas) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_panoramicnew1"]];
            }else if (_category == Category_MyAlbums) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_myalbumsnew1"]];
            }else if (_category == Category_PhotoShare) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_sharenew1"]];
            }else if (_category == Category_ContinuousShooting) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_burstnew1"]];
            }else if (_category == Category_VoiceMemos) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_voice_memosnew1"]];
            }else if (_category == Category_System) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_systemnew1"]];
            }else if (_category == Category_Storage) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_storage1"]];
            }else if (_category == Category_iBooks) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_ibooknew1"]];
            }else if (_category == Category_Applications) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_appsnew1"]];
            }else if (_category == Category_Voicemail) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_voicemailnew1"]];
            }else if (_category == Category_Notes) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_notenew1"]];
            }else if (_category == Category_Message) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_messagenew1"]];
            }else if (_category == Category_Calendar){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_calendarnew1"]];
            }else if (_category == Category_Reminder){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_remindernew1"]];
            }else if (_category == Category_Bookmarks) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_bookmarksnew1"]];
            }else if (_category == Category_Contacts){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_contactsnew1"]];
            }else if (_category == Category_CallHistory){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_callhistory1"]];
            }else if (_category == Category_SafariHistory){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_safari_historynew1"]];
            }else if (_category == Category_Explorer) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_explore1"]];
            }else if (_category == Category_iCloudDriver) {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"iCloud_iClouddriver"]];
            }else if (_category == Category_LivePhoto){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_livephotonew1"]];
            }else if (_category == Category_Screenshot){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_screenshootnew1"]];
            }else if (_category == Category_PhotoSelfies){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_selfnew1"]];
            }else if (_category == Category_Favorite){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_favoritenew1"]];
            }else if (_category == Category_Location){
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photo_locationnew1"]];
            }else {
                [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photolibrarynew1"]];
            }
        }
    }
}

- (void)configTitle {
    [_noteImageView setImage:[StringHelper imageNamed:@"transfer_note"]];
    [_backUpProgressLable setStringValue:@""];
    NSString *str = nil;
    if (_isicloudView) {
        str = CustomLocalizedString(@"icloud_TransferDevice_Message_Caution", nil);
    } else {
        str = CustomLocalizedString(@"TransferDevice_Message_Caution", nil);
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init] ;
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontNameAttribute,style,NSParagraphStyleAttributeName, nil];
    NSSize size = [str sizeWithAttributes:dic];
    [_noteImageView setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 , _noteImageView.frame.origin.y)];
    [_promptLabel setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 + 22, _promptLabel.frame.origin.y)];

    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:str?:@""];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_warningColor", nil)] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as2.length)];
    [_promptLabel setAttributedStringValue:as2];
    [as2 release], as2 = nil;
    [style release], style = nil;
}

- (void)continueloadData{
    [_condition lock];
    if(_isPause)
    {
        _isPause = NO;
        [_condition signal];
    }
    [_condition unlock];
}

-(void)showAlert{
    if (_alertViewController.isIcloudOneOpen) {
        _isPause = YES;
        [self showiCloudAnnoyAlertTitleText:CustomLocalizedString(@"iclouddriver_annoyView_titleStr", nil) withSubStr:CustomLocalizedString(@"iclouddriver_annoyView_subtitleStr", nil) withImageName:@"iCloud_pause" buyButtonText:CustomLocalizedString(@"harassment_buyBtn", nil) CancelButton:CustomLocalizedString(@"iCloudBackup_View_Tips3", nil)];
    }
}

- (void)showiCloudAnnoyAlertTitleText:(NSString *)titleText withSubStr:(NSString *)subText withImageName:(NSString *)imageName buyButtonText:(NSString *)OkText CancelButton:(NSString *)cancelText{
    
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    _alertViewController.isIcloudOneOpen = NO;
    [_alertViewController showiCloudAnnoyAlertTitleText:titleText withSubStr:subText withImageName:imageName buyButtonText:OkText CancelButton:cancelText SuperView:view];
}

- (void)startTransfer {
    if (_animationType == CustomAnimation) {
        [_customAnimationView startAnimation];
    }else if (_animationType == MediaAnimation) {
        [_mediaAnimationView startAnimation];
    }else if (_animationType == CarAnimation) {
        [_carAnimationView startAnimation];
    }else if (_animationType == BoatAnimation) {
        [_boatAnimationView startAnimation];
    }
   
    if (_isicloudView) {
        OperationLImitation *oeprtionlimit = [OperationLImitation singleton];
        [oeprtionlimit setNeedlimit:NO];
    }
    
    if (_category == category_iCloudUp) {
        _condition = [[NSCondition alloc] init];
        if (![IMBSoftWareInfo singleton].isRegistered) {
//            _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
            _alertViewController.isIcloudOneOpen = YES;
            _alertViewController.delegate = self;
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_category == category_iCloudUp) {
            [self transferPrepareFileEnd];
            [self transferProgress:0.0];
            int totalCount = 0;
            int successCount = 0;
            int currentCount = 0;
            for (int i=0;i<[_selectedItems count];i++) {
                if (i==0) {
                    NSArray *photoArray = [_selectedItems objectAtIndex:i];
                    totalCount += [photoArray count];
                }else if (i==1){
                    NSArray *contactArray = [_selectedItems objectAtIndex:i];
                    totalCount += [contactArray count];
                }else if (i==2){
                    NSArray *noteArray = [_selectedItems objectAtIndex:i];
                    totalCount += [noteArray count];

                }
            }
            for (int i=0;i<[_selectedItems count];i++) {
                if (_isStop) {
                    break;
                }
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];

                if (i==0) {
                   
                    NSArray *photoArray = [_selectedItems objectAtIndex:i];
                    if ([photoArray count]>0) {
                        [self transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_9", nil)]];
                    }
                    for (IMBPhotoEntity *photo in photoArray) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        currentCount++;
                        if ([_icloudManager uploadPhoto:photo.photoPath withContainerId:nil]) {
                            successCount += 1;
                        }
                        [self transferProgress:currentCount/(totalCount*1.0)*100.0];
                    }
                    
                }else if (i==1){
                    NSMutableArray *mArray = [NSMutableArray array];
                    NSArray *contactArray = [_selectedItems objectAtIndex:i];
                    for (IMBContactEntity *contact in contactArray) {
                        CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                        NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                        [contact setContactId:guid];
                        [mArray addObject:contact];
                    }
                    currentCount += [contactArray count];
                    successCount += [contactArray count];
                    if ([mArray count] > 0) {
                        [self transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_20", nil)]];
                        [_icloudManager importContact:mArray];
                    }
                    [self transferProgress:currentCount/(totalCount*1.0)*100.0];
                    sleep(2);
                }else if (i==2){
                    NSArray *noteArray = [_selectedItems objectAtIndex:i];
                    NSMutableArray *array = [NSMutableArray array];
                    for (IMBNoteModelEntity *entity in noteArray) {
                        if (entity.content != nil) {
//                            [array addObject:entity.content];
                            IMBUpdateNoteEntity *noteEntity = [[IMBUpdateNoteEntity alloc] init];
                            noteEntity.noteContent = [entity.content stringByReplacingOccurrencesOfString:@"Ôøº" withString:@""];
                            noteEntity.timeStamp = entity.modifyDate;
                            [array addObject:noteEntity];
                            [noteEntity release];
                        }
                    }
                    if ([array count] > 0) {
                        [self transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_17", nil)]];
                        BOOL success = [_icloudManager addNoteData:array];
                        if (success) {
                            successCount += [noteArray count];
                        }
                    }
                    currentCount += [noteArray count];
                    [self transferProgress:currentCount/(totalCount*1.0)*100.0];
                    sleep(2);
                }
            }
            [self transferComplete:successCount TotalCount:totalCount];

        }else{
            if (_transferType == TransferToContact) {
                [(IMBContactExport *)_baseTransfer exportToContacts];
            }else if (_transferType == TransferImportContacts) {
                [(IMBContactExport *)_baseTransfer importContactVCF];
            }else {
                if ( _transferType == TransferSync && (_category == Category_Contacts || _category == Category_Notes || _category == Category_Calendar || _category == Category_Photo || _category == Category_PhotoVideo || _category == Category_Reminder) ) {
                    [_closebutton setEnabled:NO];
                }
                [_baseTransfer startTransfer];
            }
        }
        
    });
}

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
            [_titleStr setStringValue:file];
            [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            
//            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:file?:@""];
//            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
//            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
//            [_backUpProgressLable setAttributedStringValue:as];
//            [as release], as = nil;
        }
    });
}
//传输准备进度结束
- (void)transferPrepareFileEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_animateProgressView removeAnimationImgView];
        [_animateProgressView startAnimation];
    });
}

- (void)startTransAnimation{
    [_animateProgressView setLoadAnimation];
}
//传输进度
- (void)transferProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_animateProgressView setProgress:progress];
    });
}
//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![TempHelper stringIsNilOrEmpty:file]) {
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:file?:@""];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
            [_backUpProgressLable setAttributedStringValue:as];
            [as release], as = nil;
        }
    });
}
//分析进度
- (void)parseProgress:(float)progress {
    
}
//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    
}

//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }
    _successCount = successCount;
    _totalCount = totalCount;
    if (_successCount > _totalCount) {
        _totalCount = _successCount;
    }
    OperationLImitation *oeprtionlimit = [OperationLImitation singleton];
    [oeprtionlimit setNeedlimit:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
       // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        if (_transferType == TransferToiTunes) {
            if (successCount > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOAD_ITUNES_DATA object:nil];
            }
        }
        _isTransferComplete = YES;
        //如果有下拉窗口，将其移除掉
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
                view = subView;
                break;
            }
        }
        NSArray *arrayView = view.subviews;
        int count = (int)arrayView.count;
        for (int i = 0; i < count; i ++) {
            NSView *view = [arrayView objectAtIndex:i];
            [view removeFromSuperview];
        }
        
        [_closebutton setEnabled:YES];
        
        if (_transferType == TransferToContact) {
            //弹出Contacts窗口
            char *ch = "open /Applications/Contacts.app";
            system(ch);
        }
        [_animateProgressView stopAnimation];
        if (_animationType == CustomAnimation) {
            [_customAnimationView stopAnimation];
        }else if (_animationType == MediaAnimation) {
            [_mediaAnimationView stopAnimation];
        }else if (_animationType == CarAnimation) {
            [_carAnimationView stopAnimation];
        }else if (_animationType == BoatAnimation) {
            [_boatAnimationView stopAnimation];
        }
        [_proContentView removeFromSuperview];
        
        if ((_transferType == TransferImport || _transferType == TransferImportContacts) && _delegate != nil) {
            if ([_delegate respondsToSelector:@selector(reload:)]) {
                [_delegate reload:nil];
            }
        }
        if (_category == Category_Summary) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_AddCONTENT_SUCCESSED object:nil];
        }
        if (![IMBSoftWareInfo singleton].isRegistered && (_isicloudView || _exportType == 3) && ![IMBSoftWareInfo singleton].isNOAdvertisement) {
            if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
                [self configEniCloudCompleteView];
                [_contentBox setContentView:_resultView];
            } else {
                [self configMuiCloudCompleteView];
                [_contentBox setContentView:_muicloudCompleteView];
            }
            
        }else {
            if ([IMBSoftWareInfo singleton].isRegistered || _successCount == 0) {
                NSString *str3 = CustomLocalizedString(@"Transfer_text_id_4", nil);
                NSMutableAttributedString *as3 = [[NSMutableAttributedString alloc] initWithString:str3?:@""];
                if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
                    [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:30] range:NSMakeRange(0, as3.length)];
                }else {
                    [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:30] range:NSMakeRange(0, as3.length)];
                }
                [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as3.length)];
                [as3 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as3.length)];
                [_resultMainStr setAttributedStringValue:as3];
                [as3 release], as3 = nil;
                
                NSString *transfercountStr = nil;
                NSString *str;
                if (_successCount > 1) {
                    transfercountStr = [NSString stringWithFormat:@"%d/%d",_successCount,totalCount];
                    str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tips", nil),transfercountStr];
                }else {
                    transfercountStr = [NSString stringWithFormat:@"%d/%d",_successCount,totalCount];
                    str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tip", nil),transfercountStr];
                }
                NSMutableAttributedString *as4 = [[NSMutableAttributedString alloc] initWithString:str?:@""];
                [as4 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as4.length)];
                [as4 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, as4.length)];
                [as4 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:NSMakeRange(0, as4.length)];
                [as4 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as4.length)];
                [[_resultSubTextView textStorage] setAttributedString:as4];
                [as4 autorelease], as4 = nil;
                
                if (_successCount < totalCount && [IMBTransferError singleton].errorArrayM.count > 0) {
                    
                    NSString *promptStr = @"";
                    NSString *overStr1 = @"";
                    NSString *overStr2 = @"";
                    NSString *overStr3 = @"";
                    if (_transferType == TransferToDevice || _transferType == TransferToiTunes  || _transferType == TransferImport || _transferType == TransferImportContacts || _transferType == TransferToContact || _transferType == TransferUpLoading||_transferType == TransferSync || _transferType == TransferToiCloud) {
                        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_viewfile", nil), CustomLocalizedString(@"Show_ResultWindow_linkTips", nil),CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)];
                        overStr1 = CustomLocalizedString(@"Show_ResultWindow_linkTips", nil);
                        overStr2 = CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil);
                    }else{
                        promptStr = [[[[[[[[CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil) stringByAppendingString:CustomLocalizedString(@"  ", nil)] stringByAppendingString:CustomLocalizedString(@"|", nil)] stringByAppendingString:CustomLocalizedString(@"  ", nil)] stringByAppendingString:CustomLocalizedString(@"Show_Transfer_text_complete_viewfile_2", nil)] stringByAppendingString:CustomLocalizedString(@"  ", nil)] stringByAppendingString:CustomLocalizedString(@"|", nil)] stringByAppendingString:CustomLocalizedString(@"  ", nil)] stringByAppendingString:CustomLocalizedString(@"Show_ResultWindow_linkTips", nil)];
                        overStr1 = CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil);
                        overStr2 = CustomLocalizedString(@"Show_Transfer_text_complete_viewfile_2", nil);
                        overStr3 = CustomLocalizedString(@"Show_ResultWindow_linkTips", nil);
                    }
                    
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
                    
                    NSRange infoRange3 = [promptStr rangeOfString:overStr3];
                    [promptAs addAttribute:NSLinkAttributeName value:overStr3 range:infoRange3];
                    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange3];
                    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange3];
                    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange3];
                    
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
                    NSString *overStr2 = @"";
                    if (_transferType == TransferToDevice || _transferType == TransferToiTunes  || _transferType == TransferImport || _transferType == TransferImportContacts || _transferType == TransferToContact || _transferType == TransferUpLoading||_transferType == TransferSync || _transferType == TransferToiCloud) {
                        promptStr = CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil);
                        overStr1 = CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil);
                    }else{
                        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_viewfile", nil), CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil),CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)];
                        overStr1 = CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil);
                        overStr2 = CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil);
                    }
                    
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
                }
                [_contentView addSubview:_resultContentView];
            }else {
                OperationLImitation *limitation = [OperationLImitation singleton];
                NSDictionary *dimensionDict = nil;
                if (limitation.remainderCount <= 0) {
                    @autoreleasepool {
                        [limitation setLimitStatus:@"noquote"];
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:AnyTrans_Activation action:AdAnnoy actionParams:@"noquote" label:LabelNone transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    [self configRunOutDayCompleteView];
                    [_contentBox setContentView:_runOutDayCompleteView];
                }else {
                    @autoreleasepool {
                        [limitation setLimitStatus:@"completed"];
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:AnyTrans_Activation action:AdAnnoy actionParams:@"completed" label:LabelNone transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    [self configUnregisteredCompleteView];
                    [_contentBox setContentView:_unregisteredResultView];
                }
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
            }
        }
        
        EventAction action = ActionNone;
        if (_transferType == TransferToiTunes) {
            action = ToiTunes;
        }else if (_transferType == TransferExport) {
            action = ContentToMac;
        }else if (_transferType == TransferImport) {
            action = Import;
        }else if (_transferType == TransferToDevice) {
            action = ToDevice;
        }
        NSString *params = [IMBCommonEnum attrackerCategoryNodesEnumToString:_category];
        if ([params isEqualToString:@"Summary"]) {
            params = @"Content";
        }
        if (!_isicloudView) {
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:_eventCategory action:action actionParams:params label:Finish transferCount:successCount screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        }
    });
}

-(EventAction) categorytransferTypeToString:(TransferModeType)categoryEnum{
    switch (_transferType) {
        case TransferToDevice:
            return ToDevice;
            break;
        case TransferToiTunes:
            return ToiTunes;
            break;
        case TransferImport:
            return Import;
            break;
        case TransferImportContacts:
            return Import;
            break;
        case TransferToContact:
            return ContentToMac;
            break;
        default:
            return ContentToMac;
            break;
    }
    
}

#pragma mark - textView Delegete
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    NSString *moreItemStr = nil;
    if ([link isEqualToString:CustomLocalizedString(@"Annoy_Runout_Number_ThirdPart_SubTitle_2", nil)]) {
        //气泡的形式弹出注册窗口
        if (_activatePopover != nil) {
            if (_activatePopover.isShown) {
                [_activatePopover close];
                return YES;
            }
        }
        if (_activatePopover != nil) {
            [_activatePopover release];
            _activatePopover = nil;
        }
        _activatePopover = [[NSPopover alloc] init];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
            _activatePopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
        }else {
            _activatePopover.appearance = NSPopoverAppearanceMinimal;
        }
        
        _activatePopover.animates = YES;
        _activatePopover.behavior = NSPopoverBehaviorApplicationDefined;
        _popoverViewController = [[IMBPopoverActivateViewController alloc] initWithDelegate:self];
        if (_activatePopover != nil) {
            _activatePopover.contentViewController = _popoverViewController;
        }
        
        [_popoverViewController release];
        NSRectEdge prefEdge = NSMinYEdge;
        
        
        int x = 175;
        if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
            x = 175;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
            x = 215;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
            x = 200;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
            x = 175;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
            x = 140;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
            x = 175;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            x = 30;
        }
        
        NSRect rect = NSMakeRect(x, textView.bounds.origin.y - 16, 410, 84);
        [_activatePopover showRelativeToRect:rect ofView:textView preferredEdge:prefEdge];
    }else {
        if (_successCount < _totalCount && [IMBTransferError singleton].errorArrayM.count > 0) {
            if (_transferType == TransferToDevice || _transferType == TransferToiTunes  || _transferType == TransferImport || _transferType == TransferImportContacts || _transferType == TransferToContact || _transferType == TransferUpLoading||_transferType == TransferSync || _transferType == TransferToiCloud) {
                moreItemStr = CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil);
            } else {
                moreItemStr = CustomLocalizedString(@"Show_Transfer_text_complete_viewfile_2", nil);
            }
            if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil)]) {
                //查看传输完成的内容
                if (_transferType == TransferToContact) {
                    //弹出Contacts窗口
                    char *ch = "open /Applications/Contacts.app";
                    system(ch);
                }else {
                    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
                    if (_isicloud) {
                        [workSpace selectFile:nil inFileViewerRootedAtPath:_downPath];
                    }else{
                        [workSpace selectFile:nil inFileViewerRootedAtPath:_exportFolder];
                    }
                }
            }else if ([link isEqualToString:moreItemStr]) {
                //传输不是全部成功的时候点击传输更多
                if (_transferType == TransferUpLoading) {
                    [(IMBiCloudDriverViewController *)_delegate iCloudReload:nil];
                }
                [self closeWindow:nil];
                
            } else if ([link isEqualToString: CustomLocalizedString(@"completeActivity_LinkTip", nil)]) {
                //活动界面点击链接
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
            }
        } else {
            if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil)]) {
                NSLog(@"%@",CustomLocalizedString(@"Transfer_text_complete_viewfile_1", nil));
                if (_transferType == TransferToContact) {
                    //弹出Contacts窗口
                    char *ch = "open /Applications/Contacts.app";
                    system(ch);
                }else {
                    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
                    if (_isicloud) {
                        [workSpace selectFile:nil inFileViewerRootedAtPath:_downPath];
                    }else{
                        [workSpace selectFile:nil inFileViewerRootedAtPath:_exportFolder];
                    }
                }
            }else if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)] || [link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil)]) {
                //点击传输更多
                if (_transferType == TransferUpLoading) {
                    [(IMBiCloudDriverViewController *)_delegate iCloudReload:nil];
                }else if (_transferType == TransferSync){
                    
                }
                [self closeWindow:nil];
                
            } else if ([link isEqualToString: CustomLocalizedString(@"completeActivity_LinkTip", nil)]) {
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
        }
    }
    return YES;
}

- (void)activateSuccess {
    [self closeWindow:nil];
}

- (IBAction)closeWindow:(id)sender {
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }
    if (_activatePopover != nil) {
        if (_activatePopover.isShown) {
            [_activatePopover close];
        }
    }
    if (!_isTransferComplete) {
        if (_baseTransfer != nil) {
            [_baseTransfer pauseScan];
        }
        if (_transferType == TransferDownLoad||_transferType == TransferUpLoading) {
            [(IMBiCloudDriverViewController *)_delegate setIsPause:YES];
        }
        [_alertViewController setIsStopPan:YES];
        int result = [self showAlertText:CustomLocalizedString(@"Main_Window_Stop_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
        [_alertViewController setIsStopPan:NO];
        if (result) {
            OperationLImitation *oeprtionlimit = [OperationLImitation singleton];
            [oeprtionlimit setNeedlimit:YES];
            if (_transferType == TransferDownLoad||_transferType == TransferUpLoading) {
                [[_delegate condition] lock];
                [[_delegate iCloudManager] cancel];
                [_delegate setIsStop:YES];
                [_delegate setIsPause:NO];
                [[_delegate condition] signal];
                [[_delegate condition] unlock];
                [_delegate cancelTimerData];
//                [self animationRemoveTransferView];
            }else if (_transferType == TransferSync){
                [_delegate cancelTimerData];
                [self animationRemoveTransferView];
            }else{
                _isStop = YES;
                [_icloudManager cancel];
                if (_baseTransfer != nil) {
                    [_closebutton setEnabled:NO];
                    [_baseTransfer stopScan];
                    [_baseTransfer resumeScan];
                    [_titleStr setStringValue:CustomLocalizedString(@"ImportSync_id_5", nil)];
                }
            }
         
//            [self animationRemoveTransferView];
        }else {
            if (_transferType == TransferDownLoad||_transferType == TransferUpLoading) {
                [[_delegate condition] lock];
                if([_delegate isPause])
                {
                    [_delegate setIsPause:NO];
                    [[_delegate condition] signal];
                }
                [[_delegate condition] unlock];
            }else if (_transferType == TransferSync){
//                [self animationRemoveTransferView];
            }else{
                if (_baseTransfer != nil) {
                    [_baseTransfer resumeScan];
                }
            }
 
//            [[(IMBiCloudDriverViewController *)_delegate iCloudManager] cancel];
          
        }
    }else {
        [[IMBTransferError singleton] removeAllError];
        if (_transferType == TransferUpLoading) {
            [(IMBiCloudDriverViewController *)_delegate iCloudReload:nil];
        }else if (_transferType == TransferSync){
            [_delegate cancelTimerData];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        [self animationRemoveTransferView];
        
        if ([_delegate respondsToSelector:@selector(closeResultWindow:)]) {
            [_delegate closeResultWindow:nil];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_IPOD object:nil];
}

- (void)animationRemoveTransferView {
    //放开语言设置按钮-----long
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    [_contentView setAutoresizingMask:NSViewMinYMargin];
    [self.view setFrame:NSMakeRect(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0 ]Y:[NSNumber numberWithInt:20] repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
    } completionHandler:^{
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:20] Y:[NSNumber numberWithInt:-self.view.frame.size.height] repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
        if (_delegate && [_delegate respondsToSelector:@selector(setTrackingAreaEnable:)]) {
            [_delegate setTrackingAreaEnable:YES];
        }
    }];
    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:0.6];
}

- (IBAction)doViewExportFile:(id)sender {
    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    [workSpace selectFile:nil inFileViewerRootedAtPath:_exportFolder];
}

- (IBAction)doBack:(id)sender {
    [self.view setWantsLayer:YES];
    [self.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-self.view.frame.size.height] repeatCount:1] forKey:@"moveY"];
    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:0.5];
}

- (void)removeAnimationView {
    [self.view removeFromSuperview];
}

#pragma mark - Alert
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            [view setHidden:NO];
            break;
        }
    }
    [view setHidden:NO];
    return [_alertViewController showAlertText:alertText OKButton:OkText CancelButton:cancelText SuperView:view];
}

- (void)moveBellImageView:(int)moveX {
    if (_bellImgView != nil) {
        [_bellImgView setFrameOrigin:NSMakePoint(340 + moveX, _bellImgView.frame.origin.y)];
    }
}

#pragma mark - iCloud完成活动界面 - 英语版
- (void)configEniCloudCompleteView {
    if (_closebutton) {
        [_closebutton release];
        _closebutton = nil;
    }
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_atResultView.frame.origin.y + _atResultView.frame.size.height - 38), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_resultView addSubview:_closebutton];
    
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
    
    if (_closebutton) {
        [_closebutton release];
        _closebutton = nil;
    }
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_muAtCompleteView.frame.origin.y + _muAtCompleteView.frame.size.height - 38), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_muicloudCompleteView addSubview:_closebutton];
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
        } else {
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
        }else {
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

#pragma mark - 未注册结果页面
- (void)configUnregisteredCompleteView {
    //关闭按钮
    if (_closebutton) {
        [_closebutton release];
        _closebutton = nil;
    }
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_unregisteredResultView.frame.origin.y + _unregisteredResultView.frame.size.height - 38), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_unregisteredResultView addSubview:_closebutton];
    
    //购买按钮
    [_unregisteredBuyBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_normal_color", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_normal_color", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_enter_color", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_enter_color", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_down_color", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_down_color", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_normal_color", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_normal_color", nil)]];
    [_unregisteredBuyBtn setButtonTitle:CustomLocalizedString(@"Annoy_Activate_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:18.0 WithLightAnimation:NO];
    [_unregisteredBuyBtn setHasRightImage:YES];
    [_unregisteredBuyBtn setRightImage:[StringHelper imageNamed:@"annoy_buy_arrow"]];
    [_unregisteredBuyBtn setHasBorder:NO];
    [_unregisteredBuyBtn setIsiCloudCompleteBtn:YES];
    [_unregisteredBuyBtn setTarget:self];
    [_unregisteredBuyBtn setAction:@selector(unregisteredBuyButtonClick:)];
    [_unregisteredBuyBtn setNeedsDisplay:YES];
    
    NSRect rect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Annoy_Activate_BtnTitle", nil) fontSize:18];
    int width = (int)(rect.size.width + 4 + 32 + 120);
    [_unregisteredBuyBtn setFrame:NSMakeRect(ceil((_unregisteredResultView.frame.size.width - width)/2.0), _unregisteredBuyBtn.frame.origin.y, width, _unregisteredBuyBtn.frame.size.height)];
    
    
    //标题文字
    NSString *overStr = nil;
    NSString *promptStr = nil;
    OperationLImitation *limitation = [OperationLImitation singleton];
    NSString *remainderStr = [NSString stringWithFormat:@"%lld", limitation.remainderCount];
//    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Annoy_TransferComplete_Title", nil),_successCount, limitation.remainderCount];
//            overStr = [overStr stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
        } else if (_successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Annoy_TransferComplete_Title_1", nil),_successCount, limitation.remainderCount];
//            overStr = [overStr stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        }
//    } else {
//        if (_successCount > 1) {
//            overStr = [NSString stringWithFormat:@"%d",_successCount];
//            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Annoy_TransferComplete_Title", nil),overStr];
//            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
//        } else if (_successCount == 1){
//            overStr = [NSString stringWithFormat:@"%d",_successCount];
//            promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Annoy_TransferComplete_Title_1", nil),overStr];
//            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
//        } else {
//            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
//        }
//    }
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:20.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:20.0] range:infoRange];
    }
    if (![IMBHelper stringIsNilOrEmpty:remainderStr]) {
        NSRange infoRange = [promptStr rangeOfString:remainderStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:20.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_unregisteredTitle setAttributedStringValue:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    //设置文字
    [_unregisteredMidPromptLabel setStringValue:CustomLocalizedString(@"Annoy_TransferComplete_SecondPart_Title", nil)];
    [_unregisteredThridPromptLabel setStringValue:CustomLocalizedString(@"Annoy_TransferComplete_ThirdPart_Title", nil)];
    [_unregisteredThridLabel1 setStringValue:CustomLocalizedString(@"Annoy_TransferComplete_ThirdPart_SubTitle_1", nil)];
    [_unregisteredThridLabel2 setStringValue:CustomLocalizedString(@"Annoy_TransferComplete_ThirdPart_SubTitle_2", nil)];
    [_unregisteredThridLabel3 setStringValue:CustomLocalizedString(@"Annoy_TransferComplete_ThirdPart_SubTitle_3", nil)];
    [_unregisteredThridLabel4 setStringValue:CustomLocalizedString(@"Annoy_TransferComplete_ThirdPart_SubTitle_4", nil)];

    //配置颜色
    [_unregisteredMidPromptLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    [_unregisteredThridPromptLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    [_unregisteredThridLabel1 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_unregisteredThridLabel2 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_unregisteredThridLabel3 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_unregisteredThridLabel4 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    
    NSString *promptStr1 = CustomLocalizedString(@"Annoy_TransferComplete_SecondPart_SubTitle_1", nil);
    [self setTextType:promptStr1 withTextLable:_unregisteredMidLabel1];
    promptStr1 = CustomLocalizedString(@"Annoy_TransferComplete_SecondPart_SubTitle_2", nil);
    [self setTextType:promptStr1 withTextLable:_unregisteredMidLabel2];
    promptStr1 = CustomLocalizedString(@"Annoy_TransferComplete_SecondPart_SubTitle_3", nil);
    [self setTextType:promptStr1 withTextLable:_unregisteredMidLabel3];
    promptStr1 = CustomLocalizedString(@"Annoy_TransferComplete_SecondPart_SubTitle_4", nil);
    [self setTextType:promptStr1 withTextLable:_unregisteredMidLabel4];
    
    [_unregisteredMidView setHasCorner:YES];
    [_unregisteredMidView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)]];
    [_unregisteredMidView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    [_unregisteredLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    //    _unregisteredActiveTextView;
    [_unregisteredActiveTextView setLinkStrIsFront:NO];
    [_unregisteredActiveTextView setNormalString:CustomLocalizedString(@"Annoy_Runout_Number_ThirdPart_SubTitle_1", nil) WithLinkString:CustomLocalizedString(@"Annoy_Runout_Number_ThirdPart_SubTitle_2", nil) WithNormalColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_unregisteredActiveTextView setAlignment:NSCenterTextAlignment];
    [_unregisteredActiveTextView setDelegate:self];
    [_unregisteredActiveTextView setSelectable:YES];
}

- (void)configRunOutDayCompleteView {
    //增加关闭按钮
    if (_closebutton) {
        [_closebutton release];
        _closebutton = nil;
    }
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_runOutDayCompleteView.frame.origin.y + _runOutDayCompleteView.frame.size.height - 38), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_runOutDayCompleteView addSubview:_closebutton];
    
    //购买按钮
    [_runOutDayStartBuyBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_normal_color", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_normal_color", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_enter_color", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_enter_color", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_down_color", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_down_color", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_normal_color", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_normal_color", nil)]];
    [_runOutDayStartBuyBtn setButtonTitle:CustomLocalizedString(@"Annoy_Activate_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:18.0 WithLightAnimation:NO];
    [_runOutDayStartBuyBtn setHasRightImage:YES];
    [_runOutDayStartBuyBtn setRightImage:[StringHelper imageNamed:@"annoy_buy_arrow"]];
    [_runOutDayStartBuyBtn setHasBorder:NO];
    [_runOutDayStartBuyBtn setIsiCloudCompleteBtn:YES];
    [_runOutDayStartBuyBtn setTarget:self];
    [_runOutDayStartBuyBtn setAction:@selector(unregisteredBuyButtonClick:)];
    [_runOutDayStartBuyBtn setNeedsDisplay:YES];
    
    NSRect rect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Annoy_Activate_BtnTitle", nil) fontSize:18];
    int width = (int)(rect.size.width +  4 + 32 + 120);
    [_runOutDayStartBuyBtn setFrame:NSMakeRect(ceil((_runOutDayCompleteView.frame.size.width - width)/2.0), _runOutDayStartBuyBtn.frame.origin.y, width, _runOutDayStartBuyBtn.frame.size.height)];
    
    //标题按钮
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if (_successCount > 1) {
        overStr = [NSString stringWithFormat:@"%d",_successCount];
        promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Annoy_TransferComplete_Title_2", nil),_successCount];
    } else if (_successCount == 1){
        overStr = [NSString stringWithFormat:@"%d",_successCount];
        promptStr = [NSString stringWithFormat: CustomLocalizedString(@"Annoy_TransferComplete_Title_2_1", nil),_successCount];
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
//    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_runOutDayTitleLable setAttributedStringValue:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    //设置文字
    [_runOutDaySubTitleLable setStringValue:CustomLocalizedString(@"Annoy_TransferComplete_SubTitle_2", nil)];
    [_runOutDayExplainLable1 setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SecondPart_SubTitle_1", nil)];
    [_runOutDayExplainLable2 setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SecondPart_SubTitle_2", nil)];
    [_runOutDayExplainLable3 setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SecondPart_SubTitle_3", nil)];
    [_runOutDayExplainLable4 setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SecondPart_SubTitle_4", nil)];
    
    //配置颜色
    [_runOutDaySubTitleLable setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    [_runOutDayExplainLable1 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_runOutDayExplainLable2 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_runOutDayExplainLable3 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_runOutDayExplainLable4 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    
    [_runOutDayBgView setHasCorner:YES];
    [_runOutDayBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)]];
    [_runOutDayBgView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    [_runOutDayActiveTextView setLinkStrIsFront:NO];
    [_runOutDayActiveTextView setNormalString:CustomLocalizedString(@"Annoy_Runout_Number_ThirdPart_SubTitle_1", nil) WithLinkString:CustomLocalizedString(@"Annoy_Runout_Number_ThirdPart_SubTitle_2", nil) WithNormalColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_runOutDayActiveTextView setAlignment:NSCenterTextAlignment];
    [_runOutDayActiveTextView setDelegate:self];
    [_runOutDayActiveTextView setSelectable:YES];
}

- (void)setTextType:(NSString *)promptStr withTextLable:(NSTextField *)textField {
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [textField setAttributedStringValue:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
}

- (void)unregisteredBuyButtonClick:(id)sender {
    OperationLImitation *limitation = [OperationLImitation singleton];
    NSDictionary *dimensionDict = nil;
    if (limitation.remainderCount <= 0) {
        @autoreleasepool {
            [limitation setLimitStatus:@"noquote"];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@#status=noquote", [TempHelper currentSelectionLanguage]] label:Buy transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else {
        @autoreleasepool {
            [limitation setLimitStatus:@"completed"];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@#status=completed", [TempHelper currentSelectionLanguage]] label:Buy transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [SystemHelper openChooseBrowser:softWare.buyId withIsActivate:NO isDiscount:NO isNeedAnalytics:YES];
}

- (void)dealloc {
    if (_activatePopover != nil) {
        [_activatePopover close];
        [_activatePopover release];
        _activatePopover = nil;
    }
    [_condition release],_condition = nil;
    [_downPath release],_downPath = nil;
    [_alertViewController release],_alertViewController = nil;
    [_closebutton release],_closebutton = nil;
    [_selectedItems release],_selectedItems = nil;
    [_selectDic release],_selectDic = nil;
    [_baseTransfer release],_baseTransfer = nil;
    [_photoAlbum release],_photoAlbum = nil;
    [_androidAlertViewController release];_androidAlertViewController = nil;
    [super dealloc];
}

@end
