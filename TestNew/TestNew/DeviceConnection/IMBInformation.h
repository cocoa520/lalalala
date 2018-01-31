//
//  IMBInformation.h
//  iMobieTrans
//
//  Created by iMobie on 14-8-7.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"

#import "IMBMusicDatabase.h"
#import "IMBIDGenerator.h"
#import "IMBPurchasesInfo.h"
//#import "IMBRecording.h"
//#import "IMBApplicationManager.h"
//
//#import "IMBNotesManager.h"
//#import "IMBBookmarksManager.h"
//#import "IMBCalendarsManager.h"
//#import "IMBMessagesManager.h"
//#import "IMBContactManager.h"
//#import "IMBCommonDefine.h"
//#import "IMBBooksManager.h"
//#import "SimpleNode.h"
//#import "IMBSafariHistoryManager.h"
//#import "IMBVoicemailManager.h"
//#import "IMBPhotoManager.h"
//#import "IMBiCloudClient.h"
@interface IMBInformation : NSObject
{
    // 纪录日志的句柄
//    IMBLogManager *_logHandle;
    //media信息句柄
    IMBMusicDatabase *_mediaDatabase;
    IMBArtworkDB *_artworkDB;
    IMBIDGenerator *_idGenerator;
    IMBPurchasesInfo *_purchasesInfo;
    BOOL _CDBCorrupted;
    
    //voiceMemo recording
//    IMBRecording *_recording;
//    IMBApplicationManager *_appManager;
    
//    IMBMessagesManager *_messageManager;
//    IMBSafariHistoryManager *_safariManager;
//    IMBVoicemailManager *_voicemailManager;
    
    NSMutableDictionary *_recordDic;
    NSMutableDictionary *_passwordDic;
    IMBiPod *_ipod;
//    NSMutableArray *_noteArray;
//    NSMutableArray *_messageArray;
//    NSMutableArray *_calendarArray;
//    NSMutableArray *_bookmarkArray;
    NSMutableArray *_collecitonArray;
//    NSMutableArray *_phoneArray;
//    NSMutableArray *_contactArray;
//    NSMutableArray *_camerarollArray;
//    NSMutableArray *_photostreamArray;
//    NSMutableArray *_photolibraryArray;
//    NSMutableArray *_photoshareArray;
//    NSMutableArray *_photovideoArray;
//    NSMutableArray *_voicemailArray;
//    NSMutableArray *_myAlbumsArray;
//    NSMutableArray *_timelapseArray;
//    NSMutableArray *_panoramasArray;
//    NSMutableArray *_livePhotoArray;
//    NSMutableArray *_screenshotArray;
//    NSMutableArray *_photoSelfiesArray;
//    NSMutableArray *_locationArray;
//    NSMutableArray *_favoriteArray;
//    NSMutableArray *_allBooksArray;
//    NSMutableArray *_safariHistoryArray;
//    NSMutableArray *_continuousShootingArray;
//    NSMutableArray *_slowMoveArray;
//    NSMutableDictionary *_albumsDic;
//    NSMutableDictionary *_continuousShootingDic;
//    NSMutableDictionary *_shareAlbumDic;
//    IMBiCloudClient *_iCloud;
//    IMBNotesManager *_notesManager;
//    BOOL noteNeedReload;
//    BOOL calendarNeedReload;
//    BOOL bookmarkNeedReload;
//    BOOL contactNeedReload;
    
    BOOL _isiCloudPhoto;
    
    //meida data
    NSMutableArray *_playlistArray;
    NSMutableArray *_trackArray;
    NSMutableArray *_cloudTrackArray;
}
@property (nonatomic, readonly) IMBMusicDatabase *mediaDatabase;
@property (nonatomic, readonly) IMBArtworkDB *artworkDB;
@property (nonatomic, readonly) IMBIDGenerator *idGenerator;
@property (nonatomic, readonly) IMBPurchasesInfo *purchasesInfo;
@property (nonatomic, assign) BOOL CDBCorrupted;
//@property(nonatomic,retain) IMBMessagesManager *messageManager;
//@property(nonatomic,retain) IMBSafariHistoryManager *safariManager;
//@property(nonatomic,retain) IMBVoicemailManager *voicemailManager;

@property(nonatomic,retain)NSMutableDictionary *recordDic;
@property(nonatomic,retain)NSMutableDictionary *passwordDic;
@property(nonatomic,retain)IMBiPod *ipod;
//@property(nonatomic,retain)NSMutableArray *noteArray;
//@property(nonatomic,retain)NSMutableArray *slowMoveArray;
//@property(nonatomic,retain)NSMutableArray *messageArray;
//@property(nonatomic,retain)NSMutableArray *calendarArray;
//@property(nonatomic,retain)NSMutableArray *bookmarkArray;
//@property(nonatomic,retain)NSMutableArray *phoneArray;
//@property(nonatomic,retain)NSMutableArray *contactArray;
//@property(nonatomic,retain)NSMutableArray *timelapseArray;
//@property(nonatomic,retain)NSMutableArray *panoramasArray;
//@property(nonatomic,retain)NSMutableArray *livePhotoArray;
//@property(nonatomic,retain)NSMutableArray *screenshotArray;
//@property(nonatomic,retain)NSMutableArray *photoSelfiesArray;
//@property(nonatomic,retain)NSMutableArray *locationArray;
//@property(nonatomic,retain)NSMutableArray *favoriteArray;
//@property(nonatomic,retain)NSMutableArray *camerarollArray;
//@property(nonatomic,retain)NSMutableArray *photostreamArray;
//@property(nonatomic,retain)NSMutableArray *photolibraryArray;
//@property(nonatomic,retain)NSMutableArray *photoshareArray;
//@property(nonatomic,retain)NSMutableArray *continuousShootingArray;
//@property(nonatomic,retain)NSMutableArray *photovideoArray;
//@property(nonatomic,retain)NSMutableArray *voicemailArray;
//@property(nonatomic,retain)NSMutableArray *myAlbumsArray;
//@property(nonatomic,retain)NSMutableArray *allBooksArray;
//@property(nonatomic,retain)NSMutableArray *safariHistoryArray;
//@property(nonatomic,retain)NSMutableDictionary *albumsDic;
//@property(nonatomic,retain)NSMutableDictionary *shareAlbumDic;
//@property(nonatomic,retain)NSMutableDictionary *continuousShootingDic;
//@property(nonatomic,retain)IMBiCloudClient *iCloud;
//@property(nonatomic,retain)IMBNotesManager *notesManager;
//@property(nonatomic,assign)BOOL noteNeedReload;
//@property(nonatomic,assign)BOOL calendarNeedReload;
//@property(nonatomic,assign)BOOL bookmarkNeedReload;
//@property(nonatomic,assign)BOOL contactNeedReload;
//@property(nonatomic,assign)BOOL isiCloudPhoto;
@property(nonatomic,retain) NSMutableArray *collecitonArray;
- (id)initWithiPod:(IMBiPod *)ipod;

#pragma mark - media数据
- (void)refreshMedia;
- (void)refreshCloudMusic;
- (void)saveChanges;
- (IMBPlaylistList*)playlists;
- (IMBTracklist*)tracks;
- (NSArray*)getTrackArrayByMediaTypes:(NSArray*)mediaTypes;
- (NSArray*)playlistArray;
- (NSArray*)trackArray;
- (NSMutableArray *)cloudTrackArray;

//- (IMBRecording*)recording;
//- (IMBApplicationManager*) applicationManager;

//- (void)loadphotoData;
//photo refresh
//- (void)refreshCameraRoll;
//- (void)refreshPhotoStream;
//- (void)refreshPhotoLibrary;
//- (void)refreshMyAlbum;
//- (void)refreshVideoAlbum;
//- (void)refreshPhotoShare;
//- (void)refreshTimeLapse;
//- (void)refreshPanoramas;
//- (void)refreshcontinuousShootings;
//- (void)refreshSlowMove;
//- (void)refreshLivePhoto;
//- (void)refreshPhotoSelfies;
//- (void)refreshLocation;
//- (void)refreshScreenshot;
//- (void)refreshFavorite;

//- (void)loadiBook;
//- (void)loadNote;
//- (void)loadBookmark;
//- (void)loadCalendar;
//- (void)loadContact;
//- (void)loadMessage:(BOOL)isFirst;

//- (void)loadSafariHistory:(BOOL)isFirst;
//- (void)loadVoicemail:(BOOL)isFirst;
//- (long long)calulatePhotoSize;
//- (long long)calulateiBookSize;

/*
//将指定的数据库考到指定的目录 返回数据库路径
- (NSString *)copysqliteToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath;
//将IMBMBfileRecord拷贝到指定的路径去
- (NSString *)copyIMBMBFileRecordTodesignatedPath:(NSString *)path fileRecord:(IMBMBFileRecord *)record backupfilePath:(NSString *)backupfilePath;
//2014 6 27 add
//将备份文件转化成有层次关系的NSArray
- (NSMutableArray *)getRootArray:(NSString *)backupfilePath;
//将recordArray转化为树形结构
//此方法适合文件和目录较少类型
- (NSTreeNode *)getRootTreeNode:(NSString *)backupfilePath;

//iCloud处理
- (NSMutableArray *)getRootArrayByiCLoud:(IMBiCloudBackup *)iCloudBackup;
- (NSString *)downloadSqliteByiCloud:(IMBiCloudBackup *)iCloudBackup withSqliteName:(NSString *)sqliteName withDomain:(NSString *)domainName;
- (int)downloadForldByiCloud:(IMBiCloudBackup *)iCloudBackup withForldPath:(NSString *)forldPath withDomain:(NSString *)domainName withDesPath:(NSString *)desPath  withCurrtentCounts:(int)currItemIndex withTotalCounts:(int)totalCounts;



//path为域下路径
- (IMBMBFileRecord *)getDBFileRecord:(NSString *)domainName path:(NSString *)path backupfilePath:(NSString *)backupFilePath;
//得到CameraRollDomain域下所有的record
- (NSMutableArray *)getCameraRollDomain:(NSString *)backupFilePath;
- (NSArray *)getAllAppsDomain:(NSString *)backupFilePath;
- (void)getFileRecordByiCloud:(IMBiCloudBackup *)iCloudBackup;


*/

@end
