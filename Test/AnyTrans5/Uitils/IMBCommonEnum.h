//
//  IMBCommonEnum.h
//  iMobieTrans
//
//  Created by Pallas on 1/22/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
static Byte ZERO_IV[16] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

typedef enum CategoryNodes {
    Category_Summary = 1,
    Category_Playlist = 2,
    Category_Music = 3,
    Category_Movies = 4,
    Category_TVShow = 5,
    Category_MusicVideo = 6,
    Category_Photos = 7,
    Category_CameraRoll = 8,
    Category_iBooks = 9,
    Category_Audiobook = 10,
    Category_Ringtone = 11,
    Category_VoiceMemos = 12,
    Category_FileSystem = 13,
    Category_PhotoStream = 14,
    Category_Storage = 15,
    Category_Desktop = 16,
    Category_System = 17,
    Category_Applications = 18,
    Category_PodCasts = 19,
    Category_iTunesU = 20,
    Category_Notes = 21,
    Category_Phone = 22,
    Category_Message = 23,
    Category_Contacts = 24,
    Category_Bookmarks = 25,
    Category_Calendar = 26,
    Category_Backups = 27,
    Category_iBookCollections = 28,
    Category_PhotoLibrary = 29,
    Category_PhotoShare = 30,
    Category_PhotoVideo = 31,
    Category_MyAlbums = 32,
    Category_Voicemail = 33,
    Category_SafariHistory = 34,
    Category_iCloud = 35,
    Category_Shutdown = 36,
    Category_Reboot = 37,
    Category_Systemlogs = 38,
    Category_TimeLapse = 39,
    Category_Panoramas = 40,
    Category_ContinuousShooting = 41,
    Category_HomeVideo = 42,
    Category_SlowMove = 43,
    Category_Clone = 44,
    Category_CallHistory = 45,
    Category_Reminder = 46,
    Category_iCloudDriver = 47,
    Category_iCloudBackup = 48,
    category_iCloudUp = 49,//iCloud上传

    Category_iTunes_lib = 50,
    Category_iTunes_Music = 51,
    Category_iTunes_Movie = 52,
    Category_iTunes_TVShow = 53,
    Category_iTunes_iBooks = 54,
    Category_iTunes_Audiobook = 55,
    Category_iTunes_Ringtone = 56, 
    Category_iTunes_App = 57,
    Category_iTunes_VoiceMemos = 58,
    Category_iTunes_iTunesU = 59,
    Category_iTunes_PodCasts = 60,
    Category_iTunes_Playlist = 61,
    Catrgory_iTunes_HomeVideo = 64,
    //设备间导入新增
    Category_eBooks = 62,
    Category_Explorer = 63,
    Category_Photo = 65,
    Category_Thumil = 66,
    
    Category_Compressed = 67,
    Category_Document = 68,
    
    Category_CloudMusic = 69,
    
    Category_LivePhoto = 70,
    Category_Screenshot = 71,
    Category_PhotoSelfies = 72,
    Category_Location = 73,
    Category_Favorite = 74,
} CategoryNodesEnum;

typedef enum CallingType {
    // 未知通话
    CallingUnkonw = 'cukn',
    // 挂断电话
    CallingMissed = 'cmsd',
    // 接通电话
    CallingReceive = 'crcv',
    // 拨出电话
    CallingCall = 'call',
    // 拨出，没有接收
    CallingCanceled = 'ccnl',
    // 挂断视频通话
    CallingMissedFacetime = 'cmft',
    // 拨出视频通话
    CallingCallFacetime = 'ccft',
    // 接通视频电话
    CallingReceiveFacetime = 'crft',
    // 拨出，没有接收的视频通话
    CallingCanceledFacetime = 'clft'
} CallingTypeEnum;

// 扫瞄类别枚举
typedef enum ScanType {
    ScanContactFile = 0,
    ScanCallHistoryFile = 1,
    ScanMessageFile = 2,
    ScanMessageAttachmentFile = 3,
    ScanVoicemailFile = 4,
    ScanCalendarFile = 5,
    ScanReminderFile = 6,
    ScanNotesFile = 7,
    ScanNotesAttachmentFile = 8,
    ScanSafariHistoryFile = 9,
    ScanSafariBookmarkFile = 10,
    
    
    //    ScanCameraRollFile = 9,
    //    ScanPhotoStreamFile = 10,
    //    ScanPhotoLibraryFile = 11,
    ScanPhotosFile = 11,
    ScanPhotosVideoFile = 12,
    ScanThumbnailFile = 13,
    ScanMusicFile = 14,
    ScanVideoFile = 15,
    ScanAudioBookFile = 16,
    ScanPlaylistFile = 17,
    ScanRingtoneFile = 18,
    ScaniBookFile = 19,
    ScanVoiceMemosFile = 20,
    
    ScanAppDocumentFile = 21,
    ScanAppPhotoFile = 22,
    ScanAppAudioFile = 23,
    ScanAppVideoFile = 24,
    
    
    ScanAppShareDocumentFile = 25,
    ScanWhatsAppFile = 26,
    ScanWhatsAppAttachmentFile = 27,
    ScanLineFile = 28,
    ScanLineAttachmentFile = 29,
    
    ScanPersonalType = 30,
    ScanMediaType = 31,
    ScanAppType = 32,
    
    ScanPodCastsFile = 33,
    ScanAudioFile = 34
} ScanTypeEnum;

typedef enum {
	Contact_PhoneNumber    = 3,
    Contact_EmailAddressNumber    = 4,
    Contact_RelatedName    = 23,
    Contact_IM    = 13,
    Contact_URL    = 22,
    Contact_Date    = 12,
    Contact_StreetAddress = 5,
    Contact_Profiles = 18,
}
ContactCategoryEnum;

typedef enum MediaType{
    AudioAndVideo = 0x00000000,
    Audio = 0x00000001,
    Video = 0x00000002,
    Podcast = 0x00000004,
    VideoPodcast = 0x00000006,
    Audiobook = 0x00000008,
    MusicVideo = 0x00000020,
    TVShow = 0x00000040,
    TVAndMusic = 0x00000060,
    Ringtone = 0x4000,
    Books = 0x400000,
    VoiceMemo = 0x00000128,
    iTunesUGroup = 0x200000,
    iTunesU = 0x200001,
    iTunesUVideo = 0x200002,
    PDFBooks = 0x800000,
    Application = 0x01000001,
    //TODO 需要对新的video进行处理
    Video_New = 0x00000064,
    Photo = 0x00002048,
    //设备间传输新增
    Playlist = 0x00000808,
    HomeVideo = 0x00000400,//1024
} MediaTypeEnum;

typedef enum{
    OutOfSpace = 0,
    AlreadyExisted = 1,
    FileErrorUnknown = 2,
    Normal = 3
} PrepareStatus;

typedef enum SyncCtrType {
    SyncNone = -1,
    SyncAddFile = 0,
    SyncDelFile = 1,
    SyncOther = 2,
    SyncRefresh = 3,
    PlaylistsType = 4,
    SyncRename = 5,
} SyncCtrTypeEnum;

typedef enum IPodFamily {
    iPod_Unknown = 0,
    iPod_Gen1_Gen2 = 1,
    iPod_Gen3 = 2,
    iPod_Mini = 3,
    iPod_Gen4 = 4,
    iPod_Gen4_2 = 5,
    iPod_Gen5 = 6,
    iPod_Nano_Gen1 = 7,
    iPod_Nano_Gen2 = 9,
    iPod_Classic = 11,
    iPod_Nano_Gen3 = 12,
    iPod_Nano_Gen4 = 15,
    iPod_Nano_Gen5 = 16,
    iPod_Nano_Gen6 = 17,
    iPod_Nano_Gen7 = 18,
    iPod_Shuffle_Gen1 = 128,
    iPod_Shuffle_Gen2 = 130,
    iPod_Shuffle_Gen3 = 132,
    iPod_Shuffle_Gen4 = 133,
    iOS_Device = 1000,
    iPod_Touch_1 = 1001,
    iPod_Touch_2 = 1002,
    iPod_Touch_3 = 1003,
    iPod_Touch_4 = 1004,
    iPod_Touch_5 = 1005,
    iPod_Touch_6 = 1006,
    iPhone = 2001,
    iPhone_3G = 2002,
    iPhone_3GS = 2003,
    iPhone_4 = 2004,
    iPhone_4S = 2005,
    iPhone_5 = 2006,
    iPhone_5C = 2007,
    iPhone_5S = 2008,
    iPhone_6 = 2009,
    iPhone_6_Plus = 2010,
    iPhone_6S = 2011,
    iPhone_6S_Plus = 2012,
    iPhone_SE = 2016,
    iPhone_7 = 2017,
    iPhone_7_Plus = 2018,
    iPhone_8 = 2019,
    iPhone_8_Plus = 2020,
    iPhone_X = 2021,
    iPad_1 = 3001,
    iPad_2 = 3002,
    The_New_iPad = 3003,
    iPad_4 = 3004,
    iPad_Air = 3005,
    iPad_Air2 = 3006,
    iPad_mini = 4001,
    iPad_mini_2 = 4002,
    iPad_mini_3 = 4003,
    iPad_mini_4 = 4004,
    iPad_Pro = 4005,
    iPad_5 = 4006,
    general_Android = 5000,
    general_iCloud = 6000,
    general_Add_Content = 7000,
} IPodFamilyEnum;

typedef enum  {
    IMBLimit_None = 0,
    IMBLimit_Time_Counts = 1,
    IMBLimit_Counts = 2,
} IMBProductLimitType;

typedef enum
{
    AppTransferType_All = 0,
    AppTransferType_ApplicationOnly = 1,
    AppTransferType_DocumentsOnly = 2
} IMBAppTransferTypeEnum;

typedef enum 
{
    IMBProgram_Startup = 0,
    IMBTransfer_Before = 1,
    IMBTransfer_Limit = 2,
    IMBProgram_Register = 3
} IMBShowRegisterType;

typedef enum {
    Backup_All = 'ball',
    Backup_iTunesCDB = 'bcdb',
    Backup_SqlitDB = 'bsdb',
    Backup_IOS5SqliteDB = 'b5db',
    Backup_ArtworkDB = 'badb',
    Backup_iTunesDB = 'bidb',
    Backup_Ringtone = 'brtn',
    Backup_iBooks = 'bbok',
    Backup_iTunesSD = 'bisd',
    Backup_Photo = 'acpt',
    Backup_addressBook = 'bddb'
} BackUpFileEnum;

enum {
    Progress_Modal_Stopped			= (1000)
};


typedef enum {
    ConversionType,
    ParsingType,
    CopyingFileType
} DisplayType;

typedef enum {
    IphoneImage = 0,
    ItunesImage = 1,
    PCImage = 2,
    IpodTouchImage = 3,
    IpadImage = 4,
    IpodNanoImage = 5
} DeviceImageType;

typedef enum {
    ImageTypeIcon = 0,
    MusicTypeIcon = 1,
    VideoTypeIcon = 2,
    FileTypeIcon = 3
    
} MediaImageType;

typedef enum {
    FileResultTypeIcon = 0,
    MovieResultTypeIcon = 1,
    MusicResultTypeIcon = 2,
    PhotoResultTypeIcon = 3,
    AppResultTypeIcon = 4,
    BookResultTypeIcon = 5
    //添加book
} MediaResultType;

typedef enum MouseStatus {
    MouseEnter = 'mset',
    MouseOut = 'msot',
    MouseDown = 'msdn',
    MouseUp = 'msup'
} MouseStatusEnum;


typedef enum{
    
    iCloudDataDownLoad = 0,
    iCloudDataWaitingDownLoad = 1,
    iCloudDataDownLoading = 2,
    iCLoudDataContinue = 3,
    //完成下载 Complete文字
    iCloudDataComplete = 4,
    iCloudDataDelete = 5,
    iCloudDataCancelDownLoad = 6,
    //iCloudDrive
    iCloudDataFail = 7,
    iCloudDrivenowdown=8,
    iCloudDrivewaiting=9,
    iCloudDrivefinish=10,
    iCloudDriveCancel=12,
    iCloudDrivePause=13,
    iCloudDriveContinue=14,
    iCloudDriveTodownload=15,
    
    
} iCLoudLoadType;

typedef enum {
    BackEnteredButton = 1,
    BackExitButton = 2,
    BackUpButton = 3,
    BackDownButton = 4,
} BackButtonType;

typedef enum LanguageType {
    EnglishLanguage = 0,
    JapaneseLanguage = 1,
    FrenchLanguage = 2,
    GermanLanguage = 3,
    CzechLanguage = 4,
    HungaryLanguage = 5,
    SpanishLanguage = 6,
    ChinaLanguage = 7,
    ArabLanguage = 8,
} LanguageTypeEnum;

typedef enum FunctionType
{
    iTunesLibraryModule = 0,
    BackupModule = 1,
    AirBackupModule = 2,
    DeviceModule = 3,
    AndroidModule = 4,
    iCloudModule = 5,
    VideoDownloadModule = 6,
    SkinModule = 7,
}FunctionType;


typedef enum CheckState {
    // 未勾选
    UnChecked = 0,
    // 勾选
    Check = 1,
    // 半选状态
    SemiChecked = -1
} CheckStateEnum;

typedef enum AddCategory {
    AddCategry_Music = 1,
    AddCategry_Video,
    AddCategry_VoiceMemo,
    AddCategry_Ringtone,
    AddCategry_App,
    AddCategry_Book,
    AddCategry_Photo,
    AddCategry_Contact,
    AddCategry_Note,
} AddContentCategoryEnum;

//add to gehry
typedef enum ChooseView {
    DisConntectViewEnum = 0,//未连接页面
    ChooseFileViewEnum  = 1,//选择要扫描的项目
    AnalysingViewEnum   = 2,//分析设备
    ScanDeviceViewEnum  = 3,//扫描界面
    RootPromptViewEnum  = 4,//root提示界面
    RootingViewEnum     = 5,//root 界面
    RootFailViewEnum    = 6,// root失败界面
    TransferViewEnum    = 7,
}ChooseViewType;

//文件类型
typedef enum FileType {
    ImageFile       = 0,
    AudioFile       = 1,
    VideoFile       = 2,
    CummonFile      = 3,
    BookFile        = 4,
} FileTypeEnum;

typedef enum{
    AryEnum_All = 1,
    AryEnum_deleted = 2,
    AryEnum_existence = 3
} AryEnum;

union {
    char   c[8];
    double d;
} x;

union {
    char    c[2];
    uint16  ui16;
} uint_16;

union {
    char    c[4];
    int32_t i32;
} int_32;

union {
    char    c[4];
    uint32  ui32;
} uint_32;

union {
    char    c[8];
    int64_t i64;
} int_64;


@interface IMBCommonEnum : NSObject {
    
}
+(NSString*) attrackerCategoryNodesEnumToString:(CategoryNodesEnum)categoryEnum;
+ (NSString*) categoryNodesEnumToString:(CategoryNodesEnum)Enum;
+ (NSString*) categoryNodesEnumToName:(CategoryNodesEnum)categoryEnum;
+ (CategoryNodesEnum) categoryNodesStringToEnum:(NSString*)categoryString;
+ (NSArray*)categoryNodeToMediaTyps:(CategoryNodesEnum)category;
+ (CategoryNodesEnum)categoryNodesByMediaType:(MediaTypeEnum)mediatype;

+(NSString*) mediaTypeEnumToString:(MediaTypeEnum)mediaType;

//这里返回fmaily的String值
+(NSString*) IPodFamilyEnumToString:(IPodFamilyEnum)Enum;
//+(CategoryNodesEnum) categoryNodesStringToEnum:(NSString*)categoryString;



@end
