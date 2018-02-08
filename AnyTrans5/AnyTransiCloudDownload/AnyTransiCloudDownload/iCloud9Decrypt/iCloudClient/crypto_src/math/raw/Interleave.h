//
//  Interleave.h
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Interleave : NSObject

+ (uint)expand8to16:(uint)x;
+ (uint)expand16to32:(uint)x;
+ (uint64_t)expand32to64:(uint)x;
// NSMutableArray == uint64_t[]
+ (void)expand64To128:(uint64_t)x withZ:(NSMutableArray*)z withZ0ff:(int)zOff;
+ (uint64_t)unshuffle:(uint64_t)x;

@end
