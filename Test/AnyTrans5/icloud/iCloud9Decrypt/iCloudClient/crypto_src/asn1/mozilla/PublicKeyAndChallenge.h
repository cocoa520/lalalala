//
//  PublicKeyAndChallenge.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "SubjectPublicKeyInfo.h"
#import "DERIA5String.h"

@interface PublicKeyAndChallenge : ASN1Object {
@private
    ASN1Sequence *_pkacSeq;
    SubjectPublicKeyInfo *_spki;
    DERIA5String *_challenge;
}

+ (PublicKeyAndChallenge *)getInstance:(id)paramObject;
- (ASN1Primitive *)toASN1Primitive;
- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo;
- (DERIA5String *)getChallenge;

@end
