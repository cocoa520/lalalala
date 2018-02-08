//
//  PKMACValue.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1TaggedObject.h"
#import "PBMParameter.h"

@interface PKMACValue : ASN1Object {
@private
    AlgorithmIdentifier *_algId;
    DERBitString *_value;
}

+ (PKMACValue *)getInstance:(id)paramObject;
+ (PKMACValue *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamPBMParameter:(PBMParameter *)paramPBMParameter paramDERBitString:(DERBitString *)paramDERBitString;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString;
- (AlgorithmIdentifier *)getAlgId;
- (DERBitString *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
