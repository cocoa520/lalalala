//
//  XTSAESCipher.h
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class KeyParameter;
@class XTSCore;

@interface XTSAESCipher : NSObject {
@private
    XTSCore *                               _core;
    int                                     _blockSize;
}

- (id)initWithClazz:(Class)clazz withSelector:(SEL)selector;

- (NSString*)getAlgorithmName;
- (int)getBlockSize;
- (XTSAESCipher*)init:(BOOL)forEncryption withKey:(KeyParameter*)key;
- (XTSAESCipher*)init:(BOOL)forEncryption withKey1:(KeyParameter*)key1 withKey2:(KeyParameter*)key2;
- (int)processDataUnit:(NSMutableData*)inBuf withInOff:(int)inOff withLength:(int)length withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withSequenceNumber:(int64_t)sequenceNumber;

@end
