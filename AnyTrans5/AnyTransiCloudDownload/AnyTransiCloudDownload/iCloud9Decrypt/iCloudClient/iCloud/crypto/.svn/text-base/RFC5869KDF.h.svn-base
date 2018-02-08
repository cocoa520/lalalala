//
//  RFC5869KDF.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Digest;

@interface RFC5869KDF : NSObject

+ (NSMutableData*)apply:(NSMutableData*)ikm withSalt:(NSMutableData*)salt withInfo:(NSMutableData*)info withDigest:(Digest*)digest withKeyLengthBytes:(int)keyLengthBytes;

@end