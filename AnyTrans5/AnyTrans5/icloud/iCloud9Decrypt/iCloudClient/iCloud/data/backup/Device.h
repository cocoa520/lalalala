//
//  Device.h
//
//
//  Created by JGehry on 8/2/16.
//
//  Complete

#import "AbstractRecord.h"
#import "SnapshotID.h"
#import "CloudKit.pb.h"

@interface Device : AbstractRecord <NSCopying> {
@private
    NSMutableArray *_snapshots;
}

+ (NSString *)DOMAIN_HMAC;
+ (NSString *)KEYBAG_UUID;

- (id)initWithSnapshots:(NSArray *)snapshots record:(Record *)record;
- (NSMutableArray*)getSnapshots;
- (NSMutableDictionary *)snapshotTimestampMap;
- (NSString *)domainHMAC;
- (NSString *)currentKeybagUUID;
- (NSString *)deviceClass;
- (NSString *)hardwareModel;
- (NSString *)marketingName;
- (NSString *)productType;
- (NSString *)serialNumber;
- (NSString *)uuid;
- (NSString *)info;

@end
