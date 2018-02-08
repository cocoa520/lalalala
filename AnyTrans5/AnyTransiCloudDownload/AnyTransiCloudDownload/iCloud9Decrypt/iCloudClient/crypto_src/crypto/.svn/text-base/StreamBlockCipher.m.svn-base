//
//  StreamBlockCipher.m
//  
//
//  Created by Pallas on 8/9/16.
//
//  Complete

#import "StreamBlockCipher.h"

@interface StreamBlockCipher ()

@property (nonatomic, readwrite, retain) BlockCipher *cipher;

@end

@implementation StreamBlockCipher
@synthesize cipher = _cipher;

- (id)initWithCipher:(BlockCipher*)cipher {
    if (self = [super init]) {
        [self setCipher:cipher];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCipher:nil];
    [super dealloc];
#endif
}

- (BlockCipher*)getUnderlyingCipher {
    return [self cipher];
}

- (Byte)returnByte:(Byte)inByte {
    return [self calculateByte:inByte];
}

- (int)processBytes:(NSData*)inBytes withInOff:(int)inOff withLen:(int)len withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    if (outOff + len > outBytes.length) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"output buffer too short" userInfo:nil];
    }
    
    if (inOff + len > inBytes.length){
        @throw [NSException exceptionWithName:@"DataLength" reason:@"input buffer too small" userInfo:nil];
    }
    
    int inStart = inOff;
    int inEnd = inOff + len;
    int outStart = outOff;
    
    while (inStart < inEnd) {
        ((Byte*)(outBytes.bytes))[outStart++] = [self calculateByte:(Byte)(((Byte*)(inBytes.bytes))[inStart++])];
    }
    
    return len;
}

- (Byte)calculateByte:(Byte)b {
    return (Byte)0;
}

@end
