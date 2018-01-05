//
//  SMIMECapabilities.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ASN1ObjectIdentifier.h"

@interface SMIMECapabilities : ASN1Object {
@private
    ASN1Sequence *_capabilities;
}

+ (ASN1ObjectIdentifier *)preferSignedData;
+ (ASN1ObjectIdentifier *)canNotDecryptAny;
+ (ASN1ObjectIdentifier *)sMIMECapabilitesVersions;
+ (ASN1ObjectIdentifier *)aes256_CBC;
+ (ASN1ObjectIdentifier *)aes192_CBC;
+ (ASN1ObjectIdentifier *)aes128_CBC;
+ (ASN1ObjectIdentifier *)idea_CBC;
+ (ASN1ObjectIdentifier *)cast5_CBC;
+ (ASN1ObjectIdentifier *)dES_CBC;
+ (ASN1ObjectIdentifier *)dES_EDE3_CBC;
+ (ASN1ObjectIdentifier *)rC2_CBC;
+ (SMIMECapabilities *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (NSMutableArray *)getCapabilities:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (ASN1Primitive *)toASN1Primitive;

@end
