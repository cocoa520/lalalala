//
//  EncryptionScheme.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"

@interface EncryptionScheme : ASN1Object {
@private
    AlgorithmIdentifier *_algId;
}

+ (EncryptionScheme *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getAlgorithm;
- (ASN1Encodable *)getParameters;
- (ASN1Primitive *)toASN1Primitive;

@end
