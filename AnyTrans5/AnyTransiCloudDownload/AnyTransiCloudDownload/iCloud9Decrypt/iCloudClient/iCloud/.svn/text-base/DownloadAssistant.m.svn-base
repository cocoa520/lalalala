//
//  DownloadAssistant.m
//
//
//  Created by Pallas on 8/9/16.
//
//  Complete

#import "DownloadAssistant.h"
#import "AssetEx.h"
#import "AuthorizeAssets.h"
#import "AssetDownloader.h"
#import "FileKeyAssistant.h"
#import "FileAssembler.h"
#import "KeyBagManager.h"
#import "XFileKeyFactory.h"
#import <objc/runtime.h>

@interface DownloadAssistant ()

@property (nonatomic, readwrite, retain) AuthorizeAssets *authorizeAssets;
@property (nonatomic, readwrite, retain) AssetDownloader *assetDownloader;
@property (nonatomic, readwrite, retain) KeyBagManager *keyBagManager;
@property (nonatomic, readwrite, retain) NSString *folder;

@end

@implementation DownloadAssistant
@synthesize authorizeAssets = _authorizeAssets;
@synthesize assetDownloader = _assetDownloader;
@synthesize keyBagManager = _keyBagManager;
@synthesize folder = _folder;

- (id)initWithAuthorizeAssets:(AuthorizeAssets*)authorizeAssets withAssetDownloader:(AssetDownloader*)assetDownloader withKeyBagManager:(KeyBagManager*)keyBagManager withFolder:(NSString*)folder {
    if (self = [super init]) {
        if (authorizeAssets == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"authorizeAssets" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (assetDownloader == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"assetDownloader" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (keyBagManager == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"keyBagManager" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (folder == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"folder" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setAuthorizeAssets:authorizeAssets];
        [self setAssetDownloader:assetDownloader];
        [self setKeyBagManager:keyBagManager];
        [self setFolder:folder];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_authorizeAssets != nil) [_authorizeAssets release]; _authorizeAssets = nil;
    if (_assetDownloader != nil) [_assetDownloader release]; _assetDownloader = nil;
    if (_keyBagManager != nil) [_keyBagManager release]; _keyBagManager = nil;
    if (_folder != nil) [_folder release]; _folder = nil;
    [super dealloc];
#endif
}

- (void)setTotalSize:(uint64_t)totalSize {
    if ([self assetDownloader]) {
        [[self assetDownloader] setTotalSize:totalSize];
    }
}

- (void)setProgressTarget:(id)progressTarget {
    if ([self assetDownloader]) {
        [[self assetDownloader] setProgressTarget:progressTarget];
    }
}

- (void)setProgressSelector:(SEL)progressSelector {
    if ([self assetDownloader]) {
        [[self assetDownloader] setProgressSelector:progressSelector];
    }
}

- (void)setProgressImp:(IMP)progressImp {
    if ([self assetDownloader]) {
        [[self assetDownloader] setProgressImp:progressImp];
    }
}

- (void)download:(NSArray*)assets withRelativePath:(NSString*)relativePath withCancel:(BOOL*)cancel {
    if (*cancel) {
        return;
    }
    NSString *outputFolder = [[self folder] stringByAppendingPathComponent:relativePath];
    @autoreleasepool {
        [[self keyBagManager] update:assets withCancel:cancel];
        
        //    SEL selector = @selector(unwrapKey:withProtectionClass:);
        //    IMP imp = class_getMethodImplementation([self class], selector);
        //    FileAssembler *fileAssembler = [[FileAssembler alloc] initWithTarget:self withSelector:selector withImp:imp withOutputFolder:outputFolder];
        SEL selector = @selector(keyBag:);
        IMP imp = class_getMethodImplementation([[self keyBagManager] class], selector);
        XFileKeyFactory *fileKeys = [[XFileKeyFactory alloc] initWithTarget:[self keyBagManager] withSel:selector withFunction:imp];
        selector = @selector(apply:);
        imp = class_getMethodImplementation([fileKeys class], selector);
        FileAssembler *fileAssembler = [[FileAssembler alloc] initWithTarget:fileKeys withSelector:selector withImp:imp withOutputFolder:outputFolder];
#if !__has_feature(objc_arc)
        if (fileKeys) [fileKeys release]; fileKeys = nil;
#endif
        
        AuthorizedAssets *authorizedAssets = [[self authorizeAssets] authorize:assets];
        
        selector = @selector(accept:withChunks:withCompleteSize:withCancel:);
        imp = class_getMethodImplementation([fileAssembler class], selector);
        [[self assetDownloader] get:authorizedAssets withTarget:fileAssembler withSelector:selector withImp:imp withCancel:cancel];
#if !__has_feature(objc_arc)
        if (fileAssembler != nil) [fileAssembler release]; fileAssembler = nil;
#endif
    }
}

//- (NSMutableData*)unwrapKey:(NSMutableData*)wrappedKey withProtectionClass:(int)protectionClass {
//    SEL selector = @selector(keyBag:);
//    IMP imp = class_getMethodImplementation([[self keyBagManager] class], selector);
//    return [FileKeyAssistant unwrap:[self keyBagManager] withSel:selector withFunction:imp protectionClass:protectionClass fileKey:wrappedKey];
//}

@end
