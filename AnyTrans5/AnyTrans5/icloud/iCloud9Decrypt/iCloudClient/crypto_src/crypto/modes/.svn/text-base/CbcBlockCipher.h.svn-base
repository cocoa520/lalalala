//
//  CbcBlockCipher.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "BlockCipher.h"

@interface CbcBlockCipher : BlockCipher {
@private
    NSMutableData *                     _iv;
    NSMutableData *                     _cbcV;
    NSMutableData *                     _cbcNextV;
    int                                 _blockSize;
    BlockCipher *                       _cipher;
    BOOL                                _encrypting;
}

/**
 * Basic constructor.
 *
 * @param cipher the block cipher to be used as the basis of chaining.
 */
- (id)initWithCipher:(BlockCipher*)cipher;

/**
 * return the underlying block cipher that we are wrapping.
 *
 * @return the underlying block cipher that we are wrapping.
 */
- (BlockCipher*)getUnderlyingCipher;

@end
