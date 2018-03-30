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
@interface IMBDownloadListViewController ()

@end

@implementation IMBDownloadListViewController
@synthesize downloadDataSource = _downloadDataSource;
@synthesize deviceManager = _deviceManager;
@synthesize iPod = _iPod;
@synthesize exportPath = _exportPath;
@synthesize delagete = _delegate;
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
    _uploadDataSource = [[NSMutableArray alloc] init];
//    _completeArray = [[NSMutableArray alloc]init];
    //    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_nodataImageView setImage:[StringHelper imageNamed:@"download_nodata"]];
    [_noTipTextField setTextColor:NODATA_NOLIKTITLE_COLOR];
    [_noTipTextField setStringValue:CustomLocalizedString(@"downloadpageNoDataTips", nil)];
//     [_tableView setIsTranferView:YES];
//    [self.view setWantsLayer:YES];
//    [self.view.layer setMasksToBounds:YES];
//    [self.view.layer setCornerRadius:5];
    [_tableView setBackgroundColor:[NSColor clearColor]];
    if (_downloadDataSource.count == 0) {
        [_contentBox setContentView:_nodataView];
    }
}

- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent{
    _chooseModeEnum = iCloudLogEnum;
    _deviceManager = driveBaseManage ;
    if (isDown) {
        _isDownLoadData = YES;
        for (IMBDriveEntity *driveEntity in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.itemIDOrPath = driveEntity.fileID;
                downloaditem.docwsID = driveEntity.docwsid;
                downloaditem.zone = driveEntity.zone;
                downloaditem.fileSize = driveEntity.fileSize;
                downloaditem.photoImage = [driveEntity.image retain];
                downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
                if (driveEntity.isFolder) {
                    downloaditem.isFolder = YES;
                    downloaditem.fileName = driveEntity.fileName;
                }else {
                    downloaditem.isFolder = NO;
                    if (driveEntity.extension){
                     downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
                    }else {
                        downloaditem.fileName = driveEntity.fileName;
                    }
                }
            [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [_downloadDataSource insertObject:downloaditem atIndex:0];
            [downloaditem release];
            downloaditem = nil;
        }
        [_deviceManager driveDownloadItemsToMac:_downloadDataSource];
    }else {
        _isDownLoadData = NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        for (NSString *pathStr in addDataSource) {
            DriveItem *uploaditem = [[DriveItem alloc] init];
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
            [uploaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [_uploadDataSource insertObject:uploaditem atIndex:0];
        }
        [_deviceManager driveUploadItems:_uploadDataSource];
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
            downloaditem.itemIDOrPath = driveEntity.fileID;
            downloaditem.docwsID = driveEntity.docwsid;
            downloaditem.zone = driveEntity.zone;
            downloaditem.fileSize = driveEntity.fileSize;
            downloaditem.photoImage = [driveEntity.image retain];
            downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
            if (driveEntity.isFolder) {
                downloaditem.isFolder = YES;
                downloaditem.fileName = driveEntity.fileName;
            }else {
                downloaditem.isFolder = NO;
                if (driveEntity.extension){
                    downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
                }else {
                    downloaditem.fileName = driveEntity.fileName;
                }
            }
            [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [_downloadDataSource insertObject:downloaditem atIndex:0];
            [downloaditem release];
            downloaditem = nil;
        }
        [_deviceManager driveDownloadItemsToMac:_downloadDataSource];

    }else {
        _isDownLoadData = NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        for (NSString *pathStr in addDataSource) {
            DriveItem *uploaditem = [[DriveItem alloc] init];
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
            [uploaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [_uploadDataSource insertObject:uploaditem atIndex:0];
        }
        [_deviceManager driveUploadItems:_uploadDataSource];

    }
    [self reloadData:YES];
}

- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath{
    _chooseModeEnum = DeviceLogEnum;
    IMBAirSyncImportTransfer *baseTransfer = nil;
    if (isDown) {
        _isDownLoadData = YES;
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
                    downloaditem.oriPath = photoEntity.oriPath;
                    downloaditem.photoDateData = photoEntity.photoDateData;
                    downloaditem.toDriveName = CustomLocalizedString(@"TransferDownloading", nil);
                    downloaditem.fileSize = photoEntity.photoSize;
                    downloaditem.docwsID = photoEntity.photoUUIDString;
                    downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
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
             downloaditem.fileName = bookEntity.bookName;
             downloaditem.oriPath = bookEntity.path;
             downloaditem.isBigFile = bookEntity.isPurchase;
             downloaditem.extension = bookEntity.extension;
             downloaditem.fileSize = bookEntity.size;
             downloaditem.allPath = bookEntity.fullPath;
             downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
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
                downloaditem.fileName = track.title;
                downloaditem.oriPath = track.filePath;
                downloaditem.fileSize = track.fileSize;
                downloaditem.localPath = [exportPath stringByAppendingPathComponent:downloaditem.fileName];
                downloaditem.photoDateData = track.dateLastModified;
                [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                [dataArray addObject:downloaditem];
                [downloaditem release];
                downloaditem = nil;
            }

            IMBMediaFileExport *baseTransfer = [[IMBMediaFileExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:_downloadDataSource exportFolder:exportPath withDelegate:self];
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [baseTransfer startTransfer];
//                [baseTransfer release];
//                [dataArray release];
//            });
        }else if (categoryNodesEnum == Category_Applications) {
            for (IMBAppEntity *appEntity in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.fileName = appEntity.appName;
                downloaditem.zone = appEntity.appKey;
                downloaditem.fileSize = appEntity.appSize;
                downloaditem.docwsID = appEntity.version;
                [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                [_downloadDataSource insertObject:downloaditem atIndex:0];
                [dataArray addObject:downloaditem];
                [downloaditem release];
                downloaditem = nil;
            }
           IMBAppExport *baseTransfer = [[IMBAppExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:_downloadDataSource exportFolder:exportPath withDelegate:self];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [baseTransfer startTransfer];
                [baseTransfer release];
                [dataArray release];
            });
        }
        [self reloadData:YES];
    }else {
        DriveItem *downloaditem = [[DriveItem alloc] init];
//        if (categoryNodesEnum == Category_PhotoLibrary) {
//            downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_12", nil);
//        }else if (<#expression#>)
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
                albumEntity.albumTitle = @"From iOSFiles";
                albumEntity.albumType = CreateAlbum;
                albumEntity.photoType = CommonType;
            
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:albumEntity playlistID:0 delegate:self];
                [albumEntity release];
                albumEntity = nil;
           
                [_uploadDataSource insertObject:downloaditem atIndex:0];
    
            }
                break;
            case Category_iBooks:
            {
               downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_13", nil);
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:nil playlistID:0 delegate:self];
                [_uploadDataSource insertObject:downloaditem atIndex:0];
            }
                break;
            case Category_Applications:
            {
                downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_14", nil);
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:nil playlistID:0 delegate:self];
                     [_uploadDataSource insertObject:downloaditem atIndex:0];
            }
                break;
            case Category_Media:
            {
                downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_28", nil);
             
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:nil playlistID:0 delegate:self];
                [_uploadDataSource insertObject:downloaditem atIndex:0];
            }
                break;
            case Category_Video:
            {
                downloaditem.fileName = CustomLocalizedString(@"MenuItem_id_29", nil);
                baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey importFiles:downloaditem CategoryNodesEnum:categoryNodesEnum photoAlbum:nil playlistID:0 delegate:self];
                [_uploadDataSource insertObject:downloaditem atIndex:0];
            }
                break;
            default:
                break;
        }
        [downloaditem release];
        downloaditem = nil;
        [self reloadData:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [baseTransfer startTransfer];
        });

    }

}

//传输状态改变的回调函数，监听传输的状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id <DownloadAndUploadDelegate> item = object;
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
    if (_isDownLoadData) {
        if (item.state == DownloadStateComplete) {
            NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeDate,item.fileSize,1,1,item.docwsID,item.isFolder];
            sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
            item.toDriveName = CustomLocalizedString(@"TransferCompelete", nil);
            [(IMBTranferViewController*)_delegate loadCompleteData:item];
//            if (_isdeiveData) {
//                item.isDriveDataComplete = YES;
//            }else{
                [_downloadDataSource removeObject:item];
//            }

            if (_downloadDataSource.count == 0) {
                [_contentBox setContentView:_nodataView];
            }
            [self reloadData:YES];
            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        }else if (item.state == DownloadStateError){
            NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeDate,item.fileSize,0,1,item.docwsID,item.isFolder];
            sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
            item.toDriveName = CustomLocalizedString(@"TransferFailed", nil);
//            [_completeArray addObject:item];
            [(IMBTranferViewController*)_delegate loadCompleteData:item];
            [_downloadDataSource removeObject:item];
            if (_downloadDataSource.count == 0) {
                [_contentBox setContentView:_nodataView];
            }
            [self reloadData:YES];
            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        }
            sqlite3_close(dbPoint);
    }else{
        if (item.state == UploadStateComplete) {
//            NSString *insertData = [NSString stringWithFormat:@"insert into \"main\".\"FileHistory\" (\"transfer_name\",\"transfer_exportPath\",\"transfer_time\",\"transfer_size\",\"transfer_status\",\"transfer_isdown\",\"transfer_id\") values ('%@','%@','%@','%lld','1','0','%@');",item.fileName,item.localPath,item.completeDate,item.fileSize,item.docwsID];
     
            NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeDate,item.fileSize,1,0,item.docwsID,item.isFolder];
            sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
            item.toDriveName = CustomLocalizedString(@"Transfer_completeView_transferState_Upload_Complete", nil);
            [(IMBTranferViewController*)_delegate loadCompleteData:item];
            [_uploadDataSource removeObject:item];
            if (_chooseModeEnum == iCloudLogEnum) {
            }else if (_chooseModeEnum == DropBoxLogEnum) {
            }else {
                
            }
            if (_uploadDataSource.count == 0) {
                [_contentBox setContentView:_nodataView];
            }
            [self reloadData:YES];
            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        }else if (item.state == UploadStateError){
//            NSString *insertData = [NSString stringWithFormat:@"insert into \"main\".\"FileHistory\" (\"transfer_name\",\"transfer_exportPath\",\"transfer_time\",\"transfer_size\",\"transfer_status\",\"transfer_isdown\",\"transfer_id\") values ('%@','%@','%@','%lld','0','0','%@');",item.fileName,item.localPath,item.completeDate,item.fileSize,item.docwsID];

            NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeDate,item.fileSize,0,0,item.docwsID,item.isFolder];
            sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
            item.toDriveName = CustomLocalizedString(@"TransferFailed", nil);
            [(IMBTranferViewController*)_delegate loadCompleteData:item];
            [_uploadDataSource removeObject:item];
            if (_chooseModeEnum == iCloudLogEnum) {
//                [_completeArray addObject:item];
            }else if (_chooseModeEnum == DropBoxLogEnum) {
//                [_completeArray addObject:item];
            }else {
                
            }
            if (_uploadDataSource.count == 0) {
                [_contentBox setContentView:_nodataView];
            }
            [self reloadData:YES];
             [self reloadData:YES];
            [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        }
        sqlite3_close(dbPoint);
    }
}

- (void)addDataSource:(NSMutableArray *)addDataSource withIsDown:(BOOL)isdown withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum withipod:(IMBiPod *)ipod withIsiCloudDrive:(BOOL) isiCloudDrive {
    if (isdown) {
        _downCount ++;
        if (isiCloudDrive) {
            for (IMBDriveEntity *driveEntity in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.itemIDOrPath = driveEntity.fileID;
                downloaditem.docwsID = driveEntity.docwsid;
                downloaditem.zone = driveEntity.zone;
                if (driveEntity.isFolder) {
                    downloaditem.isFolder = YES;
                    downloaditem.fileName = driveEntity.fileName;
                }else {
                    downloaditem.isFolder = NO;
                    if (![StringHelper stringIsNilOrEmpty:driveEntity.extension]) {
                        downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
                    }
                }
                [_downloadDataSource addObject:downloaditem];
                [downloaditem release];
                downloaditem = nil;
            }
            [_deviceManager driveDownloadItemsToMac:_downloadDataSource];
        }else if (ipod) {
        
        }else {
        
        }
    }else {
        _upCount ++;
        if (isiCloudDrive) {
//            IMBTransferModel *transferModel = [[IMBTransferModel alloc] init];
//            transferModel.dataAry = [addDataSource retain];
//            transferModel.uniqueKey = _iPod.uniqueKey;
        }else if (ipod) {
            if (categoryNodesEnum == Category_CameraRoll || categoryNodesEnum == Category_PhotoStream || categoryNodesEnum == Category_PhotoLibrary) {
                for (id driveEntity in addDataSource) {
                    DriveItem *downloaditem = [[DriveItem alloc] init];
                    if ([driveEntity isKindOfClass:[IMBPhotoEntity class]]) {
                        IMBPhotoEntity *photoEntity = (IMBPhotoEntity *)driveEntity;
                        downloaditem.fileName = photoEntity.photoName;
                        downloaditem.isStart = YES;
                        [_uploadDataSource addObject:downloaditem];
                    }else{
                        downloaditem.fileName = @"111111";
                        downloaditem.isStart = YES;
                        downloaditem.dataAry = [driveEntity retain];
                        [_uploadDataSource addObject:downloaditem];
                    }
                    [downloaditem release];
                    downloaditem = nil;
                }

                IMBPhotoFileExport *baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:_uploadDataSource exportFolder:_exportPath withDelegate:self];
                [(IMBPhotoFileExport *)baseTransfer setExportType:1];
                [baseTransfer startTransfer];
            }
        }else {
            
        }
    }

  
    [self reloadData:YES];
}

- (void)reloadData:(BOOL)isAdd {
    if (isAdd) {
        NSMutableArray *disAry = nil;
        if (_isDownLoadData) {
            disAry = _downloadDataSource;
        } else {
            disAry = _uploadDataSource;
        }
        if ([disAry count]>0) {
            [_tableView reloadData];
            [_scrollView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [_contentBox setContentView:_scrollView];
        }else{
            [_nodataView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [_contentBox setContentView:_nodataView];
        }
    }
}

#pragma mark - NSTableView Datasource and Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 100;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *disAry = nil;
    if (_isDownLoadData) {
        disAry = _downloadDataSource;
    }else {
        disAry = _uploadDataSource;
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
        disAry = _uploadDataSource;
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
        disAry = _uploadDataSource;
    }
    DownloadCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    DriveItem *entity = [disAry objectAtIndex:row];
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
        [cellView.closeButton setHidden:NO];
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
    //    NSDictionary *dimensionDict = nil;
    //    @autoreleasepool {
    //        dimensionDict = [[TempHelper customDimension] copy];
    //    }
    //    [ATTracker event:Video_Download action:Find actionParams:@"Find Video" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    //    if (dimensionDict) {
    //        [dimensionDict release];
    //        dimensionDict = nil;
    //    }
    //    ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
    //    VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
    //    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    //    [workSpace selectFile:entity.vDownloadPath inFileViewerRootedAtPath:nil];
}

//取消下载
- (void)closeTask:(id)sender {
     ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
     DriveItem *entity = (DriveItem *)rowView.objectValue;
    NSMutableArray *disAry = nil;
    if (_isDownLoadData) {
        disAry = _downloadDataSource;
    }else {
        disAry = _uploadDataSource;
    }
    if (_isDownLoadData) {
        [_deviceManager cancelDownloadItem:entity];
        [disAry removeObject:entity];
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
        [disAry removeObject:entity];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        entity.completeDate = [formatter stringFromDate:date];
        entity.toDriveName = CustomLocalizedString(@"Transfer_completeView_transferState_Complete", nil);
        entity.state = UploadStateError;
        
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
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:ActionNone actionParams:[TempHelper currentSelectionLanguage] label:Click transferCount:0 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (void)removeAllUpOrDownData {
    NSMutableArray *disAry = nil;
    if (_isDownLoadData) {
        disAry = _downloadDataSource;
    }else {
        disAry = _uploadDataSource;
    }
    if (_isDownLoadData) {
        for (DriveItem *entity in disAry) {
            [_deviceManager cancelDownloadItem:entity];
            [disAry removeObject:entity];
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
            NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],entity.fileName,entity.localPath,entity.completeDate,entity.fileSize,0,1,entity.docwsID,isparent];
            sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
            entity.toDriveName = CustomLocalizedString(@"Download Fail", nil);
            sqlite3_close(dbPoint);
            [(IMBTranferViewController*)_delegate loadCompleteData:entity];
        }
    }else {
//        [_downloadDataSource removeObject:entity];
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        entity.completeDate = [formatter stringFromDate:date];
//        entity.toDriveName = CustomLocalizedString(@"Transfer_completeView_transferState_Complete", nil);
//        entity.state = UploadStateError;
//        
//        sqlite3 *dbPoint;
//        NSString *tempPath = [TempHelper getAppiMobieConfigPath];
//        NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
//        sqlite3_open([documentPath UTF8String], &dbPoint);
//        NSString *sldsf = @"create table \"main\".\"FileHistory\" (\"history_id\" integer primary key autoincrement not null, \"transfer_name\" text,\"transfer_exportPath\" text,\"transfer_time\" text,\"transfer_size\" integer, \"transfer_status\" integer, \"transfer_isdown\" integer, \"transfer_id\" text);";
//        sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);
//        NSString *insertData = [NSString stringWithFormat:@"insert into \"main\".\"FileHistory\" (\"transfer_name\",\"transfer_exportPath\",\"transfer_time\",\"transfer_size\",\"transfer_status\",\"transfer_isdown\",\"transfer_id\") values ('%@','%@','%@','%lld','0','0','%@');",entity.fileName,entity.localPath,entity.completeDate,entity.fileSize,entity.docwsID];
//        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
//        entity.toDriveName = CustomLocalizedString(@"Download Fail", nil);
//        sqlite3_close(dbPoint);
//        [(IMBTranferViewController*)_delegate loadCompleteData:entity];
        
    }
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
    [_uploadDataSource release],_uploadDataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}
@end
