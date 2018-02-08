//
//  SRPCore.h
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class Digest;

@interface SRPCore : NSObject

+ (NSMutableData*)generateEphemeralKeyA:(BigInteger*)n withG:(BigInteger*)g withA:(BigInteger*)a;
+ (BigInteger*)generatek:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g;
+ (NSMutableData*)generateKey:(Digest*)digest withN:(BigInteger*)n withS:(BigInteger*)s;
+ (NSMutableData*)generateM1:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g withEphemeralKeyA:(NSMutableData*)ephemeralKeyA withEphemeralKeyB:(NSMutableData*)ephemeralKeyB withKey:(NSMutableData*)key withSalt:(NSMutableData*)salt withIdentity:(NSMutableData*)identity;
+ (NSMutableData*)generateM2:(Digest*)digest withN:(BigInteger*)n withA:(NSMutableData*)a withM1:(NSMutableData*)m1 withK:(NSMutableData*)k;
+ (BigInteger*)generateS:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g withA:(BigInteger*)a withK:(BigInteger*)k withU:(BigInteger*)u withX:(BigInteger*)x withB:(BigInteger*)b;
+ (BigInteger*)generateu:(Digest*)digest withA:(NSMutableData*)a withB:(NSMutableData*)b;
+ (BigInteger*)generatex:(Digest*)digest withN:(BigInteger*)n withSalt:(NSMutableData*)salt withIdentity:(NSMutableData*)dentity withPassword:(NSMutableData*)password;
+ (BOOL)isZero:(BigInteger*)n withI:(BigInteger*)i;
+ (int)length:(BigInteger*)i;
+ (NSMutableData*)padded:(BigInteger*)n withLength:(int)length;

@end
