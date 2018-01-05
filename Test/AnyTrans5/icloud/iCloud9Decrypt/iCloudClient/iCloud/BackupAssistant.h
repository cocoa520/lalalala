//
//  BackupAssistant.h
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Account;
@class BackupAccount;
@class CloudKitty;
@class ProtectionZone;
@class KeyBagManager;
@class SnapshotEx;

@interface BackupAssistant : NSObject {
@private
    CloudKitty *                            _kitty;
    ProtectionZone *                        _mbksync;
}

+ (BackupAssistant*)create:(Account*)account;

- (id)initWithKitty:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync withKeyBagManager:(KeyBagManager*)keyBagManager ;
- (id)initWithKitty:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync;

- (BackupAccount*)backupAccount;
- (NSMutableArray*)devices:(NSArray*)devices;
- (NSMutableArray*)snapshots:(NSArray*)snapshotIDs;
- (NSMutableDictionary*)snapshotsForDevices:(NSArray*)devices;
- (NSMutableArray *)assetsList:(SnapshotEx *)snapshot withCancel:(BOOL *)cancel;
- (NSMutableArray *)assets:(NSMutableDictionary *)files withCancle:(BOOL *)cancel;
- (KeyBagManager *)newKeyBagManager;

@end
