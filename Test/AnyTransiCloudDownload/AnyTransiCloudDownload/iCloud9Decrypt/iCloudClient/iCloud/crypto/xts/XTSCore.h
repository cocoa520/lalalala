//
//  XTSCore.h
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BlockCipher;
@class KeyParameter;
@class XTSTweak;

@interface XTSCore : NSObject {
@private
    BlockCipher *                       _cipher;
    XTSTweak *                          _tweak;
    BOOL                                _forEncryption;
}

- (id)initWithTweak:(XTSTweak*)tweak;

- (XTSCore*)init:(BOOL)forEncryption withKey:(KeyParameter*)key;
- (XTSCore*)init:(BOOL)forEncryption withKey1:(KeyParameter*)key1 withKey2:(KeyParameter*)key2;
- (XTSCore*)reset:(int64_t)tweakValue;
- (NSString*)getAlgorithmName;
- (int)getBlockSize;
- (int)processBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff;
- (int)doProcessBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withTweakValue:(NSMutableData*)tweakValue;
- (void)merge:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withTweak:(NSMutableData*)tweak;
- (int)processPartial:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withLength:(int)length;
- (int)doProcessPartial:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withLength:(int)length withTweakA:(NSMutableData*)tweakA withTweakB:(NSMutableData*)tweakB;

@end
