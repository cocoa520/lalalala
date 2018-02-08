//
//  GOST3410PublicKeyAlgParameters.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Sequence.h"

@interface GOST3410PublicKeyAlgParameters : ASN1Object {
@private
    ASN1ObjectIdentifier *_publicKeyParamSet;
    ASN1ObjectIdentifier *_digestParamSet;
    ASN1ObjectIdentifier *_encryptionParamSet;
}

+ (GOST3410PublicKeyAlgParameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (GOST3410PublicKeyAlgParameters *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier1:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier1 paramASN1ObjectIdentifier2:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier2;
- (instancetype)initParamASN1ObjectIdentifier1:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier1 paramASN1ObjectIdentifier2:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier2 paramASN1ObjectIdentifier3:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier3;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (ASN1ObjectIdentifier *)getPublicKeyParamSet;
- (ASN1ObjectIdentifier *)getDigestParamSet;
- (ASN1ObjectIdentifier *)getEncryptionParamSet;
- (ASN1Primitive *)toASN1Primitive;

@end
