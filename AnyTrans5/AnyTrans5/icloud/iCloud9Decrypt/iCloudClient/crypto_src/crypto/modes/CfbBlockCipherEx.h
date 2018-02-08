//
//  CfbBlockCipherEx.h
//  
//
//  Created by Pallas on 8/9/16.
//
//  Complete

#import "StreamBlockCipher.h"

@interface CfbBlockCipherEx : StreamBlockCipher {
@private
    NSMutableData *                     _iv;
    NSMutableData *                     _cfbV;
    NSMutableData *                     _cfbOutV;
    NSMutableData *                     _inBuf;
    
    int                                 _blockSize;
    BOOL                                _encrypting;
    int                                 _byteCount;
}

/**
 * return the block size we are operating at.
 *
 * @return the block size we are operating at (in bytes).
 */
- (int)blockSize;

/**
 * Basic constructor.
 *
 * @param cipher the block cipher to be used as the basis of the
 * feedback mode.
 * @param bitBlockSize the block size in bits (note: a multiple of 8)
 */
- (id)initWithCipher:(BlockCipher*)cipher withBitBlockSize:(int)bitBlockSize;

/**
 * Do the appropriate processing for CFB mode encryption.
 *
 * @param in the array containing the data to be encrypted.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the encrypted data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception IllegalStateException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)encryptBlock:(NSData*)inBytes withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff;
/**
 * Do the appropriate processing for CFB mode decryption.
 *
 * @param in the array containing the data to be decrypted.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the encrypted data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception IllegalStateException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)decryptBlock:(NSData*)inBytes withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff;
/**
 * Return the current state of the initialisation vector.
 *
 * @return current IV
 */
- (NSMutableData*)getCurrentIV;

@end
