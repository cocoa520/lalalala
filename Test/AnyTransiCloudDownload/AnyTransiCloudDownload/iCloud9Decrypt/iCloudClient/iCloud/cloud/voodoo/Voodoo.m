//
//  Voodoo.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "Voodoo.h"
#import "CategoryExtend.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"
#import "FileChecksumChunkReferencesEx.h"
#import "MapAssistant.h"
#import "StorageHostChunkListContainers.h"

@interface Voodoo ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *chunkReferenceToStorageHostChunkListContainer;
@property (nonatomic, readwrite, retain) NSMutableDictionary *fileSignatureToChunkReferenceList;
@property (nonatomic, readwrite, retain) NSMutableDictionary *chunkReferenceToFileSignature;

@end

@implementation Voodoo
@synthesize chunkReferenceToStorageHostChunkListContainer = _chunkReferenceToStorageHostChunkListContainer;
@synthesize fileSignatureToChunkReferenceList = _fileSignatureToChunkReferenceList;
@synthesize chunkReferenceToFileSignature = _chunkReferenceToFileSignature;

- (id)initWithFileGroup:(FileChecksumStorageHostChunkLists*)fileGroup {
    if (self = [super init]) {
        NSArray *storageHostChunkListList = [fileGroup storageHostChunkListList];
        NSMutableDictionary *storageHostChunkListContainerToChunkReferenceList = [StorageHostChunkListContainers storageHostChunkListContainerToChunkReferenceList:storageHostChunkListList];
        [self setChunkReferenceToStorageHostChunkListContainer:[MapAssistant invertDictionary:storageHostChunkListContainerToChunkReferenceList]];
        [self setFileSignatureToChunkReferenceList:[FileChecksumChunkReferencesEx fileSignatureToChunkReferenceList:[fileGroup fileChecksumChunkReferencesList]]];
        [self setChunkReferenceToFileSignature:[MapAssistant invertDictionary:[self fileSignatureToChunkReferenceList]]];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_chunkReferenceToStorageHostChunkListContainer != nil) [_chunkReferenceToStorageHostChunkListContainer release]; _chunkReferenceToStorageHostChunkListContainer = nil;
    if (_fileSignatureToChunkReferenceList != nil) [_fileSignatureToChunkReferenceList release]; _fileSignatureToChunkReferenceList = nil;
    if (_chunkReferenceToFileSignature != nil) [_chunkReferenceToFileSignature release]; _chunkReferenceToFileSignature = nil;
    [super dealloc];
#endif
}

- (NSArray*)chunkReferenceList:(NSString*)fileSignature {
    if ([[self fileSignatureToChunkReferenceList].allKeys containsObject:fileSignature]) {
        return [[self fileSignatureToChunkReferenceList] objectForKey:fileSignature];
    } else {
        return nil;
    }
}

- (NSString*)fileSignature:(ChunkReference*)chunkReference withCancel:(BOOL*)cancel {
    NSArray *allkeys = [self chunkReferenceToFileSignature].allKeys;
    NSEnumerator *iterator = [allkeys objectEnumerator];
    id obj = nil;
    while (obj = [iterator nextObject]) {
        if (*cancel) {
            break;
        }
        if ([chunkReference isEqual:obj]) {
            return [[self chunkReferenceToFileSignature] objectForKey:obj];
        }
    }
    return nil;
}

- (NSMutableSet*)storageHostChunkListContainer:(NSString*)fileSignature {
    NSMutableSet *retSet = [[[NSMutableSet alloc] init] autorelease];
    NSArray *chunkReferenceList = [[self fileSignatureToChunkReferenceList] objectForKey:fileSignature];
    if (chunkReferenceList == nil) {
        return retSet;
    }
    
    NSEnumerator *iterator = [chunkReferenceList objectEnumerator];
    ChunkReference *references = nil;
    NSArray *allkeys = [self chunkReferenceToStorageHostChunkListContainer].allKeys;
    while (references = [iterator nextObject]) {
        for (id obj in allkeys) {
            if ([references isEqual:obj]) {
                [retSet addObject:[[self chunkReferenceToStorageHostChunkListContainer] objectForKey:obj]];
                break;
            }
        }
    }
    return retSet;
}

@end
