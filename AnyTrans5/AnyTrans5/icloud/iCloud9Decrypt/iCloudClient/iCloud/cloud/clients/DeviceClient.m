//
//  DeviceClient.m
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import "DeviceClient.h"
#import "CloudKit.pb.h"
#import "Devices.h"

@implementation DeviceClient

+ (NSMutableArray *)device:(CloudKitty *)kitty deviceID:(NSArray *)deviceID {
    NSMutableArray *responses = [kitty recordRetrieveRequest:@"mbksync" withRecordNames:deviceID];
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (RecordRetrieveResponse *recordResponse in responses) {
         [returnAry addObject:[Devices from:[recordResponse record]]];
    }
    return returnAry;
}

@end
