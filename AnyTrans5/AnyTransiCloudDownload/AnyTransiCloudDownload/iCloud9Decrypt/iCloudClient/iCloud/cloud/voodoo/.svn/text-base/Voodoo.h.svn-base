//
//  Voodoo.h
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ChunkReference;
@class FileChecksumStorageHostChunkLists;

@interface Voodoo : NSObject {
@private
    NSMutableDictionary *                           _chunkReferenceToStorageHostChunkListContainer;
    NSMutableDictionary *                           _fileSignatureToChunkReferenceList;
    NSMutableDictionary *                           _chunkReferenceToFileSignature;
}

- (id)initWithFileGroup:(FileChecksumStorageHostChunkLists*)fileGroup;

- (NSArray*)chunkReferenceList:(NSString*)fileSignature;
- (NSString*)fileSignature:(ChunkReference*)chunkReference;
- (NSMutableSet*)storageHostChunkListContainer:(NSString*)fileSignature;

@end