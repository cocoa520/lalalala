//
//  CertBag.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"

@interface CertBag : ASN1Object {
@private
    ASN1ObjectIdentifier *_certId;
    ASN1Encodable *_certValue;
}

+ (CertBag *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getCertId;
- (ASN1Encodable *)getCertValue;
- (ASN1Primitive *)toASN1Primitive;

@end
