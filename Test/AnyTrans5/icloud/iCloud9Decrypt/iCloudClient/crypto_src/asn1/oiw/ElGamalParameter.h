//
//  ElGamalParameter.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1Sequence.h"
#import "BigInteger.h"

@interface ElGamalParameter : ASN1Object {
    ASN1Integer *_p;
    ASN1Integer *_g;
}

@property (nonatomic, readwrite, retain) ASN1Integer *p;
@property (nonatomic, readwrite, retain) ASN1Integer *g;

+ (ElGamalParameter *)getInstance:(id)paramObject;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (BigInteger *)getP;
- (BigInteger *)getG;
- (ASN1Primitive *)toASN1Primitive;

@end
