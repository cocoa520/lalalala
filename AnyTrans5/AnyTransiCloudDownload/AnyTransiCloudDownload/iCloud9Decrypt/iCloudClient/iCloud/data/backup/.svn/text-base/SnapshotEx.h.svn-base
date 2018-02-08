//
//  Snapshot.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "AbstractRecord.h"
#import "SnapshotID.h"

@class CloudKitty;

@interface SnapshotEx : AbstractRecord {
@private
    SnapshotID *_snapshotID;
    NSMutableData *_backupProperties;
    NSMutableArray *_manifests;
    NSString *_relativePath;
}

- (NSString*)relativePath;
- (void)setRelativePath:(NSString*)relativePath;

- (id)initWithBackupProperties:(NSMutableData *)backupProperties manifests:(NSMutableArray *)manifests record:(Record *)record withSnapshotID:(SnapshotID *)snapshotID;
- (NSMutableDictionary *)getBackupProperties;
- (NSMutableArray*)getManifests;
- (int64_t)quotaUsed;
- (NSString *)deviceName;
- (NSString *)deviceIOSVersion;
- (NSString *)info;

@end
