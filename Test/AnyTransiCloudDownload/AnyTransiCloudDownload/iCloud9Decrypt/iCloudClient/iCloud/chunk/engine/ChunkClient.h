//
//  ChunkClient.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ChunkListRequest;
@class StorageHostChunkList;

@interface ChunkClient : NSObject

+ (NSMutableData*)fetch:(StorageHostChunkList*)chunkList;
+ (NSMutableData*)fetch:(StorageHostChunkList*)chunkList withChunkListRequest:(ChunkListRequest*)chunkListRequest;

@end
