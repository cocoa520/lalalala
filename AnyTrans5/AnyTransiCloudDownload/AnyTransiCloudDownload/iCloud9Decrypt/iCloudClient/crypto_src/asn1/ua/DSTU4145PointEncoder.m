//
//  DSTU4145PointEncoder.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DSTU4145PointEncoder.h"
#import "ECCurve.h"
#import "BigInteger.h"

@implementation DSTU4145PointEncoder

+ (ECFieldElement *)trace:(ECFieldElement *)paramECFieldElement {
    ECFieldElement *localECFieldElement = paramECFieldElement;
    for (int i = 1; i < [paramECFieldElement fieldSize]; i++) {
        localECFieldElement = [[localECFieldElement square] add:paramECFieldElement];
    }
    return localECFieldElement;
}

+ (ECFieldElement *)solveQuadraticEquation:(ECCurve *)paramECCurve paramECFieldElement:(ECFieldElement *)paramECFieldElement {
    if ([paramECFieldElement isZero]) {
        return paramECFieldElement;
    }
    ECFieldElement *localECFieldElement1 = [paramECCurve fromBigInteger:[BigInteger Zero]];
    ECFieldElement *localECFieldElement2 = nil;
    ECFieldElement *localECFieldElement3 = nil;
    int localRandom = arc4random();
    int i = [paramECFieldElement fieldSize];
    do {
        BigInteger *big = [[BigInteger alloc] initWithBitLength:i withCertainty:localRandom];
        ECFieldElement *localECFieldElement4 = [paramECCurve fromBigInteger:big];
#if !__has_feature(objc_arc)
        if (big) [big release]; big = nil;
#endif
        localECFieldElement2 = localECFieldElement1;
        ECFieldElement *localECFieldElement5 = paramECFieldElement;
        for (int j = 1; j < i - 1; j++) {
            ECFieldElement *localECFieldElement6 = [localECFieldElement5 square];
            localECFieldElement2 = [[localECFieldElement2 square] add:[localECFieldElement6 multiply:localECFieldElement4]];
            localECFieldElement5 = [localECFieldElement6 add:paramECFieldElement];
        }
        if (![localECFieldElement5 isZero]) {
            return nil;
        }
        localECFieldElement3 = [[localECFieldElement2 square] add:localECFieldElement2];
    } while ([localECFieldElement3 isZero]);
    return localECFieldElement2;
}

+ (NSMutableData *)encodePoint:(ECPoint *)paramECPoint {
    paramECPoint = [paramECPoint normalize];
    ECFieldElement *localECFieldElement1 = [paramECPoint affineXCoord];
    NSMutableData *arrayOfByte = [localECFieldElement1 getEncoded];
    if (![localECFieldElement1 isOne]) {
        int tmp46_45 = (int)arrayOfByte.length - 1;
        NSMutableData *tmp46_41 = arrayOfByte;
        ((Byte *)[tmp46_41 bytes])[tmp46_45] = (((Byte *)[tmp46_41 bytes])[tmp46_45] | 0x1);
    }else {
        int tmp60_59 = (int)arrayOfByte.length - 1;
        NSMutableData *tmp60_55 = arrayOfByte;
        ((Byte *)[tmp60_55 bytes])[tmp60_59] = (((Byte *)[tmp60_55 bytes])[tmp60_59] | 0xFE);
    }
    return arrayOfByte;
}

+ (ECPoint *)decodePoint:(ECCurve *)paramECCurve paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    ECFieldElement *localECFieldElement1 = [paramECCurve fromBigInteger:[BigInteger valueOf:(((Byte *)[paramArrayOfByte bytes])[paramArrayOfByte.length - 1] | 0x1)]];
    BigInteger *big = [[BigInteger alloc] initWithSign:1 withBytes:paramArrayOfByte];
    ECFieldElement *localECFieldElement2 = [paramECCurve fromBigInteger:big];
#if !__has_feature(objc_arc)
    if (big) [big release]; big = nil;
#endif
    if (![[self trace:localECFieldElement2] isEqual:[paramECCurve a]]) {
        localECFieldElement2 = [localECFieldElement2 addOne];
    }
    ECFieldElement *localECFieldElement3 = nil;
    if ([localECFieldElement2 isZero]) {
        localECFieldElement3 = [[paramECCurve b] sqrt];
    }else {
        ECFieldElement *localECFieldElement4 = [[[[[localECFieldElement2 square] invert] multiply:[paramECCurve b]] add:[paramECCurve a]] add:localECFieldElement2];
        ECFieldElement *localECFieldElement5 = [self solveQuadraticEquation:paramECCurve paramECFieldElement:localECFieldElement4];
        if (localECFieldElement5) {
            if (![[self trace:localECFieldElement5] isEqual:localECFieldElement1]) {
                localECFieldElement5 = [localECFieldElement5 addOne];
            }
            localECFieldElement3 = [localECFieldElement2 multiply:localECFieldElement5];
        }
    }
    if (localECFieldElement3) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid point compression" userInfo:nil];
    }
    return [paramECCurve createPoint:[localECFieldElement2 toBigInteger] withY:[localECFieldElement3 toBigInteger]];
}

@end
