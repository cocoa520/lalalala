//
//  AssetsClient.h
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "CloudKitty.h"
#import "ProtectionZone.h"
#import "Manifest.h"
#import "AssetExs.h"
#import "CloudKit.pb.h"

@class AtomicRefrence;

@interface AssetsClient : NSObject

+ (NSMutableArray *)assets:(CloudKitty *)kitty zone:(ProtectionZone *)zone manifests:(NSArray *)manifests withCancel:(BOOL *)cancel;
+ (NSMutableArray *)manifestIDs:(Manifest *)manifestIDs;

@end