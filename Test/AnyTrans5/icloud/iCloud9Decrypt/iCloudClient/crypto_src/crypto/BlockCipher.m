//
//  BlockCipher.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "BlockCipher.h"
#import "CipherParameters.h"

@implementation BlockCipher

/// <summary>The name of the algorithm this cipher implements.</summary>
- (NSString*)algorithmName {
    return nil;
}

/// <summary>Initialise the cipher.</summary>
/// <param name="forEncryption">Initialise for encryption if true, for decryption if false.</param>
/// <param name="parameters">The key or other data required by the cipher.</param>
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
}

/// <returns>The block size for this cipher, in bytes.</returns>
- (int)getBlockSize {
    return 0;
}

/// <summary>Indicates whether this cipher can handle partial blocks.</summary>
- (BOOL)isPartialBlockOkay {
    return NO;
}

/// <summary>Process a block.</summary>
/// <param name="inBuf">The input buffer.</param>
/// <param name="inOff">The offset into <paramref>inBuf</paramref> that the input block begins.</param>
/// <param name="outBuf">The output buffer.</param>
/// <param name="outOff">The offset into <paramref>outBuf</paramref> to write the output block.</param>
/// <exception cref="DataLengthException">If input block is wrong size, or outBuf too small.</exception>
/// <returns>The number of bytes processed and produced.</returns>
- (int)processBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff {
    return 0;
}

/// <summary>
/// Reset the cipher to the same state as it was after the last init (if there was one).
/// </summary>
- (void)reset {
}

@end
