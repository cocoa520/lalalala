//
//  AssetsFactory.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>

@class AssetExs;
@class ProtectionZone;
@class Record;

@interface AssetExsFactory : NSObject

+ (AssetExs*)from:(Record*)record withProtectionZone:(ProtectionZone*)protectionZone;
+ (NSMutableData *)domain:(NSArray *)records;
+ (NSMutableArray *)files:(NSArray *)records;

@end
