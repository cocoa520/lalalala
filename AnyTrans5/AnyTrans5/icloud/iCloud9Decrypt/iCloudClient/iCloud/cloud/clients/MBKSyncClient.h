//
//  MBKSyncClient.h
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "ProtectionZone.h"
#import "HttpClient.h"
#import "CloudKitty.h"
#import "ECPrivateKeyEx.h"
#import "CloudKit.pb.h"

@interface MBKSyncClient : NSObject

+ (ProtectionZone *)mbksync:(CloudKitty *)kitty keys:(NSMutableArray *)keys;
+ (NSMutableArray *)zone:(NSMutableArray *)response withZone:(ProtectionZone *)zone;


@end
