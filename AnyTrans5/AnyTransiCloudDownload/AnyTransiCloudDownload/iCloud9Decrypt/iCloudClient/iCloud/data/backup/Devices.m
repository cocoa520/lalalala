//
//  Devices.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "Devices.h"
#import "SnapshotID.h"

@implementation Devices

+ (Device *)from:(Record *)record {
    NSMutableArray *snapshots = [self snapshots:[record recordFieldList]];
    return [[[Device alloc] initWithSnapshots:snapshots record:record] autorelease];
}

+ (NSMutableArray *)snapshots:(NSArray *)records {
    NSMutableArray *snapshotRecords = [self snapshotRecords:records];
    NSMutableArray *snapshotCommittedDates = [self snapshotCommittedDates:records];
    
    if (snapshotRecords.count != snapshotCommittedDates.count) {
        NSLog(@"-- snapshots()() - mismatched snapshot data");
    }
    
    int limit = 0;
    int recordsInt = (int)(snapshotRecords.count);
    int committedDatesInt = (int)(snapshotCommittedDates.count);
    limit = MIN(recordsInt, committedDatesInt);
    
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < limit; i++) {
        SnapshotID *snapshotID = [[SnapshotID alloc] initWithTimestamp:[[snapshotCommittedDates objectAtIndex:i] doubleValue] withID:(NSString*)[snapshotRecords objectAtIndex:i]];
        [retArray addObject:snapshotID];
#if !__has_feature(objc_arc)
        if (snapshotID) [snapshotID release]; snapshotID = nil;
#endif
    }
    return retArray;
}

+ (NSMutableArray *)snapshotRecords:(NSArray *)records {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:@"snapshots"]) {
            NSArray *tmpAry = [[recordField value] recordFieldValueList];
            for (RecordFieldValue *fieldValue in tmpAry) {
                [returnAry addObject:[[[[fieldValue referenceValue] recordIdentifier] value] name]];
            }
        }
    }
    return returnAry;
}

+ (NSMutableArray *)snapshotCommittedDates:(NSArray *)records {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:@"snapshotCommittedDates"]) {
            NSArray *tmpAry = [[recordField value] recordFieldValueList];
            for (RecordFieldValue *fieldValue in tmpAry) {
                [returnAry addObject:[NSNumber numberWithFloat:[[fieldValue dateValue] time]]];
            }
        }
    }
    return returnAry;
}

@end
