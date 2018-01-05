//
//  POPOSigningKeyInput.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "GeneralName.h"
#import "PKMACValue.h"
#import "SubjectPublicKeyInfo.h"

@interface POPOSigningKeyInput : ASN1Object {
@private
    GeneralName *_sender;
    PKMACValue *_publicKeyMAC;
    SubjectPublicKeyInfo *_publicKey;
}

+ (POPOSigningKeyInput *)getInstance:(id)paramObject;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo;
- (instancetype)initParamPKMACValue:(PKMACValue *)paramPKMACValue paramSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo;
- (GeneralName *)getSender;
- (PKMACValue *)getPublicKeyMAC;
- (SubjectPublicKeyInfo *)getPublicKey;
- (ASN1Primitive *)toASN1Primitive;

@end
