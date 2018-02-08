//
//  BufferedCipherBase.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "BufferedCipherBase.h"
#import "CategoryExtend.h"

@implementation BufferedCipherBase

+ (NSMutableData*)EmptyBuffer {
    static NSMutableData *_emptybuffer = nil;
    @synchronized(self) {
        if (_emptybuffer == nil) {
            _emptybuffer = [[NSMutableData alloc] initWithSize:0];
        }
    }
    return _emptybuffer;
}

- (NSString*)algorithmName {
    return nil;
}

- (void)init:(BOOL)forEncryption withParameters:(CipherParameters *)parameters {
}

- (int)getBlockSize {
    return 0;
}

- (int)getOutputSize:(int)inputLen {
    return 0;
}

- (int)getUpdateOutputSize:(int)inputLen {
    return 0;
}

- (NSMutableData*)processByte:(Byte)input {
    return nil;
}

- (int)processByte:(Byte)input withOutput:(NSMutableData *)output withOutOff:(int)outOff {
    NSMutableData *outBytes = [self processByte:input];
    if (outBytes == nil) {
        return 0;
    }
    if (outOff + outBytes.length > output.length) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"output buffer too short" userInfo:nil];
    }
    [output copyFromIndex:outOff withSource:outBytes withSourceIndex:0 withLength:(int)(outBytes.length)];
    return (int)(outBytes.length);
}

- (NSMutableData*)processBytes:(NSMutableData*)input {
    return [self processBytes:input withInOff:0 withLength:(int)(input.length)];
}

- (NSMutableData*)processBytes:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    return nil;
}

- (int)processBytes:(NSMutableData*)input withOutput:(NSMutableData*)output withOutOff:(int)outOff {
    return [self processBytes:input withInOff:0 withLength:(int)(input.length) withOutput:output withOutOff:outOff];
}

- (int)processBytes:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length withOutput:(NSMutableData*)output withOutOff:(int)outOff {
    NSMutableData *outBytes = [self processBytes:input withInOff:inOff withLength:length];
    if (outBytes == nil) {
        return 0;
    }
    if (outOff + outBytes.length > output.length) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"output buffer too short" userInfo:nil];
    }
    [output copyFromIndex:outOff withSource:outBytes withSourceIndex:0 withLength:(int)(outBytes.length)];
    return (int)(outBytes.length);
}


- (NSMutableData*)doFinal {
    return nil;
}

- (NSMutableData*)doFinal:(NSMutableData*)input {
    return [self doFinal:input withInOff:0 withLength:(int)(input.length)];
}

- (NSMutableData*)doFinal:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    return nil;
}

- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    NSMutableData *outBytes = [self doFinal];
    if (outOff + outBytes.length > output.length) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"output buffer too short" userInfo:nil];
    }
    [output copyFromIndex:outOff withSource:outBytes withSourceIndex:0 withLength:(int)(outBytes.length)];
    return (int)(outBytes.length);
}

- (int)doFinal:(NSMutableData*)input withOutput:(NSMutableData*)output withOutOff:(int)outOff {
    return [self doFinal:input withInOff:0 withLength:(int)(input.length) withOutput:output withOutOff:outOff];
}

- (int)doFinal:(NSMutableData *)input withInOff:(int)inOff withLength:(int)length withOutput:(NSMutableData *)output withOutOff:(int)outOff {
    int len = [self processBytes:input withInOff:inOff withLength:length withOutput:output withOutOff:outOff];
    len += [self doFinal:output withOutOff:(outOff + len)];
    return len;
}

- (void)reset {
}

@end
