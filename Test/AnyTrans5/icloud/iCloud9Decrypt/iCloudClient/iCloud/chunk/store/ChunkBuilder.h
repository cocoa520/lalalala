//
//  ChunkBuilder.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Chunk;

@interface ChunkBuilder : NSObject

- (NSFileHandle*)getOutputStream;
/**
 * Builds the Chunk. The OutputStream is closed. The Chunk is placed into the managing ChunkStore.
 *
 * @return Chunk
 * @throws IOException
 * @throws IllegalStateException if no OutputStream
 */
- (Chunk*)build;
- (Chunk*)build:(NSData*)data;

@end
