//
//  DomainParameters.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ValidationParams.h"

@interface DomainParameters : ASN1Object {
@private
    ASN1Integer *_p;
    ASN1Integer *_g;
    ASN1Integer *_q;
    ASN1Integer *_j;
    ValidationParams *_validationParams;
}

+ (DomainParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (DomainParameters *)getInstance:(id)paramObject;
- (instancetype)initParamBitInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramBigInteger4:(BigInteger *)paramBigInteger4 paramValidationParams:(ValidationParams *)paramValidationParams;
- (BigInteger *)getP;
- (BigInteger *)getG;
- (BigInteger *)getQ;
- (BigInteger *)getJ;
- (ValidationParams *)getValidationParams;
- (ASN1Primitive *)toASN1Primitive;

@end
