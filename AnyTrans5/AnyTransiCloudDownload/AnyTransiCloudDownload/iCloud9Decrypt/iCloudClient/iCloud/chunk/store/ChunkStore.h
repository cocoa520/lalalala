//
//  ChunkStore.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Chunk;
@class ChunkBuilder;

@interface ChunkStore : NSObject

- (Chunk*)chunk:(NSMutableData*)checksum;
- (ChunkBuilder*)chunkBuilder:(NSMutableData*)checksum;
- (NSMutableArray*)chunks:(NSArray*)checksums;

@end
