//
//  IMBDownloadListViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDownloadListViewController.h"
#import "HoverButton.h"
#import "StringHelper.h"
#define TableViewRowWidth 360
#define TableViewRowHight 100
#import "ObjectTableRowView.h"
#import "DownloadCellView.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
#define OringinalPropertityX 0
#define OringinalPropertityY 22
#import "IMBAirSyncImportTransfer.h"
#import "SystemHelper.h"
#import "TempHelper.h"
#import "IMBHelper.h"
#import "DriveItem.h"
#import "IMBDriveEntity.h"
#import "IMBTransferModel.h"
#import "IMBPhotoFileExport.h"
#import "IMBPhotoEntity.h"
#import "IMBTranferViewController.h"
#import "IMBBookEntity.h"
#import "IMBiBooksExport.h"
#import "IMBMediaFileExport.h"
#import "IMBAppExport.h"
#import "IMBFileSystemExport.h"
#import "IMBFileSystem.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBCommonTool.h"
#import "IMBMainPageViewController.h"
@interface IMBDownloadListViewController ()

@end

@implementation IMBDownloadListViewController
@synthesize downloadDataSource = _downloadDataSource;
@synthesize deviceManager = _deviceManager;
@synthesize iPod = _iPod;
@synthesize exportPath = _exportPath;
@synthesize delagete = _delegate;
@synthesize appKey = _appKey;
@synthesize categoryEnum = _categoryEnum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)awakeFromNib {
}

- (void)loadView {
    [super loadView];
    
    successCount = 0;
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:1];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setListener:self];
    //    [_tableView setCanSelect:YES];
    [_tableView setGridColor:COLOR_TRABLEVIEW_SELECTE_BG];
    [_tableView setBackgroundColor:COLOR_TRABLEVIEW_SELECTE_BG];
    [_tableView setSelectionHighlightColor:COLOR_TRABLEVIEW_SELECTE_BG];
    _downloadDataSource = [[NSMutableArray alloc] init];
    //    _completeArray = [[NSMutableArray alloc]init];
    //    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_nodataImageView setImage:[StringHelper imageNamed:@"transferlist_history_blankpage_ai"]];
    [_noTipTextField setTextColor:NODATA_NOLIKTITLE_COLOR];
    [_noTipTextField setStringValue:CustomLocalizedString(@"TransferNodata_tips", nil)];
    //     [_tableView setIsTranferView:YES];
    //    [self.view setWantsLayer:YES];
    //    [self.view.layer setMasksToBounds:YES];
    //    [self.view.layer setCornerRadius:5];
    [_tableView setBackgroundColor:[NSColor clearColor]];
    if (_downloadDataSource.count == 0) {
        [_contentBox setContentView:_nodataView];
    }
}

#pragma mark - 各种数据的初始
- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent withUploadDocID:(NSString *) docID{
    _chooseModeEnum = iCloudLogEnum;
    _deviceManager = driveBaseManage ;
    if (isDown) {
        _isDownLoadData = YES;
        for (IMBDriveEntity *driveEntity in addDataSource) {
            DriveItem *downloaditem = [[DriveItem alloc] init];
            [downloaditem setIsDownLoad:YES];
            downloaditem.itemIDOrPath = driveEntity.fileID;
            downloaditem.docwsID = driveEntity.docwsid;
            downloaditem.zone = driveEntity.zone;
            downloaditem.fileSize = driveEntity.fileSize;
            downloaditem.photoImage = [driveEntity.image retain];
            downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
            if (driveEntity.isFolder) {
                if (!downloaditem.photoImage) {
                    downloaditem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
                }
                downloaditem.isFolder = YES;
                downloaditem.fileName = driveEntity.fileName;
            }else {
                downloaditem.isFolder = NO;
                if (driveEntity.extension){
                    downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
                }else {
                    downloaditem.fileName = driveEntity.fileName;
                }
                if (!downloaditem.photoImage) {
                    downloaditem.photoImage = [TempHelper loadTransferFileImage:driveEntity.extension];
                }
            }
            [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [_downloadDataSource insertObject:downloaditem atIndex:0];
            [downloaditem release];
            downloaditem = nil;
        }
        [self loadTranferView];
        [_deviceManager driveDownloadItemsToMac:_downloadDataSource];
    }else {
        _isAllUpLoad = YES;
        _isDownLoadData = NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        for (NSString *pathStr in addDataSource) {
            DriveItem *uploaditem = [[DriveItem alloc] init];
            [uploaditem setIsDownLoad:NO];
            [uploaditem setUploadParent:uploadParent];
            [uploaditem setUploadDocwsID:docID];
            [uploaditem setFileName:[pathStr lastPathComponent]];
            [uploaditem setLocalPath:pathStr];
            uploaditem.toDriveName = CustomLocalizedString(@"TransferUploading", nil);
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:pathStr traverseLink:YES];
            unsigned long long length = [fileAttributes fileSize];
            uploaditem.fileSize = length;
            BOOL isFolder; //isFolder用来记录该路径是否是文件夹
            [fm fileExistsAtPath:pathStr isDirectory:&isFolder];
            uploaditem.isFolder = isFolder;
            if (isFolder) {
                uploaditem.photoImage = [[NSImage imageNamed:@"transferlist_history_icon_list_folder"] retain];
            }else {
                uploaditem.photoImage = [[TempHelper loadTransferFileImage:[pathStr pathExtension]] retain];
            }
            [uploaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [_downloadDataSource insertObject:uploaditem atIndex:0];
            [uploaditem release];
            uploaditem = nil;
        }
        [self loadTranferView];
        [_deviceManager driveUploadItems:_downloadDataSource];
    }
    [self reloadData:YES];
}

- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent{
    _deviceManager = [driveBaseManage retain];
    _chooseModeEnum = DropBoxLogEnum;
    if (isDown) {
        _isDownLoadData = YES;
        for (IMBDriveEntity *driveEntity in addDataSource) {
            DriveItem *downloaditem = [[DriveItem alloc] init];
            [downloaditem setIsDownLoad:YES];
            downloaditem.itemIDOrPath = driveEntity.fileID;
            downloaditem.docwsID = driveEntity.docwsid;
            downloaditem.zone = driveEntity.zone;
            downloaditem.fileSize = driveEntity.fileSize;
            downloaditem.photoImage = [driveEntity.image retain];
            downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
            if (driveEntity.isFolder) {
                downloaditem.isFolder = YES;
                downloaditem.fileName = driveEntity.fileName;
                if (!downloaditem.photoImage) {
                    downloaditem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
                }
            }else {
                downloaditem.isFolder = NO;
                if (driveEntity.extension){
                    downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
                }else {
                    downloaditem.fileName = driveEntity.fileName;
                }
                if (!downloaditem.photoImage) {
                    downloaditem.photoImage = [TempHelper loadTransferFileImage:driveEntity.extension];;
                }
            }
            
            [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [_downloadDataSource insertObject:downloaditem atIndex:0];
            [downloaditem release];
            downloaditem = nil;
        }
        [self loadTranferView];
        [_deviceManager driveDownloadItemsToMac:_downloadDataSource];
        
    }else {
        _isAllUpLoad = YES;
        _isDownLoadData = NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        for (NSString *pathStr in addDataSource) {
            DriveItem *uploaditem = [[DriveItem alloc] init];
            [uploaditem setIsDownLoad:NO];
            [uploaditem setUploadParent:uploadParent];
            [uploaditem setFileName:[pathStr lastPathComponent]];
            [uploaditem setLocalPath:pathStr];
            uploaditem.toDriveName = CustomLocalizedString(@"TransferUploading", nil);
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:pathStr traverseLink:YES];
            unsigned long long length = [fileAttributes fileSize];
            uploaditem.fileSize = length;
            BOOL isFolder; //isFolder用来记录该路径是否是文件夹
            [fm fileExistsAtPath:pathStr isDirectory:&isFolder];
            uploaditem.isFolder = isFolder;
            
            if (isFolder) {
                uploaditem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
            }else {
                uploaditem.photoImage = [TempHelper loadTransferFileImage:[pathStr pathExtension]];;
            }
            [uploaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [_downloadDataSource insertObject:uploaditem atIndex:0];
            [uploaditem release];
            uploaditem = nil;
        }
        [self loadTranferView];
        [_deviceManager driveUploadItems:_downloadDataSource];
        
    }
    [self reloadData:YES];
}

- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath{
    _chooseModeEnum = DeviceLogEnum;
    IMBBaseTransfer *baseTransfer = nil;
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    if (isDown) {
        _isDownLoadData = YES;
        _isdeiveData = YES;
        
        if (categoryNodesEnum == Category_CameraRoll || categoryNodesEnum == Category_PhotoStream || categoryNodesEnum == Category_PhotoLibrary) {
            for (id driveEntity in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                [downloaditem setIsDownLoad:YES];
                if ([driveEntity isKindOfClass:[IMBPhotoEntity class]]) {
                    IMBPhotoEntity *photoEntity = (IMBPhotoEntity *)driveEntity;
                    downloaditem.isDownLoad = YES;
                    downloaditem.fileName = photoEntity.photoName;
                    downloaditem.allPath = photoEntity.allPath;
                    downloaditem.photoPath = photoEntity.photoPath;
                    downloaditem.kindSubType = photoEntity.kindSubType;
                    downloaditem.thumbPath = photoEntity.thumbPath;
                    downloaditem.oriPath = photoEntity.oriPath;
                    downloaditem.photoDateData = photoEntity.photoDateData;
                    downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_img"];
                    downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
                    downloaditem.fileSize = photoEntity.photoSize;
                    downloaditem.docwsID = photoEntity.photoUUIDString;
                    downloaditem.exportPath = exportPath;
                    downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                    if (downloaditem.extension) {
                        downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:downloaditem.extension];
                    }else {
                        downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                    }
                    [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                    [_downloadDataSource insertObject:downloaditem atIndex:0];
                    [dataArray addObject:downloaditem];
                }
                [downloaditem release];
                downloaditem = nil;
            }
            IMBPhotoFileExport *baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
            [(IMBPhotoFileExport *)baseTransfer setExportType:1];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [baseTransfer startTransfer];
                [baseTransfer release];
                [dataArray release];
            });
        }else if (categoryNodesEnum == Category_iBooks) {
            for (IMBBookEntity *bookEntity in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.isDownLoad = YES;
                downloaditem.fileName = bookEntity.bookName;
                downloaditem.oriPath = bookEntity.path;
                downloaditem.isBigFile = bookEntity.isPurchase;
                downloaditem.extension = bookEntity.extension;
                downloaditem.fileSize = bookEntity.size;
                downloaditem.allPath = bookEntity.fullPath;
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_books"];
                downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
                downloaditem.exportPath = exportPath;
                if (downloaditem.extension) {
                    downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:downloaditem.extension];
                }else {
                    downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                }
                [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                [dataArray addObject:downloaditem];
                [downloaditem release];
                downloaditem = nil;
            }
            IMBiBooksExport *baseTransfer = [[IMBiBooksExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [baseTransfer startTransfer];
                [baseTransfer release];
                [dataArray release];
            });
        }else if (categoryNodesEnum == Category_Media||categoryNodesEnum == Category_Video) {
            for (IMBTrack *track in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.isDownLoad = YES;
                downloaditem.fileName = track.title;
                downloaditem.oriPath = track.filePath;
                downloaditem.fileSize = track.fileSize;
                downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                downloaditem.photoDateData = track.dateLastModified;
                downloaditem.exportPath = exportPath;
                if (categoryNodesEnum == Category_Media){
                    downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_media"];
                }else {
                    downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_video"];
                }
                
                downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
                if (downloaditem.extension) {
                    downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:downloaditem.extension];
                }else {
                    downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                }
                [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                [dataArray addObject:downloaditem];
                [downloaditem release];
                downloaditem = nil;
            }
            IMBMediaFileExport *baseTransfer = [[IMBMediaFileExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [baseTransfer startTransfer];
                [baseTransfer release];
                [dataArray release];
            });
        }else if (categoryNodesEnum == Category_Applications||categoryNodesEnum == Category_appDoucment) {
            for (id entity in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.isDownLoad = YES;
                if ([entity isKindOfClass:[IMBAppEntity class]]) {
                    IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                    downloaditem.fileName = appEntity.appName;
                    downloaditem.zone = appEntity.appKey;
                    downloaditem.fileSize = appEntity.appSize;
                    downloaditem.docwsID = appEntity.version;
                }else {
                    SimpleNode *fileEntity = (SimpleNode *)entity;
                    downloaditem.isFolder = fileEntity.container;
                    downloaditem.oriPath = fileEntity.path;
                    downloaditem.fileName = fileEntity.fileName;
                    if (downloaditem.isFolder) {
                        _sysSize = 0;
                        NSMutableArray *ary = [[NSMutableArray alloc]init];
                        [ary addObject:fileEntity];
                        //取文件夹大小
                        AFCApplicationDirectory *afcAppmd = [ipod.deviceHandle newAFCApplicationDirectory:_appKey];
                        [self caculateTotalFileCount:ary afcMedia:afcAppmd];
                        downloaditem.fileSize = _sysSize;
                        [ary release];
                        [afcAppmd close];
                    }else {
                        downloaditem.fileSize = fileEntity.itemSize;
                    }
                }
                
                downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_app"];
                downloaditem.exportPath = exportPath;
                if (downloaditem.extension) {
                    downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:downloaditem.extension];
                }else {
                    downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                }
                [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                [dataArray addObject:downloaditem];
                [downloaditem release];
                downloaditem = nil;
            }
            IMBAppExport *baseTransfer = [[IMBAppExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
            baseTransfer.appKey = _appKey;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [baseTransfer fileStartTransfer];
                [baseTransfer release];
                [dataArray release];
            });
        }else if (categoryNodesEnum == Category_System ||categoryNodesEnum == Category_Storage) {
            for (SimpleNode *simpleNode in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.isDownLoad = YES;
                downloaditem.isFolder = simpleNode.container;
                downloaditem.oriPath = simpleNode.path;
                downloaditem.fileName = simpleNode.fileName;
                if (downloaditem.isFolder) {
                    _sysSize = 0;
                    NSMutableArray *ary = [[NSMutableArray alloc]init];
                    [ary addObject:simpleNode];
                    [self caculateTotalSystemFileCount:ary afcMedia:[ipod.fileSystem afcMediaDirectory]];
                    downloaditem.fileSize = _sysSize;
                    [ary release];
                }else {
                    downloaditem.fileSize = simpleNode.itemSize;
                }
                if (downloaditem.extension) {
                    downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:downloaditem.extension];
                }else {
                    downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                }
                downloaditem.exportPath = exportPath;
                downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
                downloaditem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
                
                [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                [dataArray addObject:downloaditem];
                [downloaditem release];
                downloaditem = nil;
            }
            IMBFileSystemExport *baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [baseTransfer startTransfer];
                [baseTransfer release];
                [dataArray release];
            });
        }
        [self reloadData:YES];
    }else {
        _isAllUpLoad = YES;
        DriveItem *downloaditem = [[DriveItem alloc] init];
        downloaditem.isDownLoad = NO;
        downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_12", nil);
        downloaditem.toDriveName = CustomLocalizedString(@"TransferUploading", nil);
        downloaditem.childArray = addDataSource;
        [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        _isDownLoadData = NO;
        
        switch (categoryNodesEnum) {
            case Category_CameraRoll:
                
                break;
            case Category_PhotoLibrary:
            {
                IMBPhotoEntity *albumEntity = [[IMBPhotoEntity alloc] init];
                albumEntity.albumZpk = 46;
                albumEntity.photoCounts = (int)[addDataSource count];
                albumEntity.albumKind = 1551;
                albumEntity.albumTitle = CustomLocalizedString(@"From_Product_Name", nil);
                albumEntity.albumType = CreateAlbum;
                albumEntity.photoType = CommonType;
                
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_img"];
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:albumEntity playlistID:0 delegate:self];
                [albumEntity release];
                albumEntity = nil;
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [baseTransfer startTransfer];
                    [baseTransfer release];
                });
                
                [downloaditem release];
                downloaditem = nil;
                
            }
                break;
            case Category_iBooks:
            {
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_books"];
                downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_13", nil);
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:nil playlistID:0 delegate:self];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [baseTransfer startTransfer];
                    [baseTransfer release];
                });
                
                [downloaditem release];
                downloaditem = nil;
                
            }
                break;
            case Category_appDoucment:
            case Category_Applications:
            {
                NSFileManager *fm = [NSFileManager defaultManager];
                for (NSString *pathStr in addDataSource) {
                    DriveItem *uploaditem = [[DriveItem alloc] init];
                    [uploaditem setIsDownLoad:NO];
                    [uploaditem setUploadParent:systemPath];
                    [uploaditem setFileName:[pathStr lastPathComponent]];
                    [uploaditem setLocalPath:pathStr];
                    uploaditem.toDriveName = CustomLocalizedString(@"TransferUploading", nil);
                    NSDictionary *fileInfoDic = [fm attributesOfItemAtPath:pathStr error:nil];
                    unsigned long long length = [fileInfoDic fileSize];
                    uploaditem.fileSize = length;
                    NSString *fileType = [fileInfoDic objectForKey:NSFileType];
                    if ([NSFileTypeRegular isEqualToString:fileType]) {
                        uploaditem.isFolder = NO;
                    } else if ([NSFileTypeDirectory isEqualToString:fileType]) {
                        uploaditem.isFolder = YES;
                    }
                    
                    if (uploaditem.isFolder) {
                        uploaditem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
                    }else {
                        uploaditem.photoImage = [TempHelper loadTransferFileImage:[pathStr pathExtension]];;
                    }
                    [uploaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                    [_downloadDataSource insertObject:uploaditem atIndex:0];
                }
                baseTransfer = [[IMBAirSyncImportTransfer alloc]initWithAppUpLoadIPodkey:ipod.uniqueKey importFiles:_downloadDataSource CategoryNodesEnum:categoryNodesEnum photoAlbum:nil playlistID:0 delegate:self];
                [(IMBAirSyncImportTransfer *)baseTransfer setAppKey:_appKey];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [(IMBAirSyncImportTransfer *)baseTransfer appStartTransfer];
                    [baseTransfer release];
                });
                
            }
                break;
            case Category_Media:
            {
                downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_28", nil);
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_media"];
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:nil playlistID:0 delegate:self];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [baseTransfer startTransfer];
                    [baseTransfer release];
                });
                
                [downloaditem release];
                downloaditem = nil;
                
            }
                break;
            case Category_Video:
            {
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_video"];
                downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_29", nil);
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:nil playlistID:0 delegate:self];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [baseTransfer startTransfer];
                    [baseTransfer release];
                });
                
                [downloaditem release];
                downloaditem = nil;
                
            }
                break;
            case Category_Storage:
            case Category_System:
                downloaditem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
                downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_35", nil);
                
                baseTransfer = [[IMBBaseTransfer alloc] initWithIPodkey:ipod.uniqueKey importTracks:downloaditem withCurrentPath:systemPath withDelegate:self];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [baseTransfer startTransfer];
                    [baseTransfer release];
                });
                
                [downloaditem release];
                downloaditem = nil;
                
                break;
            default:
                break;
        }
        [self reloadData:YES];
    }
    [self loadTranferView];
}
//设备到drive
- (void)downDeviceDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath {
    _isDownLoadData = NO;
    _isdeiveData = YES;
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    if (categoryNodesEnum == Category_CameraRoll || categoryNodesEnum == Category_PhotoStream || categoryNodesEnum == Category_PhotoLibrary) {
        for (id driveEntity in addDataSource) {
            DriveItem *downloaditem = [[DriveItem alloc] init];
            if ([driveEntity isKindOfClass:[IMBPhotoEntity class]]) {
                IMBPhotoEntity *photoEntity = (IMBPhotoEntity *)driveEntity;
                downloaditem.fileName = photoEntity.photoName;
                downloaditem.allPath = photoEntity.allPath;
                downloaditem.photoPath = photoEntity.photoPath;
                downloaditem.kindSubType = photoEntity.kindSubType;
                downloaditem.thumbPath = photoEntity.thumbPath;
                downloaditem.isAddCompleteView = YES;
                downloaditem.oriPath = photoEntity.oriPath;
                downloaditem.photoDateData = photoEntity.photoDateData;
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_img"];
                downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
                downloaditem.fileSize = photoEntity.photoSize;
                downloaditem.docwsID = photoEntity.photoUUIDString;
                if (downloaditem.oriPath) {
                    downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:[downloaditem.oriPath pathExtension]];
                }else {
                    downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                }
                [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                //                    [_downloadDataSource insertObject:downloaditem atIndex:0];
                [dataArray addObject:downloaditem];
            }
            [downloaditem release];
            downloaditem = nil;
        }
        IMBPhotoFileExport *baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
        
        [(IMBPhotoFileExport *)baseTransfer setExportType:1];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
            [baseTransfer release];
            [dataArray release];
        });
    }else if (categoryNodesEnum == Category_iBooks) {
        for (IMBBookEntity *bookEntity in addDataSource) {
            DriveItem *downloaditem = [[DriveItem alloc] init];
            downloaditem.fileName = bookEntity.bookName;
            downloaditem.oriPath = bookEntity.path;
            downloaditem.isBigFile = bookEntity.isPurchase;
            downloaditem.extension = bookEntity.extension;
            downloaditem.fileSize = bookEntity.size;
            downloaditem.isAddCompleteView = YES;
            downloaditem.allPath = bookEntity.fullPath;
            downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_books"];
            downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
            if (downloaditem.extension) {
                downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:downloaditem.extension];
            }else {
                downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
            }
            
            [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            
            
            //                [_downloadDataSource insertObject:downloaditem atIndex:0];
            [dataArray addObject:downloaditem];
            [downloaditem release];
            downloaditem = nil;
        }
        IMBiBooksExport *baseTransfer = [[IMBiBooksExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
            [baseTransfer release];
            [dataArray release];
        });
    }else if (categoryNodesEnum == Category_Media||categoryNodesEnum == Category_Video) {
        for (IMBTrack *track in addDataSource) {
            DriveItem *downloaditem = [[DriveItem alloc] init];
            downloaditem.fileName = track.title;
            downloaditem.oriPath = track.filePath;
            downloaditem.fileSize = track.fileSize;
            downloaditem.isAddCompleteView = YES;
            downloaditem.photoDateData = track.dateLastModified;
            if (categoryNodesEnum == Category_Media){
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_media"];
            }else {
                downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_video"];
            }
            
            downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
            if (downloaditem.oriPath) {
                downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:[downloaditem.oriPath  pathExtension]];
            }else {
                downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
            }
            [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            
            //                [_downloadDataSource insertObject:downloaditem atIndex:0];
            [dataArray addObject:downloaditem];
            [downloaditem release];
            downloaditem = nil;
        }
        
        IMBMediaFileExport *baseTransfer = [[IMBMediaFileExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
            [baseTransfer release];
            [dataArray release];
        });
    }else if (categoryNodesEnum == Category_System||categoryNodesEnum == Category_Storage) {
        for (SimpleNode *simpleNode in addDataSource) {
            DriveItem *downloaditem = [[DriveItem alloc] init];
            downloaditem.isFolder = simpleNode.container;
            downloaditem.oriPath = simpleNode.path;
            downloaditem.fileName = simpleNode.fileName;
            downloaditem.isAddCompleteView = YES;
            if (downloaditem.isFolder) {
                _sysSize = 0;
                NSMutableArray *ary = [[NSMutableArray alloc]init];
                [ary addObject:simpleNode];
                AFCMediaDirectory *afcMedia = [ipod.fileSystem afcMediaDirectory];
                [self caculateTotalSystemFileCount:ary afcMedia:afcMedia];
                downloaditem.fileSize = _sysSize;
                [ary release];
            }else {
                downloaditem.fileSize = simpleNode.itemSize;
            }
            if (downloaditem.oriPath) {
                downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:[downloaditem.oriPath pathExtension]];
            }else {
                downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
            }
            downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
            downloaditem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
            
            [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            
            //                [_downloadDataSource insertObject:downloaditem atIndex:0];
            [dataArray addObject:downloaditem];
            [downloaditem release];
            downloaditem = nil;
        }
        IMBFileSystemExport *baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
            [baseTransfer release];
            [dataArray release];
        });
    }else if (categoryNodesEnum == Category_Applications || categoryNodesEnum == Category_appDoucment) {
        for (id entity in addDataSource) {
            DriveItem *downloaditem = [[DriveItem alloc] init];
            downloaditem.isDownLoad = YES;
            if ([entity isKindOfClass:[IMBAppEntity class]]) {
                IMBAppEntity *appEntity = (IMBAppEntity *)entity;
                downloaditem.fileName = appEntity.appName;
                downloaditem.zone = appEntity.appKey;
                downloaditem.fileSize = appEntity.appSize;
                downloaditem.docwsID = appEntity.version;
            }else {
                SimpleNode *fileEntity = (SimpleNode *)entity;
                downloaditem.isFolder = fileEntity.container;
                downloaditem.oriPath = fileEntity.path;
                downloaditem.fileName = fileEntity.fileName;
                downloaditem.isAddCompleteView = YES;
                downloaditem.isDownLoad = YES;
                if (downloaditem.isFolder) {
                    _sysSize = 0;
                    NSMutableArray *ary = [[NSMutableArray alloc]init];
                    [ary addObject:fileEntity];
                    //取文件夹大小
                    AFCApplicationDirectory *afcAppmd = [ipod.deviceHandle newAFCApplicationDirectory:_appKey];
                    [self caculateTotalFileCount:ary afcMedia:afcAppmd];
                    downloaditem.fileSize = _sysSize;
                    [ary release];
                    [afcAppmd close];
                }else {
                    downloaditem.fileSize = fileEntity.itemSize;
                }
            }
            
            downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
            downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_app"];
            
            if (downloaditem.extension) {
                downloaditem.localPath = [[exportPath stringByAppendingPathComponent:downloaditem.fileName] stringByAppendingPathExtension:downloaditem.extension];
            }else {
                downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
            }
            [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            //            [_downloadDataSource insertObject:downloaditem atIndex:0];
            [dataArray addObject:downloaditem];
            [downloaditem release];
            downloaditem = nil;
        }
        IMBAppExport *baseTransfer = [[IMBAppExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:dataArray exportFolder:exportPath withDelegate:self];
        baseTransfer.appKey = _appKey;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer fileStartTransfer];
            [baseTransfer release];
            [dataArray release];
        });
    }
    //        [self reloadData:YES];
}
//设备到设备
- (void)toDeviceAddDataSorue:(NSMutableArray *)addDataSource withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum srciPodKey:(NSString *)srcIpodKey desiPodKey:(NSString *)desiPodKey {
    IMBBetweenDeviceHandler *_baseTransfer = nil;
    IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
    if (categoryNodesEnum == Category_Media) {
        model.categoryNodes = Category_Music;
    }else if (categoryNodesEnum == Category_Video) {
        model.categoryNodes = Category_Movies;
    }else {
        model.categoryNodes = categoryNodesEnum;
    }
    
    DriveItem *downloaditem = [[DriveItem alloc] init];
    downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_12", nil);
    downloaditem.toDriveName = CustomLocalizedString(@"TransferUploading", nil);
    downloaditem.childArray = addDataSource;
    downloaditem.isDownLoad = NO;
    downloaditem.speed = addDataSource.count;
    [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    switch (categoryNodesEnum) {
        case Category_CameraRoll:
            break;
        case Category_PhotoLibrary:
        {
            downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_library"];
            downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_12", nil);
            
        }
        case Category_iBooks:
        {
            downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_books"];
            downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_13", nil);
        }
            break;
        case Category_Applications:
        {
            downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_app"];
            downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_14", nil);
        }
            break;
        case Category_Media:
        {
            downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_media"];
            downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_28", nil);
            
        }
            break;
        case Category_Video:
        {
            downloaditem.photoImage = [NSImage imageNamed:@"folder_icon_video"];
            downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_29", nil);
        }
            break;
        case Category_Storage:
        case Category_System:
            break;
        default:
            break;
    }
    [_downloadDataSource insertObject:downloaditem atIndex:0];
    _baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:downloaditem categoryModel:model srcIpodKey:srcIpodKey desIpodKey:desiPodKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
    
    [self reloadData:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_baseTransfer startTransfer];
        [_baseTransfer release];
    });
    [self loadTranferView];
    [downloaditem release];
    downloaditem = nil;
}

//传输状态改变的回调函数，监听传输的状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    DriveItem *item = object;
    if (_isdeiveData&& item.isAddCompleteView == YES) {
        if (item.state == DownloadStateComplete) {
            [self loadToicloudDownLoadData:item];
        }else if (item.state == DownloadStateError){
            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        }
    }else {
        if ([keyPath isEqualToString:@"state"]){
            if (_isDownLoadData) {
                [self allDataDownCompleteData:item];
            }else{
                [self loadDataUploadComplet:item];
            }
        }
    }
}
//to icloud 导出完成  开始上传
- (void)loadToicloudDownLoadData:(DriveItem *)item{
    IMBDeviceConnection *deivceConnection = [IMBDeviceConnection singleton];
    IMBDriveBaseManage *driveManage = nil;
    for (IMBBaseInfo *baseInfo in deivceConnection.allDevices) {
        if (baseInfo.chooseModelEnum != DeviceLogEnum &&baseInfo.isSelected) {
            driveManage = baseInfo.driveBaseManage;
        }
    }
    if (!driveManage) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:_iPod.uniqueKey btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"MSG_Device_Edition_Too_high", nil) btnClickedBlock:nil];
        return;
    }
    [(NSObject*)item removeObserver:self forKeyPath:@"state"];
    //            [_downloadDataSource removeObject:item];
    _isDownLoadData = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    DriveItem *uploaditem = [[DriveItem alloc] init];
    [uploaditem setUploadParent:@"0"];
    [uploaditem setFileName:[item.localPath lastPathComponent]];
    [uploaditem setLocalPath:item.localPath];
    [uploaditem setUploadDocwsID:@"root"];
    uploaditem.isAddCompleteView = NO;
    uploaditem.isDownLoad = NO;
    uploaditem.toDriveName = CustomLocalizedString(@"TransferUploading", nil);
    BOOL isFolder; //isFolder用来记录该路径是否是文件夹
    [fm fileExistsAtPath:item.localPath isDirectory:&isFolder];
    uploaditem.isFolder = isFolder;
    if (isFolder) {
        uploaditem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
    }else {
        uploaditem.photoImage = [TempHelper loadTransferFileImage:[item.localPath pathExtension]];;
    }
    NSDictionary *fileAttributes = [fm attributesOfItemAtPath:item.localPath error:nil];
    unsigned long long length = [fileAttributes fileSize];
    uploaditem.fileSize = length;
    [uploaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [_downloadDataSource insertObject:uploaditem atIndex:0];
    if (uploaditem) {
        [driveManage oneDriveUploadItem:uploaditem];
    }
    
    [self reloadData:YES];
    [uploaditem release];
    uploaditem = nil;
}

-(void)driveToDriveDownLoadDataComplete:(DriveItem *) uploaditem{
    
    DriveItem *uploaditem1 = [[DriveItem alloc] init];
    [uploaditem1 setIsDownLoad:NO];
    [uploaditem1 setUploadParent:uploaditem.uploadParent];
    [uploaditem1 setFileName:[uploaditem.localPath lastPathComponent]];
    [uploaditem1 setLocalPath:uploaditem.localPath];
    if (!uploaditem1.photoImage) {
        uploaditem1.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
    }
    uploaditem1.toDriveName = CustomLocalizedString(@"TransferUploading", nil);
    uploaditem1.fileSize = uploaditem.fileSize;
    BOOL isFolder;
    uploaditem1.isFolder = uploaditem.isFolder;
    if (isFolder) {
        if (!uploaditem1.photoImage) {
            uploaditem1.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
        }
    }else {
        if (!uploaditem1.photoImage) {
            uploaditem1.photoImage = [TempHelper loadTransferFileImage:[uploaditem.localPath pathExtension]];;
        }
    }
    [uploaditem1 addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [_downloadDataSource removeObject:uploaditem];
    [_downloadDataSource insertObject:uploaditem1 atIndex:0];
    
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    IMBBaseInfo *iCloudBaseInfo = nil;
    if (_chooseModeEnum == iCloudLogEnum) {
        for (IMBBaseInfo *baseInfo in connection.allDevices) {
            if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                iCloudBaseInfo = baseInfo;
            }
        }
    }else if (_chooseModeEnum == DropBoxLogEnum) {
        for (IMBBaseInfo *baseInfo in connection.allDevices) {
            if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                iCloudBaseInfo = baseInfo;
            }
        }
    }
    [uploaditem1 addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [iCloudBaseInfo.driveBaseManage oneDriveUploadItem:uploaditem1];
    [uploaditem1 release];
}

//数据下载完成
- (void)allDataDownCompleteData :(DriveItem *)item {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    item.completeDate = [formatter stringFromDate:date];
    
    sqlite3 *dbPoint;
    NSString *tempPath = [TempHelper getAppiMobieConfigPath];
    NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
    sqlite3_open([documentPath UTF8String], &dbPoint);
    
    NSString *sldsf = [self greadSqlite];
    sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);
    if (item.state == DownloadStateComplete) {
        [_downloadDataSource removeObject:item];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        if (_downloadDataSource.count < 1) {
            [_transferBtn endTranfering];
        }
        //        });
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeDate,item.fileSize,1,1,item.docwsID,item.isFolder];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        item.toDriveName = CustomLocalizedString(@"TransferCompelete", nil);
        [(IMBTranferViewController*)_delegate loadCompleteData:item];
        
        
        if (_downloadDataSource.count == 0) {
            [_contentBox setContentView:_nodataView];
        }
        [self reloadData:YES];
        [(NSObject*)item removeObserver:self forKeyPath:@"state"];
    }else if (item.state == DownloadStateError){
        [_downloadDataSource removeObject:item];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        if (_downloadDataSource.count < 1) {
            [_transferBtn endTranfering];
        }
        //        });
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeDate,item.fileSize,0,1,item.docwsID,item.isFolder];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        item.toDriveName = CustomLocalizedString(@"TransferFailed", nil);
        //            [_completeArray addObject:item];
        [(IMBTranferViewController*)_delegate loadCompleteData:item];
        if (_downloadDataSource.count == 0) {
            [_contentBox setContentView:_nodataView];
        }
        [self reloadData:YES];
        [(NSObject*)item removeObserver:self forKeyPath:@"state"];
    }
    sqlite3_close(dbPoint);
}

//数据上传完成
-(void)loadDataUploadComplet:(DriveItem *)item {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    item.completeDate = [formatter stringFromDate:date];
    
    sqlite3 *dbPoint;
    NSString *tempPath = [TempHelper getAppiMobieConfigPath];
    NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
    sqlite3_open([documentPath UTF8String], &dbPoint);
    
    NSString *sldsf = [self greadSqlite];
    sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);
    
    if (item.state == UploadStateComplete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_downloadDataSource.count <= 1) {
                if (_delegate && [_delegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    //这里没有统计总的个数和成功个数
                    [_delegate transferComplete:1 TotalCount:1];
                }
                [_transferBtn endTranfering];
            }
        });
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeDate,item.fileSize,1,0,item.docwsID,item.isFolder];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        item.toDriveName = CustomLocalizedString(@"Transfer_completeView_transferState_Upload_Complete", nil);
        [(IMBTranferViewController*)_delegate loadCompleteData:item];
        [_downloadDataSource removeObject:item];
        if (_chooseModeEnum == iCloudLogEnum) {
        }else if (_chooseModeEnum == DropBoxLogEnum) {
        }else {
            
        }
        if (_downloadDataSource.count == 0) {
            [_contentBox setContentView:_nodataView];
        }
        [self reloadData:YES];
        [(NSObject*)item removeObserver:self forKeyPath:@"state"];
    }else if (item.state == UploadStateError){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_downloadDataSource.count <= 1) {
                if (_delegate && [_delegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    //这里没有统计总的个数和成功个数
                    [_delegate transferComplete:1 TotalCount:1];
                }
                [_transferBtn endTranfering];
            }
        });
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeDate,item.fileSize,0,0,item.docwsID,item.isFolder];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        item.toDriveName = CustomLocalizedString(@"TransferFailed", nil);
        [(IMBTranferViewController*)_delegate loadCompleteData:item];
        [_downloadDataSource removeObject:item];
        if (_chooseModeEnum == iCloudLogEnum) {
            //                [_completeArray addObject:item];
        }else if (_chooseModeEnum == DropBoxLogEnum) {
            //                [_completeArray addObject:item];
        }else {
            
        }
        if (_downloadDataSource.count == 0) {
            [_contentBox setContentView:_nodataView];
        }
        [self reloadData:YES];
        [self reloadData:YES];
        [(NSObject*)item removeObserver:self forKeyPath:@"state"];
    }
    sqlite3_close(dbPoint);
}

- (void)reloadData:(BOOL)isAdd {
    if (isAdd) {
        NSMutableArray *disAry = nil;
        if (_isDownLoadData) {
            disAry = _downloadDataSource;
        } else {
            disAry = _downloadDataSource;
        }
        if ([disAry count]>0) {
            
            [_scrollView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [_contentBox setContentView:_scrollView];
            [_tableView reloadData];
        }else{
            [_nodataView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [_contentBox setContentView:_nodataView];
        }
    }
}

#pragma mark - NSTableView Datasource and Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 66;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *disAry = nil;
    if (_isDownLoadData) {
        disAry = _downloadDataSource;
    }else {
        disAry = _downloadDataSource;
    }
    return [disAry count];
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(ObjectTableRowView *)rowView forRow:(NSInteger)row {
    if ([rowView.subviews count]>0) {
        DownloadCellView *cellView = (DownloadCellView *)[[rowView subviews] objectAtIndex:0];
        if ([cellView isKindOfClass:[DownloadCellView class]]) {
            [cellView.progessField unbind:@"value"];
            [cellView.downloadFaildField unbind:@"value"];
            [cellView.progessView unbind:@"doubleValue"];
            [cellView.transferProgressView unbind:@"doubleValue"];
        }
    }
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    NSMutableArray *disAry = nil;
    if (_isDownLoadData) {
        disAry = _downloadDataSource;
    }else {
        disAry = _downloadDataSource;
    }
    ObjectTableRowView *result = [[ObjectTableRowView alloc] initWithFrame:NSMakeRect(0, 0, TableViewRowWidth, TableViewRowHight)];
    result.objectValue = [disAry objectAtIndex:row];
    return [result autorelease];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *disAry = nil;
    if (_isDownLoadData) {
        disAry = _downloadDataSource;
    }else {
        disAry = _downloadDataSource;
    }
    DownloadCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    DriveItem *entity = [disAry objectAtIndex:row];
    if (entity.isDownLoad) {
        [cellView.downOrUpImage setImage:[NSImage imageNamed:@"transferlist_icon_downloading"]];
    }else {
        [cellView.downOrUpImage setImage:[NSImage imageNamed:@"transferlist_icon_uploading"]];
    }
    [cellView.propertityViewArray removeAllObjects];
    
    [cellView setDownLoadDriveItem:entity];
    
    if (entity.fileName.length>0) {
        [cellView.titleField setStringValue:entity.fileName];
    }
    if (entity.photoImage) {
        [cellView.icon setImage:entity.photoImage];
    }else{
        [cellView.icon setImage:entity.photoImage];
    }
    
    if (entity.parent) {
        [cellView.progessField bind:@"value" toObject:entity.parent withKeyPath:@"currentSizeStr" options:nil];
    }else{
        [cellView.progessField bind:@"value" toObject:entity withKeyPath:@"currentSizeStr" options:nil];
    }
    
    [cellView.downloadFaildField bind:@"value" toObject:entity withKeyPath:@"toDriveName" options:nil];
    for (NSView *subView in cellView.subviews) {
        [subView setHidden:YES];
    }
    [cellView adjustSpaceX:OringinalPropertityX Y:OringinalPropertityY];
    [cellView.icon setHidden:NO];
    [cellView.downOrUpImage setHidden:NO];
    [cellView.titleField setHidden:NO];
    [cellView.transferProgressView bind:@"doubleValue" toObject:entity withKeyPath:@"progress" options:nil];
    //    if (entity.state == DownloadStateLoading ||entity.state == UploadStateLoading|| entity.state == TransferStateNormal) {
    [cellView.progessView bind:@"doubleValue" toObject:entity withKeyPath:@"progress" options:nil];
    [cellView.progessView setHidden:NO];
    [cellView.progessField setHidden:NO];
    [cellView.downloadFaildField setHidden:NO];
    //        [cellView.finderButton setHidden:NO];
    //        [cellView.finderButton setTarget:self];
    //        [cellView.finderButton setAction:@selector(finderFile:)];
    //        [cellView.deleteButton setHidden:NO];
    //        [cellView.deleteButton setTarget:self];
    //        [cellView.deleteButton setAction:@selector(deleteFile:)];
    //    [cellView.closeButton setHidden:NO];
    [cellView.closeButton setTarget:self];
    [cellView.closeButton setAction:@selector(closeTask:)];
    //    }
    return cellView;
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    
}

- (void)closeWindow:(id)sender {
    
}

#pragma makr Actions
- (void)finderFile:(id)sender {
}

-(void)transferBtn:(IMBHoverChangeImageBtn *)transferBtn {
    _transferBtn = transferBtn;
}

//取消下载
- (void)closeTask:(id)sender {
    ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
    DriveItem *entity = (DriveItem *)rowView.objectValue;
    NSMutableArray *disAry = nil;
    if (_isDownLoadData) {
        disAry = _downloadDataSource;
    }else {
        disAry = _downloadDataSource;
    }
    if (_isDownLoadData) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            [TempHelper customViewType:_chooseModeEnum withCategoryEnum:_categoryEnum];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (_chooseModeEnum == iCloudLogEnum) {
            [ATTracker event:CiCloud action:ACancel label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (_chooseModeEnum == DropBoxLogEnum) {
            [ATTracker event:CDropbox action:ACancel label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (_chooseModeEnum == DeviceLogEnum) {
            [ATTracker event:CDevice action:ACancel label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [_deviceManager cancelDownloadItem:entity];
        [disAry removeObject:entity];
        if (disAry.count <1) {
            [_transferBtn endTranfering];
        }
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        entity.completeDate = [formatter stringFromDate:date];
        entity.toDriveName = CustomLocalizedString(@"Transfer_completeView_transferState_Error", nil);
        entity.state = DownloadStateError;
        sqlite3 *dbPoint;
        NSString *tempPath = [TempHelper getAppiMobieConfigPath];
        NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
        sqlite3_open([documentPath UTF8String], &dbPoint);
        NSString *sldsf = [self greadSqlite];
        sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);
        //        NSString *insertData = [NSString stringWithFormat:@"insert into \"main\".\"FileHistory\" (\"transfer_name\",\"transfer_exportPath\",\"transfer_time\",\"transfer_size\",\"transfer_status\",\"transfer_isdown\",\"transfer_id\") values ('%@','%@','%@','%lld','0','1','%@');",entity.fileName,entity.localPath,entity.completeDate,entity.fileSize,entity.docwsID];
        
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],entity.fileName,entity.localPath,entity.completeDate,entity.fileSize,0,1,entity.docwsID,entity.isFolder];
        
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        entity.toDriveName = CustomLocalizedString(@"Download Fail", nil);
        sqlite3_close(dbPoint);
        [(IMBTranferViewController*)_delegate loadCompleteData:entity];
        
    }else {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            [TempHelper customViewType:_chooseModeEnum withCategoryEnum:_categoryEnum];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (_chooseModeEnum == iCloudLogEnum) {
            [ATTracker event:CiCloud action:ACancel label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (_chooseModeEnum == DropBoxLogEnum) {
            [ATTracker event:CDropbox action:ACancel label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (_chooseModeEnum == DeviceLogEnum) {
            [ATTracker event:CDevice action:ACancel label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [disAry removeObject:entity];
        if (disAry.count <1) {
            [_transferBtn endTranfering];
        }
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        entity.completeDate = [formatter stringFromDate:date];
        entity.toDriveName = CustomLocalizedString(@"Transfer_completeView_transferState_Complete", nil);
        entity.state = UploadStateError;
        [_deviceManager cancelUploadItem:entity];
        sqlite3 *dbPoint;
        NSString *tempPath = [TempHelper getAppiMobieConfigPath];
        NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
        sqlite3_open([documentPath UTF8String], &dbPoint);
        NSString *sldsf = [self greadSqlite];
        sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);
        //        NSString *insertData = [NSString stringWithFormat:@"insert into \"main\".\"FileHistory\" (\"transfer_name\",\"transfer_exportPath\",\"transfer_time\",\"transfer_size\",\"transfer_status\",\"transfer_isdown\",\"transfer_id\") values ('%@','%@','%@','%lld','0','0','%@');",entity.fileName,entity.localPath,entity.completeDate,entity.fileSize,entity.docwsID];
        int isparent = 0;
        if (entity.parent) {
            isparent = 1;
        }else{
            isparent = 0;
        }
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],entity.fileName,entity.localPath,entity.completeDate,entity.fileSize,0,0,entity.docwsID,isparent];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        entity.toDriveName = CustomLocalizedString(@"Download Fail", nil);
        sqlite3_close(dbPoint);
        [(IMBTranferViewController*)_delegate loadCompleteData:entity];
        [formatter release];
        formatter = nil;
    }
    [_tableView reloadData];
}

- (void)cleanlist:(id)sender {
    if ([_downloadDataSource count] == 0) {
        return;
    }
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
}

- (void)learnMore:(id)sender {
    //跳转到anytrans主页；
    NSURL *url = nil;
    url = [NSURL URLWithString:CustomLocalizedString(@"Product_Url", nil)];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)removeAllUpOrDownData {
    NSMutableArray *disAry = nil;
    if (_isDownLoadData) {
        disAry = _downloadDataSource;
    }else {
        disAry = _downloadDataSource;
    }
    NSMutableArray *copyArray = [_downloadDataSource copy];
    //    if (_isDownLoadData) {
    for (DriveItem *entity in copyArray) {
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        entity.completeDate = [formatter stringFromDate:date];
        entity.toDriveName = CustomLocalizedString(@"Transfer_completeView_transferState_Error", nil);
        entity.state = DownloadStateError;
        sqlite3 *dbPoint;
        NSString *tempPath = [TempHelper getAppiMobieConfigPath];
        NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
        sqlite3_open([documentPath UTF8String], &dbPoint);
        NSString *sldsf = [self greadSqlite];
        sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);
        //            NSString *insertData = [NSString stringWithFormat:@"insert into \"main\".\"FileHistory\" (\"transfer_name\",\"transfer_exportPath\",\"transfer_time\",\"transfer_size\",\"transfer_status\",\"transfer_isdown\",\"transfer_id\") values ('%@','%@','%@','%lld','0','1','%@');",entity.fileName,entity.localPath,entity.completeDate,entity.fileSize,entity.docwsID];
        int isparent = 0;
        if (entity.parent) {
            isparent = 1;
        }else{
            isparent = 0;
        }
        [_deviceManager cancelUploadItem:entity];
        [_deviceManager cancelDownloadItem:entity];
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],entity.fileName,entity.localPath,entity.completeDate,entity.fileSize,0,1,entity.docwsID,isparent];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        entity.toDriveName = CustomLocalizedString(@"Download Fail", nil);
        sqlite3_close(dbPoint);
        [(IMBTranferViewController*)_delegate loadCompleteData:entity];
        [formatter release];
        formatter = nil;
    }
    [_transferBtn endTranfering];
    [copyArray release];
    [disAry removeAllObjects];
    [_tableView reloadData];
}

#pragma mark -- transferDelegate
//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
}
//传输准备进度结束
- (void)transferPrepareFileEnd {
    
}
//传输进度
- (void)transferProgress:(float)progress {
    
}
//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    
}
//分析进度
- (void)parseProgress:(float)progress {
    
}
//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    
}
//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    if  (_isAllUpLoad){
        //        if (_delegate && [_delegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        //            [_delegate transferComplete:successCount TotalCount:totalCount];
        //        }
    }
}

//传输出现错误
- (BOOL)transferOccurError:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStopLoadingAnimNoti object:_iPod.uniqueKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
    });
    return YES;
}

- (void)transferCurrentSize:(long long)currenSize {
    
}

- (void)reloadBgview {
    [self.view setNeedsDisplay:YES];
}

#pragma mark -- 辅助方法
- (void)loadTranferView {
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    if (tranferView.view.superview) {
        return;
    }
    [tranferView reparinitialization];
    [tranferView.view setFrame:NSMakeRect(((NSViewController *)tranferView.showWindowDelegate).view.window.contentView.frame.size.width - 360+4 , -6, 360, tranferView.view.frame.size.height)];
    
    NSView *view = nil;
    for (NSView *subView in (((NSViewController *)tranferView.showWindowDelegate).view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
            view = subView;
            break;
        }
    }
    
    IMBMainPageViewController *mainPage = (IMBMainPageViewController *)tranferView.showWindowDelegate;
    mainPage.isShowTranfer = YES;
    for (NSView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
    [tranferView.view setWantsLayer:YES];
    [view setHidden:NO];
    [view setWantsLayer:YES];
    [view addSubview:tranferView.view];
    [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:tranferView.view.frame.size.width] toX:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0]  forKey:@"moveX"];
}

- (NSArray *)getFirstContent:(NSString *)path afcMedia:(AFCApplicationDirectory *)afcMedia {
    NSMutableArray *nodeArray = [NSMutableArray array];
    NSArray *array = [afcMedia directoryContents:path];
    for (NSString *fileName in array) {
        NSString *filePath = nil;
        if ([path isEqualToString:@"/"]) {
            
            filePath = [NSString stringWithFormat:@"/%@",fileName];
        }else
        {
            
            filePath = [path stringByAppendingPathComponent:fileName];
        }
        
        SimpleNode *node = [[SimpleNode alloc] initWithName:fileName];
        node.path = filePath;
        node.parentPath = path;
        NSDictionary *fileDic = [afcMedia getFileInfo:filePath];
        NSString *fileType = [fileDic objectForKey:@"st_ifmt"];
        if ([fileType isEqualToString:@"S_IFDIR"]) {
            node.container = YES;
        }else
        {
            node.container = NO;
            node.itemSize = [[fileDic objectForKey:@"st_size"] longLongValue];
        }
        [nodeArray addObject:node];
        [node release];
    }
    return nodeArray;
}

- (void)caculateTotalFileCount:(NSArray *)nodeArray afcMedia:(AFCApplicationDirectory *)afcMedia
{
    for (SimpleNode *node in nodeArray) {
        if (!node.container) {
            _sysSize += node.itemSize;
        }else
        {
            NSArray *arr = [self getFirstContent:node.path afcMedia:afcMedia];
            [self caculateTotalFileCount:arr afcMedia:afcMedia];
        }
    }
}

- (void)caculateTotalSystemFileCount:(NSArray *)nodeArray afcMedia:(AFCMediaDirectory *)afcMedia {
    for (SimpleNode *node in nodeArray) {
        if (!node.container) {
            _sysSize += node.itemSize;
        }else {
            NSArray *arr = [self getSystemContent:node.path afcMedia:afcMedia];
            [self caculateTotalSystemFileCount:arr afcMedia:afcMedia];
        }
    }
}

- (NSArray *)getSystemContent:(NSString *)path afcMedia:(AFCMediaDirectory *)afcMedia {
    NSMutableArray *nodeArray = [NSMutableArray array];
    NSArray *array = [afcMedia directoryContents:path];
    for (NSString *fileName in array) {
        NSString *filePath = nil;
        if ([path isEqualToString:@"/"]) {
            filePath = [NSString stringWithFormat:@"/%@",fileName];
        }else
        {
            filePath = [path stringByAppendingPathComponent:fileName];
        }
        SimpleNode *node = [[SimpleNode alloc] initWithName:fileName];
        node.fileName = [fileName stringByDeletingPathExtension];
        node.path = filePath;
        node.parentPath = path;
        NSDictionary *fileDic = [afcMedia getFileInfo:filePath];
        NSString *fileType = [fileDic objectForKey:@"st_ifmt"];
        NSDate *createDate = [fileDic objectForKey:@"st_birthtime"];
        int64_t fileSize = (int)[fileDic objectForKey:@"st_size"];
        NSDate *lastDate = [fileDic objectForKey:@"st_mtime"];
        node.itemSize = fileSize;
        NSString *extension = [node.path pathExtension];
        if (![StringHelper stringIsNilOrEmpty:extension]) {
            extension = [extension lowercaseString];
        }
        node.extension = extension;
        node.creatDate = [DateHelper stringFromFomate:createDate formate:@"yyyy-MM-dd HH:mm"];
        node.lastDate = [DateHelper stringFromFomate:lastDate formate:@"yyyy-MM-dd HH:mm"];
        if ([fileType isEqualToString:@"S_IFDIR"]) {
            node.container = YES;
            NSImage *picture = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];
            node.image = picture;
            node.extension = @"Folder";
        }else {
            node.container = NO;
            node.itemSize = [[fileDic objectForKey:@"st_size"] longLongValue];
            node.image = [TempHelper loadTransferFileImage:extension];
        }
        [nodeArray addObject:node];
        [node release];
    }
    
    return nodeArray;
}

- (NSString *)greadSqlite {
    return  @"create table \"main\".\"FileHistory\" (\"history_id\" integer primary key autoincrement not null, \"transfer_name\" text,\"transfer_exportPath\" text,\"transfer_time\" text,\"transfer_size\" integer, \"transfer_status\" integer, \"transfer_isdown\" integer, \"transfer_id\" text,\"transfer_isfolder\" integer);";
}

- (NSString*)insertDataSqlite {
    NSString *insertData = @"insert into \"main\".\"FileHistory\" (\"transfer_name\",\"transfer_exportPath\",\"transfer_time\",\"transfer_size\",\"transfer_status\",\"transfer_isdown\",\"transfer_id\",\"transfer_isfolder\") values ('%@','%@','%@','%lld','%d','%d','%@','%d');";
    return insertData;
}

- (void)dealloc {
    //    [_completeArray release],_completeArray = nil;
    [_deviceManager release],_deviceManager = nil;
    [_downloadDataSource release],_downloadDataSource = nil;
    [_downloadDataSource release],_downloadDataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}
@end
