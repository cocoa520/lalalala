//
//  DeviceClient.h
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "Device.h"
#import "HttpClient.h"
#import "CloudKitty.h"

@interface DeviceClient : NSObject

+ (NSMutableArray *)device:(CloudKitty *)kitty deviceID:(NSArray *)deviceID;

@end
