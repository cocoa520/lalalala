//
//  EncryptedContentInfo.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"

@interface EncryptedContentInfo : ASN1Object {
@private
    ASN1ObjectIdentifier *_contentType;
    AlgorithmIdentifier *_contentEncryptionAlgorithm;
    ASN1OctetString *_encryptedContent;
}

+ (EncryptedContentInfo *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1ObjectIdentifier *)getContentType;
- (AlgorithmIdentifier *)getContentEncryptionAlgorithm;
- (ASN1OctetString *)getEncryptedContent;
- (ASN1Primitive *)toASN1Primitive;

@end
