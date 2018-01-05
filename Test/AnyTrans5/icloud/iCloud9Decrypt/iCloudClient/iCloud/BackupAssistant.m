//
//  BackupAssistant.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "BackupAssistant.h"
#import "Account.h"
#import "AssetsClient.h"
#import "AssetTokenClient.h"
#import "BackupAccount.h"
#import "BackupAccountClient.h"
#import "CategoryExtend.h"
#import "CKInit.h"
#import "CKInits.h"
#import "CloudKitty.h"
#import "Device.h"
#import "DeviceClient.h"
#import "Manifest.h"
#import "ServiceKeySet.h"
#import "SnapshotID.h"
#import "SnapshotClient.h"
#import "EscrowedKeys.h"
#import "ProtectionZone.h"
#import "KeyBagManager.h"
#import "MBKSyncClient.h"
#import "SnapshotEx.h"
#import "AssetTokenClient.h"

@interface BackupAssistant ()

@property (nonatomic, readwrite, retain) CloudKitty *kitty;
@property (nonatomic, readwrite, retain) ProtectionZone *mbksync;

@end

@implementation BackupAssistant
@synthesize kitty = _kitty;
@synthesize mbksync = _mbksync;

+ (BackupAssistant*)create:(Account*)account {
    BackupAssistant *retBA = nil;
    @autoreleasepool {
        CKInit *ckInit = [CKInits ckInitBackupd:account];
        CloudKitty *kitty = [CloudKitty backupd:ckInit withAccount:account];
        ServiceKeySet *escrowServiceKeySet = [EscrowedKeys keysWithAccount:account];
        
        NSMutableArray *tmpArray = [[escrowServiceKeySet keys] mutableCopy];
        ProtectionZone *mbksync = [MBKSyncClient mbksync:kitty keys:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
        retBA = [[BackupAssistant alloc] initWithKitty:kitty withMbksync:mbksync];
    }
    return (retBA ? [retBA autorelease] : nil);
}

- (id)initWithKitty:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync withKeyBagManager:(KeyBagManager*)keyBagManager {
    if (self = [super init]) {
        if (mbksync == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"mbksync" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (keyBagManager == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"keyBagManager" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setKitty:kitty];
        [self setMbksync:mbksync];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithKitty:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync {
    if (self = [self initWithKitty:kitty withMbksync:mbksync withKeyBagManager:[KeyBagManager create:kitty withMbksync:mbksync]]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setKitty:nil];
    [self setMbksync:nil];
    [super dealloc];
#endif
}

- (BackupAccount*)backupAccount {
    return [BackupAccountClient backupAccount:[self kitty] zone:[self mbksync]];
}

- (NSMutableArray*)devices:(NSArray*)devices {
    return [DeviceClient device:[self kitty] deviceID:devices];
}

- (NSMutableArray*)snapshots:(NSArray*)snapshotIDs {
    return [SnapshotClient snapshots:[self kitty] zone:[self mbksync] snapshotIDs:snapshotIDs];
}

- (NSMutableDictionary*)snapshotsForDevices:(NSArray*)devices {
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    @autoreleasepool {
        NSMutableDictionary *snapshotDevice = [[NSMutableDictionary alloc] init];
        NSMutableArray *snapshotIDs = [[NSMutableArray alloc] init];
        NSEnumerator *iterator = [devices objectEnumerator];
        Device *value = nil;
        while (value = [iterator nextObject]) {
            NSArray *snapshots = [value getSnapshots];
            NSEnumerator *iterator = [snapshots objectEnumerator];
            SnapshotID *snapID = nil;
            while (snapID = [iterator nextObject]) {
                [snapshotDevice setObject:value forKey:[snapID iD]];
            }
            [snapshotIDs addObjectsFromArray:snapshots];
        }
        
        NSMutableArray *snapshots = [self snapshots:snapshotIDs];
        
        NSArray *snapDevAllkeys = [snapshotDevice allKeys];
        iterator = [snapshots objectEnumerator];
        SnapshotEx *snapshot = nil;
        NSMutableArray *tmpArray = nil;
        while (snapshot = [iterator nextObject]) {
            if (![snapDevAllkeys containsObject:[snapshot name]]) {
                continue;
            }
            Device *key = [snapshotDevice objectForKey:[snapshot name]];
            if ([returnDic.allKeys containsObject:key]) {
                tmpArray = [returnDic objectForKey:key];
            } else {
                tmpArray = [[NSMutableArray alloc] init];
                [returnDic setObject:tmpArray forKey:key];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                tmpArray = [returnDic objectForKey:key];
            }
            [snapshot setRelativePath:[self deviceSnapshotDateSubPath:key snapshot:snapshot]];
            [tmpArray addObject:snapshot];
        }
#if !__has_feature(objc_arc)
        if (snapshotDevice != nil) [snapshotDevice release]; snapshotDevice = nil;
        if (snapshotIDs != nil) [snapshotIDs release]; snapshotIDs = nil;
#endif
    }
    return [returnDic autorelease];
}

- (NSString*)deviceSnapshotDateSubPath:(Device*)device snapshot:(SnapshotEx*)snapshot {
    NSString *retVal = nil;
    @autoreleasepool {
        NSMutableDictionary *snapshotTimestamp = [[NSMutableDictionary alloc] init];
        NSMutableArray *snapshotIDs = [device getSnapshots];
        NSEnumerator *iterator = [snapshotIDs objectEnumerator];
        SnapshotID *snapshotID = nil;
        while (snapshotID = [iterator nextObject]) {
            [snapshotTimestamp setObject:@([snapshotID timestamp]) forKey:[snapshotID iD]];
        }
        
        CFTimeInterval timestamp = [snapshotTimestamp.allKeys containsObject:[snapshot name]] ? [[snapshotTimestamp objectForKey:[snapshot name]] doubleValue] : [snapshot modification];
        NSTimeZone* zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        [dateFormatter setTimeZone:zone];
        NSString *dateStr = [dateFormatter stringFromDate:[NSDate getDateTimeFromTimeStamp2001:timestamp]];
#if !__has_feature(objc_arc)
        if (snapshotTimestamp != nil) [snapshotTimestamp release]; snapshotTimestamp = nil;
        if (dateFormatter != nil) [dateFormatter release]; dateFormatter = nil;
#endif
        retVal = [[device uuid] stringByAppendingPathComponent:dateStr];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (NSMutableArray *)assetsList:(SnapshotEx *)snapshot withCancel:(BOOL *)cancel {
    NSMutableArray *retArray = nil;
    @autoreleasepool {
        NSMutableArray *newManifests = [[NSMutableArray alloc] init];
        NSMutableArray *manifests = [snapshot getManifests];
        NSEnumerator *iterator = [manifests objectEnumerator];
        Manifest *manifest = nil;
        while (manifest = [iterator nextObject]) {
            if (*cancel) {
                return nil;
            }
            if (manifest.count != 0) {
                [newManifests addObject:manifest];
            }
        }
        retArray = [AssetsClient assets:[self kitty] zone:[self mbksync] manifests:newManifests withCancel:cancel];
#if !__has_feature(objc_arc)
        if (newManifests != nil) [newManifests release]; newManifests = nil;
#endif
        [retArray retain];
    }
    return (retArray ? [retArray autorelease] : nil);
}

/**
 *  Patched in iOS 11 Support
 *
 *  @param files NSMutableArray --> NSMutableDictionary
 *
 */
- (NSMutableArray *)assets:(NSMutableDictionary *)files withCancle:(BOOL *)cancel {
    return [AssetTokenClient assets:[self kitty] zone:[self mbksync] fileList:files withCancel:cancel];
}

- (KeyBagManager *)newKeyBagManager {
    return [KeyBagManager create:[self kitty] withMbksync:[self mbksync]];
}

@end
