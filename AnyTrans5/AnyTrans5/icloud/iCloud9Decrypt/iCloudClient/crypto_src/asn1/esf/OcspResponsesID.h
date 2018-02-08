//
//  OcspResponsesID.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "OcspIdentifier.h"
#import "OtherHash.h"

@interface OcspResponsesID : ASN1Object {
@private
    OcspIdentifier *_ocspIdentifier;
    OtherHash *_ocspRepHash;
}

+ (OcspResponsesID *)getInstance:(id)paramObject;
- (instancetype)initParamOcspIdentifier:(OcspIdentifier *)paramOcspIdentifier;
- (instancetype)initParamOcspIdentifier:(OcspIdentifier *)paramOcspIdentifier paramOtherHash:(OtherHash *)paramOtherHash;
- (OcspIdentifier *)getOcspIdentifier;
- (OtherHash *)getOcspRepHash;
- (ASN1Primitive *)toASN1Primitive;

@end
