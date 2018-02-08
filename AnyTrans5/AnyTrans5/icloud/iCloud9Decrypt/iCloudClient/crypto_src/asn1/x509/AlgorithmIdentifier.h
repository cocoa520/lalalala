//
//  AlgorithmIdentifier.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1ObjectIdentifier.h"

@interface AlgorithmIdentifier : ASN1Object {
@private
    ASN1ObjectIdentifier *_algorithm;
    ASN1Encodable *_parameters;
}

+ (AlgorithmIdentifier *)getInstance:(id)paramObject;
+ (AlgorithmIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getAlgorithm;
- (ASN1Encodable *)getParameters;
- (ASN1Primitive *)toASN1Primitive;

@end
