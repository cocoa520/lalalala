//
//  ECPointsCompact.m
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "ECPointsCompact.h"
#import "BigIntegers.h"
#import "BigInteger.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "ECFieldElement.h"
#import "ECAlgorithms.h"

@implementation ECPointsCompact

+ (BigInteger*)y:(ECCurve*)curve withX:(BigInteger*)x {
    BigInteger *y = nil;
    @try {
        // Andrey Jivsov https://www.ietf.org/archive/id/draft-jivsov-ecc-compact-05.txt.
        ECFieldElement *X = [curve fromBigInteger:x];
        ECFieldElement *rhs = [[[[X square] add:[curve a]] multiply:X] add:[curve b]];
        
        // y' = sqrt( C(x) ), where y'>0
        ECFieldElement *yTilde = [rhs sqrt];
        
        if (yTilde == nil) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"invalid point compression" userInfo:nil];
        }
        
        // y = min(y',p-y')
        BigInteger *yT = [yTilde toBigInteger];
        BigInteger *yTn = [[yTilde negate] toBigInteger];
        y = [yT compareTo:yTn] == -1 ? yT : yTn;
    }
    @catch (NSException *exception) {
    }
    return y;
}

+ (ECPoint*)decodeFPPoint:(ECCurve*)curve withData:(NSMutableData*)data {
    // Patched org.bouncycastle.math.ec.ECCurve#decodePoint code.
    int expectedLength = ([curve fieldSize] + 7) / 8;
    if (expectedLength != data.length) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"incorrect data length for compact encoding" userInfo:nil];
    }
    
    ECPoint *p = nil;
    @autoreleasepool {
        BigInteger *X = [BigIntegers fromData:data withOff:0 withLength:expectedLength];
        p = [[ECPointsCompact decompressFPPoint:curve withX:X] retain];
    }
    
    if (![ECPointsCompact satisfiesCofactor:curve withPoint:p]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"invalid point" userInfo:nil];
    }
    
    return [p autorelease];
}

+ (ECPoint*)decompressFPPoint:(ECCurve*)curve withX:(BigInteger*)x {
    // See Andrey Jivsov https://www.ietf.org/archive/id/draft-jivsov-ecc-compact-05.txt.
    ECPoint *Q = nil;
    @autoreleasepool {
        @try {
            ECFieldElement *X = [curve fromBigInteger:x];
            ECFieldElement *rhs = [[[[X square] add:[curve a]] multiply:X] add:[curve b]];
            
            // y' = sqrt( C(x) ), where y'>0
            ECFieldElement *yTilde = [rhs sqrt];
            
            if (yTilde == nil) {
                @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"invalid point compression" userInfo:nil];
            }
            
            // y = min(y',p-y')
            BigInteger *yT = [yTilde toBigInteger];
            BigInteger *yTn = [[yTilde negate] toBigInteger];
            BigInteger *y = [yT compareTo:yTn] == -1 ? yT : yTn;
            
            // Q=(x,y) is the canonical representation of the point
            Q = [[curve createPoint:x withY:y] retain];
        }
        @catch (NSException *exception) {
        }
    }
    return [Q autorelease];
}

+ (BOOL)satisfiesCofactor:(ECCurve*)curve withPoint:(ECPoint*)point {
    // Patched org.bouncycastle.math.ec.ECPoint#satisfiesCofactor protected code.
    BigInteger *h = [curve cofactor];
    return h == nil || [h isEqual:[BigInteger One]] || ![[ECAlgorithms referenceMultiply:point withK:h] isInfinity];
}

@end
