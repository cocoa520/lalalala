//
//  SMIMECapability.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Sequence.h"

@interface SMIMECapability : ASN1Object {
@private
    ASN1ObjectIdentifier *_capabilityID;
    ASN1Encodable *_parameters;
}

+ (ASN1ObjectIdentifier *)preferSignedData;
+ (ASN1ObjectIdentifier *)canNotDecryptAny;
+ (ASN1ObjectIdentifier *)sMIMECapabilitiesVersions;
+ (ASN1ObjectIdentifier *)dES_CBC;
+ (ASN1ObjectIdentifier *)dES_EDE3_CBC;
+ (ASN1ObjectIdentifier *)rC2_CBC;
+ (ASN1ObjectIdentifier *)aES128_CBC;
+ (ASN1ObjectIdentifier *)aES192_CBC;
+ (ASN1ObjectIdentifier *)aES256_CBC;
+ (SMIMECapability *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getCapabilityID;
- (ASN1Encodable *)getParameters;
- (ASN1Primitive *)toASN1Primitive;

@end
