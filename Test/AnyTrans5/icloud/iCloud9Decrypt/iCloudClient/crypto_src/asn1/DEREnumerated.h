//
//  DEREnumerated.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Enumerated.h"

@interface DEREnumerated : ASN1Enumerated

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamInt:(int)paramInt;

@end
