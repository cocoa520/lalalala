//
//  ChunkListRequest.h
//  
//
//  Created by iMobie on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class StorageHostChunkList;

@interface ChunkListRequest : NSObject

+ (ChunkListRequest*)instance;

- (NSMutableURLRequest*)apply:(StorageHostChunkList*)storageHostChunkList;

@end
