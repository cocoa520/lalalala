//
//  SRPCore.m
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import "SRPCore.h"
#import "BigInteger.h"
#import "BigIntegers.h"
#import "CategoryExtend.h"
#import "Digest.h"

@implementation SRPCore

+ (NSMutableData*)generateEphemeralKeyA:(BigInteger*)n withG:(BigInteger*)g withA:(BigInteger*)a {
    BigInteger *A = [g modPowWithE:a withM:n];
    int length = [SRPCore length:n];
    return [SRPCore padded:A withLength:length];
}

+ (BigInteger*)generatek:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g {
    int length = [SRPCore length:n];
    NSMutableData *hash = [SRPCore hashWithDigest:digest withBytes:[SRPCore padded:n withLength:length], [SRPCore padded:g withLength:length], nil];
    BigInteger *retVal = [[[BigInteger alloc] initWithSign:1 withBytes:hash] autorelease];
    return retVal;
}

+ (NSMutableData*)generateKey:(Digest*)digest withN:(BigInteger*)n withS:(BigInteger*)s {
    int length = [SRPCore length:n];
    return [SRPCore hash:digest withBytes:[SRPCore padded:s withLength:length]];
}

+ (NSMutableData*)generateM1:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g withEphemeralKeyA:(NSMutableData*)ephemeralKeyA withEphemeralKeyB:(NSMutableData*)ephemeralKeyB withKey:(NSMutableData*)key withSalt:(NSMutableData*)salt withIdentity:(NSMutableData*)identity {
    // M1 = H(H(N) XOR H(g) | H(I) | s | A | B | K)
    int length = [SRPCore length:n];
    // hI = H(I)
    NSMutableData *hI = [SRPCore hash:digest withBytes:identity];
    // tmp = H(N) XOR H(g)
    NSMutableData *hNxhG = [SRPCore xorWithBytes:[SRPCore hash:digest withBytes:[SRPCore padded:n withLength:length]] withX2:[SRPCore hash:digest withBytes:[SRPCore padded:g withLength:length]]];
    return [SRPCore hashWithDigest:digest withBytes:hNxhG, hI, salt, ephemeralKeyA, ephemeralKeyB, key, nil];
}

+ (NSMutableData*)xorWithBytes:(NSData*)x1 withX2:(NSData*)x2 {
    NSMutableData *outBytes = [[[NSMutableData alloc] initWithSize:(int)(x1.length)] autorelease];
    int end = (int)(x1.length) - 1;
    for (int i = end; i >= 0; i--) {
        ((Byte*)(outBytes.bytes))[i] = (Byte)(((Byte*)(x1.bytes))[i] ^ ((Byte*)(x2.bytes))[i]);
    }
    return outBytes;
}

+ (NSMutableData*)generateM2:(Digest*)digest withN:(BigInteger*)n withA:(NSMutableData*)a withM1:(NSMutableData*)m1 withK:(NSMutableData*)k {
    return [SRPCore hashWithDigest:digest withBytes:a, m1, k, nil];
}

+ (BigInteger*)generateS:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g withA:(BigInteger*)a withK:(BigInteger*)k withU:(BigInteger*)u withX:(BigInteger*)x withB:(BigInteger*)b {
    // S = (B - k*(g^x)) ^ (a + ux)
    BigInteger *exp = [[u multiplyWithVal:x] addWithValue:a];
    BigInteger *tmp = [[[g modPowWithE:x withM:n] multiplyWithVal:k] modWithM:n];
    return [[[b subtractWithN:tmp] modWithM:n] modPowWithE:exp withM:n];
}

+ (BigInteger*)generateu:(Digest*)digest withA:(NSMutableData*)a withB:(NSMutableData*)b {
    return [[[BigInteger alloc] initWithSign:1 withBytes:[SRPCore hashWithDigest:digest withBytes:a, b, nil]] autorelease];
}

+ (BigInteger*)generatex:(Digest*)digest withN:(BigInteger*)n withSalt:(NSMutableData*)salt withIdentity:(NSMutableData*)identity withPassword:(NSMutableData*)password {
    // x = SHA1(s | SHA1(I | ":" | P))
    NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:1];
    ((Byte*)(tmpData.bytes))[0] = (Byte)':';
    NSMutableData *tmp = [SRPCore hashWithDigest:digest withBytes:identity, tmpData, password, nil];
    NSMutableData *hash = [SRPCore hashWithDigest:digest withBytes:salt, tmp, nil];
    
    BigInteger *retVal = [[[BigInteger alloc] initWithSign:1 withBytes:hash] autorelease];
#if !__has_feature(objc_arc)
    if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
    return retVal;
}

+ (BOOL)isZero:(BigInteger*)n withI:(BigInteger*)i {
    return [[i modWithM:n] isEqual:[BigInteger Zero]];
}

+ (NSMutableData*)hash:(Digest*)digest withBytes:(NSMutableData*)bytes {
    return [SRPCore hashWithDigest:digest withBytes:bytes, nil];
}

+ (NSMutableData*)hashWithDigest:(Digest*)digest withBytes:(NSMutableData*)bytes,... {
    va_list argList;
    NSMutableData *arg = nil;
    if (bytes != nil) {
        va_start(argList, bytes);
        [digest blockUpdate:bytes withInOff:0 withLength:(int)(bytes.length)];
        while((arg = va_arg(argList, NSMutableData*))) {
            [digest blockUpdate:arg withInOff:0 withLength:(int)(arg.length)];
        }
        va_end(argList);
    }
    NSMutableData *output = [[[NSMutableData alloc] initWithSize:[digest getDigestSize]] autorelease];
    [digest doFinal:output withOutOff:0];
    return output;
}

+ (int)length:(BigInteger*)i {
    return ([i bitLength] + 7) / 8;
}

+ (NSMutableData*)padded:(BigInteger*)n withLength:(int)length {
    // org.bouncycastle.crypto.agreement.srp.SRP6Util#getPadded() with overflow check
    NSMutableData *byteArray = [BigIntegers asUnsignedByteArray:n];
    if (byteArray.length > length) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"BigInteger overflows specified length" userInfo:nil];
    }
    
    if (byteArray.length < length) {
        NSMutableData *tmp = [[[NSMutableData alloc] initWithSize:length] autorelease];
        [tmp copyFromIndex:(length- (int)(byteArray.length)) withSource:byteArray withSourceIndex:0 withLength:(int)(byteArray.length)];
        byteArray = tmp;
    }
    return byteArray;
}

@end
