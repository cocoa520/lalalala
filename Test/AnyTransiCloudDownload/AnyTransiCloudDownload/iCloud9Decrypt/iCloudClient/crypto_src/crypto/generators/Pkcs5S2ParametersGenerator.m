//
//  Pkcs5S2ParametersGenerator.m
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "Pkcs5S2ParametersGenerator.h"
#import "Sha1Digest.h"
#import "HMac.h"
#import "KeyParameter.h"
#import "ParametersWithIV.h"
#import "CategoryExtend.h"
#import "ParameterUtilities.h"

@interface Pkcs5S2ParametersGenerator ()

@property (nonatomic, readwrite, retain) Mac *hMac;
@property (nonatomic, readwrite, retain) NSMutableData *state;

@end

@implementation Pkcs5S2ParametersGenerator
@synthesize hMac = _hMac;
@synthesize state = _state;

/**
 * construct a Pkcs5 Scheme 2 Parameters generator.
 */
- (id)init {
    Sha1Digest *tmpSha1 = [[Sha1Digest alloc] init];
    if (self = [self initWithDigest:tmpSha1]) {
#if !__has_feature(objc_arc)
        if (tmpSha1 != nil) [tmpSha1 release]; tmpSha1 = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (tmpSha1 != nil) [tmpSha1 release]; tmpSha1 = nil;
#endif
        return nil;
    }
}

- (id)initWithDigest:(Digest*)digest {
    if (self = [super init]) {
        HMac *tmpMac = [[HMac alloc] initWithDigest:digest];
        [self setHMac:tmpMac];
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:[[self hMac] getMacSize]];
        [self setState:tmpData];
#if !__has_feature(objc_arc)
        if (tmpMac != nil) [tmpMac release]; tmpMac = nil;
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setHMac:nil];
    [self setState:nil];
    [super dealloc];
#endif
}

- (void)f:(NSMutableData*)s withC:(int)c withiBuf:(NSMutableData*)iBuf withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    if (c == 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"iteration count must be at least 1." userInfo:nil];
    }
    
    if (s != nil) {
        [[self hMac] blockUpdate:s withInOff:0 withLen:(int)(s.length)];
    }
    
    [[self hMac] blockUpdate:iBuf withInOff:0 withLen:(int)(iBuf.length)];
    [[self hMac] doFinal:[self state] withOutOff:0];
    
    [outBytes copyFromIndex:outOff withSource:[self state] withSourceIndex:0 withLength:(int)([self state].length)];
    
    for (int count = 1; count < c; ++count) {
        [[self hMac] blockUpdate:[self state] withInOff:0 withLen:(int)([self state].length)];
        [[self hMac] doFinal:[self state] withOutOff:0];
        
        for (int j = 0; j < (int)([self state].length); ++j) {
            ((Byte*)(outBytes.bytes))[outOff + j] = ((Byte*)(outBytes.bytes))[outOff + j] ^ ((Byte*)([self state].bytes))[j];
        }
    }
}

- (NSMutableData*)generateDerivedKey:(int)dkLen {
    NSMutableData *outBytes = nil;
    @autoreleasepool {
        int hLen = [[self hMac] getMacSize];
        int l = (dkLen + hLen - 1) / hLen;
        NSMutableData *iBuf = [[NSMutableData alloc] initWithSize:4];
        outBytes = [[NSMutableData alloc] initWithSize:(l * hLen)];
        int outPos = 0;
        
        CipherParameters *param = [[KeyParameter alloc] initWithKey:[self mPassword]];
        
        [[self hMac] init:param];
        
        for (int i = 1; i <= l; i++) {
            // Increment the value in 'iBuf'
            int pos = 3;
            while (++(((Byte*)(iBuf.bytes))[pos]) == 0) {
                --pos;
            }
            
            [self f:[self mSalt] withC:self.mIterationCount withiBuf:iBuf withOutBytes:outBytes withOutOff:outPos];
            outPos += hLen;
        }
        
#if !__has_feature(objc_arc)
        if (iBuf != nil) [iBuf release]; iBuf = nil;
        if (param != nil) [param release]; param = nil;
#endif
    }
    return (outBytes ? [outBytes autorelease] : nil);
}

/**
 * Generate a key parameter derived from the password, salt, and iteration
 * count we are currently initialised with.
 *
 * @param keySize the size of the key we want (in bits)
 * @return a KeyParameter object.
 */
- (CipherParameters *)generateDerivedParameters:(int)keySize {
    return [self generateDerivedMacParameters:keySize];
}

- (CipherParameters*)generateDerivedParameters:(NSString*)algorithm withKeySize:(int)keySize {
    keySize /= 8;
    
    NSMutableData *dKey = [self generateDerivedKey:keySize];
    
    return [ParameterUtilities createKeyParameterWithAlgorithm:algorithm withKeyBytes:dKey withOffset:0 withLength:keySize];
}

/**
 * Generate a key with initialisation vector parameter derived from
 * the password, salt, and iteration count we are currently initialised
 * with.
 *
 * @param keySize the size of the key we want (in bits)
 * @param ivSize the size of the iv we want (in bits)
 * @return a ParametersWithIV object.
 */
- (CipherParameters*)generateDerivedParameters:(int)keySize withIvSize:(int)ivSize {
    keySize /= 8;
    ivSize /= 8;
    
    NSMutableData *dKey = [self generateDerivedKey:(keySize + ivSize)];
    
    KeyParameter *tmpKP = [[KeyParameter alloc] initWithKey:dKey withKeyOff:0 withKeyLen:keySize];
    ParametersWithIV *retVal = [[[ParametersWithIV alloc] initWithParameters:tmpKP withIv:dKey withIvOff:keySize withIvLen:ivSize] autorelease];
#if !__has_feature(objc_arc)
    if (tmpKP != nil) [tmpKP release]; tmpKP = nil;
#endif
    return retVal;
}

- (CipherParameters*)generateDerivedParameters:(NSString*)algorithm withKeySize:(int)keySize withIvSize:(int)ivSize {
    keySize /= 8;
    ivSize /= 8;
    
    NSMutableData *dKey = [self generateDerivedKey:(keySize + ivSize)];
    KeyParameter *key = [ParameterUtilities createKeyParameterWithAlgorithm:algorithm withKeyBytes:dKey withOffset:0 withLength:keySize];
    
    return [[[ParametersWithIV alloc] initWithParameters:key withIv:dKey withIvOff:keySize withIvLen:ivSize] autorelease];
}

/**
 * Generate a key parameter for use with a MAC derived from the password,
 * salt, and iteration count we are currently initialised with.
 *
 * @param keySize the size of the key we want (in bits)
 * @return a KeyParameter object.
 */
- (CipherParameters*)generateDerivedMacParameters:(int)keySize {
    keySize /= 8;
    
    NSMutableData *dKey = [self generateDerivedKey:keySize];
    
    return [[[KeyParameter alloc] initWithKey:dKey withKeyOff:0 withKeyLen:keySize] autorelease];
}

@end
