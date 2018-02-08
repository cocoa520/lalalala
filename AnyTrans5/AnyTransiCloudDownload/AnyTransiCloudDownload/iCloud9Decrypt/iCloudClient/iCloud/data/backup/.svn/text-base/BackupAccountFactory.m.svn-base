//
//  BackupAccountFactory.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "BackupAccountFactory.h"
#import "ProtectionZone.h"

static NSString *HMAC_KEY = @"HMACKey";
static NSString *DEVICES = @"devices";

@implementation BackupAccountFactory

+ (BackupAccount*)from:(Record*)record withProtectionZone:(ProtectionZone*)protectionZone {
    NSArray *records = [record recordFieldList];
    
    NSMutableData *encryptHmacKey = [self hmacKey:records];
    NSMutableData *hmacKey = nil;
    if (encryptHmacKey) {
        hmacKey = [protectionZone decrypt:encryptHmacKey identifierWithString:HMAC_KEY];
    }
    NSMutableArray *devices = [self devices:records];
    
    return [[[BackupAccount alloc] initWithHmacKey:hmacKey devices:devices] autorelease];
}

+ (NSMutableData *)hmacKey:(NSArray *)records {
    NSMutableData *returnData = [[[NSMutableData alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:HMAC_KEY]) {
            [returnData appendData:[[recordField value] bytesValue]];
            break;
        }
    }
    return returnData;
}

+ (NSMutableArray *)devices:(NSArray *)records {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:DEVICES]) {
            NSArray *tmpAry = [[recordField value] recordFieldValueList];
            for (RecordFieldValue *recordValue in tmpAry) {
                [returnAry addObject:[[[[recordValue referenceValue] recordIdentifier] value] name]];
            }
        }
    }
    return returnAry;
}

@end
