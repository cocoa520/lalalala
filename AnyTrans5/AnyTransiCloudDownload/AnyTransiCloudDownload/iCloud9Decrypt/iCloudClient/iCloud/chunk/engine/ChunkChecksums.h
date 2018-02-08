//
//  ChunkChecksums.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface ChunkChecksums : NSObject

+ (NSMutableData*)checksum:(int)type withData:(NSMutableData*)data;
+ (NSNumber*)matchToData:(NSMutableData*)checksum withData:(NSMutableData*)data;
+ (BOOL)match:(NSMutableData*)one withTwo:(NSMutableData*)two;
+ (NSNumber*)checksumType:(NSMutableData*)checksum;
+ (NSData*)checksumHash:(NSMutableData*)checksum;
+ (NSMutableData*)hashType1:(NSMutableData*)data;

@end
