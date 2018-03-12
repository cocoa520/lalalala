//
//  IMBiCloudManager.h
//  
//
//  Created by ding ming on 17/2/1.
//
//

#import <Foundation/Foundation.h>
#import "IMBToiCloudPhotoEntity.h"
#import "IMBiCloudCalendarEventEntity.h"
#import "IMBiCloudContactEntity.h"
#import "IMBiCloudNoteModelEntity.h"
#import "IMBiCloudNetClient.h"
#import "IMBiCloudDriveRootFolderEntity.h"
#import "IMBiCloudReminberEntity.h"
#import "IMBLogManager.h"
@interface IMBiCloudManager : NSObject {
    IMBiCloudNetClient *_netClient;
    
    NSMutableArray *_photoArray;
    NSMutableArray *_albumArray;
    int _photoCount;
    NSMutableArray *_photoVideoAlbumArray;
    int _photoVideoCount;
    NSMutableArray *_contactArray;
    NSMutableArray *_calendarArray;
    NSMutableArray *_calendarCollectionArray;
    NSMutableArray *_reminderArray;
    NSMutableArray *_reminderCollectionArray;
    NSMutableArray *_noteArray;
    IMBiCloudDriveFolderEntity *_driveFolderEntity;
    NSString *_documentID;
    
    NSString *_photoSyncToken;
    NSString *_contactPrefToken;
    NSString *_contactSyncToken;
    NSString *_notesSyncToken;
    BOOL _isHigh;
    NSString *_editReminderNewEtag;
    IMBLogManager *_logHandle;
    id _delegate;
    NSDictionary *_firstDic;
}

@property (nonatomic, assign) int photoCount;
@property (nonatomic, assign) int photoVideoCount;
@property (nonatomic, assign) id delegate;
@property (nonatomic,retain) NSMutableArray *photoArray;
@property (nonatomic,retain) NSMutableArray *albumArray;
@property (nonatomic,retain) NSMutableArray *photoVideoAlbumArray;
@property (nonatomic,retain) NSMutableArray *contactArray;
@property (nonatomic,retain) NSMutableArray *calendarArray;
@property (nonatomic,retain) NSMutableArray *calendarCollectionArray;
@property (nonatomic,retain) NSMutableArray *reminderArray;
@property (nonatomic,retain) NSMutableArray *reminderCollectionArray;
@property (nonatomic,retain) NSMutableArray *noteArray;
@property (nonatomic,retain) IMBiCloudDriveFolderEntity *driveFolderEntity;
@property (nonatomic,retain) IMBiCloudNetClient *netClient;
@property (nonatomic,retain) NSString *photoSyncToken;
@property (nonatomic,retain) NSString *contactPrefToken;
@property (nonatomic,retain) NSString *contactSyncToken;
@property (nonatomic,retain) NSString *notesSyncToken;
@property (nonatomic, retain) NSString *editReminderNewEtag;

- (NSDictionary *)loginiCloudAppleID:(NSString *)appleID WithPassword:(NSString *)password;
- (NSDictionary *)verifiTwoStepAuthentication:(NSString *)password;

- (void)getPhotosContent;
- (void)getPhotoDetail:(IMBToiCloudPhotoEntity *)albumEntity;
- (NSData *)getPhotoThumbnilDetail:(NSString *)urlStr;
- (BOOL)downloadPhoto:(IMBToiCloudPhotoEntity *)photoEntity withDownloadPath:(NSString *)downloadPath;
- (BOOL)uploadPhoto:(NSString *)filePath withContainerId:(NSString *)containerId ;
- (BOOL)syncTransferPhoto:(IMBToiCloudPhotoEntity *)photoEntity;
- (BOOL)deletePhotos:(NSArray *)deleteArr;
- (BOOL)addPhotoAlbum:(NSString *)albumName;
- (BOOL)deletePhotoAlbum:(IMBToiCloudPhotoEntity *)albumEntity;
- (BOOL)addPhotoToAlbum:(NSArray *)array withContainerId:(NSString *)containerId;

- (void)getContactContent;
- (void)importContact:(NSArray *)array;
- (BOOL)importAndroidContact:(IMBiCloudContactEntity *)entity;
- (void)editContact:(IMBiCloudContactEntity *)entity;
- (void)deleteContact:(NSArray *)array;

- (void)getReminderContent;
- (BOOL)addReminder:(ReminderAddModel *)remEntity withPguid:(NSString *)pGuid;
- (BOOL)deleteReminder:(NSArray *)remArray withPguid:(NSString *)pGuid;
- (BOOL)editReminder:(ReminderEditModel *)remEntity withPguid:(NSString *)pGuid;
- (BOOL)addReminderCollection:(NSString *)collectionName;
- (BOOL)deleteReminderCollection:(IMBiCloudCalendarCollectionEntity *)entity;

- (void)getNoteContent;
- (BOOL)addNoteData:(NSArray *)noteDataArr;
- (BOOL)deleteNote:(NSArray *)noteArr;

//获取第一级目录内容
- (void)getiCloudDriveContent;
//获取文件夹下的类容
- (void)getFolderContent:(IMBiCloudDriveFolderEntity *)folderEntity;
//断点续传 得到需要断点续传的数据
- (NSMutableArray *)getContinueDownData;
- (void)deleteContinueDonwData;

#pragma iCloud Drive下载方法
- (void)iCloudDriveDownload:(NSString *)urlStr withPath:(NSString *)path;
//断点续传方法
- (void)iCloudDriveDownload:(NSString *)urlStr withPath:(NSString *)path withStartBytes:(long long)startBytes;
//获得iCloudDrive中要被下载的文件的下载信息:docwsid、zone、extension分别对应IMBiCloudDriveFolderEntity实体中得_docwsid、_zone、_extension;   返回url字符串
- (NSString *)getiCloudDriveFileDownloadInfo:(NSString *)docwsid withZone:(NSString *)zone withExtension:(NSString *)extension;
#pragma iCloud Drive上传方法
- (BOOL)iCloudDriveUpload:(NSString *)filePath withFileSize:(long long)fileSize withZone:(NSString *)zone withContentType:(NSString *)contentType;
//**********上传完后更新***********
- (NSDictionary *)updateFileAfterUpload:(NSDictionary *)retDic withParentDir:(NSString *)parentDirId withUploadFileName:(NSString *)fileName;
#pragma iCloud Drive删除方法
- (NSDictionary *)deleteiCloudDriveArray:(NSArray *)array;
#pragma iCloud Drive创建文件夹方法
- (NSDictionary *)createiCloudDriveFolder:(NSString *)parentDrivewsId withFolderName:(NSString *)folderName;

//上传下载停止
- (void)cancel;

#pragma mark Calender相关操作方法
- (void)getCalendarContent;
- (BOOL)getCalendarCollectionContentName:(NSString *)name;
- (BOOL)addCalender:(IMBiCloudCalendarEventEntity *)calendarEvent;
- (BOOL)deleteCalender:(IMBiCloudCalendarEventEntity *)caldarEvent;
- (BOOL)editCalender:(IMBiCloudCalendarEventEntity *)caldarEvent;
- (BOOL)addCalenderCollection:(NSString *)collectionName;
- (BOOL)deleteCalenderCollection:(IMBiCloudCalendarCollectionEntity *)entity;
//加载详细信息
- (BOOL)loadCalendarDetailContent:(IMBiCloudCalendarEventEntity *)entity;
@end
