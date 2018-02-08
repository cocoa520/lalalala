//
//  Snapshots.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/5/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>
#import "SnapshotEx.h"
#import "CloudKit.pb.h"

@class ProtectionZone;

@interface Snapshots : NSObject

+ (SnapshotEx*)from:(Record*)record withProtectionZone:(ProtectionZone*)protectionZone;
+ (NSMutableArray *)manifests:(NSMutableArray *)records;
+ (NSMutableArray *)manifestCounts:(NSMutableArray *)records;
+ (NSMutableArray *)manifestChecksums:(NSMutableArray *)records;
+ (NSMutableArray *)manifestIDs:(NSMutableArray *)records;
+ (NSMutableData *)backupProperties:(NSMutableArray *)records;

@end
