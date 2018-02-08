//
//  ChunkBuilder.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkBuilder.h"
#import "Chunk.h"

@implementation ChunkBuilder

- (NSFileHandle*)getOutputStream {
    return nil;
}

/**
 * Builds the Chunk. The OutputStream is closed. The Chunk is placed into the managing ChunkStore.
 *
 * @return Chunk
 * @throws IOException
 * @throws IllegalStateException if no OutputStream
 */
- (Chunk*)build {
    return nil;
}

- (Chunk*)build:(NSData*)data {
    [[self getOutputStream] writeData:data];
    return [self build];
}

@end
