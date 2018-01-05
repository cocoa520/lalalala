//
//  BackupAccountFactory.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>
#import "BackupAccount.h"
#import "CloudKit.pb.h"

@class ProtectionZone;

@interface BackupAccountFactory : NSObject

+ (BackupAccount*)from:(Record*)record withProtectionZone:(ProtectionZone*)protectionZone;
+ (NSMutableData *)hmacKey:(NSArray *)records;
+ (NSMutableArray *)devices:(NSArray *)records;

@end
