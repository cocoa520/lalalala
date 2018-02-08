//
//  GcmBlockCipher.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "GcmBlockCipher.h"
#import "BlockCipher.h"
#import "GcmMultiplier.h"
#import "GcmExponentiator.h"
#import "Tables8kGcmMultiplier.h"
#import "KeyParameter.h"
#import "AeadParameters.h"
#import "ParametersWithIV.h"
#import "Pack.h"
#import "Check.h"
#import "GcmUtilities.h"
#import "Tables1kGcmExponentiator.h"
#import "Arrays.h"

#import "CategoryExtend.h"

@interface GcmBlockCipher ()

@property (nonatomic, readwrite, retain) BlockCipher *cipher;
@property (nonatomic, readwrite, retain) GcmMultiplier *multiplier;
@property (nonatomic, readwrite, retain) GcmExponentiator *exp;

// These fields are set by Init and not modified by processing
@property (nonatomic, readwrite, assign) BOOL forEncryption;
@property (nonatomic, readwrite, assign) int macSize;
@property (nonatomic, readwrite, retain) NSMutableData *nonce;
@property (nonatomic, readwrite, retain) NSMutableData *initialAssociatedText;
@property (nonatomic, readwrite, retain) NSMutableData *h;
@property (nonatomic, readwrite, retain) NSMutableData *j0;

// These fields are modified during processing
@property (nonatomic, readwrite, retain) NSMutableData *bufBlock;
@property (nonatomic, readwrite, retain) NSMutableData *macBlock;
@property (nonatomic, readwrite, retain) NSMutableData *s;
@property (nonatomic, readwrite, retain) NSMutableData *s_at;
@property (nonatomic, readwrite, retain) NSMutableData *s_atPre;
@property (nonatomic, readwrite, retain) NSMutableData *counter;
@property (nonatomic, readwrite, assign) int bufOff;
@property (nonatomic, readwrite, assign) uint64_t totalLength;
@property (nonatomic, readwrite, retain) NSMutableData *atBlock;
@property (nonatomic, readwrite, assign) int atBlockPos;
@property (nonatomic, readwrite, assign) uint64_t atLength;
@property (nonatomic, readwrite, assign) uint64_t atLengthPre;

@end

@implementation GcmBlockCipher
@synthesize cipher = _cipher;
@synthesize multiplier = _multiplier;
@synthesize exp = _exp;
@synthesize forEncryption = _forEncryption;
@synthesize macSize = _macSize;
@synthesize nonce = _nonce;
@synthesize initialAssociatedText = _initialAssociatedText;
@synthesize h = _h;
@synthesize j0 = _j0;
@synthesize bufBlock = _bufBlock;
@synthesize macBlock = _macBlock;
@synthesize s = _s;
@synthesize s_at = _s_at;
@synthesize s_atPre = _s_atPre;
@synthesize counter = _counter;
@synthesize bufOff = _bufOff;
@synthesize totalLength = _totalLength;
@synthesize atBlock = _atBlock;
@synthesize atBlockPos = _atBlockPos;
@synthesize atLength = _atLength;
@synthesize atLengthPre = _atLengthPre;

static const int BlockSize = 16;

- (id)initWithCipher:(BlockCipher*)c {
    if (self = [self initWithCipher:c withMultiplier:nil]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCipher:(BlockCipher*)c withMultiplier:(GcmMultiplier*)m {
    if (self = [super init]) {
        if ([c getBlockSize] != BlockSize) {
            @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"cipher required with a block size of %d", BlockSize] userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        
        if (m == nil) {
            // TODO Consider a static property specifying default multiplier
            m = [[Tables8kGcmMultiplier alloc] init];
            [self setMultiplier:m];
#if !__has_feature(objc_arc)
            if (m != nil) [m release]; m = nil;
#endif
        } else {
            [self setMultiplier:m];
        }
        [self setCipher:c];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCipher:nil];
    [self setMultiplier:nil];
    [self setExp:nil];
    [self setNonce:nil];
    [self setInitialAssociatedText:nil];
    [self setH:nil];
    [self setJ0:nil];
    [self setBufBlock:nil];
    [self setMacBlock:nil];
    [self setS:nil];
    [self setS_at:nil];
    [self setS_atPre:nil];
    [self setCounter:nil];
    [self setAtBlock:nil];
    [super dealloc];
#endif
}

- (NSString*)algorithmName {
    return [[[NSString alloc] initWithFormat:@"%@/GCM", [[self cipher] algorithmName]] autorelease];
}

- (BlockCipher*)getUnderlyingCipher {
    return [self cipher];
}

- (int)getBlockSize {
    return BlockSize;
}

/// <remarks>
/// MAC sizes from 32 bits to 128 bits (must be a multiple of 8) are supported. The default is 128 bits.
/// Sizes less than 96 are not recommended, but are supported for specialized applications.
/// </remarks>
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
    @autoreleasepool {
        [self setForEncryption:forEncryption];
        [self setMacBlock:nil];
        
        KeyParameter *keyParam;
        
        if (parameters != nil && [parameters isKindOfClass:[AeadParameters class]]) {
            AeadParameters *param = (AeadParameters*)parameters;
            
            [self setNonce:[param getNonce]];
            [self setInitialAssociatedText:[param getAssociatedText]];
            
            int macSizeBits = [param macSize];
            if (macSizeBits < 32 || macSizeBits > 128 || macSizeBits % 8 != 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"Invalid value for MAC size: %d", macSizeBits] userInfo:nil];
            }
            
            [self setMacSize:(int)(macSizeBits / 8)];
            keyParam = [param key];
        } else if (parameters != nil && [parameters isKindOfClass:[ParametersWithIV class]]) {
            ParametersWithIV *param = (ParametersWithIV*)parameters;
            
            [self setNonce:[param getIV]];
            [self setInitialAssociatedText:nil];
            [self setMacSize:16];
            keyParam = (KeyParameter*)[param parameters];
        } else {
            @throw [NSException exceptionWithName:@"Argument" reason:@"invalid parameters passed to GCM" userInfo:nil];
        }
        
        int bufLength = forEncryption ? BlockSize : (BlockSize + self.macSize);
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:bufLength];
        [self setBufBlock:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        
        if ([self nonce] == nil || [self nonce].length < 1) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"IV must be at least 1 byte" userInfo:nil];
        }
        
        // TODO Restrict macSize to 16 if nonce length not 12?
        
        // Cipher always used in forward mode
        // if keyParam is null we're reusing the last key.
        if (keyParam != nil) {
            [[self cipher] init:YES withParameters:keyParam];
            
            tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
            [self setH:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
            [[self cipher] processBlock:[self h] withInOff:0 withOutBuf:[self h] withOutOff:0];
            
            // if keyParam is null we're reusing the last key and the multiplier doesn't need re-init
            [[self multiplier] init:[self h]];
            [self setExp:nil];
        } else if ([self h] == nil) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Key must be specified in initial init" userInfo:nil];
        }
        
        tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setJ0:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        
        if ([self nonce].length == 12) {
            [[self j0] copyFromIndex:0 withSource:[self nonce] withSourceIndex:0 withLength:(int)([self nonce].length)];
            ((Byte*)([self j0].bytes))[BlockSize - 1] = 0x01;
        } else {
            [self gHASH:[self j0] withB:[self nonce] withLen:(int)([self nonce].length)];
            NSMutableData *X = [[NSMutableData alloc] initWithSize:BlockSize];
            [Pack UInt64_To_BE:(((uint64_t)([self nonce].length)) * 8UL) withBs:X withOff:8];
            [self gHASHBlock:[self j0] withB:X];
#if !__has_feature(objc_arc)
            if (X != nil) [X release]; X = nil;
#endif
        }
        
        tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setS:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setS_at:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setS_atPre:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setAtBlock:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        [self setAtBlockPos:0];
        [self setAtLength:0];
        [self setAtLengthPre:0];
        int j0Length = (int)([self j0].length);
        tmpData = [[NSMutableData alloc] initWithSize:j0Length];
        [self setCounter:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        [[self counter] copyFromIndex:0 withSource:[self j0] withSourceIndex:0 withLength:j0Length];
        [self setBufOff:0];
        [self setTotalLength:0];
        
        if ([self initialAssociatedText] != nil) {
            [self processAadBytes:[self initialAssociatedText] withInOff:0 withLen:(int)([self initialAssociatedText].length)];
        }
    }
}

- (NSMutableData*)getMac {
    int length = (int)([self macBlock].length);
    NSMutableData *retVal = [[[NSMutableData alloc] initWithSize:length] autorelease];
    [retVal copyFromIndex:0 withSource:[self macBlock] withSourceIndex:0 withLength:length];
    return retVal;
}

- (int)getOutputSize:(int)len {
    int totalData = len + self.bufOff;
    
    if (self.forEncryption) {
        return totalData + self.macSize;
    }
    
    return totalData < self.macSize ? 0 : totalData - self.macSize;
}

- (int)getUpdateOutputSize:(int)len {
    int totalData = len + self.bufOff;
    if (!self.forEncryption) {
        if (totalData < self.macSize) {
            return 0;
        }
        totalData -= self.macSize;
    }
    return totalData - totalData % BlockSize;
}

- (void)processAadByte:(Byte)input {
    ((Byte*)([self atBlock].bytes))[self.atBlockPos] = input;
    if (++(self.atBlockPos) == BlockSize) {
        // Hash each block as it fills
        [self gHASHBlock:[self s_at] withB:[self atBlock]];
        self.atBlockPos = 0;
        self.atLength += BlockSize;
    }
}

- (void)processAadBytes:(NSMutableData*)inBytes withInOff:(int)inOff withLen:(int)len {
    for (int i = 0; i < len; ++i) {
        ((Byte*)([self atBlock].bytes))[self.atBlockPos] = ((Byte*)(inBytes.bytes))[inOff + i];
        if (++(self.atBlockPos) == BlockSize) {
            // Hash each block as it fills
            [self gHASHBlock:[self s_at] withB:[self atBlock]];
            self.atBlockPos = 0;
            self.atLength += BlockSize;
        }
    }
}


- (void)initCipher {
    if (self.atLength > 0) {
        [[self s_atPre] copyFromIndex:0 withSource:[self s_at] withSourceIndex:0 withLength:BlockSize];
        self.atLengthPre = self.atLength;
    }
    
    // Finish hash for partial AAD block
    if (self.atBlockPos > 0) {
        [self gHASHPartial:[self s_atPre] withB:[self atBlock] withOff:0 withLen:self.atBlockPos];
        self.atLengthPre += (uint)(self.atBlockPos);
    }
    
    if (self.atLengthPre > 0) {
        [[self s] copyFromIndex:0 withSource:[self s_atPre] withSourceIndex:0 withLength:BlockSize];
    }
}

- (int)processByte:(Byte)input withOutBytes:(NSMutableData *)outBytes withOutOff:(int)outOff {
    ((Byte*)([self bufBlock].bytes))[self.bufOff] = input;
    if (++(self.bufOff) == (int)([self bufBlock].length)) {
        [self outputBlock:outBytes withOffset:outOff];
        return BlockSize;
    }
    return 0;
}

- (int)processBytes:(NSMutableData*)inBytes withInOff:(int)inOff withLen:(int)len withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    if ((int)(inBytes.length) < (inOff + len)) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"Input buffer too short" userInfo:nil];
    }
    
    int resultLen = 0;
    
    for (int i = 0; i < len; ++i) {
        ((Byte*)([self bufBlock].bytes))[self.bufOff] = ((Byte*)(inBytes.bytes))[inOff + i];
        if (++(self.bufOff) == (int)([self bufBlock].length)) {
            [self outputBlock:outBytes withOffset:(outOff + resultLen)];
            resultLen += BlockSize;
        }
    }
    
    return resultLen;
}

- (void)outputBlock:(NSMutableData*)output withOffset:(int)offset {
    [Check outputLength:output withOff:offset withLen:BlockSize withMsg:@"Output buffer too short"];
    if (self.totalLength == 0) {
        [self initCipher];
    }
    [self gCTRBlock:[self bufBlock] withOutput:output withOutOff:offset];
    if (self.forEncryption) {
        self.bufOff = 0;
    } else {
        [[self bufBlock] copyFromIndex:0 withSource:[self bufBlock] withSourceIndex:BlockSize withLength:self.macSize];
        self.bufOff = self.macSize;
    }
}

- (int)doFinal:(NSMutableData*)outBytes withOutOff:(int)outOff {
    int resultLen = 0;
    @autoreleasepool {
        if (self.totalLength == 0) {
            [self initCipher];
        }
        
        int extra = self.bufOff;
        
        if (self.forEncryption) {
            [Check outputLength:outBytes withOff:outOff withLen:(extra + self.macSize) withMsg:@"Output buffer too short"];
        } else {
            if (extra < self.macSize) {
                @throw [NSException exceptionWithName:@"InvalidCipherText" reason:@"data too short" userInfo:nil];
            }
            
            extra -= self.macSize;
            
            [Check outputLength:outBytes withOff:outOff withLen:extra withMsg:@"Output buffer too short"];
        }
        
        if (extra > 0) {
            [self gCTRPartial:[self bufBlock] withOff:0 withLen:extra withOutput:outBytes withOutOff:outOff];
        }
        
        self.atLength += (uint)(self.atBlockPos);
        
        if (self.atLength > self.atLengthPre) {
            /*
             *  Some AAD was sent after the cipher started. We determine the difference b/w the hash value
             *  we actually used when the cipher started (S_atPre) and the final hash value calculated (S_at).
             *  Then we carry this difference forward by multiplying by H^c, where c is the number of (full or
             *  partial) cipher-text blocks produced, and adjust the current hash.
             */
            
            // Finish hash for partial AAD block
            if (self.atBlockPos > 0) {
                [self gHASHPartial:[self s_at] withB:[self atBlock] withOff:0 withLen:self.atBlockPos];
            }
            
            // Find the difference between the AAD hashes
            if (self.atLengthPre > 0) {
                [GcmUtilities xorWithBytes:[self s_at] withY:[self s_atPre]];
            }
            
            // Number of cipher-text blocks produced
            int64_t c = (int64_t)(((self.totalLength * 8) + 127) >> 7);
            
            // Calculate the adjustment factor
            NSMutableData *H_c = [[NSMutableData alloc] initWithSize:16];
            if ([self exp] == nil) {
                Tables1kGcmExponentiator *tmpExp = [[Tables1kGcmExponentiator alloc] init];
                [self setExp:tmpExp];
#if !__has_feature(objc_arc)
                if (tmpExp != nil) [tmpExp release]; tmpExp = nil;
#endif
                [[self exp] init:[self h]];
            }
            [[self exp] exponentiateX:c withOutput:H_c];
            
            // Carry the difference forward
            [GcmUtilities multiplyWithBytes:[self s_at] withY:H_c];
            
            // Adjust the current hash
            [GcmUtilities xorWithBytes:[self s] withY:[self s_at]];
#if !__has_feature(objc_arc)
            if (H_c != nil) [H_c release]; H_c = nil;
#endif
        }
        
        // Final gHASH
        NSMutableData *X = [[NSMutableData alloc] initWithSize:BlockSize];
        [Pack UInt64_To_BE:(self.atLength * 8UL) withBs:X withOff:0];
        [Pack UInt64_To_BE:(self.totalLength * 8UL) withBs:X withOff:8];
        
        [self gHASHBlock:[self s] withB:X];
        
        // T = MSBt(GCTRk(J0,S))
        NSMutableData *tag = [[NSMutableData alloc] initWithSize:BlockSize];
        [[self cipher] processBlock:[self j0] withInOff:0 withOutBuf:tag withOutOff:0];
        [GcmUtilities xorWithBytes:tag withY:[self s]];
        
        resultLen = extra;
        
        // We place into macBlock our calculated value for T
        NSMutableData *tmpMacBlock = [[NSMutableData alloc] initWithSize:self.macSize];
        [self setMacBlock:tmpMacBlock];
        [[self macBlock] copyFromIndex:0 withSource:tag withSourceIndex:0 withLength:self.macSize];
#if !__has_feature(objc_arc)
        if (X != nil) [X release]; X = nil;
        if (tag != nil) [tag release]; tag = nil;
        if (tmpMacBlock != nil) [tmpMacBlock release]; tmpMacBlock = nil;
#endif
        
        if (self.forEncryption) {
            // Append T to the message
            [outBytes copyFromIndex:(outOff + self.bufOff) withSource:[self macBlock] withSourceIndex:0 withLength:self.macSize];
            resultLen += self.macSize;
        } else {
            // Retrieve the T value from the message and compare to calculated one
            NSMutableData *msgMac = [[NSMutableData alloc] initWithSize:self.macSize];
            [msgMac copyFromIndex:0 withSource:[self bufBlock] withSourceIndex:extra withLength:self.macSize];
            if (![Arrays constantTimeAreEqualWithByteArray:[self macBlock] withB:msgMac]) {
                @throw [NSException exceptionWithName:@"InvalidCipherText" reason:@"mac check in GCM failed" userInfo:nil];
            }
#if !__has_feature(objc_arc)
            if (msgMac != nil) [msgMac release]; msgMac = nil;
#endif
        }
        
        [self reset:NO];
    }
    
    return resultLen;
}

- (void)reset {
    [self reset:YES];
}

- (void)reset:(BOOL)clearMac {
    @autoreleasepool {
        [[self cipher] reset];
        
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setS:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setS_at:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setS_atPre:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        tmpData = [[NSMutableData alloc] initWithSize:BlockSize];
        [self setAtBlock:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        [self setAtBlockPos:0];
        [self setAtLength:0];
        [self setAtLengthPre:0];
        int dataLen = (int)([self j0].length);
        tmpData = [[NSMutableData alloc] initWithSize:dataLen];
        [self setCounter:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        [[self counter] copyFromIndex:0 withSource:[self j0] withSourceIndex:0 withLength:dataLen];
        [self setBufOff:0];
        [self setTotalLength:0];
        
        if ([self bufBlock] != nil) {
            [Arrays fillWithByteArray:[self bufBlock] withB:0];
        }
        
        if (clearMac) {
            [self setMacBlock:nil];
        }
        
        if ([self initialAssociatedText] != nil) {
            [self processAadBytes:[self initialAssociatedText] withInOff:0 withLen:(int)([self initialAssociatedText].length)];
        }
    }
}

- (void)gCTRBlock:(NSMutableData*)block withOutput:(NSMutableData*)output withOutOff:(int)outOff {
    @autoreleasepool {
        NSMutableData *tmp = [self getNextCounterBlock];
        
        [GcmUtilities xorWithBytes:tmp withY:block];
        [output copyFromIndex:outOff withSource:tmp withSourceIndex:0 withLength:BlockSize];
        
        [self gHASHBlock:[self s] withB:(self.forEncryption ? tmp : block)];
        
        self.totalLength += BlockSize;
    }
}

- (void)gCTRPartial:(NSMutableData*)buf withOff:(int)off withLen:(int)len withOutput:(NSMutableData*)output withOutOff:(int)outOff {
    @autoreleasepool {
        NSMutableData *tmp = [self getNextCounterBlock];
        
        [GcmUtilities xorWithBytes:tmp withY:buf withYoff:off withYlen:len];
        [output copyFromIndex:outOff withSource:tmp withSourceIndex:0 withLength:len];
        
        [self gHASHPartial:[self s] withB:(self.forEncryption ? tmp : buf) withOff:0 withLen:len];
        
        self.totalLength += (uint)len;
    }
}

- (void)gHASH:(NSMutableData*)Y withB:(NSMutableData*)b withLen:(int)len {
    @autoreleasepool {
        for (int pos = 0; pos < len; pos += BlockSize) {
            int num = MIN(len - pos, BlockSize);
            [self gHASHPartial:Y withB:b withOff:pos withLen:num];
        }        
    }
}

- (void)gHASHBlock:(NSMutableData*)Y withB:(NSMutableData*)b {
    @autoreleasepool {
        [GcmUtilities xorWithBytes:Y withY:b];
        [[self multiplier] multiplyH:Y];
    }
}

- (void)gHASHPartial:(NSMutableData*)Y withB:(NSMutableData*)b withOff:(int)off withLen:(int)len {
    [GcmUtilities xorWithBytes:Y withY:b withYoff:off withYlen:len];
    [[self multiplier] multiplyH:Y];
}

- (NSMutableData*)getNextCounterBlock {
    uint c = 1;
    c += ((Byte*)([self counter].bytes))[15]; ((Byte*)([self counter].bytes))[15] = (Byte)c; c >>= 8;
    c += ((Byte*)([self counter].bytes))[14]; ((Byte*)([self counter].bytes))[14] = (Byte)c; c >>= 8;
    c += ((Byte*)([self counter].bytes))[13]; ((Byte*)([self counter].bytes))[13] = (Byte)c; c >>= 8;
    c += ((Byte*)([self counter].bytes))[12]; ((Byte*)([self counter].bytes))[12] = (Byte)c;
    
    NSMutableData *tmp = [[[NSMutableData alloc] initWithSize:BlockSize] autorelease];
    // TODO Sure would be nice if ciphers could operate on int[]
    [[self cipher] processBlock:[self counter] withInOff:0 withOutBuf:tmp withOutOff:0];
    return tmp;
}

@end
