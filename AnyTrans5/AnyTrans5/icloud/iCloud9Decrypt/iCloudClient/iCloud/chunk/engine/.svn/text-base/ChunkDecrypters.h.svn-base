//
//  ChunkDecrypters.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class StreamBlockCipher;

@interface ChunkDecrypters : NSObject

+ (NSMutableData*)decrypt:(NSMutableData*)key withData:(NSMutableData*)data withOffset:(int)offset withLength:(int)length;
+ (NSMutableData*)decrypt:(NSMutableData*)key withCipher:(StreamBlockCipher*)cipher withData:(NSMutableData*)data withOffset:(int)offset withLength:(int)length;

@end
