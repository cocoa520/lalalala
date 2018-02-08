//
//  ChunkReferences.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "ChunkReferences.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"

@implementation ChunkReferences

+ (ChunkReference*)chunkReference:(int)containerIndex withChunkIndex:(int)chunkIndex {
    ChunkReference_Builder *chunkReferenceBuilder = [ChunkReference builder];
    [chunkReferenceBuilder setContainerIndex:containerIndex];
    [chunkReferenceBuilder setChunkIndex:chunkIndex];
    return [chunkReferenceBuilder build];
}

@end
