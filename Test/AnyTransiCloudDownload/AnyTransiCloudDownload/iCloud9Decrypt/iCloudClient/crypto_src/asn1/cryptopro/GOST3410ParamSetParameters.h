//
//  GOST3410ParamSetParameters.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1Sequence.h"
#import "BigInteger.h"

@interface GOST3410ParamSetParameters : ASN1Object {
    int _keySize;
    ASN1Integer *_p;
    ASN1Integer *_q;
    ASN1Integer *_a;
}

@property (nonatomic, assign) int keySize;
@property (nonatomic, readwrite, retain) ASN1Integer *p;
@property (nonatomic, readwrite, retain) ASN1Integer *q;
@property (nonatomic, readwrite, retain) ASN1Integer *a;

+ (GOST3410ParamSetParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (GOST3410ParamSetParameters *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt paramBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (int)getLKeySize;
- (int)getKeySize;
- (BigInteger *)getP;
- (BigInteger *)getQ;
- (BigInteger *)getA;
- (ASN1Primitive *)toASN1Primitive;

@end
