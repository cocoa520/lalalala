//
//  PasswordRecipientInfo.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"
#import "ASN1Sequence.h"

@interface PasswordRecipientInfo : ASN1Object {
@private
    ASN1Integer *_version;
    AlgorithmIdentifier *_keyDerivationAlgorithm;
    AlgorithmIdentifier *_keyEncryptionAlgorithm;
    ASN1OctetString *_encryptedKey;
}

+ (PasswordRecipientInfo *)getInstance:(id)paramObject;
+ (PasswordRecipientInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1Integer *)getVersion;
- (AlgorithmIdentifier *)getKeyDerivationAlgorithm;
- (AlgorithmIdentifier *)getKeyEncryptionAlgorithm;
- (ASN1OctetString *)getEncryptedKey;
- (ASN1Primitive *)toASN1Primitive;

@end
