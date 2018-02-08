//
//  PaddedBufferedBlockCipher.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

/**
 * A wrapper class that allows block ciphers to be used to process data in
 * a piecemeal fashion with padding. The PaddedBufferedBlockCipher
 * outputs a block only when the buffer is full and more data is being added,
 * or on a doFinal (unless the current block in the buffer is a pad block).
 * The default padding mechanism used is the one outlined in Pkcs5/Pkcs7.
 */

#import "BufferedBlockCipher.h"

@class BlockCipherPadding;

@interface PaddedBufferedBlockCipher : BufferedBlockCipher {
@private
    BlockCipherPadding *                        _padding;
}

/**
 * Create a buffered block cipher with the desired padding.
 *
 * @param cipher the underlying block cipher this buffering object wraps.
 * @param padding the padding type.
 */
- (id)initWithCipher:(BlockCipher*)cipher withPadding:(BlockCipherPadding*)padding;

/**
 * Create a buffered block cipher Pkcs7 padding
 *
 * @param cipher the underlying block cipher this buffering object wraps.
 */
- (id)initWithCipher:(BlockCipher*)cipher;

@end
