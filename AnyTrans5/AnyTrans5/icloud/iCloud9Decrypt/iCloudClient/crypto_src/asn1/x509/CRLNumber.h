//
//  CRLNumber.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "BigInteger.h"

@interface CRLNumber : ASN1Object {
@private
    BigInteger *_number;
}

+ (CRLNumber *)getInstance:(id)paramObject;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger;
- (BigInteger *)getCRLNumber;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
