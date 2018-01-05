//
//  BlockCipherPadding.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class SecureRandom;

@interface BlockCipherPadding : NSObject

/**
 * Initialise the padder.
 *
 * @param param parameters, if any required.
 */
- (void)init:(SecureRandom*)random;

/**
 * Return the name of the algorithm the cipher implements.
 *
 * @return the name of the algorithm the cipher implements.
 */
- (NSString*)paddingName;

/**
 * add the pad bytes to the passed in block, returning the
 * number of bytes added.
 */
- (int)addPadding:(NSMutableData*)input withInOff:(int)inOff;

/**
 * return the number of pad bytes present in the block.
 * @exception InvalidCipherTextException if the padding is badly formed
 * or invalid.
 */
- (int)padCount:(NSMutableData*)input;

@end
