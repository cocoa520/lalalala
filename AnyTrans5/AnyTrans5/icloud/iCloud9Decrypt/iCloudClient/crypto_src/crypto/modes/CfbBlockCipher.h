//
//  CfbBlockCipher.h
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "BlockCipher.h"

@interface CfbBlockCipher : BlockCipher {
@private
    NSMutableData *                     _iv;
    NSMutableData *                     _cfbV;
    NSMutableData *                     _cfbOutV;
    BOOL                                _encrypting;
    
    int                                 _blockSize;
    BlockCipher *                       _cipher;
}

/**
 * Basic constructor.
 *
 * @param cipher the block cipher to be used as the basis of the
 * feedback mode.
 * @param blockSize the block size in bits (note: a multiple of 8)
 */
- (id)initWithCipher:(BlockCipher*)cipher withBitBlockSize:(int)bitBlockSize;

/**
 * return the underlying block cipher that we are wrapping.
 *
 * @return the underlying block cipher that we are wrapping.
 */
- (BlockCipher*)getUnderlyingCipher;

/**
 * Do the appropriate processing for CFB mode encryption.
 *
 * @param in the array containing the data to be encrypted.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the encrypted data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception InvalidOperationException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)encryptBlock:(NSMutableData*)input withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff;
/**
 * Do the appropriate processing for CFB mode decryption.
 *
 * @param in the array containing the data to be decrypted.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the encrypted data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception InvalidOperationException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)decryptBlock:(NSMutableData*)input withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff;

@end
