//
//  Chunk.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Chunk : NSObject

- (NSMutableData*)getChecksum;
- (NSFileHandle*)inputStream;
- (long)copyTo:(NSFileHandle*)output;

@end
