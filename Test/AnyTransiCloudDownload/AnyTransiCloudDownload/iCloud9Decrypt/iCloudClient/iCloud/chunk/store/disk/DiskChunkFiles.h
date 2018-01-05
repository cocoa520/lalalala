//
//  DiskChunkFiles.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface DiskChunkFiles : NSObject

+ (NSString*)filename:(NSData*)chunkChecksum;
+ (NSString*)filename:(NSData*)chunkChecksum withSubSplit:(int)subSplit;
+ (NSString*)subSplit:(NSString*)fileName withSubSplit:(int)subSplit;

@end
