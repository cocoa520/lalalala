//
//  IMBMoveTransferManager.m
//  AllFiles
//
//  Created by 龙凡 on 2018/5/3.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMoveTransferManager.h"
#import "DriveItem.h"
#import "IMBTranferViewController.h"
#import "IMBTranferBtnManager.h"
@implementation IMBMoveTransferManager
@synthesize selectedAry = _selectedAry;
@synthesize originDriveBaseManager = _originDriveBaseManager;
@synthesize targerDriveBaseManager = _targerDriveBaseManager;
@synthesize targerChooseModelEnum = _targerChooseModelEnum;
@synthesize originChooseModelEnum = _originChooseModelEnum;
@synthesize origniPod = _origniPod;
@synthesize targeriPod = _targeriPod;
@synthesize categoryNodeEnum = _categoryNodeEnum;
+ (IMBMoveTransferManager*)singleton {
    static IMBMoveTransferManager *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBMoveTransferManager alloc] init];
        }
    }
    return _singleton;
}

- (void)driveToDriveDown:(NSMutableArray *)ary{
    [_originDriveBaseManager setDownloadPath:[TempHelper getAppTempPath]];
    for (IMBDriveEntity *driveEntity in ary) {
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
                downloaditem.photoImage = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
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
        [downloaditem setLocalPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:downloaditem.fileName]];
        [downloaditem addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [_originDriveBaseManager oneDriveDownloadOneItem:downloaditem];
        [downloaditem release];
        downloaditem = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id <DownloadAndUploadDelegate> item = object;
    if (item.state == DownloadStateComplete) {
        NSMutableArray *ary = [[NSMutableArray alloc]init];
        [ary addObject:item.localPath];
        //                [self addItemsDelay:ary];
        IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
        [tranferView setDelegate:self];
        tranferView.reloadDelegate = self;
//            [tranferView transferBtn:_transferBtn];
        [tranferView icloudDriveAddDataSource:ary WithIsDown:NO WithDriveBaseManage:_targerDriveBaseManager withUploadParent:@"0" withUploadDocID:@"0"];
        [(NSObject*)item removeObserver:self forKeyPath:@"state"];
        [ary release];
        ary = nil;
    }else if (item.state == DownloadStateError){
        [(NSObject*)item removeObserver:self forKeyPath:@"state"];
    }
}


-(void)dealloc {
    [super dealloc];
    if (_selectedAry) {
        [_selectedAry release];
        _selectedAry = nil;
    }
}
@end
