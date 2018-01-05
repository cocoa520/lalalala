//
//  ECGOST3410ParamSetParameters.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1Sequence.h"

@interface ECGOST3410ParamSetParameters : ASN1Object {
    ASN1Integer *_p;
    ASN1Integer *_q;
    ASN1Integer *_a;
    ASN1Integer *_b;
    ASN1Integer *_x;
    ASN1Integer *_y;
}

@property (nonatomic, readwrite, retain) ASN1Integer *p;
@property (nonatomic, readwrite, retain) ASN1Integer *q;
@property (nonatomic, readwrite, retain) ASN1Integer *a;
@property (nonatomic, readwrite, retain) ASN1Integer *b;
@property (nonatomic, readwrite, retain) ASN1Integer *x;
@property (nonatomic, readwrite, retain) ASN1Integer *y;

+ (ECGOST3410ParamSetParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (ECGOST3410ParamSetParameters *)getInstance:(id)paramObject;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramBigInteger4:(BigInteger *)paramBigInteger4 paramInt:(int)paramInt paramBigInteger5:(BigInteger *)paramBigInteger5;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (BigInteger *)getP;
- (BigInteger *)getQ;
- (BigInteger *)getA;
- (ASN1Primitive *)toASN1Primitive;

@end
