//
//  SignedPublicKeyAndChallenge.h
//  crypto
//
//  Created by JGehry on 6/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "PublicKeyAndChallenge.h"
#import "AlgorithmIdentifier.h"
#import "ASN1Sequence.h"
#import "DERBitString.h"

@interface SignedPublicKeyAndChallenge : ASN1Object {
@private
    PublicKeyAndChallenge *_pubKeyAndChal;
    ASN1Sequence *_pkacSeq;
}

+ (SignedPublicKeyAndChallenge *)getInstance:(id)paramObject;
- (ASN1Primitive *)toASN1Primitive;
- (PublicKeyAndChallenge *)getPublicKeyAndChallenge;
- (DERBitString *)getSignature;

@end
