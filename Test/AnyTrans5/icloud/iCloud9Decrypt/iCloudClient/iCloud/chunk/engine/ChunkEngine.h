//
//  ChunkEngine.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class AuthorizedAssets;
@class StorageHostChunkListContainer;
@class Voodoo;

@interface ChunkEngine : NSObject

- (NSMutableDictionary*)fetch:(StorageHostChunkListContainer*)storageHostChunkListContainer withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel;
- (NSMutableDictionary*)fetchWithSet:(NSMutableSet*)storageHostChunkListContainerList withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel;

@end
