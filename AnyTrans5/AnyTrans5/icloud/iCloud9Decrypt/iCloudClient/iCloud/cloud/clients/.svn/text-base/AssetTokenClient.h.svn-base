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
#import "iCloudClient.h"
#import "DownloadAssistant.h"

@interface AssetTokenClient : NSObject {
    NSString *_filterDownloadPath;
    iCloudClient *_iCloudClientDelegate;
    DownloadAssistant *_downloadAssistantDelegate;
}

@property (nonatomic, readwrite, retain) NSString *filterDownloadPath;
@property (nonatomic, readwrite, retain) iCloudClient *iCloudClientDelegate;
@property (nonatomic, readwrite, retain) DownloadAssistant *downloadAssistantDelegate;

+ (AssetTokenClient *)singleton;

+ (NSMutableArray *)assets:(CloudKitty *)kitty zone:(ProtectionZone *)zone fileList:(NSMutableDictionary *)fileList withCancel:(BOOL *)cancel;
+ (AssetEx *)asset:(Record *)record withAssetIDDomains:(NSMutableDictionary *)assetIDDomains zone:(ProtectionZone *)zone;

@end
