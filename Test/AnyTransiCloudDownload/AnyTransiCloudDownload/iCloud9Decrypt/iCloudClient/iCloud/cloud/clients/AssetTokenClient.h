//
//  AssetTokenClient.h
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "CloudKitty.h"
#import "ProtectionZone.h"
#import "AssetEx.h"
#import "AssetExs.h"
#import "CloudKit.pb.h"

@interface AssetTokenClient : NSObject

+ (NSMutableArray *)assetsFromAssetsList:(CloudKitty *)kitty zone:(ProtectionZone *)zone assetsList:(NSMutableArray *)assetsList;
+ (NSMutableArray *)assets:(CloudKitty *)kitty zone:(ProtectionZone *)zone fileList:(NSArray *)fileList;
+ (AssetEx *)asset:(Record *)record zone:(ProtectionZone *)zone;

@end
