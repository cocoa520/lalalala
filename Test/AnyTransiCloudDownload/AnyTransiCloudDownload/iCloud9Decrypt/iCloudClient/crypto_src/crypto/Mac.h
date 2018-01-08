//
//  Mac.h
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class CipherParameters;

@interface Mac : NSObject

/**
 * Initialise the MAC.
 *
 * @param param the key and other data required by the MAC.
 * @exception ArgumentException if the parameters argument is
 * inappropriate.
 */
- (void)init:(CipherParameters*)parameters;

/**
 * Return the name of the algorithm the MAC implements.
 *
 * @return the name of the algorithm the MAC implements.
 */
- (NSString*)algorithmName;

/**
 * Return the block size for this MAC (in bytes).
 *
 * @return the block size for this MAC in bytes.
 */
- (int)getMacSize;

/**
 * add a single byte to the mac for processing.
 *
 * @param in the byte to be processed.
 * @exception InvalidOperationException if the MAC is not initialised.
 */
- (void)update:(Byte)input;

/**
 * @param in the array containing the input.
 * @param inOff the index in the array the data begins at.
 * @param len the length of the input starting at inOff.
 * @exception InvalidOperationException if the MAC is not initialised.
 * @exception DataLengthException if there isn't enough data in in.
 */
- (void)blockUpdate:(NSMutableData*)input withInOff:(int)inOff withLen:(int)len;

/**
 * Compute the final stage of the MAC writing the output to the out
 * parameter.
 * <p>
 * doFinal leaves the MAC in the same state it was after the last init.
 * </p>
 * @param out the array the MAC is to be output to.
 * @param outOff the offset into the out buffer the output is to start at.
 * @exception DataLengthException if there isn't enough space in out.
 * @exception InvalidOperationException if the MAC is not initialised.
 */
- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff;

/**
 * Reset the MAC. At the end of resetting the MAC should be in the
 * in the same state it was after the last init (if there was one).
 */
- (void)reset;

@end