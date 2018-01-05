//
//  AssetDownloader.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "AssetDownloader.h"
#import "AuthorizedAssets.h"
#import "AssetEx.h"
#import "CategoryExtend.h"
#import "ChunkEngine.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"
#import "Voodoo.h"

@interface AssetDownloader ()

@property (nonatomic, readwrite, retain) ChunkEngine *chunkEngine;
@property (nonatomic, readwrite, assign) uint64_t completeSize;

@property (nonatomic, readwrite, retain) id progressTarget;
@property (nonatomic, readwrite, assign) SEL progressSelector;
@property (nonatomic, readwrite, assign) IMP progressImp;

@end

@implementation AssetDownloader
@synthesize chunkEngine = _chunkEngine;
@synthesize totalSize = _totalSize;
@synthesize completeSize = _completeSize;
@synthesize progressTarget = _progressTarget;
@synthesize progressSelector = _progressSelector;
@synthesize progressImp = _progressImp;

- (id)initWithChunkEngine:(ChunkEngine*)chunkEngine {
    if (self = [super init]) {
        if (chunkEngine == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"chunkEngine" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setChunkEngine:chunkEngine];
        [self setTotalSize:0];
        [self setCompleteSize:0];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setChunkEngine:nil];
    [super dealloc];
#endif
}

- (void)get:(AuthorizedAssets*)assets withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withCancel:(BOOL*)cancel {
    if (*cancel) {
        return;
    }
    NSArray *fileGropsList = [[assets fileGroups] fileGroupsList];
    NSEnumerator *iterator = [fileGropsList objectEnumerator];
    FileChecksumStorageHostChunkLists *fcsc = nil;
    while (fcsc = [iterator nextObject]) {
        if (*cancel) {
            return;
        }
        @autoreleasepool {
            [self get:assets withFileGroup:fcsc withTarget:target withSelector:selector withImp:imp withCancel:cancel];
        }
    }
}

- (void)get:(AuthorizedAssets*)assets withFileGroup:(FileChecksumStorageHostChunkLists*)fileGroup withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withCancel:(BOOL*)cancel {
    if (*cancel) {
        return;
    }
    Voodoo *voodoo = [[Voodoo alloc] initWithFileGroup:fileGroup];
    [self get:assets withVoodoo:voodoo withTarget:target withSelector:selector withImp:imp withCancel:cancel];
#if !__has_feature(objc_arc)
    if (voodoo != nil) [voodoo release]; voodoo = nil;
#endif
}

- (void)get:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withCancel:(BOOL*)cancel {
    if (*cancel) {
        return;
    }
    SEL gKEKSelector = @selector(getKeyEncryptionKey:withVoodoo:withAssets:withCancel:);
    IMP gKEKImp = class_getMethodImplementation([self class], gKEKSelector);
    NSMutableArray *assetLists = [assets getAssets];
    NSEnumerator *iterator = [assetLists objectEnumerator];
    NSMutableArray *assetArray = nil;
    while (assetArray = [iterator nextObject]) {
        if (*cancel) {
            return;
        }
        @autoreleasepool {
            [self get:self withGKEKSelector:gKEKSelector withGKEKImp:gKEKImp withAssets:assets withAssetArray:assetArray withVoodoo:voodoo withTarget:target withSelector:selector withImp:imp withCancel:cancel];
        }
    }
}

- (void)get:(id)gKEKTarget withGKEKSelector:(SEL)gKEKSelector withGKEKImp:(IMP)gKEKImp withAssets:(AuthorizedAssets*)assets withAssetArray:(NSMutableArray*)assetArray withVoodoo:(Voodoo*)voodoo withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withCancel:(BOOL*)cancel {
    if (*cancel) {
        return;
    }
    if (assetArray == nil || assetArray.count == 0) {
        NSLog(@"-- get() - empty asset list");
        return;
    }
    
    AssetEx *primaryAsset = [assetArray objectAtIndex:0];
    
    NSMutableDictionary *chunkData = [self fetchChunkData:gKEKTarget withSelector:gKEKSelector withImp:gKEKImp withAsset:primaryAsset withAssets:assets withVoodoo:voodoo withCancel:cancel];
    
    NSMutableArray *fileChunkList = [self assembleAssetChunkList:chunkData withAsset:primaryAsset withVoodoo:voodoo withCancel:cancel];
    if (fileChunkList != nil && fileChunkList.count > 0) {
        typedef void (*MethodName)(id, SEL, AssetEx*, NSArray*, uint64_t*, BOOL*);
        MethodName methodName = (MethodName)imp;
        NSEnumerator *iterator = [assetArray objectEnumerator];
        AssetEx *asset = nil;
        typedef void (*ProgressMethodName)(id, SEL, uint64_t, uint64_t);
        ProgressMethodName progressMethodName = (ProgressMethodName)[self progressImp];
        while (asset = [iterator nextObject]) {
            if (*cancel) {
                return;
            }
            @autoreleasepool {
                methodName(target, selector, asset, fileChunkList, &_completeSize, cancel);
                progressMethodName([self progressTarget], [self progressSelector], [self totalSize], [self completeSize]);
            }
        }
    }
}

- (NSMutableDictionary*)fetchChunkData:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAsset:(AssetEx*)asset withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel {
    if (*cancel) {
        return nil;
    }
    NSMutableData *fileSignatureData = [asset getFileSignature];
    NSString *fileSignature = nil;
    if (fileSignatureData != nil) {
        fileSignature = [NSString dataToHex:fileSignatureData];
    }
    NSMutableSet *storageHostChunkListContainer = nil;
    if (fileSignature != nil) {
        storageHostChunkListContainer = [voodoo storageHostChunkListContainer:fileSignature];
    }
    
    return [[self chunkEngine] fetchWithSet:storageHostChunkListContainer withTarget:target withSelector:selector withImp:imp withAssets:assets withVoodoo:voodoo withCancel:cancel];
}

- (NSMutableArray*)assembleAssetChunkList:(NSMutableDictionary*)chunkData withAsset:(AssetEx*)asset withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel {
    if (*cancel) {
        return nil;
    }
    NSMutableArray *fileChunkList = nil;
    NSMutableData *fileSignatureData = [asset getFileSignature];
    NSString *fileSignature = nil;
    if (fileSignatureData != nil) {
        fileSignature = [NSString dataToHex:fileSignatureData];
    }
    if (fileSignature != nil) {
        NSArray *chunkReferenceList = [voodoo chunkReferenceList:fileSignature];
        if (chunkReferenceList != nil) {
            NSArray *chunkDataKeys = [chunkData allKeys];
            NSEnumerator *iterator = [chunkReferenceList objectEnumerator];
            ChunkReference *reference = nil;
            while (reference = [iterator nextObject]) {
                if (*cancel) {
                    return nil;
                }
                BOOL contain = NO;
                for (id obj in chunkDataKeys) {
                    if ([reference isEqual:obj]) {
                        contain = YES;
                    }
                }
                if (!contain) {
                    return nil;
                }
            }
            
            fileChunkList = [[[NSMutableArray alloc] init] autorelease];
            iterator = [chunkReferenceList objectEnumerator];
            reference = nil;
            while (reference = [iterator nextObject]) {
                if (*cancel) {
                    return nil;
                }
                for (id obj in chunkDataKeys) {
                    if (*cancel) {
                        return nil;
                    }
                    if ([reference isEqual:obj]) {
                        [fileChunkList addObject:[chunkData objectForKey:obj]];
                    }
                }
            }
        }
    }
    return fileChunkList;
}

- (NSMutableData*)getKeyEncryptionKey:(ChunkReference*)reference withVoodoo:(Voodoo*)voodoo withAssets:(AuthorizedAssets*)assets withCancel:(BOOL*)cancel {
    if (*cancel) {
        return nil;
    }
    NSString *byteString = [voodoo fileSignature:reference withCancel:cancel];
    if ([NSString isNilOrEmpty:byteString]) {
        return nil;
    }
    AssetEx *asset =[assets asset:byteString];
    if (asset == nil) {
        return nil;
    }
    return [asset getKeyEncryptionKey];
}

@end
