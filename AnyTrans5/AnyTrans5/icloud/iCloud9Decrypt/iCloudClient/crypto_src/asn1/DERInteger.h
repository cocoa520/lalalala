//
//  DERInteger.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Integer.h"

@interface DERInteger : ASN1Integer

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamLong:(long)paramLong;

@end
