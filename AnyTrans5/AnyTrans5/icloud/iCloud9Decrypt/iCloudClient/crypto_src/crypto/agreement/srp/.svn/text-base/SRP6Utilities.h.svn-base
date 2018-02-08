//
//  SRP6Utilities.h
//  
//
//  Created by iMobie on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class Digest;
@class SecureRandom;

@interface SRP6Utilities : NSObject

+ (BigInteger*)calculateK:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g;
+ (BigInteger*)calculateU:(Digest*)digest withN:(BigInteger*)n withA:(BigInteger*)a withB:(BigInteger*)b;
+ (BigInteger*)calculateX:(Digest*)digest withN:(BigInteger*)n withSalt:(NSMutableData*)salt withIdentity:(NSMutableData*)identity withPassword:(NSMutableData*)password;
+ (BigInteger*)generatePrivateValue:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g withRandom:(SecureRandom*)random;
+ (BigInteger*)validatePublicValue:(BigInteger*)n withVal:(BigInteger*)val;
/**
 * Computes the client evidence message (M1) according to the standard routine:
 * M1 = H( A | B | S )
 * @param digest The Digest used as the hashing function H
 * @param N Modulus used to get the pad length
 * @param A The public client value
 * @param B The public server value
 * @param S The secret calculated by both sides
 * @return M1 The calculated client evidence message
 */
+ (BigInteger*)calculateM1:(Digest*)digest withN:(BigInteger*)n withA:(BigInteger*)a withB:(BigInteger*)b withS:(BigInteger*)s;

/**
 * Computes the server evidence message (M2) according to the standard routine:
 * M2 = H( A | M1 | S )
 * @param digest The Digest used as the hashing function H
 * @param N Modulus used to get the pad length
 * @param A The public client value
 * @param M1 The client evidence message
 * @param S The secret calculated by both sides
 * @return M2 The calculated server evidence message
 */
+ (BigInteger*)calculateM2:(Digest*)digest withN:(BigInteger*)n withA:(BigInteger*)a withM1:(BigInteger*)m1 withS:(BigInteger*)s;
/**
 * Computes the final Key according to the standard routine: Key = H(S)
 * @param digest The Digest used as the hashing function H
 * @param N Modulus used to get the pad length
 * @param S The secret calculated by both sides
 * @return
 */
+ (BigInteger*)calculateKey:(Digest*)digest withN:(BigInteger*)n withS:(BigInteger*)s;

@end
