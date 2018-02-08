//
//  EnvelopedData.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"
#import "OriginatorInfo.h"
#import "ASN1Set.h"
#import "EncryptedContentInfo.h"
#import "Attributes.h"

@interface EnvelopedData : ASN1Object {
@private
    ASN1Integer *_version;
    OriginatorInfo *_originatorInfo;
    ASN1Set *_recipientInfos;
    EncryptedContentInfo *_encryptedContentInfo;
    ASN1Set *_unprotectedAttrs;
}

+ (EnvelopedData *)getInstance:(id)paramObject;
+ (EnvelopedData *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (int)calculateVersion:(OriginatorInfo *)paramOriginatorInfo paramASN1Set1:(ASN1Set *)paramASN1Set1 paramASN1Set2:(ASN1Set *)paramASN1Set2;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamOriginatorInfo:(OriginatorInfo *)paramOriginatorInfo paramASN1Set1:(ASN1Set *)paramASN1Set1 paramEncryptedContentInfo:(EncryptedContentInfo *)paramEncryptedContentInfo paramASN1Set2:(ASN1Set *)paramASN1Set2;
- (instancetype)initParamOriginatorInfo:(OriginatorInfo *)paramOriginatorInfo paramASN1Set:(ASN1Set *)paramASN1Set1 paramEncryptedContentInfo:(EncryptedContentInfo *)paramEncryptedContentInfo paramAttributes:(Attributes *)paramAttributes;
- (ASN1Integer *)getVersion;
- (OriginatorInfo *)getOriginatorInfo;
- (ASN1Set *)getRecipientInfos;
- (EncryptedContentInfo *)getEncryptedContentInfo;
- (ASN1Set *)getUnprotectedAttrs;
- (ASN1Primitive *)toASN1Primitive;

@end
