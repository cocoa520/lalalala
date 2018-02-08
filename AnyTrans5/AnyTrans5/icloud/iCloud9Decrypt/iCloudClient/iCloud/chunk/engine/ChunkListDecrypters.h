//
//  ChunkListDecrypters.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class AuthorizedAssets;
@class ChunkStore;
@class Voodoo;

@interface ChunkListDecrypters : NSObject

+ (NSMutableDictionary*)decrypt:(int)container withChunkInfoList:(NSArray*)chunkInfoList withChunkStore:(ChunkStore*)chunkStore withData:(NSMutableData*)data withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel;

@end
