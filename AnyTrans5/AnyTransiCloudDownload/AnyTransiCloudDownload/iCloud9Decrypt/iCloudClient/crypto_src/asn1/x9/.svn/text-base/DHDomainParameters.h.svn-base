//
//  DHDomainParameters.h
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "DHValidationParms.h"

@interface DHDomainParameters : ASN1Object {
@private
    ASN1Integer *_p;
    ASN1Integer *_g;
    ASN1Integer *_q;
    ASN1Integer *_j;
    DHValidationParms *_validationParms;
}

+ (DHDomainParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (DHDomainParameters *)getInstance:(id)paramObject;
+ (ASN1Encodable *)getNext:(NSEnumerator *)paramEnumeration;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramBigInteger4:(BigInteger *)paramBigInteger4 paramDHValidationParms:(DHValidationParms *)paramDHValidationParms;
- (instancetype)initParamASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2 paramASN1Integer3:(ASN1Integer *)paramASN1Integer3 paramASN1Integer4:(ASN1Integer *)paramASN1Integer4 paramDHValidationParms:(DHValidationParms *)paramDHValidationParms;

@end
