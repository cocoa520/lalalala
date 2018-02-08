//
//  DERGeneralizedTime.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1GeneralizedTime.h"

@interface DERGeneralizedTime : ASN1GeneralizedTime

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamDate:(NSDate *)paramDate;
- (instancetype)initParamString:(NSString *)paramString;

@end
