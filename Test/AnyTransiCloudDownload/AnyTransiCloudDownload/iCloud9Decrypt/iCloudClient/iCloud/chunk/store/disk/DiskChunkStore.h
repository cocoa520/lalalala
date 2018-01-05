//
//  DiskChunkStore.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkStore.h"

@interface DiskChunkStore : ChunkStore {
@private
    NSString *                          _chunkFolder;
}

- (id)initWithChunkFolder:(NSString*)chunkFolder;

@end
