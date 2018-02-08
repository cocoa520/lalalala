//
//  StandardChunkEngine.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "StandardChunkEngine.h"
#import "AuthorizedAssets.h"
#import "ChunkClient.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"
#import "ChunkStore.h"
#import "ChunkListDecrypters.h"
#import "ChunkReferences.h"
#import "StorageHostChunkListContainer.h"
#import "Voodoo.h"

@interface StandardChunkEngine ()

@property (nonatomic, readwrite, retain) ChunkStore *chunkStore;

@end

@implementation StandardChunkEngine
@synthesize chunkStore = _chunkStore;

- (id)initWithChunkStore:(ChunkStore*)chunkStore {
    if (self = [super init]) {
        if (chunkStore == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"chunkEngine" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setChunkStore:chunkStore];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setChunkStore:nil];
    [super dealloc];
#endif
}

- (NSMutableDictionary*)fetch:(StorageHostChunkListContainer*)storageHostChunkListContainer withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel {
    NSMutableDictionary *chunkStoreChunks = [self chunkStoreChunks:storageHostChunkListContainer];
    
    if (chunkStoreChunks != nil) {
        return chunkStoreChunks;
    }
    
    return [self fetchChunks:storageHostChunkListContainer withTarget:target withSelector:selector withImp:imp withAssets:assets withVoodoo:voodoo withCancel:cancel];
}

- (NSMutableDictionary*)fetchChunks:(StorageHostChunkListContainer*)storageHostChunkListContainer withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel {
    StorageHostChunkList *storageHostChunkList = [storageHostChunkListContainer storageHostChunkList];
    int container = [storageHostChunkListContainer container];
    
    NSMutableData *chunkData = [self fetchChunkData:storageHostChunkList];
    
    return [ChunkListDecrypters decrypt:container withChunkInfoList:[storageHostChunkList chunkInfoList] withChunkStore:[self chunkStore] withData:chunkData withTarget:target withSelector:selector withImp:imp withAssets:assets withVoodoo:voodoo withCancel:cancel];
}

- (NSMutableData*)fetchChunkData:(StorageHostChunkList*)chunkList {
    if (chunkList != nil) {
        NSMutableData *chunkData = [ChunkClient fetch:chunkList];
        if (chunkData != nil) {
            return chunkData;
        }
    }
    return [[[NSMutableData alloc] init] autorelease];
}

- (NSMutableDictionary*)chunkStoreChunks:(StorageHostChunkListContainer*)storageHostChunkListContainer {
    StorageHostChunkList *storageHostChunkList = [storageHostChunkListContainer storageHostChunkList];
    int container = [storageHostChunkListContainer container];
    
    NSMutableArray *checksumList = [self checksumList:[storageHostChunkList chunkInfoList]];
    NSMutableArray *chunkList = [[self chunkStore] chunks:checksumList];
    
    return [self chunks:container withChunkList:chunkList];
}

- (NSMutableDictionary*)chunks:(int)container withChunkList:(NSMutableArray*)chunkList {
    if (chunkList == nil || chunkList.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *chunks = [[[NSMutableDictionary alloc] init] autorelease];
    for (int i = 0; i < chunkList.count; i++) {
        [chunks setObject:[chunkList objectAtIndex:i] forKey:[ChunkReferences chunkReference:container withChunkIndex:i]];
    }
    return chunks;
}

- (NSMutableArray*)checksumList:(NSArray*)list {
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *iterator = [list objectEnumerator];
    ChunkInfo *chunkInfo = nil;
    while (chunkInfo = [iterator nextObject]) {
        if ([chunkInfo hasChunkChecksum]) {
            [retArray addObject:[NSMutableData dataWithData:[chunkInfo chunkChecksum]]];
        }
    }
    return retArray;
}

@end
