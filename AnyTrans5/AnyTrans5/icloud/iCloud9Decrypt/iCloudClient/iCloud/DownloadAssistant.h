//
//  DownloadAssistant.h
//
//
//  Created by Pallas on 8/9/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "AuthorizeAssets.h"
#import "AssetDownloader.h"
#import "KeyBagManager.h"

@class AuthorizeAssets;
@class AssetDownloader;
@class KeyBagManager;

@interface DownloadAssistant : NSObject {
@private
    AuthorizeAssets *                           _authorizeAssets;
    AssetDownloader *                           _assetDownloader;
    KeyBagManager *                             _keyBagManager;
    NSString *                                  _folder;
}


- (id)initWithAuthorizeAssets:(AuthorizeAssets*)authorizeAssets withAssetDownloader:(AssetDownloader*)assetDownloader withKeyBagManager:(KeyBagManager*)keyBagManager withFolder:(NSString*)folder;
- (void)setTotalSize:(uint64_t)totalSize;
- (void)setProgressTarget:(id)progressTarget;
- (void)setProgressSelector:(SEL)progressSelector;
- (void)setProgressImp:(IMP)progressImp;
- (void)download:(NSArray*)assets withRelativePath:(NSString*)relativePath withCancel:(BOOL*)cancel;
- (NSString *)getFolder;
- (uint64_t)getTotalSize;

@end
