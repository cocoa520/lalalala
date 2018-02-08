//
//  UnsignedInteger.h
//  crypto
//
//  Created by JGehry on 7/5/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "BigInteger.h"

@interface UnsignedInteger : ASN1Object {
@private
    int _tagNo;
    BigInteger *_value;
}

+ (UnsignedInteger *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt paramBigInteger:(BigInteger *)paramBigInteger;
- (int)getTagNo;
- (BigInteger *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
