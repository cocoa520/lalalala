//
//  SnapshotClient.m
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import "SnapshotClient.h"
#import "PZFactory.h"
#import "Snapshots.h"

@implementation SnapshotClient

+ (NSMutableArray*)snapshots:(CloudKitty*)kitty zone:(ProtectionZone*)zone snapshotIDs:(NSArray*)snapshotIDs {
    if ([snapshotIDs count] == 0) {
        return [[[NSMutableArray alloc] init] autorelease];
    }
    NSMutableArray *snapshots = [[NSMutableArray alloc] init];
    for (SnapshotID *snapshotID in snapshotIDs) {
        [snapshots addObject:[snapshotID iD]];
    }
    NSMutableArray *responses = [kitty recordRetrieveRequest:@"mbksync" withRecordNames:snapshots];
#if !__has_feature(objc_arc)
    if (snapshots) [snapshots release]; snapshots = nil;
#endif
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordRetrieveResponse *recordResponse in responses) {
        if ([recordResponse hasRecord]) {
            SnapshotEx *snapshot = [self manifests:[recordResponse record] zone:zone];
            if (snapshot) {
                [returnAry addObject:snapshot];
            }
        }
    }
    return returnAry;
}

+ (SnapshotEx *)manifests:(Record *)record zone:(ProtectionZone *)zone {
    ProtectionZone *pZone = [[PZFactory instance] createWithBase:zone withProtectionInfo:[record protectionInfo]];
    if (pZone) {
        return [Snapshots from:record withProtectionZone:pZone];
    } else {
        return nil;
    }
}

@end
