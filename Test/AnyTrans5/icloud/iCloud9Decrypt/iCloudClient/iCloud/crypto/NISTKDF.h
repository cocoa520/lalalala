//
//  NISTKDF.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Digest;

@interface NISTKDF : NSObject

+ (NSMutableData*)ctrHMac:(NSMutableData*)keyDerivationKey withLabelString:(NSString*)labelString withDigest:(Digest*)digest withKeyLengthBytes:(int)keyLengthBytes;
+ (NSMutableData*)ctrHMac:(NSMutableData*)keyDerivationKey withLabelData:(NSData*)label withDigest:(Digest*)digest withKeyLengthBytes:(int)keyLengthBytes;

@end
