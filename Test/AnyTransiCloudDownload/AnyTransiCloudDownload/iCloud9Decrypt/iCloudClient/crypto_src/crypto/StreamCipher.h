//
//  StreamCipher.h
//  
//
//  Created by Pallas on 8/9/16.
//
//  Complete

#import "BlockCipher.h"

@interface StreamCipher : BlockCipher

- (Byte)returnByte:(Byte)inByte;
- (int)processBytes:(NSData*)inBytes withInOff:(int)inOff withLen:(int)len withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff;

@end
