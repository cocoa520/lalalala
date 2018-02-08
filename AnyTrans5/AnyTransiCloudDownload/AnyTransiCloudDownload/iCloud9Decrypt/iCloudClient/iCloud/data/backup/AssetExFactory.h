//
//  AssetFactory.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>

@class Asset;
@class AssetEx;
@class Record;
@class ProtectionZone;

@interface AssetExFactory : NSObject

+ (AssetEx*)from:(Record*)record withProtectionZone:(ProtectionZone*)protectionZone;
+ (NSMutableData *)optional:(NSMutableData *)bytes;
+ (int)protectionClass:(NSArray *)records;
+ (int)fileType:(NSArray *)records;
+ (Asset *)asset:(NSArray *)records;
+ (NSMutableData *)encryptedAttributes:(NSArray *)records;

@end
