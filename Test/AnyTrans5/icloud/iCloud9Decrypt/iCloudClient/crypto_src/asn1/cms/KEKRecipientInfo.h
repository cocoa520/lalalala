//
//  KEKRecipientInfo.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "KEKIdentifier.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"
#import "ASN1Sequence.h"

@interface KEKRecipientInfo : ASN1Object {
@private
    ASN1Integer *_version;
    KEKIdentifier *_kekid;
    AlgorithmIdentifier *_keyEncryptionAlgorithm;
    ASN1OctetString *_encryptedKey;
}

+ (KEKRecipientInfo *)getInstance:(id)paramObject;
+ (KEKRecipientInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamKEKIdentifier:(KEKIdentifier *)paramKEKIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1Integer *)getVersion;
- (KEKIdentifier *)getKekid;
- (AlgorithmIdentifier *)getKeyEncryptionAlgorithm;
- (ASN1OctetString *)getEncryptedKey;
- (ASN1Primitive *)toASN1Primitive;

@end
