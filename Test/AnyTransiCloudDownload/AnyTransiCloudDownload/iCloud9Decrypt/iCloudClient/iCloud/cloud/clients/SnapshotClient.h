//
//  SnapshotClient.h
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "SnapshotEx.h"
#import "HttpClient.h"
#import "CloudKitty.h"
#import "ProtectionZone.h"
#import "SnapshotID.h"
#import "CloudKit.pb.h"

@interface SnapshotClient : NSObject

+ (NSMutableArray*)snapshots:(CloudKitty*)kitty zone:(ProtectionZone*)zone snapshotIDs:(NSArray*)snapshotIDs;
+ (SnapshotEx *)manifests:(Record *)record zone:(ProtectionZone *)zone;

@end