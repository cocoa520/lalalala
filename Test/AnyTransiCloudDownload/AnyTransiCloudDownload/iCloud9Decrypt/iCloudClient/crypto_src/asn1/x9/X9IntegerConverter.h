//
//  X9IntegerConverter.h
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ECCurve.h"

@interface X9IntegerConverter : ASN1Object

- (int)getByteLengthECCurve:(ECCurve *)paramECCurve;
- (int)getByteLengthParamECFieldElement:(ECFieldElement *)paramECFieldElement;
- (NSMutableData *)integerToBytes:(BigInteger *)paramBigInteger paramInt:(int)paramInt;

@end
