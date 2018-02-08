//
//  Backup.h
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "BackupAssistant.h"
#import "DownloadAssistant.h"
#import "AssetExs.h"
#import "AssetEx.h"
#import "Device.h"
#import "SnapshotEx.h"

@class Account;

@interface Backup : NSObject {
@private
    BackupAssistant *_backupAssistant;
    DownloadAssistant *_downloadAssistant;
}

- (id)initWithBackupAssistant:(BackupAssistant*)backupAssistant withDownloadAssistant:(DownloadAssistant*)downloadAssistant;

- (NSMutableDictionary*)snapshots;
- (void)setProgressCallback:(id)progressTarget withProgressSelector:(SEL)progressSelector withProgressImp:(IMP)progressImp;
- (void)download:(Device*)device withSnapshot:(SnapshotEx*)snapshot withAssetsFilter:(NSPredicate*)assetsFilter withCancel:(BOOL*)cancel;
- (void)printDomainList:(NSMutableDictionary*)snapshots;
- (void)printDomainList:(Device*)device snapshot:(SnapshotEx*)snapshot;

@end
