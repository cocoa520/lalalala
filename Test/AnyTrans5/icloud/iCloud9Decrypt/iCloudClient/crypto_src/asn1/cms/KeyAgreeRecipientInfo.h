//
//  KeyAgreeRecipientInfo.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"
#import "OriginatorIdentifierOrKey.h"
#import "ASN1OctetString.h"
#import "AlgorithmIdentifier.h"
#import "ASN1Sequence.h"

@interface KeyAgreeRecipientInfo : ASN1Object {
@private
    ASN1Integer *_version;
    OriginatorIdentifierOrKey *_originator;
    ASN1OctetString *_ukm;
    AlgorithmIdentifier *_keyEncryptionAlgorithm;
    ASN1Sequence *_recipientEncryptedKeys;
}

+ (KeyAgreeRecipientInfo *)getInstance:(id)paramObject;
+ (KeyAgreeRecipientInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamOriginatorIdentifierOrKey:(OriginatorIdentifierOrKey *)paramOriginatorIdentifierOrKey paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (ASN1Integer *)getVersion;
- (OriginatorIdentifierOrKey *)getOriginator;
- (ASN1OctetString *)getUserKeyingMaterial;
- (AlgorithmIdentifier *)getKeyEncryptionAlgorithm;
- (ASN1Sequence *)getRecipientEncryptedKeys;
- (ASN1Primitive *)toASN1Primitive;

@end
