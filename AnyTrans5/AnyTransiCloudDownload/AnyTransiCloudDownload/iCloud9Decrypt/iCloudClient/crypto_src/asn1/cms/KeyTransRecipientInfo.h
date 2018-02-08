//
//  KeyTransRecipientInfo.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "RecipientKeyIdentifier.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"

@interface KeyTransRecipientInfo : ASN1Object {
@private
    ASN1Integer *_version;
    RecipientKeyIdentifier *_rid;
    AlgorithmIdentifier *_keyEncryptionAlgorithm;
    ASN1OctetString *_encryptedKey;
}

+ (KeyTransRecipientInfo *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamRecipientIdentifier:(RecipientKeyIdentifier *)paramRecipientIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1Integer *)getVersion;
- (RecipientKeyIdentifier *)getRecipientIdentifier;
- (AlgorithmIdentifier *)getKeyEncryptionAlgorithm;
- (ASN1OctetString *)getEncryptedKey;
- (ASN1Primitive *)toASN1Primitive;

@end
