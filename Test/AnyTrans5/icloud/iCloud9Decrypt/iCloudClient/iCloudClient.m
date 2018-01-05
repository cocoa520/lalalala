//
//  iCloudClient.m
//  iCloudClient
//
//  Created by long on 6/26/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "iCloudClient.h"
#import "Auth.h"
#import "Authenticator.h"
#import "Account.h"
#import "Accounts.h"
#import "AccountInfo.h"
#import "AuthorizeAssets.h"
#import "AssetDownloader.h"
#import "Backup.h"
#import "BackupAssistant.h"
#import "CategoryExtend.h"
#import "DiskChunkStore.h"
#import "DownloadAssistant.h"
#import "Headers.h"
#import "KeyBagManager.h"
#import "StandardChunkEngine.h"
#import "AssetTokenClient.h"

@interface iCloudClient ()

@property (nonatomic, readwrite, retain) NSString *outputFolder;
@property (nonatomic, readwrite, retain) id delegate;
@property (nonatomic, readwrite, retain) Auth *auth;
@property (nonatomic, readwrite, retain) Account *account;
@property (nonatomic, readwrite, retain) NSMutableDictionary *deviceSnapshots;
@property (nonatomic, readwrite, retain) Backup *backup;
@property (nonatomic, readwrite, retain) NSString *downloadFolders;

@end

@implementation iCloudClient
@synthesize outputFolder = _outputFolder;
@synthesize delegate = _delegate;
@synthesize auth = _auth;
@synthesize account = _account;
@synthesize deviceSnapshots = _deviceSnapshots;
@synthesize backup = _backup;
@synthesize downloadFolders = _downloadFolders;

- (id)init {
    if (self = [super init]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *tmpPath = [[NSString getAppSupportPath] stringByAppendingPathComponent:@"iCloud"];
        if (![fm fileExistsAtPath:tmpPath]) {
            [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [self setOutputFolder:tmpPath];
        [self setDelegate:nil];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setOutputFolder:nil];
    [self setDelegate:nil];
    [self setAuth:nil];
    [self setAccount:nil];
    [self setDeviceSnapshots:nil];
    [self setBackup:nil];
    [super dealloc];
#endif
}

- (BOOL)auth:(NSString*)token {
    BOOL retVal = NO;
    Auth *tmpAuth = [[Auth alloc] init:token];
    if (tmpAuth) {
        [self setAuth:tmpAuth];
#if !__has_feature(objc_arc)
        [tmpAuth release]; tmpAuth = nil;
#endif
        retVal = YES;
    }
    return retVal;
}

- (BOOL)auth:(NSString*)appleID withPassword:(NSString*)password {
    BOOL retVal = NO;
    @autoreleasepool {
        Authenticator *authenticator = [[Authenticator alloc] init:[Headers coreHeaders]];
        Auth *tmpAuth = [authenticator authenticate:appleID withPassword:password];
        if (tmpAuth) {
            [self setAuth:tmpAuth];
            retVal = YES;
        }
#if !__has_feature(objc_arc)
        if (authenticator) [authenticator release]; authenticator = nil;
#endif
        if (retVal) {
            retVal = [self queryAccount];
            if (!retVal) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_APPLE_ID_AUTHENTICATION_FAILURE object:nil];
                return retVal;
            }
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_APPLE_ID_AUTHENTICATION_FAILURE object:nil];
            return retVal;
        }
    }
    return retVal;
}

- (BOOL)queryAccount {
    BOOL retVal = NO;
    Account *tmpAccount = [Accounts accountWithAuth:[self auth]];
    if (tmpAccount != nil) {
        [self setAccount:tmpAccount];
        retVal = YES;
    }
    return retVal;
}

- (NSMutableDictionary*)queryBackupInfo {
    @autoreleasepool {
        AssetTokenClient *client = [AssetTokenClient singleton];
        [client setICloudClientDelegate:self];
        BackupAssistant *assistant = [BackupAssistant create:[self account]];
        
        AuthorizeAssets *authorizeAssets = [AuthorizeAssets backupd];
        NSString *downloadFolder = [[self outputFolder] stringByAppendingPathComponent:[[[self account] accountInfo] appleId]];
        self.downloadFolders = downloadFolder;
        NSString *assetOutputFolder = [downloadFolder stringByAppendingPathComponent:@"cache"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:assetOutputFolder]) {
            [fm createDirectoryAtPath:assetOutputFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        DiskChunkStore *chunkStore = [[DiskChunkStore alloc] initWithChunkFolder:assetOutputFolder];
        StandardChunkEngine *chunkEngine = [[StandardChunkEngine alloc] initWithChunkStore:chunkStore];
        AssetDownloader *assetDownloader = [[AssetDownloader alloc] initWithChunkEngine:chunkEngine];
        KeyBagManager *keyBagManager = [assistant newKeyBagManager];
        
        DownloadAssistant *downloadAssistant = [[DownloadAssistant alloc] initWithAuthorizeAssets:authorizeAssets withAssetDownloader:assetDownloader withKeyBagManager:keyBagManager withFolder:downloadFolder];
        
        Backup *bu = [[Backup alloc] initWithBackupAssistant:assistant withDownloadAssistant:downloadAssistant];
        [self setBackup:bu];
#if !__has_feature(objc_arc)
        if (chunkStore) [chunkStore release]; chunkStore = nil;
        if (chunkEngine) [chunkEngine release]; chunkEngine = nil;
        if (assetDownloader) [assetDownloader release]; assetDownloader = nil;
        if (downloadAssistant) [downloadAssistant release]; downloadAssistant = nil;
        if (bu) [bu release]; bu = nil;
#endif
        [self setDeviceSnapshots:[[self backup] snapshots]];
    }
    return [self deviceSnapshots];
}

- (void)outputProgress:(uint64_t)totalSize withCompleteSize:(uint64_t)completeSize {
    if ([self delegate]!= nil && [[self delegate] respondsToSelector:@selector(downloadProgress:withCompleteSize:)]) {
        [[self delegate] downloadProgress:totalSize withCompleteSize:completeSize];
    }
}

- (void)downloadWithDevice:(Device*)device withSnapshot:(SnapshotEx*)snapshot withDomains:(NSArray*)domains withCancel:(BOOL*)cancel {
    @autoreleasepool {
        NSMutableArray *filterDomains = [[NSMutableArray alloc] init];
        NSEnumerator *iterator = [domains objectEnumerator];
        NSString *domain = nil;
        while (domain = [iterator nextObject]) {
            [filterDomains addObject:[NSPredicate predicateWithFormat:@"self.domain BEGINSWITH[c] %@", domain]];
        }
        NSPredicate *filter = nil;
        if (filterDomains && filterDomains.count > 0) {
            filter = [NSCompoundPredicate orPredicateWithSubpredicates:filterDomains];
        }
        SEL selector = @selector(outputProgress:withCompleteSize:);
        IMP imp = class_getMethodImplementation([self class], selector);
        [[self backup] setProgressCallback:self withProgressSelector:selector withProgressImp:imp];
        [[self backup] download:device withSnapshot:snapshot withAssetsFilter:filter withCancel:cancel];
        if ([self delegate]!= nil && [[self delegate] respondsToSelector:@selector(downloadComplete)]) {
            [[self delegate] downloadComplete];
        }
#if !__has_feature(objc_arc)
        if (filterDomains) [filterDomains release]; filterDomains = nil;
#endif
    }
}

@end
