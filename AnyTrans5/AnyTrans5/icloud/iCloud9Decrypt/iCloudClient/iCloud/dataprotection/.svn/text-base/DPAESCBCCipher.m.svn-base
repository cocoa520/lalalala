//
//  DPAESCBCCipher.m
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "DPAESCBCCipher.h"
#import "AesFastEngine.h"
#import "CbcBlockCipher.h"
#import "DPAESCBCBlockIVGenerator.h"
#import "KeyParameter.h"
#import "ParametersWithIV.h"
#import <objc/runtime.h>

@interface DPAESCBCCipher ()

@property (nonatomic, readwrite, retain) BlockCipher *cipher;
@property (nonatomic, readwrite, assign) int blockLength;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite, assign) SEL selector;
@property (nonatomic, readwrite, assign) IMP imp;
@property (nonatomic, readwrite, retain) KeyParameter *key;
@property (nonatomic, readwrite, assign) BOOL forEncryption;
@property (nonatomic, readwrite, assign) int index;
@property (nonatomic, readwrite, assign) int offset;

@end

@implementation DPAESCBCCipher
@synthesize cipher = _cipher;
@synthesize blockLength = _blockLength;
@synthesize target = _target;
@synthesize selector = _selector;
@synthesize imp = _imp;
@synthesize key = _key;
@synthesize forEncryption = _forEncryption;
@synthesize index = _index;
@synthesize offset = _offset;

// 'Every time a file on the data partition is created, Data Protection creates a new 256-bit
// key (the “per-file” key) and gives it to the hardware AES engine, which uses the key to
// encrypt the file as it is written to flash memory using AES CBC mode. (On devices with
// an A8 processor, AES-XTS is used.) The initialization vector (IV) is calculated with the
// block offset into the file, encrypted with the SHA-1 hash of the per-file key.'
// Apple: iOS Security iOS 9.3 or later. May 2016.
// https://www.apple.com/business/docs/iOS_Security_Guide.pdf
+ (int)BLOCK_SIZE {
    return 4096;
}

- (id)initWithCipher:(BlockCipher*)cipher withBlockLength:(int)blockLength withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withKey:(KeyParameter*)key withForEncryption:(BOOL)forEncryption withIndex:(int)index withOffset:(int)offset {
    if (self = [super init]) {
        if (!cipher) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"cipher" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setCipher:cipher];
        [self setBlockLength:blockLength];
        [self setTarget:target];
        [self setSelector:selector];
        [self setImp:imp];
        [self setKey:key];
        [self setForEncryption:forEncryption];
        [self setIndex:index];
        [self setOffset:offset];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCipher:(BlockCipher*)cipher withBlockLength:(int)blockLength {
    if (self = [self initWithCipher:cipher withBlockLength:blockLength withTarget:nil withSelector:nil withImp:nil withKey:nil withForEncryption:NO withIndex:0 withOffset:0]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithBlockSize:(int)blockSize {
    AesFastEngine *aesFast = [[AesFastEngine alloc] init];
    CbcBlockCipher *cbcCipher = [[CbcBlockCipher alloc] initWithCipher:aesFast];
    if (self = [self initWithCipher:cbcCipher withBlockLength:blockSize]) {
#if !__has_feature(objc_arc)
        if (aesFast) [aesFast release]; aesFast = nil;
        if (cbcCipher) [cbcCipher release]; cbcCipher = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (aesFast) [aesFast release]; aesFast = nil;
        if (cbcCipher) [cbcCipher release]; cbcCipher = nil;
        [self release];
#endif
        return nil;
    }
}

- (id)init {
    if (self = [self initWithBlockSize:[DPAESCBCCipher BLOCK_SIZE]]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCipher:nil];
    [self setTarget:nil];
    [self setKey:nil];    
    [super dealloc];
#endif
}

- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
    if (![parameters isMemberOfClass:[KeyParameter class]]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"illegal params class: %@", [parameters className]] userInfo:nil];
    }
    [self setKey:(KeyParameter*)parameters];
    [self setForEncryption:forEncryption];
    
    DPAESCBCBlockIVGenerator *ivGenerator = [[DPAESCBCBlockIVGenerator alloc] initWithFileKey:[[self key] getKey]];
    [self setTarget:ivGenerator];
    [self setSelector:@selector(apply:)];
    [self setImp:class_getMethodImplementation([ivGenerator class], [self selector])];
    [self setOffset:0];
    [self setIndex:0];
#if !__has_feature(objc_arc)
    if (ivGenerator) [ivGenerator release]; ivGenerator = nil;
#endif
}

- (NSString*)algorithmName {
    return [[self cipher] algorithmName];
}

- (int)getBlockSize {
    return [[self cipher] getBlockSize];
}

- (int)processBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff {
    if (![self key]) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"not initialised" userInfo:nil];
    }
    
    if (self.offset == 0) {
        typedef NSMutableData* (*MethodName)(id, SEL, int);
        MethodName methodName = (MethodName)[self imp];
        NSMutableData *iv = methodName([self target], [self selector], self.index);
        ParametersWithIV *parameters = [[ParametersWithIV alloc] initWithParameters:[self key] withIv:iv];
        [[self cipher] init:[self forEncryption] withParameters:parameters];
#if !__has_feature(objc_arc)
        if (parameters) [parameters release]; parameters = nil;
#endif
    }
    
    self.offset += [self getBlockSize];
    if (self.offset == self.blockLength) {
        self.index++;
        self.offset = 0;
    }
    return [[self cipher] processBlock:inBuf withInOff:inOff withOutBuf:outBuf withOutOff:outOff];
}

- (void)reset {
    self.offset = 0;
    self.index = 0;
}

@end
