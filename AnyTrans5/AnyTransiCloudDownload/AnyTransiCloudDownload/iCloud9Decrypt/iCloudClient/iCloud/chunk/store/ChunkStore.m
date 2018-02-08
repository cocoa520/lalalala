//
//  ChunkStore.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkStore.h"
#import "Chunk.h"
#import "ChunkBuilder.h"

@implementation ChunkStore

- (Chunk*)chunk:(NSMutableData*)checksum {
    return nil;
}

- (ChunkBuilder*)chunkBuilder:(NSMutableData*)checksum {
    return nil;
}

- (NSMutableArray*)chunks:(NSArray*)checksums {
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *iterator = [checksums objectEnumerator];
    NSMutableData *data = nil;
    while (data = [iterator nextObject]) {
        Chunk *chunk = [self chunk:data];
        if (chunk != nil) {
            [retArray addObject:chunk];
        }
    }
    return retArray;
}

@end
