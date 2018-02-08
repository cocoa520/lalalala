//
//  AssetsFactory.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "AssetExsFactory.h"
#import "AssetExs.h"
#import "CloudKit.pb.h"
#import "ProtectionZone.h"

static NSString *ISDOMAIN = @"domain";
static NSString *FILES = @"files";

@implementation AssetExsFactory

+ (AssetExs*)from:(Record*)record withProtectionZone:(ProtectionZone*)protectionZone {
    NSArray *records = [record recordFieldList];
    NSArray *files = [self files:records];
    NSString *domain = nil;
    NSMutableData *bs = [self domain:records];
    if (bs != nil && bs.length > 0) {
        @try {
            NSMutableData *decryptData = [protectionZone decrypt:bs identifierWithString:ISDOMAIN];
            domain = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
        }
        @catch (NSException *exception) {
            return nil;
        }
    } else {
        return nil;
    }
    AssetExs *exs = [[[AssetExs alloc] initWithDomain:domain withFiles:files] autorelease];
#if !__has_feature(objc_arc)
    if (domain) [domain release]; domain = nil;
#endif
    return exs;
}

+ (NSMutableData *)domain:(NSArray *)records {
    NSMutableData *mutData = [[[NSMutableData alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:ISDOMAIN]) {
            NSData *valueData = [[recordField value] bytesValue];
            [mutData appendData:valueData];
            break;
        }
    }
    return mutData;
}

+ (NSMutableArray *)files:(NSArray *)records {
    NSMutableArray *nameStrAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:FILES]) {
            NSArray *valueList = [[recordField value] recordFieldValueList];
            for (RecordFieldValue *value in valueList) {
                [nameStrAry addObject:[[[[value referenceValue] recordIdentifier] value] name]];
            }
        }
    }
    return nameStrAry;
}

@end
