//
//  Signature.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1Sequence.h"

@interface Signature : ASN1Object {
    AlgorithmIdentifier *_signatureAlgorithm;
    DERBitString *_signature;
    ASN1Sequence *_certs;
}

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signatureAlgorithm;
@property (nonatomic, readwrite, retain) DERBitString *signature;
@property (nonatomic, readwrite, retain) ASN1Sequence *certs;

+ (Signature *)getInstance:(id)paramObject;
+ (Signature *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (AlgorithmIdentifier *)getSignatureAlgorithm;
- (DERBitString *)getSignature;
- (ASN1Sequence *)getCerts;
- (ASN1Primitive *)toASN1Primitive;

@end
