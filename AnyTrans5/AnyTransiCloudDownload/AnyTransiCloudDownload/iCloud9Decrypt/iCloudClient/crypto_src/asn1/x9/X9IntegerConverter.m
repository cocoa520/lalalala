//
//  X9IntegerConverter.m
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9IntegerConverter.h"
#import "ECFieldElement.h"
#import "BigInteger.h"
#import "CategoryExtend.h"

@implementation X9IntegerConverter

- (int)getByteLengthECCurve:(ECCurve *)paramECCurve {
    return ([paramECCurve fieldSize] + 7) / 8;
}

- (int)getByteLengthParamECFieldElement:(ECFieldElement *)paramECFieldElement {
    return ([paramECFieldElement fieldSize] + 7) / 8;
}

- (NSMutableData *)integerToBytes:(BigInteger *)paramBigInteger paramInt:(int)paramInt {
    NSMutableData *arrayOfByte1 = [paramBigInteger toByteArray];
    NSMutableData *arrayOfByte2 = nil;
    if (paramInt < arrayOfByte1.length) {
        arrayOfByte2 = [[[NSMutableData alloc] initWithSize:paramInt] autorelease];
        [arrayOfByte2 copyFromIndex:0 withSource:arrayOfByte1 withSourceIndex:(int)(arrayOfByte1.length - arrayOfByte2.length) withLength:(int)[arrayOfByte2 length]];
        return arrayOfByte2;
    }
    if (paramInt > arrayOfByte1.length) {
        arrayOfByte2 = [[[NSMutableData alloc] initWithSize:paramInt] autorelease];
        [arrayOfByte2 copyFromIndex:(int)(arrayOfByte2.length - arrayOfByte1.length) withSource:arrayOfByte1 withSourceIndex:0 withLength:(int)[arrayOfByte1 length]];
        return arrayOfByte2;
    }
    return arrayOfByte1;
}

@end
