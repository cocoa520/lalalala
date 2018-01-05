//
//  KeyBagClient.m
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import "KeyBagClient.h"
#import "PZFactory.h"
#import "KeyBagFactory.h"

@implementation KeyBagClient

+ (KeyBag *)keyBag:(CloudKitty *)kitty zone:(ProtectionZone *)zone keyBagUUID:(NSString *)keyBagUUID {
    NSMutableArray *responses = [kitty recordRetrieveRequest:@"mbksync" withRecordName:[NSString stringWithFormat:@"K:%@", keyBagUUID], nil];
    if ([responses count] != 1) {
        return nil;
    }
    ProtectionInfo *protectionInfo = [[[responses objectAtIndex:0] record] protectionInfo];
    ProtectionZone *optionalNewZone = [[PZFactory instance] createWithBase:zone withProtectionInfo:protectionInfo];
    if (!optionalNewZone) {
        return nil;
    }
    ProtectionZone *newZone = optionalNewZone;
    return [self keyBag:[responses objectAtIndex:0] zone:newZone];
}

+ (KeyBag *)keyBag:(RecordRetrieveResponse *)response zone:(ProtectionZone *)zone {
    NSMutableData *keyBagData = [self field:[response record] withLabel:@"keybagData" withProtectionZone:zone];
    if (!keyBagData) {
        return nil;
    }
    NSMutableData *secret = [self field:[response record] withLabel:@"secret" withProtectionZone:zone];
    if (!secret) {
        return nil;
    }
    return [KeyBagFactory createWithData:keyBagData withPasscode:secret];
}

+ (NSMutableData*)field:(Record*)record withLabel:(NSString*)label withProtectionZone:(ProtectionZone*)protectionZone {
    NSArray *recordFields = [record recordFieldList];
    NSEnumerator *iterator = [recordFields objectEnumerator];
    RecordField *rf = nil;
    while (rf = [iterator nextObject]) {
        if ([[[rf identifier] name] isEqualToString:label]) {
            NSMutableData *bs = [[[rf value] bytesValue] mutableCopy];
            NSMutableData *decryptData = [protectionZone decrypt:bs identifierWithString:label];
#if !__has_feature(objc_arc)
            if (bs) [bs release]; bs = nil;
#endif
            if (decryptData != nil) {
                return decryptData;
            }
        }
    }
    return nil;
}

@end
