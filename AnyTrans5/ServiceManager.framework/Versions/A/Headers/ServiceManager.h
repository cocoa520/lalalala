//
//  ServiceManager.h
//  ServiceManager
//
//  Created by Pallas on 10/19/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceManager : NSObject

+ (BOOL)startService:(NSString*)appExecutePath withBundleID:(NSString*)bundleID withPort:(int)port;

+ (BOOL)stopService:(NSString*)bundleID;

@end
