//
//  Snapshots.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/5/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "Snapshots.h"
#import "ProtectionZone.h"
#import "Manifest.h"
#import "SnapshotID.h"

static NSString *BACKUP_PROPERTIES = @"backupProperties";

@implementation Snapshots

+ (SnapshotEx*)from:(Record*)record withProtectionZone:(ProtectionZone*)protectionZone {
    SnapshotID *snapshotIDs = nil;
    if ([record hasRecordIdentifier]) {
        snapshotIDs = [SnapshotID from:[[[record recordIdentifier] value] name]];
    }
    NSMutableArray *tmpArray = [[record recordFieldList] mutableCopy];
    NSMutableArray *manifests = [self manifests:tmpArray];
#if !__has_feature(objc_arc)
    if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
    NSMutableData *backupProperties = nil;
    tmpArray = [[record recordFieldList] mutableCopy];
    NSMutableData *encryptData = [self backupProperties:tmpArray];
#if !__has_feature(objc_arc)
    if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
    if (encryptData != nil) {
        backupProperties = [protectionZone decrypt:encryptData identifierWithString:BACKUP_PROPERTIES];
    }
    SnapshotEx *snapshot = [[[SnapshotEx alloc] initWithBackupProperties:backupProperties manifests:manifests record:record withSnapshotID:snapshotIDs] autorelease];
    return snapshot;
}

+ (NSMutableArray*)manifests:(NSMutableArray*)records {
    NSMutableArray *manifestCounts = [self manifestCounts:records];
    NSMutableArray *manifestChecksums = [self manifestChecksums:records];
    NSMutableArray *manifestIDs = [self manifestIDs:records];
    
    if (manifestCounts.count != manifestChecksums.count || manifestChecksums.count != manifestIDs.count) {
        NSLog(@"-- manifests() - mismatched manifest data");
    }
    
    int limit = 0;
    int counts = (int)(manifestCounts.count);
    int checksums = (int)(manifestChecksums.count);
    int ids = (int)(manifestIDs.count);
    limit = MIN(MIN(counts, checksums), ids);
    
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < limit; i++) {
        Manifest *manifest = [[Manifest alloc] initWithCount:[[manifestCounts objectAtIndex:i] intValue] withChecksum:[[manifestChecksums objectAtIndex:i] intValue] withID:(NSString*)[manifestIDs objectAtIndex:i]];
        [retArray addObject:manifest];
#if !__has_feature(objc_arc)
        if (manifest) [manifest release]; manifest = nil;
#endif
    }
    return retArray;
}

+ (NSMutableArray *)manifestCounts:(NSMutableArray *)records {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:@"manifestCounts"]) {
            NSArray *tmpAry = [[recordField value] recordFieldValueList];
            for (RecordFieldValue *fieldValue in tmpAry) {
                [returnAry addObject:[NSNumber numberWithInt:(int)[fieldValue signedValue]]];
            }
        }
    }
    return returnAry;
}

+ (NSMutableArray *)manifestChecksums:(NSMutableArray *)records {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:@"manifestChecksums"]) {
            NSArray *tmpAry = [[recordField value] recordFieldValueList];
            for (RecordFieldValue *fieldValue in tmpAry) {
                [returnAry addObject:[NSNumber numberWithInt:(int)[fieldValue signedValue]]];
            }
        }
    }
    return returnAry;
}

+ (NSMutableArray *)manifestIDs:(NSMutableArray *)records {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:@"manifestIDs"]) {
            NSArray *tmpAry = [[recordField value] recordFieldValueList];
            for (RecordFieldValue *fieldValue in tmpAry) {
                [returnAry addObject:[fieldValue stringValue]];
            }
        }
    }
    return returnAry;
}

+ (NSMutableData *)backupProperties:(NSMutableArray *)records {
    NSMutableData *returnData = [[[NSMutableData alloc] init] autorelease];
    for (RecordField *record in records) {
        if ([[[record identifier] name] isEqualToString:BACKUP_PROPERTIES]) {
            NSData *data = [[record value] bytesValue];
            [returnData appendData:data];
            break;
        }
    }
    return returnData;
}

@end
