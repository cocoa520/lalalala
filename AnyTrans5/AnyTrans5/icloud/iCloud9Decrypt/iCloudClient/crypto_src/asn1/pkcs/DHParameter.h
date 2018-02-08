//
//  DHParameter.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"

@interface DHParameter : ASN1Object {
    ASN1Integer *_p;
    ASN1Integer *_g;
    ASN1Integer *_l;
}

@property (nonatomic, readwrite, retain) ASN1Integer *p;
@property (nonatomic, readwrite, retain) ASN1Integer *g;
@property (nonatomic, readwrite, retain) ASN1Integer *l;

+ (DHParameter *)getInstance:(id)paramObject;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramInt:(int)paramInt;
- (BigInteger *)getP;
- (BigInteger *)getG;
- (BigInteger *)getL;
- (ASN1Primitive *)toASN1Primitive;

@end
