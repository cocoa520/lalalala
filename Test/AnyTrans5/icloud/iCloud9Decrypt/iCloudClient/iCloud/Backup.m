//
//  Backup.m
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import "Backup.h"
#import "Account.h"
#import "AssetExs.h"
#import "CategoryExtend.h"
#import "Tokens.h"
#import "CKInit.h"
#import "CKInits.h"
#import "CloudKitty.h"
#import "ServiceKeySet.h"
#import "SnapshotID.h"
#import "EscrowedKeys.h"
#import "BackupAccount.h"
#import "AssetTokenClient.h"

@interface Backup ()

@property (nonatomic, readwrite, retain) BackupAssistant *backupAssistant;
@property (nonatomic, readwrite, retain) DownloadAssistant *downloadAssistant;

@end

@implementation Backup
@synthesize backupAssistant = _backupAssistant;
@synthesize downloadAssistant = _downloadAssistant;

- (id)initWithBackupAssistant:(BackupAssistant*)backupAssistant withDownloadAssistant:(DownloadAssistant*)downloadAssistant {
    if (self = [super init]) {
        if (backupAssistant == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"backupAssistant" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (downloadAssistant == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"downloadAssistant" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setBackupAssistant:backupAssistant];
        [self setDownloadAssistant:downloadAssistant];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setBackupAssistant:nil];
    [self setDownloadAssistant:nil];
    [super dealloc];
#endif
}

- (NSMutableDictionary*)snapshots {
    NSMutableDictionary *snapshots = nil;
    @autoreleasepool {
        BackupAccount *backupAccount = [[self backupAssistant] backupAccount];
        NSMutableArray *devices = [[self backupAssistant] devices:[backupAccount devices]];
        snapshots = [[[self backupAssistant] snapshotsForDevices:devices] retain];
    }
    return [snapshots autorelease];
}

- (void)setProgressCallback:(id)progressTarget withProgressSelector:(SEL)progressSelector withProgressImp:(IMP)progressImp {
    if ([self downloadAssistant]) {
        [[self downloadAssistant] setProgressTarget:progressTarget];
        [[self downloadAssistant] setProgressSelector:progressSelector];
        [[self downloadAssistant] setProgressImp:progressImp];
    }
}

- (void)download:(Device*)device withSnapshot:(SnapshotEx*)snapshot withAssetsFilter:(NSPredicate*)assetsFilter  withCancel:(BOOL*)cancel {
    @autoreleasepool {
        NSMutableArray *assetsList = [[self backupAssistant] assetsList:snapshot withCancel:cancel];
        NSMutableArray *files = [AssetExs files:assetsList filter:assetsFilter];
        // Todo 统计总大小
        uint64_t totalSize  = 0;
        NSEnumerator *iterator = [files objectEnumerator];
        NSString *asset = nil;
        while (asset = [iterator nextObject]) {
            if (*cancel) {
                return;
            }
            totalSize += [AssetExs size:asset];
        }
        if ([self downloadAssistant]) {
            [[self downloadAssistant] setTotalSize:totalSize];
        }
        
        NSString *relativePath = [snapshot relativePath];
        AssetTokenClient *tokenClient = [AssetTokenClient singleton];
        [tokenClient setFilterDownloadPath:[[[self downloadAssistant] getFolder] stringByAppendingPathComponent:relativePath]];
        [tokenClient setDownloadAssistantDelegate:[self downloadAssistant]];
        NSMutableArray *fileObj = [AssetExs fileObj:assetsList filter:assetsFilter];
        NSEnumerator *enumerator = [fileObj objectEnumerator];
        id obj = nil;
        while (obj = [enumerator nextObject]) {
            if (*cancel) {
                return;
            }
            if (obj && [obj isKindOfClass:[AssetExs class]]) {
                AssetExs *asset = (AssetExs *)obj;
                
                int i = 0;
                int fileCount = (int)[[asset getFiles] count];
                int filePartition = 0;
                if (fileCount > 100000) {
                    filePartition = fileCount / 3000;
                }else if (fileCount > 10000) {
                    filePartition = fileCount / 300;
                }else if (fileCount > 1000) {
                    filePartition = fileCount / 30;
                }else if (fileCount > 100) {
                    filePartition = fileCount / 3;
                }else {
                    filePartition = fileCount;
                }
                NSMutableDictionary *tmpDict = nil;
                for (NSString *str in [asset getFiles]) {
                    if (*cancel) {
                        return;
                    }
                    i++;
                    if (!tmpDict) {
                        tmpDict = [[NSMutableDictionary alloc] init];
                    }
                    if ([AssetExs isNonEmpty:str]) {
                        [tmpDict setObject:asset.domain forKey:str];
                    }
                    if (i == fileCount || i == filePartition) {
                        filePartition += filePartition;
                    }else if (i < filePartition) {
                        continue;
                    }
                    if ([[tmpDict allKeys] count] > 0) {
                        NSArray *assets = nil;
                        @autoreleasepool {
                            assets = [[self backupAssistant] assets:tmpDict withCancle:cancel];
                            assets ? [assets retain] : nil;
                        }
                        if (*cancel) {
#if !__has_feature(objc_arc)
                            if (tmpDict) {
                                [tmpDict release];
                                tmpDict = nil;
                            }
                            if (assets) [assets release]; assets = nil;
#endif
                            return;
                        }
                        if (assets != nil && assets.count > 0) {
                            @autoreleasepool {
                                [[self downloadAssistant] download:assets withRelativePath:relativePath withCancel:cancel];
                            }
                        }
#if !__has_feature(objc_arc)
                        if (tmpDict) {
                            [tmpDict release];
                            tmpDict = nil;
                        }
                        if (assets) [assets release]; assets = nil;
#endif
                    }
                }
#if !__has_feature(objc_arc)
                if (tmpDict) {
                    [tmpDict release];
                    tmpDict = nil;
                }
#endif
            }
        }
    }
}

- (void)printDomainList:(NSMutableDictionary*)snapshots {
    @autoreleasepool {
        NSEnumerator *iterator = [snapshots keyEnumerator];
        Device *device = nil;
        while (device = [iterator nextObject]) {
            NSArray *value = [snapshots objectForKey:device];
            if (value != nil && value.count > 0) {
                for (SnapshotEx *snapshot in value) {
                    [self printDomainList:device snapshot:snapshot];
                }
            }
        }
    }
}

- (void)printDomainList:(Device*)device snapshot:(SnapshotEx*)snapshot {
    // Asset list.
    NSMutableArray *assetsList = [[self backupAssistant] assetsList:snapshot];
    NSLog(@"-- printDomainList() - assets count: %ld", (unsigned long)assetsList.count);
    
    // Output domains --domains option
    NSLog(@"Device: %@", [device info]);
    NSLog(@"Snapshot: %@", [snapshot info]);
    NSLog(@"Domains / file count:");
    NSEnumerator *iterator = [assetsList objectEnumerator];
    AssetExs *assetexs = nil;
    while (assetexs = [iterator nextObject]) {
        NSLog(@"%@ / %ld", [assetexs domain], (unsigned long)[[assetexs filess] count]);
    }
}

- (NSMutableArray *)partition:(NSMutableArray *)list size:(int)size {
    if (size < 0) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"bad size: %d", size] userInfo:nil];
    }
    NSMutableArray *lists = nil;
    @autoreleasepool {
        int count = (int)(list.count);
        lists = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i += size) {
            int fromIndex = i;
            int toIndex = fromIndex + size;
            int length = toIndex > count ? count - fromIndex : size;
            NSArray *tmpSublist = [list subarrayWithRange:NSMakeRange(fromIndex, length)];
            [lists addObject:tmpSublist];
        }
    }
    return (lists ? [lists autorelease] : nil);
}

@end
