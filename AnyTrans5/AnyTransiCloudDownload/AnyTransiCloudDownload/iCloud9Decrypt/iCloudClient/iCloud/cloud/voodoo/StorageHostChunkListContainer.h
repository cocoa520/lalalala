//
//  StorageHostChunkListContainer.h
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class StorageHostChunkList;

@interface StorageHostChunkListContainer : NSObject <NSCopying> {
@private
    StorageHostChunkList *                              _storageHostChunkList;
    int                                                 _container;
}

- (StorageHostChunkList*)storageHostChunkList;
- (int)container;

- (id)initWithStorageHostChunkList:(StorageHostChunkList*)storageHostChunkList withContainer:(int)container;

@end
