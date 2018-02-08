//
//  PBKDF2.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Digest;

@interface PBKDF2 : NSObject

+ (NSMutableData*)generate:(NSMutableData*)password withSalt:(NSMutableData*)salt withIterations:(int)iterations withLengthBits:(int)lengthBits;
+ (NSMutableData*)generate:(Digest*)digest withPassword:(NSMutableData*)password withSalt:(NSMutableData*)salt withIterations:(int)iterations withLengthBits:(int)lengthBits;

@end
