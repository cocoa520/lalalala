//
//  Devices.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>
#import "Device.h"
#import "CloudKit.pb.h"

@interface Devices : NSObject

+ (Device *)from:(Record *)record;
+ (NSMutableArray *)snapshots:(NSArray *)records;
+ (NSMutableArray *)snapshotRecords:(NSArray *)records;
+ (NSMutableArray *)snapshotCommittedDates:(NSArray *)records;

@end
