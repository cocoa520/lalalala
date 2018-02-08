//
//  StorageHostChunkListContainers.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "StorageHostChunkListContainers.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"
#import "ChunkReferences.h"
#import "StorageHostChunkListContainer.h"

@implementation StorageHostChunkListContainers

+ (NSMutableDictionary*)storageHostChunkListContainerToChunkReferenceList:(NSArray*)storageHostChunkListList {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *iterator = [storageHostChunkListList objectEnumerator];
    StorageHostChunkList *storageHostChunkList = nil;
    int container = 0;
    while (storageHostChunkList = [iterator nextObject]) {
        int chunkCount = (int)[[storageHostChunkList chunkInfoList] count];
        NSMutableArray *chunkReferenceList = [[NSMutableArray alloc] init];
        for (int i = 0; i < chunkCount; i++) {
            [chunkReferenceList addObject:[ChunkReferences chunkReference:container withChunkIndex:i]];
        }
        StorageHostChunkListContainer *storageHostChunkListContainer = [[StorageHostChunkListContainer alloc] initWithStorageHostChunkList:storageHostChunkList withContainer:container];
        [retDict setObject:chunkReferenceList forKey:storageHostChunkListContainer];
#if !__has_feature(objc_arc)
        if (chunkReferenceList != nil) [chunkReferenceList release]; chunkReferenceList = nil;
        if (storageHostChunkListContainer != nil) [storageHostChunkListContainer release]; storageHostChunkListContainer = nil;
#endif
        container++;
    }
    return retDict;
}

@end
