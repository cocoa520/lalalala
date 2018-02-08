//
//  SRP6Utilities.m
//  
//
//  Created by iMobie on 8/3/16.
//
//  Complete

#import "SRP6Utilities.h"
#import "BigInteger.h"
#import "BigIntegers.h"
#import "CategoryExtend.h"
#import "Digest.h"
#import "SecureRandom.h"

@implementation SRP6Utilities

+ (BigInteger*)calculateK:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g {
    return [SRP6Utilities hashPaddedPair:digest withN:n withN1:n withN2:g];
}

+ (BigInteger*)calculateU:(Digest*)digest withN:(BigInteger*)n withA:(BigInteger*)a withB:(BigInteger*)b {
    return [SRP6Utilities hashPaddedPair:digest withN:n withN1:a withN2:b];
}

+ (BigInteger*)calculateX:(Digest*)digest withN:(BigInteger*)n withSalt:(NSMutableData*)salt withIdentity:(NSMutableData*)identity withPassword:(NSMutableData*)password {
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSMutableData *output = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
        
        [digest blockUpdate:identity withInOff:0 withLength:(int)(identity.length)];
        [digest update:(Byte)':'];
        [digest blockUpdate:password withInOff:0 withLength:(int)(password.length)];
        [digest doFinal:output withOutOff:0];
        
        [digest blockUpdate:salt withInOff:0 withLength:(int)(salt.length)];
        [digest blockUpdate:output withInOff:0 withLength:(int)(output.length)];
        [digest doFinal:output withOutOff:0];
        
        retVal = [[BigInteger alloc] initWithSign:1 withBytes:output];
#if !__has_feature(objc_arc)
        if (output != nil) [output release]; output = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (BigInteger*)generatePrivateValue:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g withRandom:(SecureRandom*)random {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        int minBits = MIN(256, ((int)[n bitLength] / 2));
        BigInteger *min = [[BigInteger One] shiftLeftWithN:(minBits - 1)];
        BigInteger *max = [n subtractWithN:[BigInteger One]];
        bigInt = [BigIntegers createRandomInRange:min withMax:max];
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

+ (BigInteger*)validatePublicValue:(BigInteger*)n withVal:(BigInteger*)val {
    val = [val modWithM:n];
    
    // Check that val % N != 0
    if ([val isEqual:[BigInteger Zero]]) {
        @throw [NSException exceptionWithName:@"Crypto" reason:@"Invalid public value: 0" userInfo:nil];
    }
    
    return val;
}

/**
 * Computes the client evidence message (M1) according to the standard routine:
 * M1 = H( A | B | S )
 * @param digest The Digest used as the hashing function H
 * @param N Modulus used to get the pad length
 * @param A The public client value
 * @param B The public server value
 * @param S The secret calculated by both sides
 * @return M1 The calculated client evidence message
 */
+ (BigInteger*)calculateM1:(Digest*)digest withN:(BigInteger*)n withA:(BigInteger*)a withB:(BigInteger*)b withS:(BigInteger*)s {
    BigInteger *m1 = [SRP6Utilities hashPaddedTriplet:digest withN:n withN1:a withN2:b withN3:s];
    return m1;
}

/**
 * Computes the server evidence message (M2) according to the standard routine:
 * M2 = H( A | M1 | S )
 * @param digest The Digest used as the hashing function H
 * @param N Modulus used to get the pad length
 * @param A The public client value
 * @param M1 The client evidence message
 * @param S The secret calculated by both sides
 * @return M2 The calculated server evidence message
 */
+ (BigInteger*)calculateM2:(Digest*)digest withN:(BigInteger*)n withA:(BigInteger*)a withM1:(BigInteger*)m1 withS:(BigInteger*)s {
    BigInteger *m2 = [SRP6Utilities hashPaddedTriplet:digest withN:n withN1:a withN2:m1 withN3:s];
    return m2;
}

/**
 * Computes the final Key according to the standard routine: Key = H(S)
 * @param digest The Digest used as the hashing function H
 * @param N Modulus used to get the pad length
 * @param S The secret calculated by both sides
 * @return
 */
+ (BigInteger*)calculateKey:(Digest*)digest withN:(BigInteger*)n withS:(BigInteger*)s {
    BigInteger *retVal = nil;
    @autoreleasepool {
        int padLength = ([n bitLength] + 7) / 8;
        NSMutableData *_S = [SRP6Utilities getPadded:s withLength:padLength];
        [digest blockUpdate:_S withInOff:0 withLength:(int)(_S.length)];
        
        NSMutableData *output = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
        [digest doFinal:output withOutOff:0];
        retVal = [[BigInteger alloc] initWithSign:1 withBytes:output];
#if !__has_feature(objc_arc)
        if (output != nil) [output release]; output = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (BigInteger*)hashPaddedTriplet:(Digest*)digest withN:(BigInteger*)n withN1:(BigInteger*)n1 withN2:(BigInteger*)n2 withN3:(BigInteger*)n3 {
    BigInteger *retVal = nil;
    @autoreleasepool {
        int padLength = ([n bitLength] + 7) / 8;
        
        NSMutableData *n1_bytes = [SRP6Utilities getPadded:n1 withLength:padLength];
        NSMutableData *n2_bytes = [SRP6Utilities getPadded:n2 withLength:padLength];
        NSMutableData *n3_bytes = [SRP6Utilities getPadded:n3 withLength:padLength];
        
        [digest blockUpdate:n1_bytes withInOff:0 withLength:(int)(n1_bytes.length)];
        [digest blockUpdate:n2_bytes withInOff:0 withLength:(int)(n2_bytes.length)];
        [digest blockUpdate:n3_bytes withInOff:0 withLength:(int)(n3_bytes.length)];
        
        NSMutableData *output = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
        [digest doFinal:output withOutOff:0];
        retVal = [[BigInteger alloc] initWithSign:1 withBytes:output];
#if !__has_feature(objc_arc)
        if (output != nil) [output release]; output = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (BigInteger*)hashPaddedPair:(Digest*)digest withN:(BigInteger*)n withN1:(BigInteger*)n1 withN2:(BigInteger*)n2 {
    BigInteger *retVal = nil;
    @autoreleasepool {
        int padLength = ([n bitLength] + 7) / 8;
        
        NSMutableData *n1_bytes = [SRP6Utilities getPadded:n1 withLength:padLength];
        NSMutableData *n2_bytes = [SRP6Utilities getPadded:n2 withLength:padLength];
        
        [digest blockUpdate:n1_bytes withInOff:0 withLength:(int)(n1_bytes.length)];
        [digest blockUpdate:n2_bytes withInOff:0 withLength:(int)(n2_bytes.length)];
        
        NSMutableData *output = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
        [digest doFinal:output withOutOff:0];
        retVal = [[BigInteger alloc] initWithSign:1 withBytes:output];
#if !__has_feature(objc_arc)
        if (output != nil) [output release]; output = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (NSMutableData*)getPadded:(BigInteger*)n withLength:(int)length {
    NSMutableData *bs = [BigIntegers asUnsignedByteArray:n];
    if (bs.length < length) {
        NSMutableData *tmp = [[[NSMutableData alloc] initWithSize:length] autorelease];
        [tmp copyFromIndex:(length - ((int)bs.length)) withSource:bs withSourceIndex:0 withLength:(int)(bs.length)];
        bs = tmp;
    }
    return bs;
}

@end
