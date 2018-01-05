//
//  DHValidationParms.h
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DERBitString.h"
#import "ASN1Integer.h"

@interface DHValidationParms : ASN1Object {
@private
    DERBitString *_seed;
    ASN1Integer *_pgenCounter;
}

+ (DHValidationParms *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (DHValidationParms *)getInstance:(id)paramObject;
- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString paramASN1Integer:(ASN1Integer *)paramASN1Integer;
- (DERBitString *)getSeed;
- (ASN1Integer *)getPgenCounter;
- (ASN1Primitive *)toASN1Primitive;

@end
