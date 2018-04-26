//
//  IMBHWInfo.h
//  iMobieTrans
//
//  Created by Pallas on 3/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

#import <sys/sysctl.h>
#import <sys/resource.h>
#import <sys/vm.h>

@interface IMBHWInfo : NSObject {
@private
    NSNotificationCenter *nc;
    
    NSString* _platformSerialNumber;
    NSDictionary* _cpuIds;
    NSString* _hardwareUUID;
    NSString* _hardwareSerialNumber;
}

@property(nonatomic, readonly, retain) NSString* platformSerialNumber;
@property(nonatomic, readonly, retain) NSDictionary* cpuIds;
@property(nonatomic, readonly, retain) NSString* hardwareUUID;
@property(nonatomic, readonly, retain) NSString* hardwareSerialNumber;

+ (IMBHWInfo*)singleton;

@end
