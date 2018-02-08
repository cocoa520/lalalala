//
//  HKDFBytesGenerator.m
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "HKDFBytesGenerator.h"
#import "CategoryExtend.h"
#import "HMac.h"
#import "Digest.h"
#import "HKDFParameters.h"
#import "KeyParameter.h"

@interface HKDFBytesGenerator ()

@property (nonatomic, readwrite, retain) HMac *hMacHash;
@property (nonatomic, readwrite, assign) int hashLen;
@property (nonatomic, readwrite, retain) NSMutableData *info;
@property (nonatomic, readwrite, retain) NSMutableData *currentT;
@property (nonatomic, readwrite, assign) int generatedBytes;

@end

@implementation HKDFBytesGenerator
@synthesize hMacHash = _hMacHash;
@synthesize hashLen = _hashLen;
@synthesize info = _info;
@synthesize currentT = _currentT;
@synthesize generatedBytes = _generatedBytes;

/**
 * Creates a HKDFBytesGenerator based on the given hash function.
 *
 * @param hash the digest to be used as the source of generatedBytes bytes
 */
- (id)initWithDigest:(Digest*)hash {
    if (self = [super init]) {
        HMac *tmpHMac = [[HMac alloc] initWithDigest:hash];
        [self setHMacHash:tmpHMac];
#if !__has_feature(objc_arc)
        if (tmpHMac != nil) [tmpHMac release]; tmpHMac = nil;
#endif
        [self setHashLen:[hash getDigestSize]];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setHMacHash:nil];
    [self setInfo:nil];
    [self setCurrentT:nil];
    [super dealloc];
#endif
}

- (void)init:(HKDFParameters*)param {
    if (!(param != nil && [param isKindOfClass:[HKDFParameters class]])) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"HKDF parameters required for HKDFBytesGenerator" userInfo:nil];
    }
    
    @autoreleasepool {
        if ([param skipExtract]) {
            // use IKM directly as PRK
            KeyParameter *tmpKP = [[KeyParameter alloc] initWithKey:[param getIKM]];
            [[self hMacHash] init:tmpKP];
#if !__has_feature(objc_arc)
            if (tmpKP != nil) [tmpKP release]; tmpKP = nil;
#endif
        } else {
            [[self hMacHash] init:[self extract:[param getSalt] withIKM:[param getIKM]]];
        }
        
        [self setInfo:[param getInfo]];
        self.generatedBytes = 0;
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:self.hashLen];
        [self setCurrentT:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
    }
}

/**
 * Performs the extract part of the key derivation function.
 *
 * @param salt the salt to use
 * @param ikm  the input keying material
 * @return the PRK as KeyParameter
 */
- (KeyParameter*)extract:(NSMutableData*)salt withIKM:(NSMutableData*)ikm {
    KeyParameter *retVal = nil;
    @autoreleasepool {
        KeyParameter *tmpKP = [[KeyParameter alloc] initWithKey:ikm];
        [[self hMacHash] init:tmpKP];
#if !__has_feature(objc_arc)
        if (tmpKP != nil) [tmpKP release]; tmpKP = nil;
#endif
        if (salt == nil) {
            // TODO check if hashLen is indeed same as HMAC size
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:self.hashLen];
            tmpKP = [[KeyParameter alloc] initWithKey:tmpData];
            [[self hMacHash] init:tmpKP];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
            if (tmpKP != nil) [tmpKP release]; tmpKP = nil;
#endif
        } else {
            tmpKP = [[KeyParameter alloc] initWithKey:salt];
            [[self hMacHash] init:tmpKP];
#if !__has_feature(objc_arc)
            if (tmpKP != nil) [tmpKP release]; tmpKP = nil;
#endif
        }
        [[self hMacHash] blockUpdate:ikm withInOff:0 withLen:(int)(ikm.length)];
        NSMutableData *prk = [[NSMutableData alloc] initWithSize:self.hashLen];
        [[self hMacHash] doFinal:prk withOutOff:0];
        retVal = [[KeyParameter alloc] initWithKey:prk];
#if !__has_feature(objc_arc)
        if (prk != nil) [prk release]; prk = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * Performs the expand part of the key derivation function, using currentT
 * as input and output buffer.
 *
 * @throws DataLengthException if the total number of bytes generated is larger than the one
 * specified by RFC 5869 (255 * HashLen)
 */
- (void)expandNext {
    int n = self.generatedBytes / self.hashLen + 1;
    if (n >= 256) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"HKDF cannot generate more than 255 blocks of HashLen size" userInfo:nil];
    }
    @autoreleasepool {
        // special case for T(0): T(0) is empty, so no update
        if (self.generatedBytes != 0) {
            [[self hMacHash] blockUpdate:[self currentT] withInOff:0 withLen:self.hashLen];
        }
        [[self hMacHash] blockUpdate:[self info] withInOff:0 withLen:(int)([self info].length)];
        [[self hMacHash] update:((Byte)n)];
        [[self hMacHash] doFinal:[self currentT] withOutOff:0];
    }
}

- (Digest*)getDigest {
    return [[self hMacHash] getUnderlyingDigest];
}

- (int)generateBytes:(NSMutableData*)outBuf withOutOff:(int)outOff withLen:(int)len {
    if (self.generatedBytes + len > 255 * self.hashLen) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"HKDF may only be used for 255 * HashLen bytes of output" userInfo:nil];
    }
    
    @autoreleasepool {
        if (self.generatedBytes % self.hashLen == 0) {
            [self expandNext];
        }
        
        // copy what is left in the currentT (1..hash
        int toGenerate = len;
        int posInT = self.generatedBytes % self.hashLen;
        int leftInT = self.hashLen - self.generatedBytes % self.hashLen;
        int toCopy = MIN(leftInT, toGenerate);
        [outBuf copyFromIndex:outOff withSource:[self currentT] withSourceIndex:posInT withLength:toCopy];
        self.generatedBytes += toCopy;
        toGenerate -= toCopy;
        outOff += toCopy;
        
        while (toGenerate > 0) {
            [self expandNext];
            toCopy = MIN(self.hashLen, toGenerate);
            [outBuf copyFromIndex:outOff withSource:[self currentT] withSourceIndex:0 withLength:toCopy];
            self.generatedBytes += toCopy;
            toGenerate -= toCopy;
            outOff += toCopy;
        }
    }
    return len;
}

@end
