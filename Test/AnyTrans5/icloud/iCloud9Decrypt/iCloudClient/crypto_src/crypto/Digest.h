//
//  Digest.h
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "Memoable.h"

@interface Digest : Memoable

/**
 * return the algorithm name
 *
 * @return the algorithm name
 */
- (NSString*)algorithmName;

/**
 * return the size, in bytes, of the digest produced by this message digest.
 *
 * @return the size, in bytes, of the digest produced by this message digest.
 */
- (int)getDigestSize;

/**
 * return the size, in bytes, of the internal buffer used by this digest.
 *
 * @return the size, in bytes, of the internal buffer used by this digest.
 */
- (int)getByteLength;

/**
 * update the message digest with a single byte.
 *
 * @param inByte the input byte to be entered.
 */
- (void)update:(Byte)input;

/**
 * update the message digest with a block of bytes.
 *
 * @param input the byte array containing the data.
 * @param inOff the offset into the byte array where the data starts.
 * @param len the length of the data.
 */
- (void)blockUpdate:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length;

/**
 * Close the digest, producing the final digest value. The doFinal
 * call leaves the digest reset.
 *
 * @param output the array the digest is to be copied into.
 * @param outOff the offset into the out array the digest is to start at.
 */
- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff;

/**
 * reset the digest back to it's initial state.
 */
- (void)reset;

@end
