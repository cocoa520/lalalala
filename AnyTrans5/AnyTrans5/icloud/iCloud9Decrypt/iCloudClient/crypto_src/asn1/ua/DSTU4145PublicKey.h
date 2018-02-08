//
//  DSTU4145PublicKey.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "ECPoint.h"

@interface DSTU4145PublicKey : ASN1Object {
@private
    ASN1OctetString *_pubKey;
}

+ (DSTU4145PublicKey *)getInstance:(id)paramObject;
- (instancetype)initParamECPoint:(ECPoint *)paramECPoint;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1Primitive *)toASN1Primitive;

@end
