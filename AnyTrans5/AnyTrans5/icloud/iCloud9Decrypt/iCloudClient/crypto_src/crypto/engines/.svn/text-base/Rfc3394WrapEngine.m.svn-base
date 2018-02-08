//
//  Rfc3394WrapEngine.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "Rfc3394WrapEngine.h"
#import "BlockCipher.h"
#import "CategoryExtend.h"
#import "ParametersWithRandom.h"
#import "KeyParameter.h"
#import "ParametersWithIV.h"
#import "Arrays.h"

@interface Rfc3394WrapEngine ()

@property (nonatomic, readwrite, retain) BlockCipher *engine;
@property (nonatomic, readwrite, retain) KeyParameter *param;
@property (nonatomic, readwrite, assign) BOOL forWrapping;
@property (nonatomic, readwrite, retain) NSMutableData *iv;

@end

@implementation Rfc3394WrapEngine
@synthesize engine = _engine;
@synthesize param = _param;
@synthesize forWrapping = _forWrapping;
@synthesize iv = _iv;

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableData *tmpIV = [[NSMutableData alloc] initWithSize:8];
            for (int i = 0; i < 8; i++) {
                ((Byte*)(tmpIV.bytes))[i] = 0xa6;
            }
            [self setIv:tmpIV];
#if !__has_feature(objc_arc)
            if (tmpIV != nil) [tmpIV release]; tmpIV = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithEngine:(BlockCipher*)engine {
    if (self = [self init]) {
        [self setEngine:engine];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setEngine:nil];
    [self setParam:nil];
    [self setIv:nil];
    [super dealloc];
#endif
}

- (void)init:(BOOL)forWrapping withParameters:(CipherParameters*)parameters {
    [self setForWrapping:forWrapping];
    
    if (parameters != nil && [parameters isKindOfClass:[ParametersWithRandom class]]) {
        parameters = [((ParametersWithRandom*)parameters) parameters];
    }
    
    if (parameters != nil && [parameters isKindOfClass:[KeyParameter class]]) {
        [self setParam:(KeyParameter*)parameters];
    } else if (parameters != nil && [parameters isKindOfClass:[ParametersWithIV class]]) {
        ParametersWithIV *pIV = (ParametersWithIV*)parameters;
        NSMutableData *iv = [pIV getIV];
        
        if (iv.length != 8) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"IV length of parameters not equal to 8" userInfo:nil];
        }
        
        [self setIv:iv];
        [self setParam:(KeyParameter*)[pIV parameters]];
    } else {
        // TODO Throw an exception for bad parameters?
    }
}

- (NSString*)algorithmName {
    return [[self engine] algorithmName];
}

- (NSMutableData*)wrap:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    if (![self forWrapping]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"not set for wrapping" userInfo:nil];
    }
    
    int n = length / 8;
    
    if ((n * 8) != length) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"wrap data must be a multiple of 8 bytes" userInfo:nil];
    }
    
    int ivLen = (int)([self iv].length);
    NSMutableData *block = nil;
    @autoreleasepool {
        block = [[NSMutableData alloc] initWithSize:(length + ivLen)];
        NSMutableData *buf = [[NSMutableData alloc] initWithSize:(8 +  ivLen)];
        
        [block copyFromIndex:0 withSource:[self iv] withSourceIndex:0 withLength:ivLen];
        [block copyFromIndex:ivLen withSource:input withSourceIndex:inOff withLength:length];
        
        [[self engine] init:YES withParameters:[self param]];
        
        for (int j = 0; j != 6; j++) {
            for (int i = 1; i <= n; i++) {
                [buf copyFromIndex:0 withSource:block withSourceIndex:0 withLength:ivLen];
                [buf copyFromIndex:ivLen withSource:block withSourceIndex:(8 * i) withLength:8];
                [[self engine] processBlock:buf withInOff:0 withOutBuf:buf withOutOff:0];
                
                int t = n * j + i;
                for (int k = 1; t != 0; k++) {
                    Byte v = (Byte)t;
                    
                    ((Byte*)(buf.bytes))[ivLen - k] = ((Byte*)(buf.bytes))[ivLen - k] ^ v;
                    t = (int)((uint)t >> 8);
                }
                
                [block copyFromIndex:0 withSource:buf withSourceIndex:0 withLength:8];
                [block copyFromIndex:(8 * i) withSource:buf withSourceIndex:8 withLength:8];
            }
        }
        
#if !__has_feature(objc_arc)
        if (buf != nil) [buf release]; buf = nil;
#endif
    }
    
    return (block ? [block autorelease] : nil);
}

- (NSMutableData*)unwrap:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    if ([self forWrapping]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"not set for unwrapping" userInfo:nil];
    }
    
    int n = length / 8;
    
    if ((n * 8) != length) {
         @throw [NSException exceptionWithName:@"InvalidCipherText" reason:@"unwrap data must be a multiple of 8 bytes" userInfo:nil];
    }
    
    int ivLen = (int)([self iv].length);
    NSMutableData *block = nil;
    @autoreleasepool {
        block = [[NSMutableData alloc] initWithSize:(length - ivLen)];
        NSMutableData *a = [[NSMutableData alloc] initWithSize:ivLen];
        NSMutableData *buf = [[NSMutableData alloc] initWithSize:(8 + ivLen)];
        
        [a copyFromIndex:0 withSource:input withSourceIndex:inOff withLength:ivLen];
        [block copyFromIndex:0 withSource:input withSourceIndex:(inOff + ivLen) withLength:(length - ivLen)];
        
        [[self engine] init:NO withParameters:[self param]];
        
        n = n - 1;
        
        for (int j = 5; j >= 0; j--) {
            for (int i = n; i >= 1; i--) {
                [buf copyFromIndex:0 withSource:a withSourceIndex:0 withLength:ivLen];
                [buf copyFromIndex:ivLen withSource:block withSourceIndex:(8 * (i - 1)) withLength:8];
                
                int t = n * j + i;
                for (int k = 1; t != 0; k++) {
                    Byte v = (Byte)t;
                    
                    ((Byte*)(buf.bytes))[ivLen - k] = ((Byte*)(buf.bytes))[ivLen - k] ^ v;
                    t = (int)((uint)t >> 8);
                }
                
                [[self engine] processBlock:buf withInOff:0 withOutBuf:buf withOutOff:0];
                [a copyFromIndex:0 withSource:buf withSourceIndex:0 withLength:8];
                [block copyFromIndex:(8 * (i - 1)) withSource:buf withSourceIndex:8 withLength:8];
            }
        }
        
        if (![Arrays constantTimeAreEqualWithByteArray:a withB:[self iv]]) {
            @throw [NSException exceptionWithName:@"InvalidCipherText" reason:@"checksum failed" userInfo:nil];
        }
        
#if !__has_feature(objc_arc)
        if (a != nil) [a release]; a = nil;
        if (buf != nil) [buf release]; buf = nil;
#endif
    }
    
    return (block ? [block autorelease] : nil);
}

@end
