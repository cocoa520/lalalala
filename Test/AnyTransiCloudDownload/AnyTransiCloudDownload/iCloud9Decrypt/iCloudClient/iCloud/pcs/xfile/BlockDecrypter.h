//
//  BlockDecrypter.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BufferedBlockCipher;
@class ParametersWithIV;
@class KeyParameter;

@interface BlockDecrypter : NSObject {
@private
    BufferedBlockCipher *                       _blockCipher;
    ParametersWithIV *                          _blockIVKey;
    KeyParameter *                              _key;
}

- (id)initWithBlockCipher:(BufferedBlockCipher*)blockCipher withBlockIVKey:(ParametersWithIV*)blockIVKey withKey:(KeyParameter*)key;

- (int)decryptWithBlock:(int)block withInData:(NSMutableData*)inData withLength:(int)length withOutData:(NSMutableData*)outData;
- (int)decryptWithBlock:(int)block withInData:(NSMutableData*)inData withInDataOff:(int)inDataOff withLength:(int)length withOutData:(NSMutableData*)outData withOutDataOff:(int)outDataOff;

@end