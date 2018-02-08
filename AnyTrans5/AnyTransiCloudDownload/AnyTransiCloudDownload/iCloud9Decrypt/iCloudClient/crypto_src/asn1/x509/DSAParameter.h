//
//  DSAParameter.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1TaggedObject.h"

@interface DSAParameter : ASN1Object {
    ASN1Integer *_p;
    ASN1Integer *_q;
    ASN1Integer *_g;
}

@property (nonatomic, readwrite, retain) ASN1Integer *p;
@property (nonatomic, readwrite, retain) ASN1Integer *q;
@property (nonatomic, readwrite, retain) ASN1Integer *g;

+ (DSAParameter *)getInstance:(id)paramObject;
+ (DSAParameter *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3;
- (BigInteger *)getP;
- (BigInteger *)getQ;
- (BigInteger *)getG;
- (ASN1Primitive *)toASN1Primitive;

@end
