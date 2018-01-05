//
//  KeyBagClient.h
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "KeyBag.h"
#import "HttpClient.h"
#import "CloudKitty.h"
#import "ProtectionZone.h"
#import "CloudKit.pb.h"

@interface KeyBagClient : NSObject

+ (KeyBag *)keyBag:(CloudKitty *)kitty zone:(ProtectionZone *)zone keyBagUUID:(NSString *)keyBagUUID;
+ (KeyBag *)keyBag:(RecordRetrieveResponse *)response zone:(ProtectionZone *)zone;
+ (NSMutableData*)field:(Record*)record withLabel:(NSString*)label withProtectionZone:(ProtectionZone*)protectionZone;

@end
