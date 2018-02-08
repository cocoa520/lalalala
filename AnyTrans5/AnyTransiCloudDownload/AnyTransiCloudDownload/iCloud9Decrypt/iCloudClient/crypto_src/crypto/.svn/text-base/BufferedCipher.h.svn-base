//
//  BufferedCipher.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class CipherParameters;

@interface BufferedCipher : NSObject

/// <summary>The name of the algorithm this cipher implements.</summary>
- (NSString*)algorithmName;

/// <summary>Initialise the cipher.</summary>
/// <param name="forEncryption">If true the cipher is initialised for encryption,
/// if false for decryption.</param>
/// <param name="parameters">The key and other data required by the cipher.</param>
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters;

- (int)getBlockSize;

- (int)getOutputSize:(int)inputLen;

- (int)getUpdateOutputSize:(int)inputLen;

- (NSMutableData*)processByte:(Byte)input;
- (int)processByte:(Byte)input withOutput:(NSMutableData*)output withOutOff:(int)outOff;

- (NSMutableData*)processBytes:(NSMutableData*)input;
- (NSMutableData*)processBytes:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length;
- (int)processBytes:(NSMutableData*)input withOutput:(NSMutableData*)output withOutOff:(int)outOff;
- (int)processBytes:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length withOutput:(NSMutableData*)output withOutOff:(int)outOff;

- (NSMutableData*)doFinal;
- (NSMutableData*)doFinal:(NSMutableData*)input;
- (NSMutableData*)doFinal:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length;
- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff;
- (int)doFinal:(NSMutableData*)input withOutput:(NSMutableData*)output withOutOff:(int)outOff;
- (int)doFinal:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length withOutput:(NSMutableData*)output withOutOff:(int)outOff;

/// <summary>
/// Reset the cipher. After resetting the cipher is in the same state
/// as it was after the last init (if there was one).
/// </summary>
- (void)reset;

@end
