//
//  ChunkEngine.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkEngine.h"
#import "AuthorizedAssets.h"
#import "StorageHostChunkListContainer.h"
#import "Voodoo.h"

@implementation ChunkEngine

- (NSMutableDictionary*)fetch:(StorageHostChunkListContainer*)storageHostChunkListContainer withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel {
    return nil;
}

- (NSMutableDictionary*)fetchWithSet:(NSMutableSet*)storageHostChunkListContainerList withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    if (storageHostChunkListContainerList != nil && storageHostChunkListContainerList.count > 0) {
        NSEnumerator *iterator = [storageHostChunkListContainerList objectEnumerator];
        StorageHostChunkListContainer *shclc = nil;
        while (shclc = [iterator nextObject]) {
            if (*cancel) {
                return retDict;
            }
            NSMutableDictionary *dict = [self fetch:shclc withTarget:target withSelector:selector withImp:imp withAssets:assets withVoodoo:voodoo withCancel:cancel];
            if (dict != nil && dict.count > 0) {
                [retDict setValuesForKeysWithDictionary:dict];
            }
        }
    }
    return retDict;
}

@end
