//
//  CrlValidatedID.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "OtherHash.h"
#import "CrlIdentifier.h"

@interface CrlValidatedID : ASN1Object {
@private
    OtherHash *_crlHash;
    CrlIdentifier *_crlIdentifier;
}

+ (CrlValidatedID *)getInstance:(id)paramObject;
- (instancetype)initParamOtherHash:(OtherHash *)paramOtherHash;
- (instancetype)initParamOtherHash:(OtherHash *)paramOtherHash paramCrlIdentifier:(CrlIdentifier *)paramCrlIdentifier;
- (OtherHash *)getCrlHash;
- (CrlIdentifier *)getCrlIdentifier;
- (ASN1Primitive *)toASN1Primitive;

@end
